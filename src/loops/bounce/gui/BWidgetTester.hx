package loops.bounce.gui;

import fancy.WidgetTester;
import al.layouts.data.LayoutData.FixedSize;
import widgets.Button;
import al.Builder;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

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
