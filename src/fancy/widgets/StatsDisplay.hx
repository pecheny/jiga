package fancy.widgets;

import a2d.Widget;
import bootstrap.Data.ChangingVal;
import bootstrap.Data.IntPlusTempValue;
import dungsmpl.DungeonData.BattleStats;
import fancy.domkit.Dkit;
import fu.PropStorage;
import htext.style.TextContextBuilder;
import htext.style.TextStyleContext;

using al.Builder;

class StatsDisplay extends Widget {
    @:once var unit:BattleStats;
    @:once var styles:TextContextStorage;
    @:once var props:PropStorage<Dynamic>;
    var tc:TextStyleContext;

    override function init() {
        var styleName = props.get(Dkit.TEXT_STYLE);
        tc = styles.getStyle(styleName??"");
        Builder.createContainer(ph, horizontal, Center).withChildren([
            for (kv in unit.stats.keyValueIterator())
                factory(kv.key, cast kv.value)
        ]);
    }

    function factory(name, val:ChangingVal<Int>) {
        if (Std.isOfType(val, IntPlusTempValue))
            return new IntPlusTmpLabel(Builder.widget(), tc).setup(name, cast val).ph;
        return new ValLabel(Builder.widget(), tc).setup(name, val).ph;
    }
}
