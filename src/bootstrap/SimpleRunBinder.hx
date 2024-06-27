package bootstrap;

import Pause;
import al.ec.WidgetSwitcher;
import ec.CtxWatcher;
import ec.Entity;
import gameapi.GameRun;
import gameapi.GameRunBinder;
import update.Updatable;
import update.UpdateBinder;

class SimpleRunBinder extends ec.Component implements CtxBinder implements GameRunBinder implements Updatable implements Pausable {
    var run:GameRun;
    var paused = false;
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
        if (run != null)
            startGame();
    }

    function startGame() {
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
    }

    public function pause(v) {
        this.paused = v;
    }

    public function update(dt:Float) {
        if (paused)
            return;
        if (run == null)
            return;
        run.update(dt);
    }
}