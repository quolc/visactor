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

class Velement_Gear extends Velement {
  int n;
  float r;
  float v=radians(0.5);
  float angle;
  color col;
  
  public Velement_Gear(int vel, int pit, int since, Velement parent, int depth) {
    super(vel, pit, since, parent);
    /*
      initialization of private values / lifespan / others...
    */
    
    vel = int(random(127));
    
    if(vel<32) {
      n=2;
      r=30;
      lifespan = 80;
    } else if(vel<64) {
      n=3;
      r=60;
      lifespan = 100;
    } else if(vel<96) {  
      n=4;
      r=90;
      lifespan = 120;
    } else {
      n=int(random(4)+2);
      r=120;
      lifespan = 150;
    }
    
    this.col = color(random(256), random(256), random(256));
    this.spread = n;
  }
  
  public boolean addChild(Velement elem) {
    if(this.depth<DEPTH_LIMIT) {
    /*
      add child node. you can call recursively this method.
    */
      if(this.stage()==1 && spreadCheck(elem)) {
        this.children.add(elem);
        elem.setParent(this);
        return true;
      } else {
        if(this.children.size()>0) {
          return ((Velement)this.children.get(0)).addChild(elem); 
        }
      }
    }
    return false;
  }
  
  public int stage() {
    /*
      return current life-stage of this element.
      -1:fetus 0:young 1:mature 2:elder 3:dead
    */
    if(this.lifespan < ll) return 3;
    if(this.children.size()>0) return 2;
    return 1;
  }
  
  public void proc() {
    /*
      main routine called every frame.
    */
    
    angle += v;
    super.proc();
  }
  
  public void render() {
    /*
      rendering routine called every frame.
      multiple call is possible so you shouldn't write breakable code in this function.
    */
    if(this.stage()!=3) {
      fill(col,127);
      for(int i=0; i<n; i++) {
        for(int j=0; j<4; j++) {
          ellipse(r*cos(angle+PI*2/n*i-radians(j*2)), r*sin(angle+PI*2/n*i-radians(j*2)), r/7, r/7);
        }
      }
    }
    if(this.children.size()>0) {
      for(int i=0; i<n; i++) {
        pushMatrix();
        translate(r*cos(angle+PI*2/n*i), r*sin(angle+PI*2/n*i));
        rotate(angle+PI*2/n*i);
        scale(0.8);
        ((Velement)this.children.get(0)).render();
        popMatrix();
      }
    }
  }
}
