package loops.talk;

import bootstrap.DefNode;
import bootstrap.DescWrap;

typedef CommandCall = String;

typedef TalkResponce = {
    caption:String,
    actions:Array<CommandCall>,
    ?guards:Array<CommandCall>,
    ?onDone:OnResponceDone
}

@:forward(indexOf, substring, substr)
enum abstract OnResponceDone(String) {
    var stay;
    var end;
    var next;

    public inline function goto() {
        // @formatter:off
        return 
            if (this.lastIndexOf('goto') != 0) 
                null 
            else if (this.lastIndexOf('goto:') == 0)
                Index(Std.parseInt(this.substring(this.lastIndexOf(':') + 1))) 
            else 
                Alias(this.substring(this.lastIndexOf('#') + 1));
        // @formatter:on
    }
}

enum DialogId {
    Index(n:Int);
    Alias(a:String);
}

abstract DialogUri(String) {
    public inline function new(s) {
        this = s;
    }

    public static inline function fromIndex(talkId:String, index:Int) {
        return new DialogUri('$talkId:$index');
    }

    public inline function getDialogId():DialogId {
        // @formatter:off
        return 
            if (this.lastIndexOf(':') > -1) Index(Std.parseInt(this.substring(this.lastIndexOf(':') + 1))) 
            else Alias(this.substring(this.lastIndexOf('#') + 1));
        // @formatter:on
    }

    public inline function getTalkId():String {
        // @formatter:off
        return 
            if (this.lastIndexOf(':') > -1) this.substring(0, this.lastIndexOf(':')) 
            else this.substring(0, this.lastIndexOf('#') - 1);
        // @formatter:on
    }

    // public function locateDialog(talk:Array<DialogDesc>) {
    //     var id = getDialogId();
    //     var intId = Std.parseInt(id);
    //     if (intId != null)
    //         return talk[intId];
    //     for (d in talk)
    //         if (d.id == id)
    //             return d;
    //     return null;
    // }
}

typedef DialogDesc = {
    ?alias:String,
    index:Int,
    talkId:String,
    caption:String,
    responces:Array<TalkResponce>
}

@:forward(length, get)
abstract TalkDesc(Array<DialogDesc>) to Array<DialogDesc> {
    public function getDialog(id:DialogId) {
        switch id {
            case Index(n):
                return this[n];
            case Alias(a):
                for (d in this)
                    if (d.alias == a)
                        return d;
        }
        return null;
    }
}

class DialogData extends DescWrap<DialogUri> {}

class TalksDefNode extends DefNode<TalkDesc> {
    override function get(path:Null<String>) {
        var def = super.get(path);
        for (i in 0...def.length) {
            // if(def[i].id!=null)
            //     throw 'Dialogs should not definde id property at $path[$i]';
            if (def[i].alias != null && (def[i].alias.indexOf("#") > -1 || def[i].alias.indexOf(":") > -1))
                throw 'Invalid character :|# in dialogs alias ' + def[i].alias + ' at $path[$i]';
            def[i].talkId = path;
            def[i].index = i;
        }
        return def;
    }
}
