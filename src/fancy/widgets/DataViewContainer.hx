package fancy.widgets;

import a2d.ChildrenPool;
import a2d.Placeholder2D;
import a2d.Widget2DContainer;
import a2d.Widget;
import al.Builder;
import al.core.TWidget.IWidget;

class DataViewContainer<TData, TWidget:IWidget<Axis2D> & DataView<TData>> extends Widget implements DataView<Array<TData>>{
    @:once var fui:FuiBuilder; // for cases when construction called before fui/ctx are available, to call init later. not sure if it should be removed.
    var descr:Array<TData>; // stores before init only
    public var buttons(default, null):ChildrenPool<TWidget>;


    public function new(ph:Placeholder2D, fac:Int->TWidget) {
        super(ph);
        var wc = ph.entity.getComponent(Widget2DContainer);
        if (wc == null)
            wc = Builder.createContainer(ph, vertical, Center);
        buttons = new ChildrenPool(wc, fac);
    }

    override function init() {
        if (descr != null) {
            initData(descr);
            descr = null;
        }
    }

	public function initData(descr:Array<TData>) {
        if (_inited) {
            buttons.setActiveNum(descr.length);
            for (i in 0...descr.length)
                buttons.pool[i].initData(descr[i]);
        } else {
            this.descr = descr;
        }
    }
}
