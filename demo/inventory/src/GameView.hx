package;

import fu.PropStorage;
import ec.DebugInit;
import bootstrap.SelfClosingScreen;
import fu.input.WidgetFocus;
import fu.bootstrap.ButtonColors;
import fancy.widgets.OptionPickerGui;
import htext.Align;
import DemoState;
import al.core.DataView;
import fu.Signal;
import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;

class GameView extends BaseDkit {
    public var onDone:Signal<Void->Void> = new Signal();

    static var SRC = <game-view vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b()) public id="lbl"  text={ "Lets play!1" }  />
        <button(b().v(pfr, .1).b()) public id="drink"   text={"Drink"}   />
        <button(b().v(pfr, .1).b()) public id="hit"   text={"Hit"}   />
    </game-view>
}

class ResultsScreen extends BaseDkit implements SelfClosingScreen {
    public var onDone:ec.Signal<Void->Void> = new ec.Signal();

    static var SRC = <results-screen vl={PortionLayout.instance}>
        <label(b().v(pfr, 0.2).b()) public id="desc"   />
        <button(b().h(sfr, .36).v(sfr, .12).b()) focus={true} text={ "Done" } onClick={onOkClick} style={"small-text-center"} />

    </results-screen>

    function onOkClick() {
        onDone.dispatch();
    }
}

class ItemPicker extends BaseDkit implements OptionPickerGui<Item> {
    static var SRC = <item-picker hl={PortionLayout.instance}>
        <data-container(b().v(pfr, 1).b()) id="cardsContainer"  layouts={GuiStyles.L_HOR_CARDS} dispatch={true} itemFactory={cardFactory}>
        </data-container>
    </item-picker>

    public var onChoice(default, null):IntSignal = new IntSignal();

    public function initData(descr:Array<Item>) {
        cardsContainer.initData(descr);
    }

    function cardFactory() {
        var ph = b().h(sfr, 0.3).v(sfr, 0.3).b();
        var bc = new ButtonColors(ph.entity);
        fui.quad(ph, 0);
        new WidgetFocus(ph);
        return new ItemCard(ph);
    }

    override function init() {
        super.init();
        cardsContainer.onChoice.listen(n -> onChoice.dispatch(n));
    }
}

class ItemCard extends BaseDkit implements DataView<Item> {
    static var SRC = <item-card >
        <label(b().v(sfr, 0.2).b()) id="title" text={"X"} align={Align.Center} />
    <switcher(b().v(pfr, 1).b()) id="content"   >
        <consumable-view(b().v(pfr, 0.2).b()) id="consumable"/>
        <weapon-view(b().v(pfr, 0.2).b()) id="weapon" />
    </switcher>
 </item-card>

    public function initData(descr:Item) {
        if (descr.weapon != null) {
            content.switchTo(weapon.ph);
            weapon.initData(descr);
        } else if (descr.consumable != null) {
            content.switchTo(consumable.ph);
            consumable.initData(descr);
        }
    }
}

@:postInit(initDkit)
class WeaponView extends BaseDkit implements DataView<Weapon> {
    static var SRC = <weapon-view vl={PortionLayout.instance}>
        <label(b().v(sfr, 0.2).b()) id="title" text={"X"} align={Align.Center} />
        <label(b().v(sfr, 0.2).b()) public id="desc"   />
    </weapon-view>

    override function initDkit() {
        super.initDkit();
    }

    public function initData(descr:Weapon) {
        title.text = "Weapon";
        desc.text = 'Dmg: ${descr.weapon.dmg}';
    }
}

@:postInit(initDkit)
class ConsumableView extends BaseDkit implements DataView<Consumable> {
    static var SRC = <consumable-view vl={PortionLayout.instance}>
        <label(b().v(pfr, 0.2).b()) id="title" text={"X"} align={Align.Center} />
        <label(b().v(pfr, 0.2).b()) public id="desc"   />
    </consumable-view>

    override function initDkit() {
        super.initDkit();
    }

    public function initData(descr:Consumable) {
        title.text = "Potion";
        desc.text = 'Uses: ${descr.consumable.count}';
    }
}
