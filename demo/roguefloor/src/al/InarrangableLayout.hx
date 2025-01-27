package al;

import al.core.AxisState;
import al.layouts.AxisLayout;

class InarrangableLayout implements AxisLayout{
    public static final instance = new InarrangableLayout();

    function new() {
    
    }


    public function arrange(pos:Float, size:Float, children:Array<AxisState>):Float {
        for (ch in children) {
            if(ch.isArrangable())
                continue;
            var cpos = switch 
            ch.position.type {
                case fixed: pos + ch.position.value;
                case percent: pos + ch.position.value * size / 100;
                case managed: throw "magic";
            }
            var csize = ch.size.getFixed() + ch.size.getPortion() * size;
            ch.apply(cpos , csize );
        }
        return size; // todo calc max coord relative to parent's origin

    }
}