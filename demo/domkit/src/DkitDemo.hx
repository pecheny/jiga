package;

import a2d.ContainerStyler;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.layouts.data.LayoutData;
import fancy.WidgetTester;
import fancy.domkit.Dkit;
import fu.PropStorage;

using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;
using al.Builder;

class DkitDemo extends WidgetTester {
    public function new() {
        super();
        var bw = new DomkitSampleWidget(Builder.widget());
        // var bw = new CMSDFLabel(Bu)
        createStyles();

        fui.makeClickInput(bw.ph);
        switcher.switchTo(bw.ph);
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

class DomkitSampleWidget extends BaseDkit {
    // public var onDone:Signal<Void->Void> = new Signal();
    static var SRC = <domkit-sample-widget vl={PortionLayout.instance}>
        
        <label(b().v(pfr, .2).b()) id="lbl"  text={ "Do you want to buy smth?" }  >
        </label>
        <base(b().v(pfr, 0.7).b())  >
        ${fui.quad(__this__.ph, 0xff025f29)}
        </base>
        <button(b().v(pfr, .1).h(sfr, 0.5).b())   text={ "Ok" } onClick={onOkClick}  />
        <base(b().v(pfr, 0.2).b()) />
    </domkit-sample-widget>

    function onOkClick() {
        trace("click");
    }
}
