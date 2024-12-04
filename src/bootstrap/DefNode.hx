package bootstrap;

import utils.MathUtil;
import haxe.io.Path;
import haxe.Json;
import openfl.Assets;

interface DefProvider<T> {
    public function get(path:String):T;
}

class GenericDef<T> implements DefProvider<T> {
    var getter:String->T;

    public function new(get:String->T) {
        this.getter = get;
    }

    public function get(path:String):T {
        return getter(path);
    }
}

/**
    let prefix is directory path relative to the lib root. 
    The directory and all subfolders contain json-s, each of them conforms DefNode.T

    If prefix is path to json, it should be object of defId=>T pairs
**/
class DefNode<T> implements DefProvider<T> {
    // var value:{};
    // var lib:AssetLib;
    var assets:PathAccess;
    var prefix:String;

    public function new(prefix, lib) {
        this.prefix = prefix;
        this.assets = new AbAssets(lib);
    }

    public function get(path):T {
        if (path == null)
            return assets.getContent(prefix);
        return assets.getContent(Path.join([prefix, path]));
    }

    public function getDyn(path = null):Dynamic {
        if (path == null)
            return assets.getContent(prefix);
        return assets.getContent(Path.join([prefix, path]));
    }
}

class DirDesc {
    // public var name:String;
    public var subdirs:Map<String, DirDesc> = new Map();
    public var files:Array<String> = [];

    public function new() {}

    public function getDir(name) {
        if (subdirs.exists(name))
            return subdirs.get(name);
        var dir = new DirDesc();
        subdirs.set(name, dir);
        return dir;
    }
}

interface PathAccess {
    function getContent(path:String):Dynamic;
}

class AbAssets implements PathAccess {
    var lib:AssetLib;

    public var root:DirDesc = new DirDesc();

    public function new(lib:AssetLib) {
        this.lib = lib;
        for (p in lib.getFilePaths())
            procPath(p);
    }

    // TODO dirty impl, not optimized, should be rewrotten and tested
    public function getContent(path:String):Dynamic {
        var split = path.split('/');
        var dir = root;
        for (i in 0...split.length) {
            var name = split[i];
            if (dir.subdirs.exists(name)) {
                dir = dir.subdirs[name];
                continue;
            } else if (dir.files.indexOf(name + ".json") > -1) {
                var filePath = Path.join([for (k in 0...i + 1) split[k]]) + ".json";
                var txt = lib.getText(filePath);
                var dyn = Json.parse(txt);
                for (j in i + 1...split.length) {
                    dyn = Reflect.field(dyn, split[j]);
                    if (dyn == null)
                        throw 'Wrong path $path at ${split[j]}';
                }
                return dyn;
            }
        }
        // path points to dir
        var result = {};
        for (subd in dir.subdirs.keys())
            Reflect.setField(result, subd, getContent(Path.join([path, subd])));
        for (f in dir.files)
            Reflect.setField(result, f.substring(0, f.indexOf(".json")), Json.parse(lib.getText(Path.join([path, f]))));

        return result;
    }

    function procPath(p:String) {
        var split = p.split('/');
        var dir = root;
        for (i in 0...split.length - 1)
            dir = dir.getDir(split[i]);
        dir.files.push(split[split.length - 1]);
    }
}

typedef LibUndertype = #if lime lime.utils.AssetLibrary #else openfl.utils.AssetLibrary #end

@:forward(getText)
abstract AssetLib(LibUndertype) from LibUndertype {
    public inline function getFilePaths() {
        #if !lime
        throw "not impld";
        #end
        return @:privateAccess this.paths.keys();
    }
}

class DefNodeTest {
    public static function main() {
        var lib = Assets.getLibrary("");
    }
}
