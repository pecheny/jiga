package bootstrap;

import Pause;
import al.ec.WidgetSwitcher;
import ec.CtxWatcher;
import ginp.GameInput.GameInputUpdater;
import gameapi.GameRun;
import update.UpdateBinder;
import update.Updatable;
import ec.Entity;
import gameapi.GameRunBinder;

class SimpleRunBinder extends ec.Component implements CtxBinder implements GameRunBinder implements Updatable implements Pausable {
    var run:GameRun;
    var loop:UpdateLoop;
    var paused = false;
    @:once var input:GameInputUpdater;
    @:once var switcher:WidgetSwitcher<Axis2D>;

    public function new(e:Entity, switcher) {
        super(e);
        this.switcher = switcher;
        e.addComponentByType(GameRunBinder, this);
        e.addComponentByType(Updatable, this);
        e.addComponentByType(Pausable, this);
        new CtxWatcher(UpdateBinder, e);
        new CtxWatcher(Pause, e);
    }

    override function init() {
        super.init();
        loop = new UpdateLoop(input);
        if (run != null)
            startGame();
    }

    function startGame() {
        loop.run = run;
        run.reset();
        switcher.switchTo(run.getView());
        run.startGame();
    }

    function setRun(run) {
        if (run == null)
            throw "wrong";
        if (this.run != null)
            this.run.gameOvered.remove(startGame);
        this.run = run;
        this.run.gameOvered.listen(startGame);
        if (loop != null)
            startGame();
    }

    public function bind(e:Entity) {
        var run = e.getComponent(GameRun);
        if (run != null)
            setRun(run);
    }

    public function unbind(e:Entity) {
        var run = e.getComponent(GameRun);
        if (this.run != run)
            return;
        this.run = null;
        loop.run = null;
    }

    public function pause(v) {
        this.paused = v;
    }

    public function update(dt:Float) {
        if (paused)
            return;
        if (run == null || loop == null)
            return;
        loop.update(dt);
    }
}

class UpdateLoop implements Updatable {
    var input:GameInputUpdater;

    public var run:GameRun;

    public function new(input) {
        this.input = input;
    }

    public function update(t:Float) {
        if (run == null)
            return;
        input.beforeUpdate(t);
        run.update(t);
        input.afterUpdate();
    }
}
