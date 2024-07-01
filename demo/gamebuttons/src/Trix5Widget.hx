package;

import TriButtons;
import al.al2d.Placeholder2D;
import ec.CtxWatcher;
import ecbind.InputBinder;
import fancy.domkit.Dkit;
import fancy.widgets.GbuttonView;
import ginp.GameButtons;
import ginp.GameInput.GameInputUpdater;
import ginp.GameInputUpdaterBinder;
import graphics.ShapesColorAssigner;
import input.ButtonInputBinder;
import input.GameUIButton;
import shimp.HoverInputSystem;
import shimp.InputSystem;
import utils.MacroGenericAliasConverter;
import widgets.CMSDFLabel;
import widgets.ColouredQuad.InteractiveColors;
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
        new GameUIButton(ph, bt, "TriButtons");
        var wdg = new GbuttonView(ph, bt);
        new CMSDFLabel(ph, fui.textStyles.getStyle("center")).withText(bt.toString());
        fui.quad(ph, 0);
        wdg.addHandler(new InteractiveColors(ph.entity.getComponent(ShapesColorAssigner).setColor).viewHandler);
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