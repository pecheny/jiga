package fancy.widgets;

import fancy.widgets.ProgressBarWidget;
import al.al2d.Widget;

using al.Builder;
using transform.LiquidTransformer;
using transform.LiquidTransformer;

class DeltaProgressBar extends Widget {
    var healthRed:ProgressBarWidget;
    var healthbar:ProgressBarWidget;
    var value:Float;

    public function new(w) {
        super(w);
        healthRed = new ProgressBarWidget(w, 0xff0000);
        healthbar = new ProgressBarWidget(w);
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
