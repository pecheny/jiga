package loops.llevelup;

import a2d.ChildrenPool;
import al.layouts.PortionLayout;
import bootstrap.Executor;
import bootstrap.GameRunBase;
import fu.PropStorage;
import fancy.domkit.Dkit.BaseDkit;
import fancy.widgets.OptionPickerGui;
import fu.Signal;
import fu.bootstrap.ButtonColors;
import fu.ui.InteractivePanelBuilder;
import gameapi.CheckedActivity;
import haxe.ds.ReadOnlyArray;
import loops.llevelup.LevelupData.LevelUpDesc;
import loops.llevelup.LevelupData.LevelingDef;
import shared.ProgStats;
import utils.WeightedRandomProvider;
import widgets.Label;

class LevelUpActivity extends GameRunBase implements CheckedActivity {
    @:once var stats:ProgStats;
    // @:once var defs:DungeonDefs; // todo  replace with levelup defs
    @:once var defs:LevelingDef;
    @:once var executor:Executor;
    @:once var gui:OptionPickerGui<String>;
    var expToLvl:ReadOnlyArray<Int> = [0, 5, 10, 15, 30, 50, 70, 90, 100, 120, 140];

    override function init() {
        gui.onChoice.listen(onChoise);
        var etl = defs.get(null).expToLvl;
        if (etl!=null)
            expToLvl = etl;
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
        gui.initData(options.map(o -> o.name));
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

class LevelupGui extends BaseDkit implements OptionPickerGui<String> {
    public var onChoice(default, null) = new IntSignal();

    @:once var props:PropStorage<Dynamic>;
    var input:DataChildrenPool<String, DataLabel>;

    static var SRC = <levelup-gui>
        <base(b().v(pfr, 1).b()) id="cardsContainer"  vl={PortionLayout.instance} />
    </levelup-gui>;

    override function init() {
        super.init();
        input = new InteractivePanelBuilder().withContainer(cardsContainer.c)
            .withWidget(() -> {
                var ph = b().h(sfr, 0.3).v(sfr, 0.1).b();
                var bc = new ButtonColors(ph.entity);
                fui.quad(ph, 0);
                new DataLabel(ph, fui.s());
            })
            .withSignal(onChoice)
            .build();
    }

    public function initData(captions:Array<String>) {
        input.initData(captions);
    }
}
