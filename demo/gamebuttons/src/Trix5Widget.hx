package;

import InputTest.GButtonView;
import TriButtons;
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
import update.Updatable;
import ginp.GameInputUpdaterBinder;
import ginp.GameButtons;
import ginp.GameInput.GameInputUpdater;
import utils.MacroGenericAliasConverter;
import input.ButtonInputBinder;
import ginp.GameButtons.GameButtonsImpl;
import TriButtons;
import al.al2d.Placeholder2D;
import ec.CtxWatcher;
import ecbind.InputBinder;
import fancy.domkit.Dkit;
import shimp.HoverInputSystem;
import shimp.InputSystem;
import widgets.utils.WidgetHitTester;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class Trix5Widget extends BaseDkit {
    function createTouchSystem(ph:Placeholder2D) {
        var sys = new HoverInputSystem(new Point(), new WidgetHitTester(ph));
        ph.entity.addComponent(new InputBinder<Point>(sys));
        ph.entity.addComponentByType(InputSystemTarget, sys);
        new CtxWatcher(InputBinder, ph.entity, true);
    }

    override public function initDkit() {
        super.initDkit();
        var gb = new GameButtonsImpl<TriButtons>(TriButtons.aliases.length);
        var bb = new ButtonInputBinder(MacroGenericAliasConverter.toString(TriButtons), gb);
        new CtxWatcher(GameInputUpdaterBinder, entity);
        entity.addComponentByName(MacroGenericAliasConverter.toAlias(ButtonInputBinder, TriButtons), bb);
        entity.addComponentByType(GameInputUpdater, gb);
        entity.addComponentByType(GameButtons, gb);
    }

    function gbutton(bt:TriButtons, ph:Placeholder2D) {
        new GbuttonView(bt, ph);
    }

    #if !display
    static var SRC = <trix5-widget  layouts={GuiStyles.L_VERT_BUTTONS }>
        ${createTouchSystem(__this__.ph)}
    <base(b().v(pfr, 0.7).b())  layouts={GuiStyles.L_HOR_CARDS} >
        <base( b().b()) onConstruct={gbutton.bind(TriButtons.l)} />
        <base( b().b()) onConstruct={gbutton.bind(TriButtons.up)} />
        <base( b().b()) onConstruct={gbutton.bind(TriButtons.r)} />
    </base>
    <base(b().v(pfr, 0.7).b())  layouts={GuiStyles.L_HOR_CARDS} >
        <base( b().b()) onConstruct={gbutton.bind(TriButtons.l)} />
        <base( b().b()) onConstruct={gbutton.bind(TriButtons.up)} />
        <base( b().b()) onConstruct={gbutton.bind(TriButtons.r)} />
    </base>
    </trix5-widget>;
    #end
}

class GbuttonView extends BaseDkit implements Updatable {
    @:once var colors:ShapesColorAssigner<ColorSet>;
    @:once var inp:GameButtons<TriButtons>;
    var gameButton:TriButtons;

    static var SRC = <gbutton-view hl={PortionLayout.instance}>
        ${fui.quad(__this__.ph, 0xff025f29)}
        <label(b().b()) id="lbl" style={"small-text"}/>
    </gbutton-view>

    public function new(gb:TriButtons, p:Placeholder2D, ?parent:BaseDkit) {
        this.gameButton = gb;
        super(p, parent);
        initComponent();
        initDkit();
        lbl.text = TriButtons.aliases[gb];
    }

    public function update(dt:Float) {
        var val = (inp.pressed(gameButton));
        colors.setColor(val ? 0xff0000 : 0x0);
    }

    override function init() {
        entity.addComponentByType(Updatable, this);
        new CtxWatcher(UpdateBinder, entity);
        new GameUIButton(ph, gameButton, "TriButtons");
        super.init();
    }
}
