package fancy.domkit;

import widgets.CMSDFLabel;
import dungsmpl.WeaponsGui;
import fancy.domkit.Dkit;
import al.Builder;
import fancy.WidgetTester;

using al.Builder;
using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;

class Tester extends WidgetTester {
    public function new() {
        super();
        BaseDkit.inject(fui);
        var pcStyle = fui.textStyles.newStyle("small-text") //        .withAlign(vertical, Center)
            .withSize(sfr, .05)
            .withPadding(horizontal, sfr, 0.1)
            .build();
        var bw = new Region(null);
        var lw = Builder.widget();
        var pnl = Builder.v().withChildren([Builder.widget(), bw.p, lw, Builder.widget(),]);
        fui.makeClickInput(pnl);
        switcher.switchTo(pnl);
        new CMSDFLabel(lw, fui.s()).withText("foo");
        @:privateAccess bw.lbl.label.setColor(0xffffffff);
        // bw.setT(0.5);
    }
}
