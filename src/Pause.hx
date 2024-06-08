package;

import ec.Signal;
import ec.Entity;
import ec.CtxWatcher.CtxBinder;

class Pause implements Pausable implements CtxBinder {
    var targets:Array<Pausable> = [];
    public var onChange:Signal<Bool->Void> = new Signal();

    public var paused(default, null) = false;

    public function new() {}

    public function pause(v:Bool) {
        paused = v;
        for (p in targets)
            p.pause(v);
        onChange.dispatch(v);
    }

    public function bind(e:Entity) {
        trace("bind");
        var p = e.getComponent(Pausable);
        if (p != null) addChild(p);
    }

    public function unbind(e:Entity) {
        var p = e.getComponent(Pausable);
        if (p != null)
            targets.remove(p);
    }

    public function addChild(p:Pausable) {
        targets.push(p);
        p.pause(paused);
    }
}

interface Pausable {
    public function pause(v:Bool):Void;
}
