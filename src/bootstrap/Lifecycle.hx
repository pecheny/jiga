package bootstrap;

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
    function resume():Void;
    function showMenu():Void;
}

interface State {
    public function load(state:Dynamic):Void;
    public function dump():Dynamic;
}

class LifecycleImpl extends BootstrapMain implements Lifecycle {
    var run:GameRun;
    var storage:BrowserStorage;
    var menu:Placeholder2D = Builder.widget();
    var pause:Pause;

    public function new() {
        super();
        pause = rootEntity.addComponent(new Pause());
        pause.pause(true);
        fui.makeClickInput(menu);
        rootEntity.addComponentByType(Lifecycle, this);
        var kbinder = new utils.KeyBinder();

        kbinder.addCommand(Keyboard.SPACE, () -> {
            pause.pause(!pause.paused);
        });
        kbinder.addCommand(Keyboard.ESCAPE, () -> {
            showMenu();
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
        this.run = run;
        new PauseRunUpdater(run);
        rootEntity.addChild(run.entity);
    }

    public function newGame() {
        rootEntity.getComponent(State).load(Json.parse(openfl.utils.Assets.getText("state.json")));
        run.reset();
        launch();
    }

    public function resume() {
        // if(rootEntity.getComponent(State).items.value ==null){
        //     newGame();
        //     return;
        // }
        rootEntity.getComponent(WidgetSwitcher).switchTo(run.getView());
        rootEntity.getComponent(Pause).pause(false);
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
        resume();
        run.startGame();
    }

    public function showMenu():Void {
        rootEntity.getComponent(Pause).pause(true);
        rootEntity.getComponent(WidgetSwitcher).switchTo(menu);
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
        if(pause.paused)
            return;
        run.update(dt);
    }
}
