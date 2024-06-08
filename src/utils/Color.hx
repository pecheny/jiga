package utils;

abstract Color(Int) from Int to Int {
    public var r(get, set):Int;
    public var g(get, set):Int;
    public var b(get, set):Int;
    public var a(get, set):Int;

    public inline function get_r() return (this & 0xff0000) >> 16;
    public inline function set_r(v:Int) return this = (this & 0xff00ffff) + ((v & 0xff) <<16);

    public inline function get_g() return (this & 0x00ff00) >> 8;
    public inline function set_g(v:Int) return this = (this & 0xffff00ff) + ((v & 0xff) <<8);

    public inline function get_b() return (this & 0xff) ;
    public inline function set_b(v:Int) return this = (this & 0xffffff00) + (v & 0xff) ;

    public inline function get_a() return (this & 0xff000000) >> 24;
    public inline function set_a(v:Int) return this = (this & 0x00ffffff) + ((v & 0xff) <<24);

    // var r = (val & 0xff0000)>> 16;
    // var g = (val & 0x00ff00) >> 8;
    // var b = (val & 0x0000ff);
    // var a = (val  >> 24) & 0xff;
}
