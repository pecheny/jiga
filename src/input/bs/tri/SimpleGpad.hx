package input.bs.tri;

import a2d.Placeholder2D;
import al.layouts.PortionLayout;
import al2d.WidgetHitTester2D;
import dkit.Dkit.BaseDkit;
import ec.CtxWatcher;
import ecbind.InputBinder;
import ecbind.MultiInputBinder;
import fancy.widgets.GbuttonView;
import fu.graphics.ColouredQuad.InteractiveColors;
import fu.ui.CMSDFLabel;
import ginp.ButtonOutputBinder;
import ginp.GameButtonsImpl;
import ginp.api.GameButtons;
import ginp.api.GameButtonsDispatcher;
import ginp.api.GameInputUpdater;
import ginp.api.GameInputUpdaterBinder;
import graphics.ShapesColorAssigner;
import shimp.MultiInputTarget;
import shimp.Point;
import utils.MacroGenericAliasConverter;

using a2d.transform.LiquidTransformer;
using al.Builder;

class SimpleGpad extends BaseDkit {
    var gb:GameButtonsImpl<TriButtons>;
    var labels:Map<TriButtons, String> = [l => "&lt;", r => "&gt;", up => "^"];

    public var dispatcher(get, null):GameButtonsDispatcher<TriButtons>;

    function get_dispatcher()
        return gb;

    public var buttons(get, null):GameButtons<TriButtons>;

    function get_buttons()
        return gb;

    static var SRC = <simple-gpad hl={PortionLayout.instance}>
        <base(b().b()) onConstruct={gbutton.bind(l)}/>
        <base(b().b()) onConstruct={gbutton.bind(r)}/>
        <base(b().b()) onConstruct={gbutton.bind(up)}/>
    </simple-gpad>

    function createTouchSystem(ph:Placeholder2D) {
        var sys = new shimp.MultiInputSystemContainer(() -> new Point(), new WidgetHitTester2D(ph));
        ph.entity.addComponent(new InputBinder<Point>(sys));
        ph.entity.addComponentByType(MultiInputTarget, sys);
        new CtxWatcher(MultiInputBinder, ph.entity);
    }

    override public function initDkit() {
        super.initDkit();
        gb = new GameButtonsImpl<TriButtons>(TriButtons.aliases.length);
        var bb = new ButtonOutputBinder(MacroGenericAliasConverter.toString(TriButtons), gb);
        new CtxWatcher(GameInputUpdaterBinder, entity);
        entity.addComponentByName(MacroGenericAliasConverter.toAlias(ButtonOutputBinder, TriButtons), bb);
        entity.addComponentByType(GameInputUpdater, gb);
        entity.addComponentByType(GameButtons, gb);
        createTouchSystem(ph);
    }

    function gbutton(bt:TriButtons, ph:Placeholder2D) {
        new GameUIButton(ph, bt, "TriButtons");
        fui.quad(ph, 0);
        var wdg = new GbuttonView(ph, bt);
        wdg.addHandler(new InteractiveColors(ph.entity.getComponent(ShapesColorAssigner).setColor).viewHandler);
        new CMSDFLabel(ph, fui.textStyles.getStyle("center")).withText(labels[bt]);
    }
}
