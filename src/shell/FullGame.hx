package shell;

import al.Builder;
import fu.Signal;
import shell.MenuItem.MenuData;
import persistent.State;
import ec.Entity;
import gameapi.GameRun;
import a2d.Placeholder2D;
import bootstrap.SequenceRun;
import storage.Storage;
import storage.LocalStorage;
import persistent.StorageStateManager;
import persistent.AssetStateLoader;
import bootstrap.GameRunBase;

// activity, containing main menu and game session
class FullGame extends SequenceRun {
    public var menu(default, null):Placeholder2D;
    public var onNewLoaded(default, null):Signal<Void->Void> = new Signal();

    var ma:MenuActivity;
    var menuData:MenuData = [];

    public function new(ctx, w, vtarg, gameplay:GameRunBase) {
        super(ctx, w, vtarg);
        menu = Builder.widget();
        ma = new MenuActivity(new Entity("main menu"), menu);
        addActivity(ma);
        addActivity(gameplay);
        var state = gameplay.entity.getComponent(State);
        entity.addComponentByType(State, state);
        createManagement();
    }

    public function createManagement() {
        entity.addComponentByType(Storage, new LocalStorage());
        var presets = new AssetStateLoader(entity);
        presets.onLoaded.listen(onNewStateLoaded);
        menuData.push({caption: "New game", handler: () -> presets.load()});
        var saves = new StorageStateManager(entity);
        saves.onLoaded.listen(onStateLoaded);
        menuData.push({caption: "Load game", handler: () -> saves.load()});
        ma.initData(menuData);
    }

    // state loaded from template after call newGame()
    function onNewStateLoaded() {
        onNewLoaded.dispatch();
        ma.gameOvered.dispatch();
    }

    // after loadGame
    function onStateLoaded() {
        ma.gameOvered.dispatch();
    }
}
