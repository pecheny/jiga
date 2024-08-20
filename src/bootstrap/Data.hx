package bootstrap;

import fu.Signal;

typedef Weight = Float;
typedef NormVal = Float;

@:enum abstract Sign(Int) to Int {
    var positive = 1;
    var negative = -1;

    public inline function other():Sign {
        return cast this * -1;
    }
}

interface RO<T:Float> {
    function getVal():T;
}

interface RW<T:Float> extends RO<T> {
    function changeVal(delta:T):T;
    function setVal(newVal:T):T;
}

// class ObservableVal<T:Float> implements RW<T> {
//     var val:RW<T>;
//     public var onChange(default, null) = new IntSignal();
//     public function new(v) {
//         this.val = v;
//     }
//     public function getVal():T {
//         return val.getVal();
//     }
//     public function changeVal(delta:T):T {
//         var r = val.changeVal(delta);
//         onChange.dispatch(r);
//         return r;
//     }
//     public function setVal(newVal:T):T {
//         var r = val.setVal(newVal);
//         onChange.dispatch(r);
//         return r;
//     }
// }

interface ChangingVal<T:Float> extends RO<T> {
    public var onChange(get, null):ISignal<T>;
}

class IntCapValue implements RW<Int> implements ChangingVal<Int> {
    public var onChange(get, null):ISignal<Int>;

    function get_onChange() {
        return _onChange;
    }

    var _onChange = new IntSignal();

    public var max(default, set):Int;

    var val:Int;

    public function new(v) {
        max = v;
        val = v;
    }

    public function getVal():Int {
        return val;
    }

    public function changeVal(delta:Int):Int {
        return setVal(val + delta);
    }

    public function init(v) {
        max = val = v;
        _onChange.dispatch(0);
    }

    public function setVal(newVal:Int):Int {
        if (newVal > max)
            newVal = max;
        var delta = newVal - val;
        val = newVal;
        _onChange.dispatch(delta);
        return val;
    }

    public function normalized() {
        return val / max;
    }

    function set_max(value:Int):Int {
        max = value;
        setVal(val);
        return max;
    }
}

// class IntValue implements RW<Int> {
//     var val:Int;
//     public function new(v) {
//         val = v;
//     }
//     public function getVal():Int {
//         return val;
//     }
//     public function changeVal(delta:Int):Int {
//         return val += delta;
//     }
//     public function setVal(newVal:Int):Int {
//         return val = newVal;
//     }
// }

class IntValue implements RW<Int> implements ChangingVal<Int> {
    public var onChange(get, null):ISignal<Int>;

    function get_onChange() {
        return _onChange;
    }

    var _onChange = new IntSignal();

    var val:Int;

    public function new(v) {
        val = v;
    }

    public function getVal():Int {
        return val;
    }

    public function changeVal(delta:Int):Int {
        return setVal(val + delta);
    }

    public function setVal(newVal:Int):Int {
        var delta = newVal - val;
        val = newVal;
        _onChange.dispatch(delta);
        return val;
    }
}

class IntPlusTempValue implements RW<Int> implements ChangingVal<Int> {
    public var prm(default, null):IntValue;
    public var tmp(default, null):IntValue;
    public var onChange(get, null):ISignal<Int>;

    var _onChange = new IntSignal();

    function get_onChange() {
        return _onChange;
    }

    public function new(v) {
        prm = new IntValue(v);
        prm.onChange.listen(dispatch);
        tmp = new IntValue(0);
        tmp.onChange.listen(dispatch);
    }

    function dispatch(_) {
        _onChange.dispatch(0);
    }

    public function getVal():Int {
        return prm.getVal() + tmp.getVal();
    }

    public function changeVal(delta:Int):Int {
        return prm.setVal(prm.getVal() + delta);
    }

    public function setVal(newVal:Int):Int {
        return prm.setVal(newVal);
    }
}
