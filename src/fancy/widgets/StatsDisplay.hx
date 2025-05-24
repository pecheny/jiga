package fancy.widgets;

import ginp.Keyboard;
import utils.KeyBinder;
import i18n.I18n;
import dkit.Dkit;
import a2d.Widget;
import fu.PropStorage;
import htext.style.TextContextBuilder;
import htext.style.TextStyleContext;
import stset.Stats;

using al.Builder;
using Lambda;

class StatsDisplay extends Widget {
    @:once var unit:StatsSet;
    @:once var styles:TextContextStorage;
    @:once var props:PropStorage<Dynamic>;
    @:onceOpt var i18n(default, set):I18n;
    var tc:TextStyleContext;
    var labels:Map<String, IStatLabel>;

    override function init() {
        var styleName = props.get(Dkit.TEXT_STYLE);
        tc = styles.getStyle(styleName ?? "");
        labels = [for (k in unit.keys) k => factory(k, cast Reflect.field(unit, k))];
        Builder.createContainer(ph, horizontal, Center).withChildren(unit.keys.map(k -> labels[k].ph));
        localize();
        new KeyBinder().addCommand(Keyboard.E, () -> trace(i18n, entity.getComponentUpward(I18n)));
    }

    function localize() {
        if (i18n == null || labels == null)
            return;
        for (k in unit.keys) {
            labels[k].statName = i18n.tr('<$k/>');
        }
    }

    function factory(name, val:StatRO<Int>):IStatLabel {
        if (Std.isOfType(val, TempIncGameStat))
            return new IntPlusTmpLabel(Builder.widget(), tc).setup(name, cast val);
        return new ValLabel(Builder.widget(), tc).setup(name, val);
    }

    function set_i18n(value:I18n):I18n {
        i18n = value;
        localize();
        return value;
    }
}
