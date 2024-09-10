package fancy.widgets;

import fu.Signal;

interface OptionPickerGui<TData> extends DataView<Array<TData>> {
    public var onChoice(default, null):IntSignal;
}