package bootstrap;

import ec.PropertyComponent.FlagComponent;
import update.UpdateBinder;
import ec.CtxWatcher;
import update.Updatable;
import a2d.Placeholder2D;
import bootstrap.SimpleRunBinder;
import bootstrap.BootstrapMain;
import ginp.Keyboard;
import gameapi.GameRun;
import al.ec.WidgetSwitcher;
import haxe.Json;
#if js
import storage.BrowserStorage;
#end

using a2d.transform.LiquidTransformer;
using al.Builder;

#if !js
typedef BrowserStorage = {}
#end

interface Lifecycle {
    function newGame():Void;
    function saveGame():Void;
    function loadGame():Void;
    // function resume():Void;
    function toggleMenu():Void;
    var hasActiveSession:FlagComponent;
}

interface State {
    public function load(state:Dynamic):Void;
    public function dump():Dynamic;
}

class LifecycleImpl extends BootstrapMain implements Lifecycle {
    var run:GameRun;
    var storage:BrowserStorage;
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

        kbinder.addCommand(Keyboard.SPACE, () -> {
            pause.pause(!pause.paused);
        });
        kbinder.addCommand(Keyboard.ESCAPE, () -> {
            toggleMenu();
        });

        kbinder.addCommand(Keyboard.A, () -> {
            ec.DebugInit.initCheck.dispatch(rootEntity);
        });

        var entity = rootEntity;
        #if js
        storage = new BrowserStorage();
        #end
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
    }

    public function onGameOver() {
        hasActiveSession.value = false;
        rootEntity.removeChild(run.entity); // to prevent update() call on inconsistent run state.
        rootEntity.getComponent(WidgetSwitcher).switchTo(gameOver);
    }

    public function newGame() {
        rootEntity.addChild(run.entity);
        var data = Json.parse(openfl.utils.Assets.getText("state.json"));
        trace(data);
        rootEntity.getComponent(State).load(data);
        run.reset();
        launch();
    }

    public function saveGame():Void {
        #if sys
        sys.io.File.saveContent("save.json", Json.stringify(rootEntity.getComponent(State).dump(), null, " "));
        #else
        storage.saveValue("save.json", Json.stringify(rootEntity.getComponent(State).dump(), null, " "));
        #end
    }

    public function loadGame():Void {
        #if sys
        if (!sys.FileSystem.exists("save.json"))
            return;
        rootEntity.getComponent(State).load(Json.parse(sys.io.File.getContent("save.json")));
        #else
        var stdata = storage.getValue("save.json", null);
        var state = Json.parse(stdata ?? openfl.utils.Assets.getText("state.json"));
        rootEntity.getComponent(State).load(state);
        #end
        launch();
    }

    function launch() {
        hideMenu();
        hasActiveSession.value = true;
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
