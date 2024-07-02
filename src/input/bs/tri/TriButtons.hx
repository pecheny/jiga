package input.bs.tri;

@:build(macros.BuildMacro.buildAxes())
@:enum abstract TriButtons(Axis<TriButtons>) to Axis<TriButtons> to Int {
    var l;
    var r;
    var up;
}