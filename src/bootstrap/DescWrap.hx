package bootstrap;

class DescWrap<T> {
    public var data(default, null):T;

    public function new(d:T) {
        this.data = d;
    }
}
