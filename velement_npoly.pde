/*

  -- velement_npoly.pde
  
  polygonal spreading pattern
  
  Child      : 1~2
  Velocity   : 
  Octave     : 
  LifeSpan   : 
          
*/

import java.util.*;
import java.lang.*;

class Velement_nPoly extends Velement {
  int n;
  int lim;
  
  public Velement_nPoly(int vel, int pit, int since, Velement parent, int depth) {
    super(vel, pit, since, parent);
    /*
      initialization of private values / lifespan / others...
    */
    
    lim=1;
    if(vel<32) {
      n=3;
    } else if(vel<64) {
      n=4;
    } else if(vel<96) {  
      n=5;
    } else {
      n=int(random(4)+3);
    }
    
    lifespan=120;
    this.spread = n;
  }
  
  public boolean addChild(Velement elem) {
    if(this.depth<DEPTH_LIMIT) {
      if(this.stage()==1 && this.children.size()<lim && spreadCheck(elem)) {
        this.children.add(elem);
        elem.setParent(this);
        return true;
      } else {
        for(int i=0; i<this.children.size(); i++) {
          if(((Velement)this.children.get(i)).addChild(elem)) return true;
        }
      }
    }
    return false;
  }
  
  public int stage() {
    if(this.ll>this.lifespan) return 3;
    if(this.children.size()>=this.lim) return 2;
    else return 1;
  }
  
  public void proc() {
    /*
      main routine called every frame.
    */
    super.proc();
  }
  
  public void render() {
    //body
    /*
    strokeWeight(2);
    stroke(255,255,255, (float)ll/lifespan*255);
    */
    fill(255,255,255, (float)(lifespan-ll)/lifespan*127);
    for(int i=0; i<n; i++) {
      ellipse(2*ll*ll/100*cos(i*2*PI/n), 2*ll*ll/100*sin(i*2*PI/n), sqrt(ll), sqrt(ll)); 
    }
    noStroke();
    
    //poly
    if(this.children.size()>0) {
      for(int i=0; i<n; i++) {
        pushMatrix();
        rotate(PI*2/n*i);
        scale(0.5);
        translate(100, 0);
        ((Velement)this.children.get(0)).render();
        popMatrix();
      }
    }
    /*
      rendering routine called every frame.
      multiple call is possible so you shouldn't write breakable code in this function.
    */
  }
}
