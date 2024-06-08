package stset;

import bootstrap.Component;
import bootstrap.Data;
import ec.Entity;
import openfl.display.Sprite;

class LiveStats extends Stats<LiveStat, IntCapValue> {}
class BattleStats extends Stats<BattleStat, IntValue> {}
class ProgStats extends Stats<ProgStat, IntValue> {}

enum abstract LiveStat(String) to String from String {
    var hlt;
    var man;
}

enum abstract BattleStat(String) to String from String {
    var dmg;
    var spd;
    var def;
    var hts;
    var hlt;
}

enum abstract ProgStat(String) to String from String {
    var exp;
    var gld;
    var lvl;
}

class StatsPg extends Sprite {
    public function new() {
        super();
        // var bs = new BattleStats();
        // trace(bs.keys());
        // var e = new Entity();
        // e.addComponent(bs);
        // e.addComponent(new LiveStats());
        // bs.dmg = 10;
        // bs.dmg++;
        // trace(bs.dmg);

        // var abs:ValWrrap = bs.getStat(dmg);
        // trace(1+abs);

        // var battleStats:StatSet<BattleStatWrap, BattleStats> = new StatSet<BattleStatWrap, BattleStats>(stats,);
        test_shared_map();
    }

    function test_shared_map() {
        // it is important to create storage map with ? interface value type param
        // casting map<T, TVal1:I> to map<T, TVal2:I> gives unpredictable results
        // even when you reference to val:I = map.get()
        var map = new Map<String, RW<Int>>();

        // if underlaying value types are different, the order of construction matters.
        // the first Stats subclass containing stat with shared name constructs value of its own underlaying type
        // it should be compatible with underlaying types of all further Stats sublacces referencing stat with this name
        var ls = new LiveStats(map);
        trace(map);
        ls.getStat(hlt).onChange.listen(v -> trace("hlt " + v));
        ls.initAll({hlt: 10});
        trace(ls.hlt);

        ls.hlt = 15;

        ls.hlt++;
        // trace(ls.hlt);
        var bs = new BattleStats(map);
        var s = bs.stats.get("hlt");

        bs.hlt = 15;
        bs.hlt++;
        trace("assert", (ls.hlt == bs.hlt), (ls.hlt == 10), bs.hlt);
    }
}

class TestClient extends Component {
    @:once var battleStats:BattleStats;
    @:once var liveStats:LiveStats;

    public function hit(incomingDmg:Int) {
        var dmg = incomingDmg - battleStats.def;
        liveStats.getStat(hlt).changeVal(-dmg);
    }
}
