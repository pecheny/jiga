package;

import a2d.Placeholder2D;
import a2d.PlaceholderBuilder2D;
import al.core.DataView;
import al.core.TWidget;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.layouts.data.LayoutData;
import fancy.Layouts;
import fu.PropStorage;
import fancy.WidgetTester;
import fancy.domkit.Dkit;
import fancy.widgets.DataViewContainer;
import fu.graphics.ColouredQuad;
import fu.ui.ButtonBase;
import fu.ui.Properties;

using a2d.transform.LiquidTransformer;
using al.Builder;

class LevelupDemo extends WidgetTester {
	public function new() {
		super();
		var wdg = Builder.widget();
		fui.makeClickInput(wdg);

		createStyles();
		var b = new PlaceholderBuilder2D(fui.ar, true);
		b.keepStateAfterBuild = true;
		b.v(sfr, 0.15).h(sfr, 0.7);

		var gui = new RadioGroup<String, RadioButton>(wdg, (n) -> {
			new RadioButton(b.b());
		});
		gui.initData(["foo", "bar", "baz"]);
		switcher.switchTo(wdg);
	}

	function createStyles() {
		var default_text_style = "small-text";

		var pcStyle = fui.textStyles.newStyle(default_text_style)
			.withSize(sfr, .07)
			.withPadding(horizontal, sfr, 0.1)
			.withAlign(vertical, Center)
			.build();

		var props = new DummyProps<String>();
		props.set(Dkit.TEXT_STYLE, default_text_style);
		e.addComponentByType(PropStorage, props);

		var distributer = new al.layouts.Padding(new FractionSize(.25), new PortionLayout(Center, new FixedSize(0.1)));
		var contLayouts = new ContainerStyler();
		contLayouts.reg(GuiStyles.L_HOR_CARDS, distributer, WholefillLayout.instance);
		e.addComponent(contLayouts);
	}
}

class RadioGroup<TData, TWidget:IWidget<Axis2D> & DataView<TData>> extends DataViewContainer<TData, TWidget> {
	var toggles:Array<CheckedProp> = [];
	var activeId = 0;
	var fac:Int->TWidget;

	public function new(ph, fac) {
		this.fac = fac;
		super(ph, factory);
	}

	function factory(n) {
		var wdg = fac(n);
		toggles.push(CheckedProp.getOrCreate(wdg.entity));
		new ButtonBase(wdg.ph, setActiveId.bind(n));
		return wdg;
	}

	public function setActiveId(id:Int) {
		if (toggles.length >= activeId)
			toggles[activeId].value = false;
		activeId = id;
		toggles[activeId].value = true;
	}

	override function initData(descr:Array<TData>) {
		super.initData(descr);
		if (_inited)
			setActiveId(0);
	}
}

class RadioButton extends BaseDkit implements DataView<String> {
	static var SRC = <radio-button hl={PortionLayout.instance}>
    <label(b().h(pfr, .2).b()) id="status"  text={ "[ ]" }  />
    <label(b().h(pfr, .7).b()) id="caption"  text={ "text" }  />
</radio-button>;

	@:once var vswitcher:ClickViewProcessor;

	var toggle:CheckedProp;
	var clr:ColorToggle;

	public function new(ph:Placeholder2D, ?parent:BaseDkit) {
		super(ph, parent);
		initComponent();
		initDkit();
	}

	override function init() {
		super.init();
        ColouredQuad.flatClolorToggleQuad(ph);
        clr = ph.entity.getComponent(ColorToggle);
        toggle = CheckedProp.getOrCreate(ph.entity);
        toggle.onChange.listen(invalidate);
        invalidate();
	}

	function invalidate() {
		clr.setActive(toggle.value);
		status.text = toggle.value ? "[X]" : "[--]";
	}

	public function initData(descr:String) {
		caption.text = descr;
	}
}
