package input.bs.tri;

import al.al2d.Placeholder2D;
import al.layouts.PortionLayout;
import ec.CtxWatcher;
import ecbind.InputBinder;
import fancy.domkit.Dkit;
import fancy.widgets.GbuttonView;
import ginp.GameButtons;
import ginp.api.GameButtons;
import ginp.api.GameInputUpdater;
import ginp.api.GameInputUpdaterBinder;
import graphics.ShapesColorAssigner;
import input.ButtonInputBinder;
import input.GameUIButton;
import input.GameUIButtonTuple;
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

    function gbutton(bt:Array<TriButtons>, ph:Placeholder2D) {
        new GameUIButtonTuple(ph, bt, "TriButtons");
        fui.quad(ph, 0);
        if (bt.length == 1) {
            var wdg = new GbuttonView(ph, bt[0]);
            wdg.addHandler(new InteractiveColors(ph.entity.getComponent(ShapesColorAssigner).setColor).viewHandler);
            new CMSDFLabel(ph, fui.textStyles.getStyle("center")).withText(bt[0].toString());
        }
    }

    #if !display
    static var SRC = <trix5-widget  vl={PortionLayout.instance}>
        ${createTouchSystem(__this__.ph)}
    <base(b().v(pfr, 0.7).b())  hl={PortionLayout.instance} >
        <base( b().b()) onConstruct={gbutton.bind([l, up])} />
        <base( b().b()) onConstruct={gbutton.bind([ up])} />
        <base( b().b()) onConstruct={gbutton.bind([r, up])} />
    </base>
    <base(b().v(pfr, 0.7).b())  hl={PortionLayout.instance} >
        <base( b().b()) onConstruct={gbutton.bind([l])} />
        <base( b().b()) />
        <base( b().b()) onConstruct={gbutton.bind([r])} />
    </base>
    </trix5-widget>;
    #end
}
