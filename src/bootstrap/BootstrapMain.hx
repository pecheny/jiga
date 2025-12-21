package bootstrap;

import a2d.Placeholder2D;
import al.ec.WidgetSwitcher;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.layouts.data.LayoutData;
import al.openfl.StageAspectResizer;
import backends.lime.MouseRoot;
import backends.lime.MultitouchRoot;
import backends.openfl.OpenflBackend.StageImpl;
import dkit.Dkit.BaseDkit;
import ec.CtxWatcher;
import ec.Entity;
import ecbind.MultiInputBinder;
import fu.Uikit;
import gameapi.GameRun;
import gameapi.GameRunBinder;
import ginp.ButtonInputBinder;
import ginp.ButtonOutputBinder;
import ginp.ButtonsMapper;
import ginp.GameButtonsImpl;
import ginp.Keyboard;
import ginp.api.GameButtons;
import ginp.api.GameInputUpdaterBinder;
import ginp.presets.BasicGamepad;
import ginp.presets.OneButton;
import htext.style.TextContextBuilder;
import input.ClickEmulator;
import input.UnlockBackButton;
import loops.bounce.BouncingLoop;
import loops.bounce.BouncingTimeline.MyWeaponFac;
import loops.bounce.gui.BouncingWidget;
import shimp.MultiInputTarget;
import states.States;
import update.UpdateBinder;
import utils.AbstractEngine;
import utils.MacroGenericAliasConverter as MGA;

using a2d.transform.LiquidTransformer;
using al.Builder;

class BootstrapMain extends AbstractEngine {
    var fui:FuiBuilder;
    var rootEntity:Entity;
    var stateSwitcher:StateSwitcher; // there is a entry loop, check if it is actual
    var runSwitcher:RunSwitcher;

    public function new() {
        super();
        var stage = new StageImpl(1);
        var uikit = new Uikit(stage);
        fui = new FuiBuilder(stage, uikit);
        var root = rootEntity = new Entity("root");
        setWindowPosition();
        // lime.app.Application.current.window.onRenderContextLost.add(() -> trace("lime app context lost")); -- doesnt work
        BaseDkit.inject(fui);
        regTextProcessor();
        uikit.configure(root);
        dkitDefaultStyles();
        uikit.createContainer(root);
        root.addComponentByType(fu.Uikit, uikit);
        createFlashDisplay();
        initFui();
        createInput();
        iniUpdater();
        var wsw = rootEntity.getComponent(WidgetSwitcher);
        runSwitcher = new RunSwitcher(rootEntity, wsw.ph, wsw);
        runSwitcher.relaunchAtBind = false;
        // todo maybe bind updater or make it accessible other way
        @:privateAccess rootEntity.getComponent(UpdateBinder).updater.addUpdatable(runSwitcher);

        createRunWrapper();
        createRun();
    }

    function regTextProcessor() {}

    @:deprecated
    function createRun() {}

    @:deprecated
    function enterRun(run:GameRun) {
        run.entity.addComponentByType(GameRun, run);
        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);
    }

    @:deprecated
    function createRunWrapper() {
        new SimpleRunBinder(rootEntity, null);
    }

    function setWindowPosition() {
        var wnd = openfl.Lib.application.window;
        if (wnd.y < 0)
            wnd.y = 20;
        wnd.x = 200;
    }

    /**
        Creates root for multitouch input targets.
    **/
    function createMultiInput() {
        var ar = fui.ar;
        var mibinder = new MultiInputBinder();
        var mroot = new MultitouchRoot(mibinder, ar.getAspectRatio());
        var root = new MouseRoot(new InputToMultiTarget(mibinder, -1), ar);
        rootEntity.addComponent(mibinder);
    }

    /**
        Creates and binds GameInput. By default it is OneButton, supposed to override for exact buttons and axis set. 
    **/
    function createInput() {
        var basic = new BasicGamepadInput();
        basic.createKeyMapping([
            Keyboard.ESCAPE => start,
            Keyboard.LEFT => left,
            Keyboard.RIGHT => right,
            Keyboard.UP => up,
            Keyboard.DOWN => down,
            Keyboard.TAB => tright,
            Keyboard.SPACE => a,
            Keyboard.A => left,
            Keyboard.D => right,
            Keyboard.W => up,
            Keyboard.S => down,
            Keyboard.ENTER => a,
        ]);
        rootEntity.addComponent(new UnlockBackButton(@:privateAccess basic.kbd));
        rootEntity.addComponentByName(MGA.toAlias(ButtonInputBinder, BasicGamepadButtons), new ButtonInputBinder(BasicGamepadButtons.basisTypeName(), basic));
        rootEntity.addComponentByName(MGA.toAlias(ButtonOutputBinder, BasicGamepadButtons), new ButtonOutputBinder(BasicGamepadButtons.basisTypeName(), basic));
        rootEntity.addComponentByName(MGA.toAlias(GameButtons, BasicGamepadButtons), basic);

        var oneButtonMapper = new ButtonsMapper([BasicGamepadButtons.a => OneButton.button]);
        basic.addListener(oneButtonMapper);
        var oneButton = new GameButtonsImpl(OneButton.aliases.length);
        var oneCtx = new Entity("one button");
        oneButton.bind(oneCtx);
        rootEntity.addChild(oneCtx);
        oneButtonMapper.addListener(oneButton);

        rootEntity.addComponentByName(MGA.toAlias(GameButtons, OneButton), oneButton);

        // listen for gui buttons dispatchers
        rootEntity.addComponentByName(MGA.toAlias(ButtonOutputBinder, OneButton), new ButtonOutputBinder(OneButton.basisTypeName(), oneButton));
        rootEntity.addComponentByName(MGA.toAlias(ButtonInputBinder, OneButton), new ButtonInputBinder(OneButton.basisTypeName(), oneButton));
    }

    function createClickEmulator(e) {
        var clicks = new ClickEmulator(e, BasicGamepadButtons.a);
        ButtonInputBinder.addListener(BasicGamepadButtons, e, clicks);
        return e;
    }

    function createGameplaySimple() {
        var entity = new Entity("run");
        var fac = new MyWeaponFac();
        entity.addComponent(fac.createDummyTracer());
        var bouncing = new BouncingWidget(Builder.widget());
        var loop = new BouncingLoop(entity, bouncing.ph, bouncing);
        return entity;
    }

    function createFlashDisplay() {
        fui.configureDisplayRoot(rootEntity, this);
    }

    function initFui() {
        var rw = Builder.ph();
        rootEntity.addComponentByType(Placeholder2D, rw);
        fui.configureInput(rootEntity);
        fui.configureScreen(rootEntity);
        fui.configureAnimation(rootEntity);
        rootEntity.addComponent(fui);
        var v = new StageAspectResizer(rw, 2);
        var switcher = new WidgetSwitcher(rw);
        rootEntity.addComponent(switcher);
    }

    function iniUpdater() {
        var updater = new RunUpdater();
        addUpdatable(updater);
        rootEntity.addComponentByType(GameInputUpdaterBinder, updater);
        rootEntity.addComponent(new UpdateBinder(updater));
    }

    function dkitDefaultStyles() {
        var contLayouts = fui.uikit.containers;
        var distributer = new al.layouts.Padding(new FractionSize(.25), new PortionLayout(Center, new FixedSize(0.1)));
        contLayouts.reg(GuiStyles.L_HOR_CARDS, distributer, WholefillLayout.instance);
        contLayouts.reg(GuiStyles.L_VERT_BUTTONS, WholefillLayout.instance, distributer);
    }
}
