package loops.market;

import ec.Signal;
import bootstrap.DescWrap;

enum abstract MarketItemState(Int) {
    var available;
    var na;
    var sold;
}

interface MarketGuiModel {
    public function getState(n:Int):MarketItemState;
}

typedef MarketItem<TRes> = {
    price:TRes,
}

class MarketItemRecord<TRes> {
    public var data(default, null):MarketItem<TRes>;
    public var state(default, null):MarketItemState;
    public var onChange(default, null):Signal<MarketItemState->Void> = new Signal();

    public function new(data, state) {
        this.data = data;
        this.state = state;
    }

    public function setState(s) {
        state = s;
        onChange.dispatch(s);
    }
}

typedef MarketDesc<TRes> = Array<MarketItem<TRes>>;
class MarketData<TRes> extends DescWrap<MarketDesc<TRes>> {}
