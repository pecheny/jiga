package bootstrap;

import gl.passes.CmsdfPass;
import gl.aspects.ExtractionUtils.TextureAspectFactory;
import htext.FontAspectsFactory;
import fu.GuiDrawcalls;
import a2d.Placeholder2D;
import al.ec.WidgetSwitcher;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.layouts.data.LayoutData;
import al.openfl.StageAspectResizer;
import al.openfl.display.FlashDisplayRoot;
import backends.lime.MultitouchRoot;
import backends.openfl.OpenflBackend;
import ec.CtxWatcher;
import ec.Entity;
import ecbind.MultiInputBinder;
import fancy.Layouts.ContainerStyler;
import fancy.Props;
import fancy.domkit.Dkit;
import gameapi.GameRun;
import gameapi.GameRunBinder;
import ginp.GameButtonsImpl;
import ginp.api.GameButtons;
import ginp.api.GameInputUpdater;
import ginp.api.GameInputUpdaterBinder;
import ginp.presets.OneButton;
import ginp.presets.OneButtonInput;
import gl.passes.FlatColorPass;
import gl.passes.ImagePass;
import gl.passes.MsdfPass;
import htext.style.TextContextBuilder;
import input.ButtonInputBinder;
import loops.bounce.BouncingLoop;
import loops.bounce.BouncingTimeline.MyWeaponFac;
import loops.bounce.gui.BouncingWidget;
import openfl.display.Sprite;
import shimp.MultiInputTarget;
import states.States;
import update.UpdateBinder;
import utils.AbstractEngine;
import utils.MacroGenericAliasConverter as MGA;

using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;
using al.Builder;

class BootstrapMain extends AbstractEngine {
	var fui = new FuiBuilder();
	var rootEntity:Entity;
	var stateSwitcher:StateSwitcher;

	public function new() {
		super();
		rootEntity = new Entity("root");
		setWindowPosition();
		regDrawcals();
		textStyles();
		createFlashDisplay();
		initFui();
		dkitDefaultStyles();
		createInput();
		iniUpdater();

		// rootEntity.dispatchContext(rootEntity);
		createRunWrapper();
		createRun();
	}

	function createRun() {}

	function enterRun(run:GameRun) {
		run.entity.addComponentByType(GameRun, run);
		new CtxWatcher(GameRunBinder, run.entity);
		rootEntity.addChild(run.entity);
	}

	function createRunWrapper() {
		new SimpleRunBinder(rootEntity, null);
	}

	function regDrawcals() {
		var pipeline = fui.pipeline;
		pipeline.addPass(GuiDrawcalls.BG_DRAWCALL, new FlatColorPass());
		pipeline.addPass(GuiDrawcalls.TEXT_DRAWCALL, new CmsdfPass());
		var fontAsp = new FontAspectsFactory(fui.fonts, pipeline.textureStorage);
		pipeline.addAspectExtractor(GuiDrawcalls.TEXT_DRAWCALL, fontAsp.create, fontAsp.getAlias);

		pipeline.addPass(PictureDrawcalls.IMAGE_DRAWCALL, new ImagePass());
		var picAsp = new TextureAspectFactory(pipeline.textureStorage);
		pipeline.addAspectExtractor(PictureDrawcalls.IMAGE_DRAWCALL, picAsp.create);
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
		var root = new InputRoot(new InputToMultiTarget(mibinder, -1), ar.getAspectRatio());
		rootEntity.addComponent(mibinder);
	}

	/**
		Creates and binds GameInput. By default it is OneButton, supposed to override for exact buttons and axis set. 
	**/
	function createInput() {
		var input = new OneButtonInput();
		rootEntity.addComponentByType(GameInputUpdater, input);
		rootEntity.addComponentByType(GameButtons, input);
		rootEntity.addComponent(input);
		// listen for gui buttons dispatchers
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
		fui.createContainer(rootEntity, Xml.parse(GuiDrawcalls.DRAWCALLS_LAYOUT).firstElement());
		// var container:Sprite = rootEntity.getComponent(Sprite);
		// addChild(container);
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

	function textStyles() {
		var font = "Assets/fonts/robo.fnt";
		fui.addBmFont("", font); // todo
		var ts = fui.textStyles;
		ts.newStyle("small-text")
			.withSize(sfr, .07)
			.withPadding(horizontal, sfr, 0.1)
			.withAlign(vertical, Center)
			.build();
		ts.resetToDefaults();
		ts.newStyle("center").withAlign(horizontal, Center).build();
		ts.newStyle("fit")
			.withSize(pfr, .5)
			.withAlign(horizontal, Forward)
			.withAlign(vertical, Backward)
			.withPadding(horizontal, pfr, 0.33)
			.withPadding(vertical, pfr, 0.33)
			.build();
		rootEntity.addComponent(ts.getStyle("fit"));
		ts.resetToDefaults();
		rootEntity.addComponentByType(TextContextStorage, ts);
	}

	function dkitDefaultStyles() {
		BaseDkit.inject(fui);
		var e = rootEntity;
		var props = e.getOrCreate(Props, () -> new CascadeProps<String>(null, "root-props"));
		props.set(Dkit.TEXT_STYLE, "small-text");

		var distributer = new al.layouts.Padding(new FractionSize(.25), new PortionLayout(Center, new FixedSize(0.1)));
		var contLayouts = new ContainerStyler();
		contLayouts.reg(GuiStyles.L_HOR_CARDS, distributer, WholefillLayout.instance);
		contLayouts.reg(GuiStyles.L_VERT_BUTTONS, WholefillLayout.instance, distributer);
		e.addComponent(contLayouts);
	}
}
