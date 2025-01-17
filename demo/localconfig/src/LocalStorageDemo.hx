package;

import al.ec.WidgetSwitcher;
import ec.Entity;
import dkit.Dkit.BaseDkit;
import openfl.display.Sprite;
import al.layouts.PortionLayout;
import fu.PropStorage;
import fu.graphics.ColouredQuad;
import fu.ui.ButtonBase;
import fu.ui.Properties;
import storage.LocalStorage;
import storage.Storage;

using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;
using al.Builder;

class LocalStorageDemo extends Sprite {
    public function new() {
        super();
        
        var fui = new FuiBuilder();
        BaseDkit.inject(fui);
        var root:Entity = fui.createDefaultRoot();
        var uikit = new FlatUikitExtended(fui);
        uikit.configure(root);
        uikit.createContainer(root);

        var switcher = root.getComponent(WidgetSwitcher);
        var bw = new DomkitSampleWidget(Builder.widget());
        bw.entity.addComponentByType(Storage, new LocalStorage());

        fui.makeClickInput(bw.ph);
        switcher.switchTo(bw.ph);
    }

}

class DomkitSampleWidget extends BaseDkit {
    static var SRC = <domkit-sample-widget vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b())  text={ "This button can stay in pressed or released state. The state stored in target-dependent local storage: json file in app data dir on sys targets and browser localStorage on HTML5." }  />
        <base(b().v(pfr, 0.1).l().b()) >
            ${new ToggleButton (__this__.ph)}
            ${new PersistentProperty(__this__.entity,CheckedProp.getOrCreate(__this__.entity), "buttonToggled")}
            <label(b().b())  text={ "Button" }  />
        </base>
        <base(b().v(pfr, .2).b())   />
    </domkit-sample-widget>
}

class ToggleButton extends ButtonBase {
    var colorToggle:ColorToggle;
    var toggle:CheckedProp;

    public function new(w) {
        super(w, null);
        toggle = CheckedProp.getOrCreate(w.entity);
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
