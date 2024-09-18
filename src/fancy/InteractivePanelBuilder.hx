package fancy;

import a2d.ChildrenPool;
import a2d.Placeholder2D;
import a2d.Widget;
import al.core.DataView;
import al.core.Placeholder;
import al.core.TWidget.IWidget;
import al.core.WidgetContainer.WContainer;
import fu.Signal.IntSignal;
import fu.ui.ButtonBase;


/**
    You init container with array of TData instead of placeholders and the DataChildrenPool creates and init TButton for each TData.
    InteractivePanelBuilder is a factory for DataChildrenPool, which allows to construct the item representation step by step, defining view and input components separately.
    The input handler has access to id of the clicked item, so if it has acces to the same array of TData, it can react properly. 
**/
class InteractivePanelBuilder<TData, TButton:IWidget<Axis2D> & DataView<TData>> {
    var onChoise:IntSignal;
    var buttons:DataChildrenPool<TData, TButton>;
    var wc:WContainer<Placeholder<Axis2D>>;
    var widgetFactory:Void->TButton;

    // var handler:Int->Void;
    public function new() {}

    function factory(n:Int):TButton {
        var btn = widgetFactory();
        inputHandlerFactory(btn.ph, n);
        return btn;
    }

    dynamic function inputHandlerFactory(ph:Placeholder2D, n:Int) {
        new ButtonBase(ph, onChoise.dispatch.bind(n));
    }

    public function withInput(fac:(ph:Placeholder2D, n:Int) -> Void) {
        inputHandlerFactory = fac;
        return this;
    }

    public function withContainer(wc) {
        this.wc = wc;
        return this;
    }

    public function withWidget(fac:Void->TButton) {
        widgetFactory = fac;
        return this;
    }

    public function withSignal(sig:IntSignal) {
        onChoise = sig;
        return this;
    }

    // public function withHandler(h:Int->Void) {
    //     handler = h;
    //     return this;
    // }

    public function build() {
        buttons = new DataChildrenPool(wc, factory);
        return buttons;
    }
}
