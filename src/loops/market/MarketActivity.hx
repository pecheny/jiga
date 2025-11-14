package loops.market;

import bootstrap.Activitor;
import bootstrap.GameRunBase;
import bootstrap.SelfClosingScreen;
import fancy.widgets.OptionPickerGui;
import fu.Signal;
import loops.market.MarketData;
import stset.Stats.GameStat;

interface MarketGui<TRes> extends OptionPickerGui<MarketItemRecord<TRes>> extends SelfClosingScreen {}

interface ResourceTransactor<TRes> {
    public function has(res:TRes):Bool;
    public function spend(res:TRes):Bool;
}

class IntResTransactor implements ResourceTransactor<Int> {
    var stat:GameStat<Int>;

    public function new(stat) {
        this.stat = stat;
    }

    public function has(res:Int):Bool {
        return stat.value >= res;
    }

    public function spend(res:Int):Bool {
        if (! has(res))
            return false;
        stat.value -= res;
        return true;
    }
}

class MarketActivity<TRes> extends GameRunBase implements ActHandler<MarketDesc<TRes>> implements StatefullActHandler {
    public var onChange:Signal<Void->Void> = new Signal();
    public var onPurchase:Signal<Dynamic->Void> = new Signal();

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
