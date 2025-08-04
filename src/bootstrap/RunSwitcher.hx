package bootstrap;

import al.ec.WidgetSwitcher;
import gameapi.GameRun;

class RunSwitcher extends GameRunBase {
    var activitViewyTarget:WidgetSwitcher<Axis2D>;
    var activity:GameRun;

    public var relaunchAtBind:Bool = true;

    public function new(ctx, w, vtarg) {
        super(ctx, w);
        this.activitViewyTarget = vtarg;
    }

    public function switchTo(activity:GameRun) {
        unbind();
        if (activity != null)
            bind(activity);
    }

    function bind(act:GameRun) {
        this.activity = act;
        entity.addChild(act.entity);
        activitViewyTarget.switchTo(activity.getView());
        if (relaunchAtBind) {
            activity.reset();
            activity.startGame();
        }
    }

    function unbind() {
        if (activity == null)
            return;
        // activity.reset();
        entity.removeChild(activity.entity);
        this.activity = null;
        activitViewyTarget.switchTo(null);
    }

    override function reset() {
        activity?.reset();
    }

    override function update(dt:Float) {
        activity?.update(dt);
    }
}
