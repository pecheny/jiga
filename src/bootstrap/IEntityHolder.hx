package bootstrap;

import ec.IComponent;

@:autoBuild(bootstrap.Macros.EntityHolderMacro.build())
interface IEntityHolder extends IComponent {}
