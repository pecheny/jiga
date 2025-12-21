package loops.llevelup;

import bootstrap.Executor;
import bootstrap.GameRunBase;
import dkit.Dkit.BaseDkit;
import fancy.widgets.OptionPickerGui;
import fu.PropStorage;
import fu.Signal;
import fu.bootstrap.ButtonColors;
import fu.input.WidgetFocus;
import gameapi.CheckedActivity;
import haxe.ds.ReadOnlyArray;
import loops.llevelup.LevelupData;
import stset.Stats;
import utils.WeightedRandomProvider;
import widgets.Label;

class LevelingStats implements StatsSet {
    public var exp(default, null):GameStat<Int>;
    public var lvl(default, null):GameStat<Int>;
}

class LevelUpActivity extends GameRunBase implements CheckedActivity {
    @:once var stats:LevelingStats;
    // @:once var defs:DungeonDefs; // todo  replace with levelup defs
    @:once var defs:LevelingDef;
    @:once var executor:Executor;
    @:once var gui:OptionPickerGui<String>;
    var expToLvl:ReadOnlyArray<Int> = [0, 5, 10, 15, 30, 50, 70, 90, 100, 120, 140];

    override function init() {
        gui.onChoice.listen(onChoise);
        var etl = defs.get(null).expToLvl;
        if (etl != null)
            expToLvl = etl;
    }

    var options:Array<LevelUpDesc>;

    override function startGame() {
        var candidatesRo:ReadOnlyArray<LevelUpDesc> = defs.get(null).levelups;
        var candidates = candidatesRo.filter(f -> executor.guardsPasses(f.guards));
        var prv:WeightedRandomProvider<LevelUpDesc> = new WeightedRandomProvider(candidates);
        if (shouldActivate())
            options = [
                for (i in 0...3) {
                    var o = prv.get();
                    candidates.remove(o);
                    o;
                }
            ];
        else
            options = [];
        gui.initData(options.map(o -> o.name));
    }

    function onChoise(n) {
        var o = options[n];
        stats.lvl.value++;
        for (a in o.actions)
            executor.run(a);
        gameOvered.dispatch();
    }

    override function reset() {
        options = null;
    }

    public function shouldActivate():Bool {
        // see * [2024-12-03 Tue 13:42] jiga leveling
        var exp = stats.exp.value;
        var nextLvl = stats.lvl.value + 1;
        return expToLvl.length > nextLvl && expToLvl[nextLvl] <= exp;
    }
}

class LevelupGui extends BaseDkit implements OptionPickerGui<String> {
    public var onChoice(default, null) = new IntSignal();

    static var SRC = <levelup-gui>
    <data-container(b().v(pfr, 1).b()) id="cardsContainer"  layouts={GuiStyles.L_HOR_CARDS} dispatch={true} itemFactory={cardFactory}>
        // ${new DataContainerFocus(__this__)}
        // ${fui.createHorizontalNavigationSignals(__this__.entity);}
    </data-container>

        // <base(b().v(pfr, 1).b()) id="cardsContainer"  vl={PortionLayout.instance} />
    </levelup-gui>;

    function cardFactory() {
        var ph = b().h(sfr, 0.3).v(sfr, 0.3).b();
        var bc = new ButtonColors(ph.entity);
        fui.quad(ph, 0);
        new WidgetFocus(ph);
        return new DataLabel(ph, fui.s());
    }

    override function init() {
        super.init();
        cardsContainer.onChoice.listen(n -> onChoice.dispatch(n));
    }

    public function initData(captions:Array<String>) {
        cardsContainer.initData(captions);
    }
}
