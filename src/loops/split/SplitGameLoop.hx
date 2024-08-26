package loops.split;

import a2d.Placeholder2D;
import ec.Entity;
import ec.Signal;
import gameapi.GameRun;
import states.States;

class SplitGameLoop extends StateMachine implements GameRun {
    @:isVar public var entity(get, set):Entity;
	public var gameOvered(default, null):Signal<() -> Void> = new Signal();
    public var statusGui:StatusWidget;
    public var health(default, null):Float;
    public var score:Int;

    public function new() {
        super();
        addState(new SplittingGameState(this));
        addState(new ResultPresentation(this));
        reset();
    }

    public function reset() {
        setHealth(100);
        setScore(0);
    }

    public function startGame():Void {
        changeState(SplittingGameState);
    }


    public function gameOver() {
        gameOvered.dispatch();
    }


    public function setHealth(value:Float):Float {
        this.health = value;
        if (statusGui != null)
            statusGui.setHealth(value / 100);
        return value;
    }

    public function setScore(v:Int) {
        score = v;
        if (statusGui != null)
            statusGui.setScore(v);
    }

    public function fade(a:Float) {
    }

	public function getView():Placeholder2D {
        return statusGui.widget();
	}

    public function get_entity():Entity {
        return entity;
    }

    public function set_entity(entity:Entity):Entity {
        this.entity = entity;
        return entity;
    }
}

class IdleState extends SplitStateBase {}

class SplitStateBase extends State {
    var t:Float;
    var duration = 1.;
    var fsm:SplitGameLoop;

    public function new(fsm) {
        this.fsm = fsm;
    }
}

class SplittingGameState extends SplitStateBase {
    override function onEnter() {
        t = duration;
        fsm.fade(0);
    }

    override function update(dt:Float) {
        fsm.statusGui.setProgress(t / duration);
        t -= dt;
        if (t <= 0) {
            fsm.setHealth(fsm.health - 50);

            if (fsm.health == 0)
                fsm.gameOver();
            else
                fsm.changeState(ResultPresentation);
        }
    }
}

class ResultPresentation extends SplitStateBase {
    override function onEnter() {
        t = duration;
        fsm.setScore(fsm.score + 1);
    }

    override function update(dt:Float) {
        t -= dt;
        var tp = (t / duration);
        fsm.fade(1 - tp * tp);
        if (t <= 0)
            fsm.changeState(SplittingGameState);
    }
}
