package;

import a2d.Placeholder2D;
import al.core.DataView;
import al.ec.WidgetSwitcher;
import al.layouts.PortionLayout;
import bootstrap.BootstrapMain;
import dkit.Components.ButtonDkit;
import dkit.Dkit.BaseDkit;
import ec.Entity;
import fu.input.DataContainerFocus;
import fu.input.WidgetFocus;
import fu.ui.scroll.WheelHandler;
import ginp.ButtonInputBinder;
import ginp.ButtonOutputBinder;
import ginp.Keyboard;
import ginp.presets.BasicGamepad;
import input.ClickEmulator;
import utils.MacroGenericAliasConverter as MGA;

using a2d.transform.LiquidTransformer;
using al.Builder;

class DataContainerDemo extends BootstrapMain {
    public function new() {
        super();

        var switcher = rootEntity.getComponent(WidgetSwitcher);
        var bw = new DomkitSampleWidget(Builder.widget());

        fui.makeClickInput(bw.ph);
        fui.createHorizontalNavigationSignals(bw.entity);
        rootEntity.addChild(createClickEmulator(new Entity("click emulator")));

        switcher.switchTo(bw.ph);

        bw.cardsContainer.initData([for (i in 0...10) "b " +i ]);
    }
    
    override function createInput() {
        var basic = new BasicGamepadInput();
        basic.createKeyMapping([Keyboard.ESCAPE => start, Keyboard.LEFT => left, Keyboard.RIGHT => right, Keyboard.UP => up, Keyboard.DOWN =>down, Keyboard.SPACE => a]);
        rootEntity.addComponentByName(MGA.toAlias(ButtonInputBinder, BasicGamepadButtons), new ButtonInputBinder(MGA.toString(BasicGamepadButtons), basic));
        rootEntity.addComponentByName(MGA.toAlias(ButtonOutputBinder, BasicGamepadButtons), new ButtonOutputBinder(MGA.toString(BasicGamepadButtons), basic));
    }

}

class DomkitSampleWidget extends BaseDkit {
    public var focus:DataContainerFocus;
    static var SRC = <domkit-sample-widget vl={PortionLayout.instance}>
        <data-container(b().v(pfr, 1).b()) scroll={true} public id="cardsContainer"   itemFactory={cardFactory} inputFactory={inputFactory} layouts={GuiStyles.L_HOR_CARDS} hl={PortionLayout.instance}>
            ${new WheelHandler(__this__.ph, horizontal)}
            ${focus = new DataContainerFocus(__this__)}
        </data-container>
    </domkit-sample-widget>

    function cardFactory() {
        var mc = new MarketCard(b().v(sfr, 0.3).h(sfr, 0.3).t(1).b("card"));
        new WidgetFocus(mc.ph);
        return mc;
    }

    override function init() {
        super.init();
    }

    function inputFactory(ph, n) {
        // new ButtonBase(ph, () -> trace("foo"));
    }
}

class MarketCard extends ButtonDkit implements DataView<String> {
    public function initData(descr:String) {
        text = descr;
        onClick = ()->trace(descr);
    }
}
