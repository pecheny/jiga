package fancy.widgets;

import a2d.Widget;
import fu.graphics.ColouredQuad;
import fu.graphics.ShapeWidget;
import fu.ui.ButtonBase;
import fu.ui.Properties;
import gl.sets.ColorSet;
import graphics.ShapesColorAssigner;
import shimp.ClicksInputSystem.ClickTargetViewState;

class ColorBgToggleComponent extends Widget {
    @:once var viewProc:ClickViewProcessor;
    @:once var fui:FuiBuilder;
    var toggle:EnabledProp;
    var inactiveColor = 0x1c1c1c;
    var colors:ShapesColorAssigner<ColorSet>;
    var interactiveColors:InteractiveColors;
    var state:ClickTargetViewState = Idle;

    override function init() {
        fui.lqtr(ph);
        var shw = new ShapeWidget(ColorSet.instance, ph, true);
        shw.addChild(new graphics.shapes.QuadGraphicElement(ColorSet.instance));
        colors = new ShapesColorAssigner(ColorSet.instance, 0, shw.getBuffer());
        interactiveColors = new InteractiveColors(colors.setColor);
        viewProc.addHandler(changeViewState);
        shw.manInit();
        toggle = EnabledProp.getOrCreate(ph.entity);
        toggle.onChange.listen(() -> changeViewState(state));
        changeViewState(state);
    }

    function changeViewState(st:ClickTargetViewState) {
        state = st;
        if (toggle.enabled)
            interactiveColors.viewHandler(st);
        else
            colors.setColor(inactiveColor);
    }
}