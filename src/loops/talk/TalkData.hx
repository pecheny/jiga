package loops.talk;

import bootstrap.DescWrap;

typedef CommandCall = String;

typedef TalkResponce = {
    caption:String,
    actions:Array<CommandCall>,
    ?guards:Array<CommandCall>,
    ?stay:Bool
}

typedef DialogDesc = {
    ?id:String,
    caption:String,
    responces:Array<TalkResponce>
}

typedef TalkDesc = Array<DialogDesc>;
class DialogData extends DescWrap<DialogDesc> {}
