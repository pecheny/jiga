package loops.market;

import ec.Signal;
import bootstrap.DescWrap;

typedef CommandCall = String;

enum abstract MarketItemState(Int) {
    var available;
    var na;
    var sold;
}

interface MarketGuiModel {
    public function getState(n:Int):MarketItemState;
}

typedef MarketItem = {
    ?weapon:String,
    price:Int,
    ?actions:Array<CommandCall>,
    ?guards:Array<CommandCall>,
    ?descr:String,
    ?title:String
}

class MarketItemRecord {
    public var data(default, null):MarketItem;
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

typedef MarketDesc = Array<MarketItem>;
class MarketData extends DescWrap<MarketDesc> {}
