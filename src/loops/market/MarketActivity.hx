package loops.market;

import bootstrap.Activitor;
import bootstrap.GameRunBase;
import bootstrap.SelfClosingScreen;
import fancy.widgets.OptionPickerGui;
import fu.Signal;
import loops.market.MarketData;
import stset.Stats.GameStat;

class MarketActivity<TRes> extends GameRunBase implements ActHandler<MarketDesc<TRes>> implements StatefullActHandler {
    public var onChange:Signal<Void->Void> = new Signal();
    public var onPurchase:Signal<Dynamic->Void> = new Signal();
    public var onPurchaseN = new IntSignal();

    @:once var gui:MarketGui<TRes>;
    var transactor:ResourceTransactor<TRes>;
    var data:MarketDesc<TRes>;
    var items:Array<MarketItemRecord<TRes>>;

    public function new(ctx, w, transactor) {
        this.transactor = transactor;
        super(ctx, w);
        watch(w.entity);
    }

    override function init() {
        super.init();
        gui.onChoice.listen(onChoise);
        gui.onDone.listen(onDone);
    }

    override function startGame() {
        gui.initData(items);
    }

    function onDone() {
        gameOvered.dispatch();
    }

    function onChoise(n) {
        var item = items[n];
        if (!isAvailable(item.data))
            return;
        transactor.spend(item.data.price);
        item.setState(sold);
        onPurchase.dispatch(item.data);
        onPurchaseN.dispatch(n);
        // todo this check available right in gui now, put it there
        for (mi in items)
            if (mi.state != sold)
                mi.setState(isAvailable(mi.data) ? available : na);
        onChange.dispatch();
    }

    override function reset() {
        data = null;
    }

    public function initDescr(d:MarketDesc<TRes>):ActHandler<MarketDesc<TRes>> {
        data = d;
        items = data.map(mi -> new MarketItemRecord(mi, isAvailable(mi) ? available : na));
        return this;
    }

    function isAvailable(item:MarketItem<TRes>) {
        return transactor.has(item.price);
    }

    public function dump():Dynamic {
        return items.filter(i -> i.state != sold).map(i -> i.data);
    }
}
