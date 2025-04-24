package loops.market;

import loops.market.MarketActivity.MarketGui;
import dkit.Dkit.BaseDkit;
import a2d.ChildrenPool;
import a2d.Placeholder2D;
import al.core.DataView;
import al.layouts.PortionLayout;
import fu.bootstrap.ButtonScale;
import fu.ui.InteractivePanelBuilder;
import fu.ui.ButtonEnabled;
import fu.Signal.IntSignal;
import fu.ui.Button;
import fu.ui.Properties;
import loops.market.MarketData;
import utils.Signal;

using al.Builder;
using a2d.ProxyWidgetTransform;

class MarketWidget extends BaseDkit implements MarketGui {
    public var onDone:ec.Signal<Void->Void> = new ec.Signal();
    public var onChoice(default, null) = new IntSignal();

    static var SRC = <market-widget vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b()) id="lbl"  text={ "Do you want to buy smth?" }  >
        </label>
        <base(b().v(pfr, 0.7).b()) id="cardsContainer"  layouts={GuiStyles.L_HOR_CARDS} />
        <button(b().v(pfr, .1).b())   text={ "Ok" } onClick={onOkClick}  />
    </market-widget>;

    var buttons:DataChildrenPool<MarketItemRecord, MarketCard>;
    var maxNumber:Int;

    override function init() {
        buttons = new InteractivePanelBuilder<MarketItemRecord, MarketCard>().withContainer(cardsContainer.c)
            .withWidget(() -> {
                var mc = new MarketCard(b().v(sfr, 0.3).h(sfr, 0.3).t(1).b("card"));
                new ButtonScale(mc.entity);
                mc;
            })
            .withSignal(onChoice)
            .withInput((ph, n) -> new ButtonEnabled(ph, onChoice.dispatch.bind(n)))
            .build();
    }

    function onOkClick() {
        onDone.dispatch();
    }

    public function initData(items:Array<MarketItemRecord>) {
        buttons.initData(items);
    }
}

class MarketCard extends BaseDkit implements DataView<MarketItemRecord> {
    @:once var toggle:EnabledProp;
    var descr:MarketItemRecord;

    static var SRC = <market-card vl={PortionLayout.instance} >
        <switcher(b().v(pfr, 1).b()) id="content"   >
            <label(b().v(pfr, 0.2).b()) id="soldCard" text={"X"}  />
            <label(b().v(pfr, 0.2).b()) id="card"   />
        </switcher>
        <label(b().v(pfr, 0.2).b()) id="lbl"   />
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
        if (s == sold) {
            lbl.text = "Sold out!";
            content.switchTo(soldCard.ph);
        } else {
            lbl.text = getCaption(descr.data);
            card.text = "" + descr.data.weapon;
            content.switchTo(card.ph);
        }
    }

    function getCaption(d:MarketItem) {
        // return d.weapon + " " + d.lvl + " for " + d.price + " gld";
        return d.price + " gld";
    }
}
