package;

import bootstrap.BootstrapMain;
import ec.Entity;
import levelmap.RgflLinear.DummyLevel;

using a2d.transform.LiquidTransformer;
using al.Builder;

class ActionDemo extends BootstrapMain {
    public function new() {
        super();

        var ph = Builder.widget();
        fui.makeClickInput(ph);

        var e = new Entity("run");
        e.addComponent(new DummyLevel());
        var run = new MapActivity(e, ph);
        enterRun(run);
    }
}
