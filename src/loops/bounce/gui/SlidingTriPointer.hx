package loops.bounce.gui;

import Axis2D;
import data.IndexCollection;
import data.aliases.AttribAliases;
import gl.AttribSet;
import gl.ValueWriter.AttributeWriters;
import graphics.shapes.Shape;
import haxe.io.Bytes;

class SlidingTriPointer <T:AttribSet> implements Shape {
    var writers:AttributeWriters;
    public var t:Float = 0;
    var inds = IndexCollection.fromArray([0,1,2]);

    public function new(attrs:T) {
        writers = attrs.getWriter(AttribAliases.NAME_POSITION) ;
    }

    public inline function getIndices():IndexCollection {
        return inds;
    }

    inline function writeTridPostions(target:Bytes, writer:AttributeWriters, vertOffset = 0, transformer ) {
        inline function setx(i, val) {
            writer[horizontal].setValue(target, vertOffset + i, transformer(horizontal, val));
        }
        inline function sety(i, val) {
            writer[vertical].setValue(target, vertOffset + i, transformer(vertical, val));
        }
        var wd = 0.03;
        setx(0, t-wd);
        setx(1, t);
        setx(2, t+wd);
        sety(0, 1);
        sety(1, 0);
        sety(2, 1);
    }

    public function writePostions(target:Bytes,  vertOffset = 0, transformer) {
        writeTridPostions(target, writers, vertOffset , transformer);
        writeAttributes(target, vertOffset, transformer);
    }

    public dynamic function writeAttributes(target:Bytes,  vertOffset = 0, transformer) {
        
    }

    public function getVertsCount():Int {
        return 3;
    }

    public function initInBuffer(target:Bytes, vertOffset:Int) {}
}