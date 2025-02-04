package bootstrap;

import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;
import bootstrap.Lifecycle;

class Menu extends BaseDkit {
 @:once var l:Lifecycle;
 static var SRC = <menu layouts={GuiStyles.L_HOR_CARDS}>
    <button(b().v(sfr, 0.1).b()) text={"new game"} onClick={()->l.newGame()} />
    <button(b().v(sfr, 0.1).b()) text={"save game"} onClick={()->l.saveGame()} />
    <button(b().v(sfr, 0.1).b()) text={"load game"} onClick={()->l.loadGame()} />
    <button(b().v(sfr, 0.1).b()) text={"continue"} onClick={()->l.resume()} />
 </menu> 
}