package loops.market;

import a2d.ChildrenPool;
import a2d.Placeholder2D;
import al.core.DataView;
import al.layouts.PortionLayout;
import fu.bootstrap.ButtonScale;
import fu.ui.InteractivePanelBuilder;
import fancy.domkit.Dkit.BaseDkit;
import fu.ui.ButtonEnabled;
import fancy.widgets.ColorBgToggleComponent;
import fu.Signal.IntSignal;
import fu.ui.Button;
import fu.ui.Properties;
import loops.market.MarketData;
import utils.Signal;

using al.Builder;
using a2d.ProxyWidgetTransform;


class MarketWidget extends BaseDkit {
    public var onDone:Signal<Void->Void> = new Signal();
    public var onChoise(default, null) = new IntSignal();

    static var SRC = <market-widget vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b()) id="lbl"  text={ "Do you want to buy smth?" }  >
        //  ${fui.quad(__this__.ph, 0x6c3e44)}
        </label>
        <base(b().v(pfr, 0.7).b()) id="cardsContainer"  layouts={GuiStyles.L_HOR_CARDS} >
            // ${fui.quad(__this__.ph, 0x79ff0000)}
        </base>
        <button(b().v(pfr, .1).b())   text={ "Ok" } onClick={onOkClick}  />
    </market-widget>;

    // layouts={GuiStyles.L_HOR_CARDS}
    var buttons:DataChildrenPool<MarketItemRecord, MarketCard>;
    var okButton:Button;
    var maxNumber:Int;

    override function init() {
        buttons = new InteractivePanelBuilder<MarketItemRecord, MarketCard>().withContainer(cardsContainer.c)
            .withWidget(() -> {
                var mc = new MarketCard(b().v(sfr, 0.3).h(sfr, 0.3).t(1).b("card"));
                new ButtonScale(mc.entity);
                mc;
            })
            .withSignal(onChoise)
            .withInput((ph, n) -> new ButtonEnabled(ph, onChoise.dispatch.bind(n)))
            .build();
    }

    function onOkClick() {
        onDone.dispatch();
    }

    public function initState(items:Array<MarketItemRecord>) {
        buttons.initData(items);
    }
}

class MarketCard extends BaseDkit implements DataView<MarketItemRecord> {
    @:once var toggle:EnabledProp;
    var descr:MarketItemRecord;

    static var SRC = <market-card vl={PortionLayout.instance} >
        ${new ColorBgToggleComponent(__this__.ph.getInnerPh())}
        <label(b().v(pfr, 1).b()) id="lbl"  color={ 0xecb7b7 } text={ "Region" }  />
    </market-card>;

    public function initData(descr:MarketItemRecord) {
        if (this.descr != null)
            this.descr.onChange.remove(onChange);
        this.descr = descr;
        descr.onChange.listen(onChange);
        onChange(descr.state);
    }

    function onChange(s:MarketItemState) {
        toggle.enabled = s == MarketItemState.available;
        lbl.text = s == sold ? "Sold out!" : getCaption(descr.data);
    }

    function getCaption(d:MarketItem) {
        return d.weapon + " " + d.lvl + " for " + d.price + " gld";
    }
}

