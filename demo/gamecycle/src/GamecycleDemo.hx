package;

import storage.LocalStorage;
import persistent.StorageStateManager;
import persistent.AssetStateLoader;
import fu.input.FocusManager.LinearFocusManager;
import input.ClickEmulator;
import al.core.DataView;
import al.ec.WidgetSwitcher;
import bootstrap.BootstrapMain;
import ec.Entity;
import ginp.ButtonInputBinder;
import ginp.ButtonOutputBinder;
import ginp.Keyboard;
import ginp.presets.BasicGamepad;
import persistent.State;
import shell.MenuItem.MenuData;
import shell.MenuView;
import utils.MacroGenericAliasConverter as MGA;

using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;
using al.Builder;

class GamecycleDemo extends BootstrapMain {
    public function new() {
        super();

        var e = new Entity("run");
        var view = new GameView(Builder.widget());
        var run = new Gameplay(e, view.ph);
        run.entity.addComponent(view);
        var state = new DemoState();
        run.entity.addComponentByType(State, state);
        run.entity.addComponent(state);

        fui.makeClickInput(rootEntity.getComponent(WidgetSwitcher).ph);
        rootEntity.addChild(createClickEmulator(new Entity("click emulator")));

        var full = new shell.FullGame(new Entity(), Builder.widget(), rootEntity.getComponent(WidgetSwitcher), run);

        // ==== load data preset for new game
        var presetLoader = new AssetStateLoader(state);
        // presetLoader.dataLoadedHook = data -> {
        //     data.started = true;
        //     data;
        // }
        full.addStateLoader(presetLoader);
        full.newGame = () -> presetLoader.load;

        // ==== add game saves
        var storage = new LocalStorage();
        var saves = new StorageStateManager(storage, state);
        full.addStateLoader(saves);
        full.mainMenu.addButton({caption: "load", handler: saves.load, enabled: saves.hasValue}, 1);
        full.gameMenu.addButton({caption: "save", handler: saves.save}, 0);
        var gameOver = full.gameOver;
        full.gameOver = () -> {
            saves.delete();
            gameOver();
        }

        runSwitcher.switchTo(full);
        full.reset();
        full.startGame();
    }

    function createClickEmulator(e) {
        var clicks = new ClickEmulator(e, BasicGamepadButtons.a);
        ButtonInputBinder.addListener(BasicGamepadButtons, e, clicks);
        return e;
    }
}
