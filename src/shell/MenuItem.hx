package shell;

typedef MenuItem = {
    caption:String,
    handler:Void->Void,
    ?enabled:Void->Bool,
}

typedef MenuData = Array<MenuItem>
