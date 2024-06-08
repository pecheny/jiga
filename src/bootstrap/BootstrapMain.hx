package bootstrap;

import al.al2d.Placeholder2D;
import al.ec.WidgetSwitcher;
import al.openfl.StageAspectResizer;
import FuiBuilder.XmlLayerLayouts;
import htext.style.TextContextBuilder;
import mesh.providers.ColorArrayProvider;
import al.layouts.PortionLayout;
import fancy.domkit.Dkit;
import al.layouts.WholefillLayout;
import fancy.Layouts.ContainerStyler;
import al.layouts.data.LayoutData;
import fancy.Props;
import update.UpdateBinder;
import al.openfl.display.FlashDisplayRoot;
import bootstrap.EntryLoop;
import ec.Entity;
import fancy.domkit.Dkit.BaseDkit;
import ginp.GameButtons;
import ginp.GameInput.GameInputUpdater;
import ginp.presets.OneButton;
import ginp.presets.OneButtonInput;
import input.ButtonInputBinder;
import loops.bounce.BouncingLoop;
import loops.bounce.BouncingTimeline.MyWeaponFac;
import loops.bounce.gui.BouncingWidget;
import openfl.display.Sprite;
import states.States;
import utils.AbstractEngine;
import utils.MacroGenericAliasConverter as MGA;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class BootstrapMain extends AbstractEngine {
    var fui = new FuiBuilder();
    var rootEntity:Entity;
    var stateSwitcher:StateSwitcher;

    public function new() {
        super();
        rootEntity = new Entity("root");
        setWindowPosition();
        regDrawcals();
        iniupdater();
        textStyles();
        createFlashDisplay();
        initFui();
        dkitDefaultStyles();
        createInput();

        rootEntity.dispatchContext(rootEntity);
        createRunWrapper();
    }

    function createRunWrapper() {
        new SimpleRunBinder(rootEntity, null);
    }

    function regDrawcals() {
        new FlatColorPass(fui).register();
        new CmsdfPg(fui).register();
    }

    function setWindowPosition() {
        var wnd = openfl.Lib.application.window;
        if (wnd.y < 0)
            wnd.y = 20;
        wnd.x = 800;
    }

    /**
        Creates and binds GameInput. By default it is OneButton, supposed to override for exact buttons and axis set. 
    **/
    function createInput() {
        var input = new OneButtonInput();
        rootEntity.addComponentByType(GameInputUpdater, input);
        rootEntity.addComponentByType(GameButtons, input);
        rootEntity.addComponent(input);
        rootEntity.addComponentByName(MGA.toAlias(ButtonInputBinder, OneButton), new ButtonInputBinder(MGA.toString(OneButton), input.buttonListener));
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
        var flashCanvas = new Sprite();
        addChild(flashCanvas);
        rootEntity.addComponent(new FlashDisplayRoot(flashCanvas));
    }

    function initFui() {
        var rw = Builder.ph();
        rootEntity.addComponentByType(Placeholder2D, rw);
        fui.configureInput(rootEntity);
        fui.configureScreen(rootEntity);
        fui.configureAnimation(rootEntity);
        rootEntity.addComponent(fui);
        fui.createContainer(rootEntity, Xml.parse(XmlLayerLayouts.COLOR_AND_TEXT).firstElement());
        var container:Sprite = rootEntity.getComponent(Sprite);
        addChild(container);
        var v = new StageAspectResizer(rw, 2);
        var switcher = new WidgetSwitcher(rw);
        rootEntity.addComponent(switcher);
    }

    function iniupdater() {
        rootEntity.addComponent(new UpdateBinder(fui.updater));
    }

    function textStyles() {
        var font = "Assets/fonts/robo.fnt";
        fui.addBmFont("", font); // todo
        var pcStyleC = fui.textStyles.newStyle("center").withAlign(horizontal, Center).build();
        var pcStyle = fui.textStyles.newStyle("score") //        .withAlign(vertical, Center)
            .withSize(sfr, .1)
            .withPadding(horizontal, sfr, 0.3)
            .build();
        var fitStyle = fui.textStyles.newStyle("fit")
            .withSize(pfr, .5)
            .withAlign(horizontal, Forward)
            .withAlign(vertical, Backward)
            .withPadding(horizontal, pfr, 0.33)
            .withPadding(vertical, pfr, 0.33)
            .build();
        fui.textStyles.resetToDefaults();
        rootEntity.addComponentByType(TextContextStorage, fui.textStyles);
    }

    function dkitDefaultStyles() {
        BaseDkit.inject(fui);

        var default_text_style = "small-text";

        var pcStyle = fui.textStyles.newStyle(default_text_style)
            .withSize(sfr, .07)
            .withPadding(horizontal, sfr, 0.1)
            .withAlign(vertical, Center)
            .build();

        var e = rootEntity;
        var props = new DummyProps<String>();
        props.set(Dkit.TEXT_STYLE, default_text_style);
        e.addComponentByType(Props, props);

        var distributer = new al.layouts.Padding(new FractionSize(.25), new PortionLayout(Center, new FixedSize(0.1)));
        var contLayouts = new ContainerStyler();
        contLayouts.reg(GuiStyles.L_HOR_CARDS, distributer, WholefillLayout.instance);
        e.addComponent(contLayouts);
    }
}
