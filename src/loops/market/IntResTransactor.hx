package loops.market;

import loops.market.MarketData;
import stset.Stats.GameStat;

class IntResTransactor implements ResourceTransactor<Int> {
    var stat:GameStat<Int>;

    public function new(stat) {
        this.stat = stat;
    }

    public function has(res:Int):Bool {
        return stat.value >= res;
    }

    public function spend(res:Int):Bool {
        if (! has(res))
            return false;
        stat.value -= res;
        return true;
    }
}
