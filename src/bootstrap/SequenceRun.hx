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

class SequenceRun extends GameRunBase {
    var checkers:Array<Void->CheckerResult> = [];
    var activities:Array<Runnable> = [];
    var current = 0;
    var activitViewyTarget:WidgetSwitcher<Axis2D>;
    var currentActivity:GameRun;

    public function new(ctx, w, vtarg) {
        super(ctx, w);
        this.activitViewyTarget = vtarg;
    }

    public function addChecker(ch:Void->CheckerResult) {
        checkers.push(ch);
    }

    public function addActivity(a:GameRun) {
        entity.addChild(a.entity);
        a.gameOvered.listen(turn);
        activities.push(Activity(a));
    }

    public function addFuncStep(f:Void->Void) {
        activities.push(Function(f));
    }

    override function startGame() {
        // reset();
        turn();
        trace("started");
    }

    public dynamic function afterReset() {}

    override function reset() {
        current = -1;
        for (run in activities)
            switch run {
                // case Ac
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

        currentActivity = null;
        current++;
        if (current == activities.length)
            current = 0;
        var runnable = activities[current];

        switch runnable {
            case Activity(activity):
                currentActivity = activity;
                activitViewyTarget.switchTo(activity.getView());
                activity.reset();
                activity.startGame();
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
        currentActivity.update(dt);
        if (interruptFlag) {
            check();
            interruptFlag = false;
        }
    }
}
