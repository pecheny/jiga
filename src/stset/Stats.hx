package stset;

import fu.Signal;
import haxe.ds.ReadOnlyArray;

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

class GameStat<T:Int> implements StatRO<Int> implements Serializable {
    public var onChange(default, null):Signal<Int->Void> = new Signal();
    @:isVar public var value(get, set):Int;

    function get_value():Int {
        return value;
    }

    function set_value(newVal:Int):Int {
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

class CapGameStat<T:Float> extends GameStat<Int> {
    public var max(default, set):Int;

    public function new(max:Int, val:Int = cast 0) {
        @:bypassAccessor this.max = max;
        super(val);
    }

    override function set_value(newVal:Int):Int {
        if (newVal > max)
            newVal = max;
        return super.set_value(newVal);
    }

    function set_max(val:Int):Int {
        max = val;
        set_value(value);
        return max;
    }

    override function getData():Dynamic {
        return {value: value, max: max};
    }

    override function loadData(d:Dynamic) {
        trace(d);
        if (d is Float) {
            max = d;
            value = cast 0;
        } else {
            max = d.max;
            value = d.value;
        }
        trace(value);
    }
}

class TempIncGameStat<T:Float> extends GameStat<Int> {
    public var prm(default, null):GameStat<Int>;
    public var tmp(default, null):GameStat<Int>;

    public function new(val:Int, ?prm:GameStat<Int>, ?tmp) {
        this.prm = prm ?? new GameStat(val);
        this.tmp = tmp ?? new GameStat(0);
        super(val);
        this.prm.onChange.listen(dispatch);
        this.tmp.onChange.listen(dispatch);
    }

    function dispatch(d) {
        onChange.dispatch(d);
    }

    override function get_value():Int {
        return prm.value + tmp.value;
    }

    override function set_value(newVal:Int):Int {
        return prm.set_value(newVal);
    }
}
