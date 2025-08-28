package;

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


        runSwitcher.switchTo(full);
        full.reset();
        full.startGame();
    }

    override function createInput() {
        var basic = new BasicGamepadInput();
        basic.createKeyMapping([
            Keyboard.ESCAPE => start,
            Keyboard.LEFT => left,
            Keyboard.RIGHT => right,
            Keyboard.UP => up,
            Keyboard.DOWN => down,
            Keyboard.SPACE => a
        ]);
        rootEntity.addComponentByName(MGA.toAlias(ButtonInputBinder, BasicGamepadButtons), new ButtonInputBinder(MGA.toString(BasicGamepadButtons), basic));
        rootEntity.addComponentByName(MGA.toAlias(ButtonOutputBinder, BasicGamepadButtons), new ButtonOutputBinder(MGA.toString(BasicGamepadButtons), basic));
    }

    function createClickEmulator(e) {
        var clicks = new ClickEmulator(e, BasicGamepadButtons.a);
        ButtonInputBinder.addListener(BasicGamepadButtons, e, clicks);
        return e;
    }
}
