package loops.deck;

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

class BattleDeck<T, BT:T & BattleCard<TPile>, TPile:Int> extends Component {
    var deck:Array<BT> = [];

    var piles:Map<TPile, Array<BattleCardId>>;
    public function new(nOfPiles:Int) {
        super(null);
        piles = [for (p in 0...nOfPiles) (cast p) => []];
    }

    public function reset() {
        deck.resize(0);
        for (k in piles.keys())
            piles[k].resize(0);
    }

    public function addCard(c:T, pile:TPile) {
        var b:BT = cast c;
        b.pile = pile;
        b.ph = null;
        b.id = new BattleCardId(deck.length);
        piles[pile].push(b.id);
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
        piles[to].push(id);
    }

    public function shuffle() {
        throw "na";
    }

    public function cardsCount(?pile:TPile) {
        if (pile != null)
            return piles[pile].length;
        return deck.length;
    }

    public function getPile(pile:TPile):Array<BT> {
        return piles[pile].map(i -> deck[cast i]);
    }
}
