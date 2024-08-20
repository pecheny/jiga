package fancy.widgets;

import fu.Signal;
import al.al2d.Widget.IWidget;

interface OptionPickerGui<TData> extends DataView<Array<TData>> {
    public var onChoice(default, null):IntSignal;
}