package;

import DemoState;
import al.Builder;
import GameView.ResultsScreen;
import GameView.ItemPicker;
import al.ec.WidgetSwitcher;
import bootstrap.GameRunBase;

class Gameplay extends GameRunBase {
    var view:GameView;
    @:once var state:DemoState;
    var inventory:Inventory<Item>;
    var switcher:WidgetSwitcher<Axis2D>;
    var offer:GameView;
    var pick:ItemPicker;
    var result:ResultsScreen;

    override function init() {
        switcher = new WidgetSwitcher(getView());
        super.init();
        inventory = new Inventory(state.items);
        offer = new GameView(Builder.widget());
        pick = new ItemPicker(Builder.widget());
        result = new ResultsScreen(Builder.widget());
        offer.drink.onClick = () -> {
            var items = inventory.getItems(i -> i.consumable != null);
            @:privateAccess pick.onChoice.listeners.resize(0);
            pick.onChoice.listen(n -> drink(items[n]));
            pick.initData(items);
            switcher.switchTo(pick.ph);
        }

        offer.hit.onClick = () -> {
            var items = inventory.getItems(i -> i.weapon != null);
            @:privateAccess pick.onChoice.listeners.resize(0);
            pick.onChoice.listen(n -> hit(items[n]));
            pick.initData(items);
            switcher.switchTo(pick.ph);
        }

        result.onDone.listen(() -> switcher.switchTo(offer.ph));
        switcher.switchTo(offer.ph);
    }

    function drink(d:Consumable) {
        result.desc.text = 'You have drunk a ${d.consumable.action}';
        // consume
        switcher.switchTo(result.ph);
    }

    function hit(w:Weapon) {
        result.desc.text = 'You have hit ${w.weapon.dmg} dmg';
        switcher.switchTo(result.ph);
    }

    override function reset() {
        view?.lbl.text = "";
    }

}
