package fancy.widgets;

import a2d.Placeholder2D;
import a2d.ProxyWidgetTransform;
import a2d.Widget;
import al.prop.ScaleComponent;
import ec.CtxWatcher;
import htext.style.TextStyleContext;
import stset.Stats;
import update.Updatable;
import update.UpdateBinder;
import widgets.Label;

class IntPlusTmpLabel extends Widget implements Updatable implements IStatLabel {
    public var statName (default, set):String;
    var lbl:Label;
    var stat:TempIncGameStat<Int>;
    var style:TextStyleContext;
    var scale:ScaleComponent;
    var iph:Placeholder2D;

    public function new(p, s) {
        style = s;
        super(p);
        scale = ScaleComponent.getOrCreate(ph.entity);
        scale.value = 2;
        iph = ProxyWidgetTransform.grantInnerTransformPh(p);
        init();
    }

    override function init() {
        lbl = new Label(iph, style);
        if (stat != null)
            setText();

        entity.addComponentByType(Updatable, this);
        new CtxWatcher(UpdateBinder, entity);
    }

    public function setup(name:String, stat) {
        if (this.stat != null)
            throw "resetup not allowed";
        this.stat = stat;
        stat.onChange.listen(setText);
        statName = name;
        return this;
    }

    function setText(?_:Int) {
        var tmpVal = stat.tmp.value;
        var delta = if (tmpVal == 0) "" else if (tmpVal > 0) ' +$tmpVal' else ' -$tmpVal';
        lbl?.withText('$statName ${stat.prm.value}$delta');
        t = duration;
    }

    var t = 0.;
    var duration = .5;

    public function update(dt:Float) {
        if (t > 0) {
            t -= dt / duration;
            scale.value = 1 + t;
        } else if (t != 0) {
            t = 0;
            scale.value = 1;
        }
    }
    
    function set_statName(value:String):String {
        statName = value;
        setText();
        return value;
    }
}
