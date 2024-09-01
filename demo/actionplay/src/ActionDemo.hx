package;

import Input;
import a2d.Placeholder2D;
import al.core.AllAxisApplier.AnyAxisApplier;
import bootstrap.BootstrapMain;
import ec.CtxWatcher;
import ec.Entity;
import gameapi.GameRun;
import gameapi.GameRunBinder;
import ginp.GameInput;
import ginp.OnScreenStick;
import ginp.api.GameInputUpdater;
import gl.aspects.ProjectionMatrixAspect;
import gl.passes.FlatColorPass;
import openfl.DummyOflStickAdapter;
import openfl.display.Sprite;
import shaderbuilder.ProjectionMatrixElement;

using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;
using al.Builder;

class ActionDemo extends BootstrapMain {
    var input:GameInput<TGAxis, TGButts>;
    var stick:Sprite;

    public function new() {
        super();

        var ph = Builder.widget();
        fui.makeClickInput(ph);
        createRenderLayer(ph);

        var e = new Entity("run");
        var run = new Gameplay(e, ph);
        ph.entity.getComponent(ProjectionMatrixAspect).setView(run.F_BRD[0], run.L_BRD[0], run.F_BRD[1], run.L_BRD[1]);
        new Render(run);
        run.entity.addComponentByType(GameRun, run);
        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);
        addChild(stick);
    }

    override function createInput() {
        input = new GameInput(TGAxis.aliases.length, TGButts.aliases.length);

        rootEntity.addComponentByType(GameInputUpdater, input);
        var stick = createStick();
        var rend = new openfl.DummyOflStickRenderer(stick);
        this.stick = rend;
        addUpdatable(rend);
        var mapper = input.mapAxisSource(stick).withMapped(Axis2D.horizontal, TGAxis.h);
        rootEntity.addComponent(input);
    }
    function createStick() {
        var stick = new OnScreenStick(60);
        var adapter = new DummyOflStickAdapter(stick);
        input.addEarlyUpdatable(adapter);
        return stick;
        // onScreenStick = stick;
    }

    public static final dl = 
    '<container>
        <drawcall type="color"/>
    </container>';
    //* [2024-05-29 Wed 23:42] Render passes / notes.org

    function createRenderLayer(ph:Placeholder2D) {
        fui.pipeline.addPass(new GameRenderPass());
        var projAspect = new ProjectionMatrixAspect();
        ph.entity.addComponent(projAspect);
        for (a in Axis2D)
            ph.axisStates[a].addSibling(new AnyAxisApplier(projAspect, a));
        fui.pipeline.addAspect(projAspect);
        fui.createContainer(ph.entity, Xml.parse(dl).firstElement());
        // var spr:Sprite = ph.entity.getComponent(Sprite);
        // addChild(spr);
    }
}

class GameRenderPass extends FlatColorPass {
    public function new() {
        super();
        
        vertElems.push(ProjectionMatrixElement.instance);
        alias.push(ProjectionMatrixElement.alias);

        // drawcallType = "game-color";
        // shaderType = "game-color";
    }
}