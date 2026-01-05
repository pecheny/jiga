package loops.market;

import ec.Entity;
import al.core.Placeholder;
import Axis2D;
import al.core.TWidget.IWidget;
import a2d.Placeholder2D;
import dkit.Dkit.SwitcherDkit;
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

        <data-container(b().v(pfr, 1).b("dc")) scroll={true} id="cardsContainer"   itemFactory={cardFactory} inputFactory={inputFactory} layouts={GuiStyles.L_HOR_CARDS }>
            ${new WheelHandler(__this__.ph, horizontal)}
            ${new DataContainerFocus(__this__)}
            ${fui.createHorizontalNavigationSignals(__this__.entity);}
        </data-container>

        <base(b().v(pfr, .1).b()) />
        <button(b().h(sfr, .36).v(sfr, .12).b("done")) autoFocus={true} focus={true} text={ "Done" } onClick={onOkClick} style={"small-text-center"} />
    </market-widget>;

    var maxNumber:Int;

    function cardFactory() {
        var mc = createCard();
        new WidgetFocus(mc.ph);
        return new MarketCardComponent(mc);
    }

    function createCard():MarketCardWrapper<Int> {
        return new MarketCard(b().v(sfr, 0.3).h(sfr, 0.3).t(1).b("card"));
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

interface MarketCardWrapper<TRes> extends IWidget<Axis2D> {
    public var content(get, null):SwitcherDkit;
    public var soldView(get, null):Placeholder2D;
    public function setState(state:MarketItemState, ?price:TRes):Void;
    public function getView(data:Dynamic):Placeholder2D;
}

class MarketCardComponent<TRes> implements DataView<MarketItemRecord<TRes>> implements IWidget<Axis2D> {
    var wrapper:MarketCardWrapper<TRes>;

    @:once var toggle:EnabledProp;
    var descr:MarketItemRecord<TRes>;

    public function new(wrapper) {
        this.wrapper = wrapper;
        watch(wrapper.entity);
    }

    public function initData(descr:MarketItemRecord<TRes>) {
        if (this.descr != null)
            this.descr.onChange.remove(onChange);
        this.descr = descr;
        descr.onChange.listen(onChange);
        onChange(descr.state);
    }

    function onChange(s:MarketItemState) {
        toggle.enabled = s == MarketItemState.available;
        if (s == MarketItemState.sold) {
            wrapper.setState(s, null);
            wrapper.content.switchTo(wrapper.soldView);
        } else {
            wrapper.setState(s, descr.data.price);
            wrapper.content.switchTo(wrapper.getView(descr.data));
        }
    }

    public var ph(get, null):Placeholder<Axis2D>;
    public var entity(get, null):Entity;

    public function get_entity():Entity {
        return wrapper.entity;
    }

    public function get_ph():Placeholder<Axis2D> {
        return wrapper.ph;
    }
}

class MarketCard extends BaseDkit implements MarketCardWrapper<Int> {
    @:once var toggle:EnabledProp;
    var descr:MarketItemRecord<Int>;

    static var SRC = <market-card vl={PortionLayout.instance} >
        <base(b().v(pfr, 0.2).b()) />
        <switcher(b().v(pfr, 1).b())  id="_content">
            <label(b().v(pfr, 0.2).b()) id="soldCard" text={"X"} align={Align.Center} />
            <label(b().v(pfr, 0.2).b()) public id="card"   />
        </switcher>
        <label(b().v(pfr, 0.2).b()) id="lbl" align={Align.Center}  />
    </market-card>;

    public var soldView(get, null):Placeholder2D;

    public function get_soldView():Placeholder2D {
        return soldCard.ph;
    }

    public var content(get, null):SwitcherDkit;

    function get_content():SwitcherDkit {
        return _content;
    }

    function onChange(s:MarketItemState) {}

    public function setState(s:MarketItemState, ?price:Int) {
        toggle.enabled = s == MarketItemState.available;
        lbl.color = s == MarketItemState.na ? 0xff0000 : 0xffffff;
        if (s == sold) {
            lbl.text = "Sold out!";
        } else {
            lbl.text = price + " gld";
        }
    }

    public function getView(data:Dynamic):Placeholder2D {
            card.text = "" + descr.data;
        return card.ph;
    }
}
