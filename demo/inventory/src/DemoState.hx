package;

import fu.Serializable;
import persistent.State;

class DemoState implements State implements Serializable {
    @:serialize public var items (default, null):Array<Item> = []; 

    public function new() {}
}

typedef Weapon = {
    ?weapon:{dmg:Int}
}

typedef Armor = {
    ?armor:{def:Int}
}

typedef Consumable = {
    ?consumable:{
        var count:Int;
        var action:String;
    }
}

typedef Item = {
    >Weapon,
    >Armor,
    >Consumable,
    ?index:Int,
}
