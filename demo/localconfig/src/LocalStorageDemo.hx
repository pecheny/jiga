package;

import al.layouts.PortionLayout;
import fancy.GuiApi.ToggleComponent;
import fancy.Layouts.ContainerStyler;
import fancy.Props;
import fancy.WidgetTester;
import fancy.domkit.Dkit;
import storage.LocalStorage;
import storage.Storage;
import widgets.ButtonBase;
import widgets.ColouredQuad;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class LocalStorageDemo extends WidgetTester {
    public function new() {
        super();
        var bw = new DomkitSampleWidget(Builder.widget());
        createStyles();
        bw.entity.addComponentByType(Storage, new LocalStorage());

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
        e.addComponentByType(Props, props);

        var contLayouts = new ContainerStyler();
        e.addComponent(contLayouts);
    }
}

class DomkitSampleWidget extends BaseDkit {
    static var SRC = <domkit-sample-widget vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b())  text={ "This button can stay in pressed or realised state. The state stored in target-dependent local storage: json file in app data dir on sys targets and browser localStorage on HTML5." }  />
        <base(b().v(pfr, 0.1).l().b()) >
            ${new ToggleButton (__this__.ph)}
            ${new PersistentProperty(__this__.entity,ToggleComponent.getOrCreate(__this__.entity), "buttonToggled")}
            <label(b().b())  text={ "Button" }  />
        </base>
        <base(b().v(pfr, .2).b())   />
    </domkit-sample-widget>
}

class ToggleButton extends ButtonBase {
    var colorToggle:ColorToggle;
    var toggle:ToggleComponent;

    public function new(w) {
        super(w, null);
        toggle = ToggleComponent.getOrCreate(w.entity);
        var q = ColouredQuad.flatClolorToggleQuad(w);
        colorToggle = q.ph.entity.getComponent(ColorToggle);
        invalidate();
        toggle.onChange.listen(invalidate);
    }

    function invalidate() {
        colorToggle.setActive(toggle.value);
    }

    override function handler() {
        toggle.value = !toggle.value;
    }
}
