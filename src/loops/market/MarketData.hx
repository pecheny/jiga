package loops.market;

import bootstrap.SelfClosingScreen;
import fancy.widgets.OptionPickerGui;
import ec.Signal;
import bootstrap.DescWrap;

enum abstract MarketItemState(Int) {
    var available;
    var na;
    var sold;
}

interface MarketGui<TRes> extends OptionPickerGui<MarketItemRecord<TRes>> extends SelfClosingScreen {}

interface ResourceTransactor<TRes> {
    public function has(res:TRes):Bool;
    public function spend(res:TRes):Bool;
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
