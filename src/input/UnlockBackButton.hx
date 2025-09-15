package input;

import openfl.OflKbd;
import ec.Entity;
import ec.CtxWatcher.CtxBinder;

class UnlockBackButton implements CtxBinder {
    @:isVar var count(default, set):Int = 0;
    var target:OflKbd;

    public function new(target) {
        this.target = target;
    }

    public function bind(e:Entity) {
        count++;
    }

    public function unbind(e:Entity) {
        count--;
    }

    function set_count(value:Int):Int {
        count = value;
        target.interceptBack = count < 1;
        return value;
    }
}
