package;

import widgets.ColouredQuad;
import fancy.widgets.ActivButton;
import haxe.ds.ReadOnlyArray;
import fancy.GuiApi.ToggleComponent;
import widgets.ColouredQuad.InteractiveColors;
import al.al2d.ChildrenPool.DataView;
import al.al2d.Placeholder2D;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.layouts.data.LayoutData;
import algl.Builder.PlaceholderBuilderGl;
import fancy.Layouts;
import fancy.Props;
import fancy.WidgetTester;
import fancy.domkit.Dkit;
import fancy.widgets.DataViewContainer;
import graphics.ShapesColorAssigner;
import widgets.ButtonBase;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class LevelupDemo extends WidgetTester {
    public function new() {
        super();
        var wdg = Builder.widget();
        fui.makeClickInput(wdg);

        createStyles();
        var b = new PlaceholderBuilderGl(fui.ar, true);
        b.keepStateAfterBuild = true;
        b.v(sfr, 0.15).h(sfr, 0.7);

        var toggles:Array<ToggleComponent> = [];
        var rgroup = new RadioGroup(toggles);
        var gui = new DataViewContainer<String, RadioButton>(wdg, (n) -> {
            var ph = b.b();
            var toggle = new ToggleComponent();
            ph.entity.addComponent(toggle);
            toggles.push(toggle);

            new ButtonBase(ph, rgroup.setActiveId.bind(n));
            ColouredQuad.flatClolorToggleQuad(ph);
            var clr = ph.entity.getComponent(ColorToggle);
            toggle.onChange.listen(() -> clr.setActive(toggle.value));
            new RadioButton(ph);
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
        e.addComponentByType(Props, props);

        var distributer = new al.layouts.Padding(new FractionSize(.25), new PortionLayout(Center, new FixedSize(0.1)));
        var contLayouts = new ContainerStyler();
        contLayouts.reg(GuiStyles.L_HOR_CARDS, distributer, WholefillLayout.instance);
        e.addComponent(contLayouts);
    }
}

class RadioGroup {
    var toggles:ReadOnlyArray<ToggleComponent>;
    var activeId = 0;

    public function new(tgls) {
        this.toggles = tgls;
    }

    public function setActiveId(id:Int) {
        if (toggles.length >= activeId)
            toggles[activeId].value = false;
        activeId = id;
        toggles[activeId].value = true;
    }
}

class RadioButton extends BaseDkit implements DataView<String> {
    static var SRC = <radio-button hl={PortionLayout.instance}>
    <label(b().h(pfr, .2).b()) id="status"  text={ "[ ]" }  />
    <label(b().h(pfr, .7).b()) id="caption"  text={ "text" }  />
</radio-button>;

    public function new(ph:Placeholder2D, ?parent:BaseDkit) {
        super(ph, parent);
        initComponent();
        initDkit();
        var tg = ToggleComponent.getOrCreate(ph.entity);
        tg.onChange.listen(() -> setState(tg.value));
    }

    function setState(val:Bool) {
        status.text = val ? "[X]" : "[--]";
    }

    public function initData(descr:String) {
        caption.text = descr;
    }
}