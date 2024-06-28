package;

import al.al2d.Placeholder2D;
import input.GameUIButton;
import Trix5Buttons.TriButtons;
import gl.sets.ColorSet;
import graphics.ShapesColorAssigner;
import update.UpdateBinder;
import update.Updatable;
import input.ButtonInputBinder;
import ginp.GameInput.GameInputUpdater;
import openfl.OflKbd;
import ginp.api.KbdDispatcher;
import al.layouts.PortionLayout;
import bootstrap.BootstrapMain;
import bootstrap.GameRunBase;
import ec.CtxWatcher;
import ec.Entity;
import fancy.domkit.Dkit;
import gameapi.GameRun;
import gameapi.GameRunBinder;
import utils.MacroGenericAliasConverter as MGA;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class GameButtonsDemo extends BootstrapMain {
    public function new() {
        super();

        var ph = Builder.widget();
        fui.makeClickInput(ph);

        var wdg = new DomkitSampleWidget(Builder.widget());
        var e = new Entity("run");
        var run = new GameRunBase(e, wdg.ph);
        run.entity.addComponentByType(GameRun, run);
        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);
    }

    override function createInput() {
        rootEntity.addComponentByType(KbdDispatcher, new OflKbd());
        var ie = new Entity("input");
        var inp = new Trix5Buttons(ie);
        rootEntity.addComponentByType(GameInputUpdater, inp);
        rootEntity.addAliasByName(Entity.getComponentId(Trix5Buttons), inp);
        rootEntity.addChild(ie);
        rootEntity.addComponentByName(MGA.toAlias(ButtonInputBinder, TriButtons), new ButtonInputBinder(MGA.toString(TriButtons), inp));
    }
}

class DomkitSampleWidget extends BaseDkit {
    static var SRC = <domkit-sample-widget hl={PortionLayout.instance}>
        <gbutton(TriButtons.l, b().b()) id="l" />
        <base(b().v(pfr, 0.7).b()) id="cardsContainer"  layouts={GuiStyles.L_HOR_CARDS} >
        </base>
        <gbutton(TriButtons.r, b().b()) id="r" />
    </domkit-sample-widget>

    function onOkClick() {
        trace("click");
    }

 
}

@:uiComp("gbutton")
class GbuttonView extends BaseDkit implements Updatable {
    @:once var colors:ShapesColorAssigner<ColorSet>;
    @:once var inp:Trix5Buttons;
    var gameButton:TriButtons;

    static var SRC = <gbutton>
    ${fui.quad(__this__.ph, 0xff025f29)}
    </gbutton>
    public function new(gb:TriButtons, p:Placeholder2D, ?parent:BaseDkit) {
        this.gameButton = gb;
        super(p,parent);
        initComponent();
    }


    public function update(dt:Float) {
        var val = (inp.pressed(gameButton));
        colors.setColor(val ? 0xff0000 : 0x0);
    }

    override function init() {
        super.init();
        entity.addComponentByType(Updatable, this);
        new CtxWatcher(UpdateBinder, entity);
        new GameUIButton(ph, gameButton, "TriButtons");
    }
}
