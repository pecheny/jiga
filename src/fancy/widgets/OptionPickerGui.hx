package fancy.widgets;

import al.core.DataView;
import fu.Signal;

interface OptionPickerGui<TData> extends DataView<Array<TData>> {
    public var onChoice(default, null):IntSignal;
}