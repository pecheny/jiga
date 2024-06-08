package utils;

interface ISignal<T> {
    public function listen(listener:T->Void) :Void;
}

class IntSignal implements ISignal<Int>{
    var listeners:Array<Int->Void> = [];
    var isDispatching = false;
    var toRemove:Array<Int->Void> = [];

    public function new() {
    }

    public function listen(listener:Int->Void) {
        listeners.push(listener);
    }

    public function dispatch(n) {
            isDispatching = true;
            for (listener in listeners) listener(n);
            isDispatching = false;
            for (listener in toRemove) listeners.remove(toRemove.shift());
    }

    public inline function remove(l:Int->Void) {
        if (isDispatching)
            toRemove.push(l);
        else
            listeners.remove(l);
    }
}

class Signal<T:haxe.Constraints.Function> {
    var listeners:Array<T> = [];
    var isDispatching = false;
    var toRemove:Array<T> = [];

    public function new() {
    }

    public inline function listen(listener:T) {
        listeners.push(listener);
    }

    public macro function dispatch(signal, args:Array<haxe.macro.Expr>) {
        return macro {
            @:privateAccess $signal.isDispatching = true;
            for (listener in $signal.asArray()) listener($a{args});
            @:privateAccess $signal.isDispatching = false;
            for (listener in @:privateAccess $signal.toRemove) @:privateAccess $signal.listeners.remove(@:privateAccess $signal.toRemove.shift());
        }
    }

    public inline function asArray() return listeners;

    public inline function remove(l:T) {
        if (isDispatching)
            toRemove.push(l);
        else
            listeners.remove(l);
    }
}
