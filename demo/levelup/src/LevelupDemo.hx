package;

import bootstrap.BootstrapMain;
import bootstrap.Executor;
import ec.Component;
import ec.CtxWatcher;
import ec.Entity;
import gameapi.GameRun;
import gameapi.GameRunBinder;
import loops.llevelup.LevelUpActivity;
import loops.llevelup.LevelupData;
import shared.ProgStats;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class LevelupDemo extends BootstrapMain {
    public function new() {
        super();
        var wdg = Builder.widget();
        fui.makeClickInput(wdg);
        var player = new Entity("player");
        player.addComponent(new ProgStats()).initAll({exp: 100, lvl: 0, gld: 0});
        player.addComponent(new LevelingDef("levelups", openfl.utils.Assets.getLibrary("")));
        var entity = player;
        var ctx = entity.addComponent(new ExecCtx(entity));
        entity.addComponent(new Executor(ctx.vars));

        var run = new LevelUpActivity(new Entity("dungeon-run"), wdg);
        player.addChild(run.entity); // for injection only
        run.entity.addComponentByType(GameRun, run);
        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);
    }
}


@:keep
class ExecCtx extends Component {
    @:once var stats:ProgStats;

    var ctx:ExecCtx;

    @:isVar public var vars(get, null):Dynamic = {};

    override function init() {
        for (k in stats.stats.keys())
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
