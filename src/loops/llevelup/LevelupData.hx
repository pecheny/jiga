package loops.llevelup;

import hxmath.math.MathUtil;
import bootstrap.DefNode;
import haxe.ds.ReadOnlyArray;

typedef CommandCall = String;

typedef Leveled = {
    levels:Array<Dynamic>,
    ?curLvl:Int
}

typedef LevelUpDesc = {
    weight:Float,
    name:String,
    actions:Array<CommandCall>,
    ?guards:Array<CommandCall>,
}

typedef LevelingDesc = {
    levelups:ReadOnlyArray<LevelUpDesc>,
    expToLvl:ReadOnlyArray<Int>
}

class LevelingDef extends DefNode<LevelingDesc> {}

class DefLvlNode<T:Leveled> extends DefNode<T> {
    public function getLvl(path, lvl:Int) {
        var def = get(path);
        if (def.levels == null)
            return def;
        var curLvl = MathUtil.intMin(lvl + 1, def.levels.length);
        for (l in 1...curLvl)
            apply(def, def.levels[l]);
        def.curLvl = curLvl;
        return def;
    }

    function apply(dst, src) {
        for (k in Reflect.fields(src)) {
            Reflect.setField(dst, k, Reflect.field(src, k));
        }
    }
}
