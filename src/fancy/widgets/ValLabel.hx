package fancy.widgets;

import htext.style.TextStyleContext;
import widgets.Label;
import a2d.Widget;
import stset2.Stats.CapGameStat;
import stset2.Stats.StatRO;

class ValLabel<T:Float> extends Widget {
    var lbl:Label;
    var statName:String;
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
        statName = name;
        this.stat = stat;
        stat.onChange.listen(setText);
        capped = null;
        if (Std.isOfType(stat, CapGameStat))
            capped = cast stat;
        setText();
        return this;
    }

    function setText(?_:T) {
        if (capped != null)
            lbl?.withText('$statName:<br/>${capped.value}/${capped.max}');
        else
            lbl?.withText('$statName:<br/>${stat.value}');
    }
}
