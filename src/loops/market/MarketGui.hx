package loops.market;

import al.core.DataView;
import al.layouts.PortionLayout;
import dkit.Dkit.BaseDkit;
import fu.Signal.IntSignal;
import fu.bootstrap.ButtonScale;
import fu.input.DataContainerFocus;
import fu.input.WidgetFocus;
import fu.ui.ButtonEnabled;
import fu.ui.Properties;
import fu.ui.scroll.WheelHandler;
import htext.Align;
import loops.market.MarketActivity.MarketGui;
import loops.market.MarketData;

using a2d.ProxyWidgetTransform;
using al.Builder;

class MarketWidget extends BaseDkit implements MarketGui<Int> {
    public var onDone:ec.Signal<Void->Void> = new ec.Signal();
    public var onChoice(default, null) = new IntSignal();

    static var SRC = <market-widget vl={PortionLayout.instance}>
        <label(b().v(pfr, .24).b()) id="lbl"  text={ "Do you want to buy smth?" } align={Align.Center}/>
        <base(b().v(pfr, .1).b()) />

        <data-container(b().v(pfr, 1).b()) scroll={true} id="cardsContainer"   itemFactory={cardFactory} inputFactory={inputFactory} layouts={GuiStyles.L_HOR_CARDS }>
            ${new WheelHandler(__this__.ph, horizontal)}
            ${new DataContainerFocus(__this__)}
            ${fui.createHorizontalNavigationSignals(__this__.entity);}
        </data-container>

        <base(b().v(pfr, .1).b()) />
        <button(b().h(sfr, .36).v(sfr, .12).b("done")) autoFocus={true} focus={true} text={ "Done" } onClick={onOkClick} style={"small-text-center"} />
    </market-widget>;

    var maxNumber:Int;

    function cardFactory() {
        var mc = new MarketCard(b().v(sfr, 0.3).h(sfr, 0.3).t(1).b("card"));
        new WidgetFocus(mc.ph);
        new ButtonScale(mc.entity);
        return mc;
    }

    function inputFactory(ph, n) {
        new ButtonEnabled(ph, onChoice.dispatch.bind(n));
    }

    function onOkClick() {
        onDone.dispatch();
    }

    public function initData(items:Array<MarketItemRecord<Int>>) {
        cardsContainer.initData(items);
    }
}

class MarketCard extends BaseDkit implements DataView<MarketItemRecord<Int>> {
    @:once var toggle:EnabledProp;
    var descr:MarketItemRecord<Int>;

    static var SRC = <market-card vl={PortionLayout.instance} >
        <base(b().v(pfr, 0.2).b()) />
        <switcher(b().v(pfr, 1).b()) id="content"   >
            <label(b().v(pfr, 0.2).b()) id="soldCard" text={"X"} align={Align.Center} />
            <label(b().v(pfr, 0.2).b()) public id="card"   />
        </switcher>
        <label(b().v(pfr, 0.2).b()) id="lbl" align={Align.Center}  />
    </market-card>;

    public function initData(descr:MarketItemRecord<Int>) {
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
            card.text = "" + descr.data;
            content.switchTo(card.ph);
        }
    }

    function getCaption(d:MarketItem<Int>) {
        // return d.weapon + " " + d.lvl + " for " + d.price + " gld";
        return d.price + " gld";
    }
}
