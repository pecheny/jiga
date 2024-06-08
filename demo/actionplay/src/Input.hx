package;
@:build(macros.BuildMacro.buildAxes())
@:enum abstract TGAxis(Axis<TGAxis>) to Axis<TGAxis> {
    var h;
}

@:build(macros.BuildMacro.buildAxes())
@:enum abstract TGButts(Axis<TGButts>) to Axis<TGButts> {
    var jump = 0;
}