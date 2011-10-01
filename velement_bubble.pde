/*

  -- velement_bubble.pde
  
  bubble-like pattern
  
  Child      : 
  Velocity   : 
  Octave     : 
  LifeSpan   : 
          
*/

import java.util.*;
import java.lang.*;

class Velement_Bubble extends Velement {
  class Bubble {
    int rad;
    color c;
    public Bubble(int r, int g, int b) {
      this.c = color(r, g, b, 32);
      this.rad = 0;
    }
  }
  
  ArrayList bubbles;
  int k;
  
  public Velement_Bubble(int vel, int pit, int since, Velement parent, int depth) {
    super(vel, pit, since, parent);
    /*
      initialization of private values / lifespan / others...
    */
    
    this.lifespan = vel;
    this.bubbles = new ArrayList();
    this.k = int(random(6));
    this.spread = k;
  }
  
  public boolean addChild(Velement elem) {
    if(this.depth<DEPTH_LIMIT) {
      if(this.children.size()==0) {
        if(this.stage()==1 && spreadCheck(elem)) {
          this.children.add(elem);
          elem.setParent(this);
          return true;
        }
      } else {
        return ((Velement)this.children.get(0)).addChild(elem);
      }
    }
    return false;
  }
  
  public int stage() {
    /*
      return current life-stage of this element.
      -1:fetus 0:young 1:mature 2:elder 3:dead
    */
    if(this.ll > this.lifespan) return 3;
    if(this.children.size()>0 || this.ll > this.lifespan/2) {
      return 2;
    }
    if(this.ll < this.lifespan/4) return 0;
    if(this.generating) {
      return -1; 
    }
    return 1;
  }
  
  public void proc() {
    /*
      main routine called every frame.
    */
    if(this.stage()!=3) {
      if((this.generating || this.bubbles.size()<=3) && this.bubbles.size()<5) {
        if(this.generating || int(random(50))==0) {
          int r;
          int g;
          int b;
          while(true) {
            r = int(random(255));
            g = int(random(255));
            b = int(random(255));
            if(this.bubbles.size()>1 || sqrt(r*r+g*g+b*b)>200) break;
          }
          this.bubbles.add(new Bubble(r,g,b));
        }
      }
      for(int i=0; i<this.bubbles.size(); i++) {
        ((Bubble)this.bubbles.get(i)).rad++;
      }
    }
    
    super.proc();
  }
  
  public void render() {
    if(this.stage()!=3) {
      noFill();
      for(int i=0; i<this.bubbles.size(); i++) {
        stroke(((Bubble)this.bubbles.get(i)).c);
//        stroke(255,255,255, 32);
        ellipse(0, 0, pow(((Bubble)this.bubbles.get(i)).rad, 0.7)*3.5, pow(((Bubble)this.bubbles.get(i)).rad, 0.7)*3.5);
      }
      noStroke();
    }
    
    for(int i=0; i<this.children.size(); i++) {
      pushMatrix();
      
      rotate(PI*2/6*this.k);
//      translate(pow(this.lifespan, 0.7)*3.8, 0);
//      scale(1.0);
      ((Velement)this.children.get(0)).render();
      
      popMatrix();
    }
    
    /*
      rendering routine called every frame.
      multiple call is possible so you shouldn't write breakable code in this function.
    */
  }
}
