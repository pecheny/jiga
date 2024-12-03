package fancy.widgets;

import bootstrap.Data.ChangingVal;
import bootstrap.Data.IntPlusTempValue;
import htext.style.TextStyleContext;
import widgets.Label;
import a2d.Widget;
import stset.Stats;

class IntPlusTmpLabel extends Widget {
    var lbl:Label;
    var statName:String;
    var stat:TempIncGameStat<Int>;
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

    public function setup(name:String, stat) {
        if (this.stat != null)
            throw "resetup not allowed";
        statName = name;
        this.stat = stat;
        stat.onChange.listen(setText);
        setText();
        return this;
    }

    function setText(?_:Int) {
        var tmpVal = stat.tmp.value;
        var delta = if (tmpVal == 0) "" else if (tmpVal > 0) ' +$tmpVal' else ' -$tmpVal';
        lbl?.withText('$statName:<br/>${stat.prm.value}$delta');
    }
}
