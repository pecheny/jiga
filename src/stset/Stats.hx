package stset;

import haxe.ds.ReadOnlyArray;
import fu.Signal;

@:autoBuild(stset.Stats.StatsMacro.build())
interface StatsSet {
    var keys(default, null):ReadOnlyArray<String>;
}

interface StatRO<T:Float> {
    var onChange(default, null):Signal<T->Void>;
    var value(get, null):T;
}

interface Serializable {
    function loadData(d:Dynamic):Void;
    function getData():Dynamic;
}

class GameStat<T:Float> implements StatRO<T> implements Serializable {
    public var onChange(default, null):Signal<T->Void> = new Signal();
    @:isVar public var value(get, set):T;

    function get_value():T {
        return value;
    }

    function set_value(newVal:T):T {
        var delta = newVal - value;
        value = newVal;
        onChange.dispatch(delta);
        return value;
    }

    public function new(v:T) {
        this.value = v;
    }

    public function loadData(d:Dynamic):Void {
        value = d;
    }

    public function getData():Dynamic
        return value;
}

class CapGameStat<T:Float> extends GameStat<T> {
    public var max(default, set):T;

    public function new(max:T, val:T = cast 0) {
        @:bypassAccessor this.max = max;
        super(val);
    }

    override function set_value(newVal:T):T {
        if (newVal > max)
            newVal = max;
        return super.set_value(newVal);
    }

    function set_max(val:T):T {
        max = val;
        set_value(value);
        return max;
        
    }
    override function getData():Dynamic {
        return {value:value, max:max};
    }
    override function loadData(d:Dynamic) {
        trace(d);
        if (d is Float) {
            max = d;
            value = cast 0;
        } else {
            value = d.value;
        }
        trace(value);
        
    }
}

class TempIncGameStat<T:Float> extends GameStat<T> {
    public var prm(default, null):GameStat<T>;
    public var tmp(default, null):GameStat<T>;

    public function new(val:T, ?prm, ?tmp) {
        this.prm = prm ?? new GameStat(val);
        this.tmp = tmp ?? new GameStat(cast 0);
        super(val);
        this.prm.onChange.listen(dispatch);
        this.tmp.onChange.listen(dispatch);
    }

    function dispatch(d) {
        onChange.dispatch(d);
    }

    override function get_value():T {
        return prm.value + tmp.value;
    }

    override function set_value(newVal:T):T {
        return prm.set_value(newVal);
    }
}
