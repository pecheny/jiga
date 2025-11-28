package loops.bounce;

import ginp.api.GameButtons;
import gameapi.Interruption;
import utils.MathUtil;
import bootstrap.Activitor.ActHandler;
import ginp.presets.OneButton;
import ginp.GameButtonsImpl;
import bootstrap.Data;
import bootstrap.GameRunBase;
import loops.bounce.Data;
import ec.Entity;
import states.States;

enum abstract BouncingWidgetState(Int) {
    var bouncing;
    var presenting;
}

interface BouncingGui {
    public function setT(t:Float):Void;
    public function setState(state:BouncingWidgetState):Void;
    public function initRegions(weights:haxe.ds.ReadOnlyArray<Float>):Void;
    public function setHitsRemain(n:Int):Void;
}

class BouncingLoop extends GameRunBase implements ActHandler<LoopConfig> {
    @:once(gen) public var input:GameButtons<OneButton>;
    public var gui:BouncingGui;

    public var loopCount = 1;

    var fsm:BouncingLoopFsm;

    public function new(ctx, w, gui) {
        this.gui = gui;
        super(ctx, w);
    }

    override public function init() {
        fsm = new BouncingLoopFsm(entity, gui, gameOver, input);
    }

    override public function startGame():Void {
        fsm.changeState(BouncingState);
    }

    override function reset() {
        fsm.reset();
        fsm.loopsRemains = loopCount;
    }

    override function update(dt:Float) {
        super.update(dt);
        fsm.update(dt);
    }

    public function gameOver() {
        gameOvered.dispatch();
    }

    public function initDescr(d:LoopConfig):ActHandler<LoopConfig> {
        loopCount = d.numOfHits;
        fsm.numBounces = d.numOfBounces;
        fsm.periodDuration = d.periodDuration;
        if (d.timeFunction != null)
            fsm.timeTranformer = d.timeFunction;
        else
            fsm.timeTranformer = t -> t;
        var rps:ResultPresentation = cast @:privateAccess fsm.states.get(ResultPresentation);
        rps.duration = d.afterHitDelay;
        var tl = entity.getComponent(BouncingTimeline);
        tl.init(d.regions);
        tl.onGap = d.onMiss;
        return this;
    }
}

class BouncingLoopFsm extends StateMachine {
    public var gui(default, null):BouncingGui;
    public var entity(default, null):Entity;
    public var input:GameButtons<OneButton>;
    public var periodDuration:Void->Float;
    public var numBounces:Int = -1;
    public var bounceCount:Int = 0;
    public var loopsRemains(default, set) = 0;
    public var timeTranformer:Float->Float;

    var actionState:BouncingState;
    var onDone:Void->Void;

    public function new(ctx:Entity, screen:BouncingGui, onDone, input) {
        super();
        this.input = input;
        entity = ctx;
        this.onDone = onDone;
        gui = screen;
        actionState = addState(new BouncingState(this));
        addState(new ResultPresentation(this));
    }

    public function reset() {
        actionState.reset();
        bounceCount = 0;
    }

    public function gameOver() {
        onDone();
    }

    function set_loopsRemains(value) {
        gui.setHitsRemain(value);
        return loopsRemains = value;
    }
}

class IdleState extends BouncingStateBase {}

class BouncingStateBase extends State {
    var t:Float;
    var fsm:BouncingLoopFsm;

    public function new(fsm) {
        this.fsm = fsm;
    }
}

class BouncingState extends BouncingStateBase {
    var direction:Sign;
    var timeline:BouncingTimeline;

    override function onEnter() {
        super.onEnter();
        fsm.gui.setState(bouncing);
    }

    public function reset() {
        t = 0;
        direction = positive;
        timeline = fsm.entity.getComponent(BouncingTimeline);
        timeline.reroll();
        fsm.gui.initRegions(timeline.getWeights());
    }

    override function update(dt:Float) {
        t += direction * dt / fsm.periodDuration();
        fsm.gui.setT(fsm.timeTranformer(t));
        if (t <= 0 || t >= 1) {
            // todo check bounces num
            if (fsm.numBounces > -1) {
                fsm.bounceCount++;
                if (fsm.bounceCount >= fsm.numBounces) {
                    fsm.loopsRemains = 0;
                    fsm.changeState(ResultPresentation);
                    return;
                }
            }

            t = MathUtil.clamp(t, 0, 1);
            direction = direction.other();
        }
        if (fsm.input.justPressed(button)) {
            processTap();
        }
    }

    function processTap() {
        var weights = timeline.getWeights();
        var regId = 0;
        var regEnd = 0.;
        fsm.loopsRemains--;
        var t = fsm.timeTranformer(this.t);
        for (i in 0...weights.length) {
            regEnd += weights[i];
            regId = i;
            if (regEnd >= t)
                break;
        }
        timeline.execRegionHit(regId);
        fsm.changeState(ResultPresentation);
    }
}

class ResultPresentation extends BouncingStateBase {
    public var duration = 1.;

    override function onEnter() {
        t = duration;
        fsm.gui.setState(presenting);
    }

    override function onExit() {
        var interruption = fsm.entity.getComponentUpward(Interruption);
        if (interruption != null)
            interruption.dispatch();
    }

    override function update(dt:Float) {
        t -= dt;
        var tp = (t / duration);
        if (t <= 0 || fsm.input.justPressed(button)) {
            if (fsm.loopsRemains <= 0)
                fsm.gameOver();
            else {
                fsm.changeState(BouncingState);
            }
        }
    }
}
