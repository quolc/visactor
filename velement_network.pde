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

class Velement_Network extends Velement {
  int n;
  float[] xs = new float[10];
  float[] ys = new float[10];
  color[] cols = new color[10];
  float achievement;
  float ratio=1.0/2;
  
  public Velement_Network(int vel, int pit, int since, Velement parent, int depth) {
    super(vel, pit, since, parent);
    /*
      initialization of private values / lifespan / others...
    */
    
    if(vel<32) {
      n=2;
    } else if(vel<64) {
      n=3;
    } else if(vel<96) {  
      n=4;
    } else {
      n=int(random(4)+2);
    }
    
    for(int i=0; i<n; i++) {
      float r=100*(0.8+random(0.4));
      float theta = random(radians(360));
      
      xs[i] = r*cos(theta);
      ys[i] = r*sin(theta);
      cols[i] = color(random(256), random(256), random(256));
    }
    
    lifespan=100;
    this.spread = n;
  }
  
  public boolean addChild(Velement elem) {
    if(this.depth<DEPTH_LIMIT) {
      if(this.stage()==1 && this.children.size()<n && spreadCheck(elem)) {
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
    /*
      return current life-stage of this element.
      -1:fetus 0:young 1:mature 2:elder 3:dead
    */
    if(this.ll>this.lifespan) return 3;
    if(this.children.size()>=this.n) return 2;
    if(ll>(float)this.lifespan*ratio) return 1;
    return 0;
  }
  
  public void proc() {
    /*
      main routine called every frame.
    */
    
    this.achievement = min(1, sqrt(sqrt((float)ll/(lifespan*ratio))));
    
    super.proc();
  }
  
  public void render() {
    /*
      rendering routine called every frame.
      multiple call is possible so you shouldn't write breakable code in this function.
    */
    if(this.stage()!=3) {
      fill(255,255,255,128);
      for(int i=0; i<n; i++) {
        stroke(cols[i], 64);
        line(0, 0, xs[i]*achievement, ys[i]*achievement);
        noStroke();
        if(achievement>=1) {
          ellipse(xs[i], ys[i], 12, 12);
        }
      }
      ellipse(0,0,12,12);
    }
    
    for(int i=0; i<children.size(); i++) {
      pushMatrix();
      
      translate(xs[i], ys[i]);
      ((Velement)this.children.get(i)).render();
      
      popMatrix();
    }
  }
}
