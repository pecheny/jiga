package fancy.widgets;

import bootstrap.Data.IntCapValue;
import bootstrap.Data.ChangingVal;
import htext.style.TextStyleContext;
import widgets.Label;
import a2d.Widget;

class ValLabel<T:Float> extends Widget {
    var lbl:Label;
    var statName:String;
    var stat:ChangingVal<T>;
    var capped:IntCapValue;
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

    public function setup(name:String, stat:ChangingVal<T>) {
        if (this.stat != null)
            throw "resetup not allowed";
        statName = name;
        this.stat = stat;
        stat.onChange.listen(setText);
        capped = null;
        if (Std.isOfType(stat, IntCapValue))
            capped = cast stat;
        setText();
        return this;
    }

    function setText(?_:T) {
        if (capped != null)
            lbl?.withText('$statName:<br/>${capped.getVal()}/${capped.max}');
        else
            lbl?.withText('$statName:<br/>${stat.getVal()}');
    }
}
