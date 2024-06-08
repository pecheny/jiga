package loops.llevelup;

import shared.ProgStats;
import loops.llevelup.LevelupData.LevelingDef;
import bootstrap.Executor;
import fancy.widgets.NumChoisesWidget;
import utils.WeightedRandomProvider;
import loops.llevelup.LevelupData.LevelUpDesc;
import haxe.ds.ReadOnlyArray;
// import dungsmpl.DungeonData;
// import bootstrap.Unit;
import gameapi.CheckedActivity;
import bootstrap.GameRunBase;

class LevelUpActivity extends GameRunBase implements CheckedActivity {
    @:once var stats:ProgStats;
    // @:once var defs:DungeonDefs; // todo  replace with levelup defs
    @:once var defs:LevelingDef;
    @:once var executor:Executor;
    var gui:NumChoisesWidget;
    var expToLvl = [0, 5, 10, 15, 30, 50, 70, 90, 100, 120, 140];

    public function new(ctx, w) {
        gui = new NumChoisesWidget(w);
        gui.onChoise.listen(onChoise);
        super(ctx, w);
    }

    var options:Array<LevelUpDesc>;

    override function startGame() {
        var candidatesRo:ReadOnlyArray<LevelUpDesc> = defs.get(null).levelups;
        var candidates = candidatesRo.slice(0).filter(f -> executor.guardsPasses(f.guards));
        var prv:WeightedRandomProvider<LevelUpDesc> = new WeightedRandomProvider(candidates);
        options = [
            for (i in 0...3) {
                var o = prv.get();
                candidates.remove(o);
                o;
            }
        ];
        gui.initChoises(options.map(o -> o.name));
    }
    

    function onChoise(n) {
        var o = options[n];
        stats.getStat("lvl").changeVal(1);
        for (a in o.actions)
            executor.run(a);
        gameOvered.dispatch();
    }

    override function reset() {
        options = null;
    }

    public function shouldActivate():Bool {
        var exp = stats.getStat("exp").getVal();
        var curLvl = stats.getStat("lvl").getVal();
        var availLvl = 0;
        for (i in 0...expToLvl.length)
            if (expToLvl[i] > exp) {
                availLvl = i;
                break;
            }
        return curLvl < availLvl;
    }
}
