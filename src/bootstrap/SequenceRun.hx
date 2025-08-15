package bootstrap;

import al.ec.WidgetSwitcher;
import gameapi.GameRun;

enum abstract CheckerResult(Bool) from Bool {
    var stop = true;
    var follow = false;
}

enum Runnable {
    Activity(gr:GameRun);
    Function(f:Void->Void);
}

class SequenceRun extends RunSwitcher {
    var checkers:Array<Void->CheckerResult> = [];
    var activities:Array<Runnable> = [];
    var current = 0;


    public function addChecker(ch:Void->CheckerResult) {
        checkers.push(ch);
    }

    public function addActivity(a:GameRunBase) {
        a.injectFrom(entity);
        a.gameOvered.listen(turn);
        activities.push(Activity(a));
    }

    public function addFuncStep(f:Void->Void) {
        activities.push(Function(f));
    }

    override function startGame() {
        turn();
    }

    public dynamic function afterReset() {}

    override function reset() {
        current = -1;
        for (run in activities)
            switch run {
                case Activity(gr):
                    gr.reset();
                case Function(f):
            }
        super.reset();
        afterReset();
    }

    function gameOver() {
        // reset(); brokes bouncing.invalidateInput()
        gameOvered.dispatch();
    }

    function check():CheckerResult {
        for (ch in checkers) {
            if (stop == ch()) {
                gameOver();
                return stop;
            }
        }
        return follow;
    }

    function turn() {
        if (stop == check())
            return;
        switchTo(null);
        current++;
        if (current == activities.length)
            current = 0;
        var runnable = activities[current];

        switch runnable {
            case Activity(activity):
                switchTo(activity);
            case Function(f):
                f();
                turn();
        }
        // ?? listen forgot or listen all at add
    }

    public var interruptFlag:Bool = false;

    override function update(dt:Float) {
        if (current == -1)
            return;
        super.update(dt);
        if (interruptFlag) {
            check();
            interruptFlag = false;
        }
    }
}
