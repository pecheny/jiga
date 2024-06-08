package;

import openfl.display.Sprite;
import flgl.ProjPosElement;
import flgl.ProjMatAspect;
import al.al2d.Placeholder2D;
import bootstrap.BootstrapMain;
import ec.CtxWatcher;
import ec.Entity;
import gameapi.GameRun;
import gameapi.GameRunBinder;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;


class ActionDemo extends BootstrapMain {
    public function new() {
        super();

        var ph = Builder.widget();
        fui.makeClickInput(ph);
        createRenderLayer(ph);

        var e = new Entity("run");
        var run = new Gameplay(e, ph);
        new Render(run);
        run.entity.addComponentByType(GameRun, run);
        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);
    }

    public static final dl = 
    '<container>
    <drawcall type="color"/>
    </container>';
    //* [2024-05-29 Wed 23:42] Render passes / notes.org

    function createRenderLayer(ph:Placeholder2D) {
        new GameRenderPass(fui).register();
        var projAspect = new ProjMatAspect();
        fui.setAspects([projAspect]);
        fui.createContainer(ph.entity, Xml.parse(dl).firstElement());
        var spr:Sprite = ph.entity.getComponent(Sprite);
        addChild(spr);
        fui.setAspects([]);
    }
}

class GameRenderPass extends FlatColorPass {
    public function new(fui) {
        super(fui);
        vertElems.push(ProjPosElement.instance);
        // drawcallType = "game-color";
        shaderType = "game-color";
    }
}