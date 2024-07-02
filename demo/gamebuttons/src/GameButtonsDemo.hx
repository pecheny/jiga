package;

import input.bs.tri.TriButtons;
import input.bs.tri.Trix5Widget;
import al.al2d.Placeholder2D;
import al.layouts.PortionLayout;
import bootstrap.BootstrapMain;
import bootstrap.GameRunBase;
import ec.CtxWatcher;
import ec.Entity;
import ecbind.InputBinder;
import fancy.Props;
import fancy.domkit.Dkit;
import gameapi.GameRun;
import gameapi.GameRunBinder;
import ginp.GameButtons;
import ginp.GameInput.GameInputUpdater;
import ginp.KeyToGameButtons;
import ginp.api.KbdDispatcher;
import gl.sets.ColorSet;
import graphics.ShapesColorAssigner;
import htext.style.TextContextBuilder.TextContextStorage;
import input.ButtonInputBinder;
import input.GameUIButton;
import openfl.OflKbd;
import shimp.HoverInputSystem;
import shimp.InputSystem;
import update.Updatable;
import update.UpdateBinder;
import utils.MacroGenericAliasConverter as MGA;
import widgets.utils.WidgetHitTester;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class GameButtonsDemo extends BootstrapMain {
    public function new() {
        super();

        var ph = Builder.widget();
        fui.makeClickInput(ph);

        // var wdg = new DomkitSampleWidget(Builder.widget());
        var wdg = new Trix5Widget(Builder.widget());
        var e = new Entity("run");
        var run = new GameRunBase(e, wdg.ph);
        run.entity.addComponentByType(GameRun, run);
        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);
    }

    // override function createInput() {
    //     rootEntity.addComponentByType(KbdDispatcher, new OflKbd());
    //     var ie = new Entity("input");
    //     var inp = new KeyToGameButtons(TriButtons.aliases.length);
    //     inp.bind(ie); // maybe bind to rootEntity would work too but this way better illustrates composition several inputs in one project
    //     rootEntity.addComponentByType(GameInputUpdater, inp);
    //     rootEntity.addAliasByName(Entity.getComponentId(GameButtons), inp);
    //     rootEntity.addChild(ie);
    //     rootEntity.addComponentByName(MGA.toAlias(ButtonInputBinder, TriButtons), new ButtonInputBinder(MGA.toString(TriButtons), inp));
    // }
}

// class DomkitSampleWidget extends BaseDkit {
//     static var SRC = <domkit-sample-widget layouts={GuiStyles.L_VERT_BUTTONS }>
//     <base(b().v(pfr, 0.7).b())  layouts={GuiStyles.L_HOR_CARDS} >
//         ${createTouchSystem(__this__.ph)}
//         <gbutton(TriButtons.l, b().b("lb")) />
//         <gbutton(TriButtons.up, b().b()) />
//         <gbutton(TriButtons.r, b().b()) />
//     </base>
//     <base(b().v(pfr, 0.7).b())  layouts={GuiStyles.L_HOR_CARDS} >
//         <gbutton(TriButtons.l, b().b("lb")) />
//         <gbutton(TriButtons.up, b().b()) />
//         <gbutton(TriButtons.r, b().b()) />
//     </base>
//     </domkit-sample-widget>

//     function createTouchSystem(ph:Placeholder2D) {
//         var sys = new HoverInputSystem(new Point(), new WidgetHitTester(ph));
//         ph.entity.addComponent(new InputBinder<Point>(sys));
//         ph.entity.addComponentByType(InputSystemTarget, sys);
//         new CtxWatcher(InputBinder, ph.entity, true);
//     }
// }