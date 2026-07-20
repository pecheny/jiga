package loops.deck;

import fu.Signal;
import update.Updatable;
import PhSerializer.PhDump;
import ec.Component;
import haxe.ds.Map;

typedef BattleCard<TPile> = {
    pile:TPile,
    id:BattleCardId,
    ?ph:PhDump
}

abstract BattleCardId(Int) {
    public inline function new(v) {
        this = v;
    }
}

typedef CardTransition = {
    id:BattleCardId,
    t:Float
}

class APile {
    public var cardAdded:Signal<BattleCardId->Void> = new Signal();
    public var cards(default, null):Array<BattleCardId> = [];
    public var inbox(default, null):Array<CardTransition> = [];

    public function new() {}

    public function addCard(id) {
        cards.push(id);
        // inbox.push({
        //     id: id,
        //     t: -1
        // });
    }

    public function remove(id) {
        return cards.remove(id);
    }

    public function clear() {
        cards.resize(0);
        inbox.resize(0);
    }

    public function processInbox() {
        for (c in inbox) {
            if (c.t == 1) {
                inbox.remove(c);
                cards.push(c.id);
                cardAdded.dispatch(c.id);
            }
        }
    }
}

class BattleDeck<TCard, TBatCard:TCard & BattleCard<TPile>, TPile:Int> extends Component implements Updatable {
    var deck:Array<TBatCard> = [];
    // var piles:Map<TPile, Array<BattleCardId>>;
    public  var piles:Map<TPile, APile>;

    public function new(nOfPiles:Int) {
        super(null);
        piles = [for (p in 0...nOfPiles) (cast p) => new APile()];
    }

    public function reset() {
        deck.resize(0);
        for (k in piles.keys())
            piles[k].clear();
    }

    public function addCard(c:TCard, pile:TPile) {
        var b:TBatCard = cast c;
        b.pile = pile;
        b.ph = null;
        b.id = new BattleCardId(deck.length);
        piles[pile].addCard(b.id);
        deck.push(b);
    }

    public function moveCard(id:BattleCardId, to:TPile) {
        var card = deck[cast id];
        if (card.pile == to)
            throw "Wrong";
        var from = piles[cast card.pile];
        if (!from.remove(id))
            throw "wrong";
        card.pile = to;
        piles[to].addCard(id);
    }

    public function shuffle() {
        throw "na";
    }

    public function cardsCount(?pile:TPile) {
        if (pile != null)
            return piles[pile].cards.length;
        return deck.length;
    }

    public function getPile(pile:TPile):Array<TBatCard> {
        return piles[pile].cards.map(i -> deck[cast i]);
    }

    var duration = 1;

    public function update(dt:Float) {
        for (p => ap in piles) {
            for (ib in ap.inbox) {
                if (ib.t < 0)
                    continue;
                var value = ib.t + dt / duration;
                if (value >= 1)
                    ib.t = 1;
                else
                    ib.t = value;
            }
            ap.processInbox();
        }
    }
}
