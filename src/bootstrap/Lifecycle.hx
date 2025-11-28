package bootstrap;

import a2d.Placeholder2D;
import al.ec.WidgetSwitcher;
import bootstrap.BootstrapMain;
import ec.CtxWatcher;
import ec.PropertyComponent.FlagComponent;
import gameapi.GameRun;
import ginp.Keyboard;
import haxe.Json;
import openfl.ui.KeyLocation;
import persistent.State;
import storage.LocalStorage;
import update.Updatable;
import update.UpdateBinder;

using a2d.transform.LiquidTransformer;
using al.Builder;

interface Lifecycle {
    function newGame():Void;
    function saveGame():Void;
    function loadGame():Void;
    // function resume():Void;
    function toggleMenu():Void;
    var hasActiveSession:FlagComponent;
}

class LifecycleImpl extends BootstrapMain implements Lifecycle {
    var run:GameRun;
    var storage:LocalStorage;
    var menu:Placeholder2D = Builder.widget();
    var gameOver:Placeholder2D = Builder.widget();
    var pause:Pause;

    public var hasActiveSession:FlagComponent = @:privateAccess new FlagComponent();

    public function new() {
        super();
        fui.makeClickInput(gameOver);

        pause = rootEntity.addComponent(new Pause());
        pause.pause(true);
        fui.makeClickInput(menu);
        rootEntity.addComponentByType(Lifecycle, this);
        var kbinder = new utils.KeyBinder();

        kbinder.addCommand(Keyboard.P, () -> {
            pause.pause(!pause.paused);
        });
        kbinder.addCommand(Keyboard.ESCAPE, () -> {
            toggleMenu();
        });

        kbinder.addCommand(Keyboard.A, () -> {
            ec.DebugInit.initCheck.dispatch(rootEntity);
        });
        openfl.Lib.current.stage.addEventListener(openfl.events.KeyboardEvent.KEY_UP, onKeyUp);

        var entity = rootEntity;
        storage = new LocalStorage();
    }

    function bindRun(run:GameRun) {
        var goScreen = gameOver.entity.getComponent(SelfClosingScreen);
        if (goScreen == null) {
            goScreen = new GameOverScreen(gameOver);
            gameOver.entity.addComponentByType(SelfClosingScreen, goScreen);
        }
        goScreen.onDone.listen(showMenu);
        if (this.run != null) {
            this.run.gameOvered.remove(onGameOver);
        }

        this.run = run;
        this.run.gameOvered.listen(onGameOver);

        // TODO rebinding same run would fail on readd updater
        new PauseRunUpdater(run);
        rootEntity.addChild(run.entity);
    }

    public function onGameOver() {
        hasActiveSession.value = false;
        // rootEntity.removeChild(run.entity); // to prevent update() call on inconsistent run state.
        rootEntity.getComponent(WidgetSwitcher).switchTo(gameOver);
    }

    public function newGame() {
        var data = Json.parse(openfl.utils.Assets.getText("state.json"));
        trace(data);
        rootEntity.getComponent(State).load(data);
        run.reset();
        launch();
    }

    public function saveGame():Void {
        storage.saveValue("save.json", Json.stringify(rootEntity.getComponent(State).dump(), null, " "));
    }

    public function loadGame():Void {
        var stdata = storage.getValue("save.json", null);
        var state = Json.parse(stdata ?? openfl.utils.Assets.getText("state.json"));
        rootEntity.getComponent(State).load(state);
        launch();
    }

    function launch() {
        rootEntity.addChild(run.entity); // on gameOver entity was removed so it should be readded.
        hideMenu();
        hasActiveSession.value = true;
        run.reset();
        run.startGame();
    }

    var inMenu = true;

    public function toggleMenu():Void {
        if (!hasActiveSession.value)
            return;
        if (inMenu)
            hideMenu();
        else
            showMenu();
    }

    function showMenu() {
        inMenu = true;
        rootEntity.getComponent(Pause).pause(true);
        rootEntity.getComponent(WidgetSwitcher).switchTo(menu);
    }

    function hideMenu() {
        inMenu = false;
        rootEntity.getComponent(WidgetSwitcher).switchTo(run.getView());
        rootEntity.getComponent(Pause).pause(false);
    }
}

class PauseRunUpdater implements Updatable extends ec.Component {
    var run:GameRun;
    @:once var pause:Pause;

    public function new(run) {
        this.run = run;
        super(run.entity);
        entity.addComponentByType(Updatable, this);
        new CtxWatcher(UpdateBinder, entity);
    }

    public function update(dt:Float) {
        if (pause.paused)
            return;
        run.update(dt);
    }
}
