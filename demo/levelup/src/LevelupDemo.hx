package;

import bootstrap.BootstrapMain;
import bootstrap.Executor;
import ec.Component;
import ec.CtxWatcher;
import ec.Entity;
import fancy.widgets.OptionPickerGui;
import gameapi.GameRun;
import gameapi.GameRunBinder;
import loops.llevelup.LevelUpActivity;
import loops.llevelup.LevelupData;

using a2d.transform.LiquidTransformer;
using al.Builder;

class LevelupDemo extends BootstrapMain {
    public function new() {
        super();
        

        var wdg = Builder.widget();
        fui.makeClickInput(wdg);
        var player = new Entity("player");
        var s = player.addComponent(new LevelingStats({exp: 20, lvl: 0, gld: 0}));
        player.addComponent(new LevelingDef("levelups", openfl.utils.Assets.getLibrary("")));
        var entity = player;
        var ctx = entity.addComponent(new ExecCtx(entity));
        entity.addComponent(new Executor(ctx.vars, true));

        var gui = new LevelupGui(wdg);
        var run = new LevelUpActivity(new Entity("dungeon-run"), wdg);
        run.entity.addAliasByName(Entity.getComponentId(OptionPickerGui), gui);

        player.addChild(run.entity); // for injection only
        run.entity.addComponentByType(GameRun, run);
        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);
    }
}


@:keep
class ExecCtx extends Component {
    @:once var stats:LevelingStats;

    var ctx:ExecCtx;

    @:isVar public var vars(get, null):Dynamic = {};

    override function init() {
        for (k in stats.keys)
            Reflect.setField(vars, k, k);
        Reflect.setField(vars, "ctx", this);
        ctx = this;
    }


    public function changeStat(statId, delta:Int) {
        trace("change " + statId + " " + delta + " " + this);
    }

    function get_vars():Dynamic {
        if (!_inited)
            throw "wrong";
        return vars;
    }
}
