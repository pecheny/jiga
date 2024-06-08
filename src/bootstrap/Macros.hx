package bootstrap;

import haxe.macro.Context;

class EntityHolderMacro {
    #if macro
    static var tmpl = macro class EntityHolder implements IComponent {
        @:isVar public var entity(get, set):ec.Entity;

        public function get_entity():ec.Entity {
            return entity;
        }

        public function set_entity(value:ec.Entity):ec.Entity {
            return this.entity = value;
        }
    }

    public static function build() {
        var fields = Context.getBuildFields();
        for (f in tmpl.fields)
            fields.push(f);
        return fields;
    }
    #end
}
