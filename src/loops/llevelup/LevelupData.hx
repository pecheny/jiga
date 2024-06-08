package loops.llevelup;

import bootstrap.DefNode;
import haxe.ds.ReadOnlyArray;

typedef CommandCall = String;

typedef LevelUpDesc = {
    weight:Float,
    name:String,
    actions:Array<CommandCall>,
    ?guards:Array<CommandCall>,
}

typedef LevelingDesc = {
    levelups:ReadOnlyArray<LevelUpDesc>,
}

class LevelingDef extends DefNode<LevelingDesc> {}
