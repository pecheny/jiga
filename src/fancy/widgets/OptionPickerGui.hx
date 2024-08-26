package fancy.widgets;

import fu.Signal;
import a2d.Widget.IWidget;

interface OptionPickerGui<TData> extends DataView<Array<TData>> {
    public var onChoice(default, null):IntSignal;
}