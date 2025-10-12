package stset;

import stset.Stats.GameStat;

class CompoStat extends GameStat<Int> {
    var sources:Array<StatSource> = [];
    public function add(src:StatSource) {
        src.onChange.listen(onSrcChange);
        sources.push(src);
    }
    
    public function remove(src:StatSource) {
        src.onChange.remove(onSrcChange);
        sources.remove(src);
    }
    
    override function set_value(newVal:Int):Int {
        return value;
    }
    
    function onSrcChange() {
        var old = value;
        var r = 0;
        for (s in sources)
            r += s.value;
        var delta = r - old;
        @:bypassAccessor value = r;
        onChange.dispatch(delta);
    }
}
