package loops.market;

import bootstrap.Activitor.ActHandler;
import bootstrap.GameRunBase;
import dungsmpl.DungeonData;
import dungsmpl.DungeonGame.ExecCtx;
import loops.market.MarketData;
import loops.market.MarketGui;

class MarketActivity extends GameRunBase implements ActHandler<MarketDesc> {
    @:once var stats:ProgStats;
    @:once var exec:ExecCtx;
    var gui:MarketWidget;
    var data:MarketDesc;
    var items:Array<MarketItemRecord>;

    public function new(ctx, w) {
        gui = new MarketWidget(w);
        gui.onChoise.listen(onChoise);
        gui.onDone.listen(onDone);
        super(ctx, w);
    }

    override function startGame() {
        gui.initState(items);
    }

    function onDone() {
        gameOvered.dispatch();
    }

    function onChoise(n) {
        var item = items[n];
        if (!isAvailable(item.data))
            return;
        stats.gld.value -= item.data.price;
        item.setState(sold);
        exec.addItem(item.data);
        // todo this check available right in gui now, put it there
        for (mi in items)
            if (mi.state != sold)
                mi.setState(isAvailable(mi.data) ? available : na);
    }

    override function reset() {
        data = null;
    }

    public function initDescr(d:MarketDesc):ActHandler<MarketDesc> {
        data = d;
        items = data.map(mi -> new MarketItemRecord(mi, isAvailable(mi) ? available : na));
        return this;
    }

    function isAvailable(item:MarketItem) {
        return (item.price <= stats.gld.value);
    }
}
