package loops.bounce.gui;

import fu.bootstrap.WidgetTester;
import al.layouts.data.LayoutData.FixedSize;
import fu.ui.Button;
import al.Builder;

using al.Builder;
using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;

class BWidgetTester extends WidgetTester {
    public function new() {
        super();
        var bw = new BouncingWidget(Builder.widget());
        var pnl = Builder.v().withChildren([
            Builder.widget(),
            bw.widget(),
            Builder.widget(),
        ]);
        fui.makeClickInput(pnl);
        switcher.switchTo(pnl);
        bw.setT(0.5);
    }
}
