package stset;

import fu.Signal;

interface StatSource {
    public var onChange(default, null):Signal<Void->Void>;
    public var value(get, null):Int;
}
