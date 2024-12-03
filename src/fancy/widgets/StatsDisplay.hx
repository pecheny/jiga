package fancy.widgets;

import a2d.Widget;
import fancy.domkit.Dkit;
import fu.PropStorage;
import htext.style.TextContextBuilder;
import htext.style.TextStyleContext;
import stset.Stats;

using al.Builder;

class StatsDisplay extends Widget {
    @:once var unit:StatsSet;
    @:once var styles:TextContextStorage;
    @:once var props:PropStorage<Dynamic>;
    var tc:TextStyleContext;

    override function init() {
        var styleName = props.get(Dkit.TEXT_STYLE);
        tc = styles.getStyle(styleName??"");
        Builder.createContainer(ph, horizontal, Center).withChildren([
            for (k in unit.keys)
                factory(k, cast Reflect.field(unit, k))
        ]);
    }

    function factory(name, val:StatRO<Int>) {
        if (Std.isOfType(val, TempIncGameStat))
            return new IntPlusTmpLabel(Builder.widget(), tc).setup(name, cast val).ph;
        return new ValLabel(Builder.widget(), tc).setup(name, val).ph;
    }
}
