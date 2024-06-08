package loops.split;

import ginp.GameInput.GameInputUpdater;
import bootstrap.EntryLoop;
import al.openfl.display.FlashDisplayRoot;
import ec.Entity;
import gameapi.GameRun;
import openfl.display.Sprite;
import states.States;
import utils.AbstractEngine;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;


class Main extends AbstractEngine {
    var fui = new FuiBuilder();
    var rootEntity:Entity;
    var stateSwitcher:StateSwitcher;

    public function new() {
        super();
        // addChild(new FPS());
        var wnd = openfl.Lib.application.window;
        if (wnd.y < 0)
            wnd.y = 20;
        wnd.x = 800;
        renderingStuff();
        var drawcallsLayout = '<container>
        <drawcall type="color"/>
        <drawcall type="text" font=""/>
        </container>';
        rootEntity = fui.createDefaultRoot(drawcallsLayout);
        textStyles();
        var flashCanvas = new Sprite();
        addChild(flashCanvas);
        rootEntity.addComponent(new FlashDisplayRoot(flashCanvas));

        var container:Sprite = rootEntity.getComponent(Sprite);
        addChild(container);

        var input = new Input();
        rootEntity.addComponentByType(GameInputUpdater, input);
        rootEntity.addComponent(input);

        rootEntity.addChild(createGameplay());

        var loop1 = new EntryLoop(rootEntity);
        addUpdatable(@:privateAccess loop1.machine);
    }

    function createGameplay() {
        var entity = new Entity("run");
        var loop = new SplitGameLoop();
        entity.addComponentByType(GameRun, loop);
        entity.addComponent(loop);

        var stw = fui.placeholderBuilder.h(pfr, 1).v(sfr, 0.2).b("status gui").withLiquidTransform(fui.ar.getAspectRatio());
        loop.statusGui = new StatusWidget(stw, fui.ar.getAspectRatio(), fui);
        return entity;
    }

    function renderingStuff() {
        // fui.regDrawcallType("circles", {
        //     type: "circles",
        //     attrs: ColorTexSet.instance,
        //     vert: [Uv0Passthrough.instance, PosPassthrough.instance, ColorPassthroughVert.instance],
        //     frag: [ColorTextureFragment.instance],
        // }, (e, xml) -> {
        //     if (!xml.exists("path"))
        //         throw '<image /> gldo should have path property';
        //     // todo image name to gldo
        //     return fui.createGldo(ColorTexSet.instance, e, "circles", new TextureBinder(fui.textureStorage, xml.get("path")), "");
        // });
    }

    function textStyles() {
        var pcStyleC = fui.textStyles.newStyle("center").withAlign(horizontal, Center).build();
        var pcStyle = fui.textStyles.newStyle("score") //        .withAlign(vertical, Center)
            .withSize(sfr, .1)
            .withPadding(horizontal, sfr, 0.3)
            .build();
    }
}