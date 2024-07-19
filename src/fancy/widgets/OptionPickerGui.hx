package fancy.widgets;

import utils.Signal.IntSignal;
import al.al2d.Widget.IWidget;

interface OptionPickerGui<TData> extends DataView<Array<TData>> {
    public var onChoice(default, null):IntSignal;
}