package shared;

import bootstrap.Data.IntValue;
import stset.Stats;

enum abstract ProgStat(String) to String from String {
    var exp;
    var gld;
    var lvl;
}
class ProgStats extends Stats<ProgStat, IntValue> {}

