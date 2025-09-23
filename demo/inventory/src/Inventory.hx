class Inventory<TItem:{index:Int}> {
    var storage:Array<TItem>;

    public function new(storage) {
        this.storage = storage;
    }

    public function getItems(filter:TItem->Bool) {
        var result = [];

        for (i in 0...storage.length) {
            var item = storage[i];
            if (!filter(item))
                continue;
            item.index = i;
            result.push(item);
        }
        return result;
    }
}
