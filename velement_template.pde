/*

  -- velement_template.pde
  
  description of the pattern
  
  Child      : 
  Velocity   : 
  Octave     : 
  LifeSpan   : 
          
*/

import java.util.*;
import java.lang.*;

class Velement_Template extends Velement {
  
  public Velement_Template(int vel, int pit, int since, Velement parent, int depth) {
    super(vel, pit, since, parent);
    /*
      initialization of private values / lifespan / others...
    */
  }
  
  public boolean addChild(Velement elem) {
    /*
      add child node. you can call recursively this method.
    */
    return false;
  }
  
  public int stage() {
    /*
      return current life-stage of this element.
      -1:fetus 0:young 1:mature 2:elder 3:dead
    */
    return 0;
  }
  
  public void proc() {
    /*
      main routine called every frame.
    */
    super.proc();
  }
  
  public void render() {
    /*
      rendering routine called every frame.
      multiple call is possible so you shouldn't write breakable code in this function.
    */
  }
}
