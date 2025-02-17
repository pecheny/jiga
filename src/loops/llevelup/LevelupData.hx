package loops.llevelup;

import bootstrap.DefNode.GenericDef;
import hxmath.math.MathUtil;
import haxe.ds.ReadOnlyArray;

typedef CommandCall = String;


typedef LevelUpDesc = {
    weight:Float,
    name:String,
    actions:Array<CommandCall>,
    ?guards:Array<CommandCall>,
}

typedef LevelingDesc = {
    var levelups (default, null):ReadOnlyArray<LevelUpDesc>;
    var expToLvl (default, null):ReadOnlyArray<Int>;
}

class LevelingDef extends GenericDef<LevelingDesc> {}

