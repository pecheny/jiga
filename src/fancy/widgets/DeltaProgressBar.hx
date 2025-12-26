package fancy.widgets;

import fancy.widgets.ProgressBarWidget;
import a2d.Widget;

using al.Builder;
using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;

class DeltaProgressBar extends Widget {
    var healthRed:ProgressBarWidget;
    var healthbar:ProgressBarWidget;
    var value:Float;

    public function new(w, mainColor = 0xffffff, deltaColor=0xff0000) {
        super(w);
        healthRed = new ProgressBarWidget(w, deltaColor);
        healthbar = new ProgressBarWidget(w, mainColor);
    }

    public function hideDelta() {
        healthRed.setPtogress(value);
        healthbar.setPtogress(value);
    }

    public function setValue(v:Float) {
        value = v;
        healthbar.setPtogress(v);
    }
}
