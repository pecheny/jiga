package fancy;

import ec.Entity;
import fancy.domkit.Dkit.BaseDkit;
import al.ec.WidgetSwitcher;
import FuiBuilder.XmlLayerLayouts;
import al.Builder;
import openfl.display.Sprite;

using al.Builder;
using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;

class WidgetTester extends Sprite {
    public var fui:FuiBuilder;
    public var switcher:WidgetSwitcher<Axis2D>;

    var e:Entity;

    public function new() {
        super();
        fui = new FuiBuilder();

        new FlatColorPass(fui).register();
        new CmsdfPass(fui).register();
        BaseDkit.inject(fui);
        fui.regDefaultDrawcalls = () -> {};
        e = fui.createDefaultRoot(XmlLayerLayouts.COLOR_AND_TEXT);
        switcher = e.getComponent(WidgetSwitcher);
        var container:Sprite = e.getComponent(Sprite);
        addChild(container);
    }
}
