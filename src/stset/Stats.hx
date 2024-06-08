package stset;

import bootstrap.Data;

@:autoBuild(stset.StatsMacro.build())
class Stats<TName:String, T:RW<Int>> {
    public var stats(default, null):Map<String, RW<Int>>;

    public function new(?store:Map<String, RW<Int>>) {
        stats = if (store != null) store else new Map();

        createValues();
    }

    function createValues() {}

    public function getStat(name:TName):T {
        return cast stats.get(name);
    }

    public function keys():Array<String> {
        throw "abstract";
    }

    public inline function getShared<T>(cl:Class<T>, name:TName):T {
        // inline is a workaround of bug in hl when casn obbject from map to its own type make it broken
        var val = stats.get(name);
        try {
            return cast val;
        } catch (e) {
            trace("e " + e);
            return null;
        }
    }

    public function initAll(desc:Dynamic, dflt = 0) {
        for (statName in keys()) {
            var val = if (Reflect.hasField(desc, statName)) Reflect.field(desc, statName) else 0;
            var stat = stats.get(statName);
            if (Std.isOfType(stat, IntCapValue)) {
                cast(stat, IntCapValue).init(val);
            }
            stat.setVal(val);
        }
    }
}
