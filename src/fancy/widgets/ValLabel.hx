package fancy.widgets;

import htext.style.TextStyleContext;
import widgets.Label;
import a2d.Widget;
import stset.Stats.CapGameStat;
import stset.Stats.StatRO;

class ValLabel<T:Float> extends Widget implements IStatLabel {
    public var statName (default, set):String;
    var lbl:Label;
    var stat:StatRO<T>;
    var capped:CapGameStat<T>;
    var style:TextStyleContext;

    public function new(p, s) {
        style = s;
        super(p);
        init();
    }

    override function init() {
        lbl = new Label(ph, style);
        if (stat != null)
            setText();
    }

    public function setup(name:String, stat:StatRO<T>) {
        if (this.stat != null)
            throw "resetup not allowed";
        this.stat = stat;
        stat.onChange.listen(setText);
        capped = null;
        if (Std.isOfType(stat, CapGameStat))
            capped = cast stat;
        statName = name;
        return this;
    }

    function setText(?_:T) {
        if (capped != null)
            lbl?.withText('$statName ${capped.value}/${capped.max}');
        else
            lbl?.withText('$statName ${stat.value}');
    }

    function set_statName(value:String):String {
        statName = value;
        setText();
        return value;
    }
}
