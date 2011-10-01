/*

  -- velement_circletraffic.pde
  
  line pattern consists by single-colored small circles.
  
  Child      : 1
  Velocity   : length of the lifespan = length of the line
  Octave     : ? color or satulation of the line?
  LifeSpan   : descrived above
          
*/

import java.util.*;
import java.lang.*;

class Velement_CircleTraffic extends Velement {
  // original elements
  int rad;
  int r;
  int g;
  int b;
  int childirection = 1;
  
  // override methods
  Velement_CircleTraffic(int vel, int pit, int since, Velement parent, int depth) {
    super(vel, pit, since, parent);
    
    this.r = int(random(255));
    this.g = int(random(255));
    this.b = int(random(255));
    this.rad = 0;
    
    this.lifespan = 80;
    this.spread = 1;
  }
  public boolean addChild(Velement elem) {
    if(this.depth<DEPTH_LIMIT) {
      if(this.children.size()==0) {
        if(this.stage()==1 && spreadCheck(elem)) {
          this.children.add(elem);
          elem.setParent(this);
//          this.childirection = int(random(0,2))*2-1;
          return true;
        }
      } else {
        return ((Velement)this.children.get(0)).addChild(elem);
      }
    }
    return false;
  }
  public int stage() {
    if(this.ll > this.lifespan) {
      return 3; 
    }
    if(this.ll > this.lifespan/4*3) {
      return 2;
    }
    if(this.ll > this.lifespan/2) {
      return 1; 
    }
    return 0;
  }
  public void released() {    
    super.released();
  }
  public void proc() {
    if(this.stage()!=3) {
      this.rad+=3;
    }
    super.proc(); 
  }
  
  public void render() {
    if(this.stage()!=3) {
      if(this.stage()==2) {
        fill(this.r, this.g, this.b, 20*(1-(float)(this.ll-this.lifespan*3/4)/((float)this.lifespan/4)));
      } else {
        fill(this.r, this.g, this.b, 30);
      }
    
      for(int i=0; i<pow(rad,1.2)/30; i++) {
        if(this.velocity==127) {
          rect(i*25, 0, 14, 14);
        } else {
          ellipse(i*25, 0, 20, 20);
        }
      }
    }
    
    if(this.children.size()>0) {
      pushMatrix();
      translate(lifespan/2*5 - lifespan/2*5%25, 0);
      rotate(PI/2*this.childirection);
      if(this.velocity==127) {
        translate(0,-14); 
      }
      ((Velement)this.children.get(0)).render();
      popMatrix();
    }
    
//    super.render();
  }
  
}

