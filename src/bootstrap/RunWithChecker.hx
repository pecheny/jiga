package bootstrap;

import al.ec.WidgetSwitcher;
import gameapi.GameRun;
import states.States;


class RunWithChecker extends GameRunBase {
    var actionRun:GameRunBase;
    var isGameOvered:Void->Bool;
    var fsm:StateMachine;
    var activitViewyTarget:WidgetSwitcher<Axis2D>;

    public function new(ctx, w, actionRun, vtarg, isGameOvered) {
        super(ctx, w);
        this.actionRun = actionRun;
        this.activitViewyTarget = vtarg;
        actionRun.gameOvered.listen(onActionDone);
        this.isGameOvered = isGameOvered;
        ctx.addChild(actionRun.entity);
        init();
    }

    override function init() {
        fsm = new StateMachine();
        fsm.addState(new EmptyState());
        fsm.addState(new RunState(actionRun));
    }

    override function startGame() {
        fsm.changeState(RunState);
        actionRun.reset();
        activitViewyTarget.switchTo(actionRun.getView());
        actionRun.startGame();
    }

    public dynamic function afterReset() {
        
    }
    override function reset() {
        super.reset();
        afterReset();
        actionRun.reset();
    }

    function onActionDone() {
        if (isGameOvered())
            gameOver();
        else
            turn();
    }

    function gameOver() {
        actionRun.reset();
        fsm.changeState(EmptyState);
        entity.getComponent(GameRun).gameOvered.dispatch();
    }

    function turn() {
        actionRun.reset();
    }

    override function update(dt:Float) {
        fsm.update(dt);
    }
}

class RunState extends State {
    var actionRun:GameRunBase;

    public function new(action) {
        this.actionRun = action;
    }

    override function update(t:Float) {
        actionRun.update(t);
    }
}
