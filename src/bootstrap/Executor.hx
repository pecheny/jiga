package bootstrap;

class Executor {
    var parser = new hscript.Parser();
    var interp = new hscript.Interp();

    public function new(ctx) {
        for (v in Reflect.fields(ctx)) {
            var fld = Reflect.field(ctx, v);
            interp.variables.set(v, fld);
        }
    }

    public function run(expr:String) {
        // var ast = parser.parseString("ctx." + expr);
        var ast = parser.parseString( expr);
        // on js functions do not carry closure to 'this',
        // so the easies workaround i'd found is pass not function themself, but ctx obj w/methods
        //
        return interp.execute(ast);
    }

    public function guardsPasses(guards:Array<String>) {
        if(guards == null)
            return true;
        for (s in guards)
            if (!run(s))
                return false;
        return true;
    }
}
