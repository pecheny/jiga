package loops.market;

import fu.ui.scroll.WheelHandler;
import fu.ui.scroll.ScrollboxInput;
import shimp.InputSystem.InputSystemTarget;
import fu.ui.scroll.ScrollableContent.Scrollable;
import htext.Align;
import a2d.Placeholder2D;
import al.core.DataView;
import al.layouts.PortionLayout;
import dkit.Dkit.BaseDkit;
import fu.Signal.IntSignal;
import fu.bootstrap.ButtonScale;
import fu.ui.ButtonEnabled;
import fu.ui.Properties;
import loops.market.MarketActivity.MarketGui;
import loops.market.MarketData;

using a2d.ProxyWidgetTransform;
using al.Builder;

class MarketWidget extends BaseDkit implements MarketGui {
    public var onDone:ec.Signal<Void->Void> = new ec.Signal();
    public var onChoice(default, null) = new IntSignal();

    static var SRC = <market-widget vl={PortionLayout.instance}>
        <label(b().v(pfr, .24).b()) id="lbl"  text={ "Do you want to buy smth?" } align={Align.Center}/>
        <base(b().v(pfr, .1).b()) />

        <data-container(b().v(pfr, 1).b()) scroll={true} id="cardsContainer"   itemFactory={cardFactory} inputFactory={inputFactory} layouts={GuiStyles.L_HOR_CARDS }>
            ${new WheelHandler(__this__.ph, horizontal)}
        </data-container>

        <base(b().v(pfr, .1).b()) />
        <button(b().h(sfr, .36).v(sfr, .12).b())   text={ "Done" } onClick={onOkClick} style={"small-text-center"} />
    </market-widget>;

    var maxNumber:Int;

    function cardFactory() {
        var mc = new MarketCard(b().v(sfr, 0.3).h(sfr, 0.3).t(1).b("card"));
        new ButtonScale(mc.entity);
        return mc;
    }
    
    override function init() {
        super.init();
    }

    function inputFactory(ph, n) {
        new ButtonEnabled(ph, onChoice.dispatch.bind(n));
    }

    function onOkClick() {
        onDone.dispatch();
    }

    public function initData(items:Array<MarketItemRecord>) {
        cardsContainer.initData(items);
    }
}

class MarketCard extends BaseDkit implements DataView<MarketItemRecord> {
    @:once var toggle:EnabledProp;
    var descr:MarketItemRecord;

    static var SRC = <market-card vl={PortionLayout.instance} >
        <base(b().v(pfr, 0.2).b()) />
        <switcher(b().v(pfr, 1).b()) id="content"   >
            <label(b().v(pfr, 0.2).b()) id="soldCard" text={"X"} align={Align.Center} />
            <label(b().v(pfr, 0.2).b()) public id="card"   />
        </switcher>
        <label(b().v(pfr, 0.2).b()) id="lbl" align={Align.Center}  />
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
        lbl.color = s == MarketItemState.na ? 0xff0000 : 0xffffff;
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
