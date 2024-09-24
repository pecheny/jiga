package fancy;

import ec.Entity;
import ec.IComponent;
import ec.Component;

interface Props<T> {
    public function get(name:String):T;
    public function set(name:String, val:T):Void;
}

class DummyProps<T> implements Props<T> {
    var map:Map<String, T> = new Map();

    public function get(name:String):T {
        return map.get(name);
    }

    public function set(k, v:T) {
        map.set(k, v);
    }

    public function new() {}
}

class CascadeProps<T> extends DummyProps<T> implements IComponent {
    var name:String;
    var defaultVal:T;

    @:isVar public var entity(get, set):Entity;

    public function new(defaultVal:T, name:String = "") {
        super();
        this.name = name;
        this.defaultVal = defaultVal;
    }

    inline function paretn() {
        return entity?.parent?.getComponentUpward(Props);
    }

    override function get(alias:String) {
        var val = super.get(alias);
        if (val != null)
            return val;
        var up = paretn();
        if (up == null)
            return defaultVal;
        return up.get(alias);
    }

    function get_entity():Entity {
        return entity;
    }

    function set_entity(value:Entity):Entity {
        return entity = value;
    }
}

class PropsAccess<T> {
    var p:Props<T>;

    function new() {}

    
    public static function getOrCreateStr<T>(e:Entity):PropsAccess<T> {
        var pa = new PropsAccess<T>();
        pa.p = null;
        pa.p = e.getComponent(Props);
        if (pa.p != null)
            return pa;
        pa.p = new CascadeProps<T>(null, e.name + "-props");
        e.addComponentByType(Props, pa.p);
        return pa;
    }

    public function with(name, val:T) {
        p.set(name, val);
        return this;
    }
}
