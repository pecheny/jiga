package;

import DemoState.Item;
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

using al.Builder;

class GamecycleDemo extends BootstrapMain {
    public function new() {
        super();

        var e = new Entity("run");
        var run = new Gameplay(e, Builder.widget());
        var state = new DemoState();
        run.entity.addComponentByType(State, state);
        run.entity.addComponent(state);
        var items:Array<Item> = [{weapon:{dmg:3}}, {consumable:{count:3, action:"heal"}}];
        state.load({items:items});
        var kbinder = new utils.KeyBinder();
        kbinder.addCommand(openfl.ui.Keyboard.A, () -> {
            ec.DebugInit.initCheck.dispatch(rootEntity); // propably not committed in slec
        });

        fui.makeClickInput(rootEntity.getComponent(WidgetSwitcher).ph);
        rootEntity.addChild(createClickEmulator(new Entity("click emulator")));

        runSwitcher.switchTo(run);
        run.reset();
        run.startGame();
    }
}
