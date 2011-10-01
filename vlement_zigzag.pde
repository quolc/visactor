/*

  -- velement_spiral.pde
  
  description of the pattern
  
  Child      : 
  Velocity   : 
  Octave     : 
  LifeSpan   : 
          
*/

import java.util.*;
import java.lang.*;

class Velement_Zigzag extends Velement {
  int a;
  int l;
  int n;
  int multi=5;
  boolean embeded=false;
  
  public Velement_Zigzag(int vel, int pit, int since, Velement parent, int depth) {
    super(vel, pit, since, parent);
    /*
      initialization of private values / lifespan / others...
    */
    
    if(vel<32) {
      n=3;
    } else if(vel<64) {
      n=4;
    } else if(vel<96) {  
      n=5;
    } else {
      n=int(random(4)+3);
    }
    
    a = 30;
    l = 2;
    this.lifespan = a*n-multi;
    this.spread = 15;
  }
  
  public boolean addChild(Velement elem) {
    if(this.depth<DEPTH_LIMIT) {
    /*
      add child node. you can call recursively this method.
    */
      if(this.stage()==1 && spreadCheck(elem)) {
        if(this.generating) {
          embeded = true;
        }
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
    if(ll>lifespan) return 3;
    if(this.children.size()==1) return 2;
    if(lifespan/3*2>ll && ll>lifespan/12) return 1;
    return 0;
  }
  
  public void proc() {
    /*
      main routine called every frame.
    */
    super.proc();
    if(this.stage()==3) this.ll++;
  }
  
  public void render() {
    fill(255, 255, 255, 20);
    
    if(!embeded) {
      if(this.stage()!=3) {
        for(int i=ll+multi; i>ll; i--) {
          float x = i*l;
          float y;
          if((i/a)%2==0) {
            y = a*l-(i%a)*l;
          } else {
            y = i%a*l;
          }
          ellipse(x, y, sqrt(ll), sqrt(ll));
        }
      }
      
      if(this.children.size()>0) {
        for(int i=0; i*a<=ll; i++) {
          float x = i*a*l;
          float y;
          if((i)%2==0) {
              y = a*l;
            } else {
              y = 0;
            }
          pushMatrix();
          
          translate(x, y);
          if(i%2==0) {
            rotate(PI/4);
          } else {
            rotate(-PI/4);
          }
          
          scale(0.8);
          
          ((Velement)this.children.get(0)).render();
          popMatrix();
        }
      }
    } else if(this.children.size()>0) {
      for(int i=ll+multi; i>ll; i--) {
          float x = i*l;
          float y;
          if((i/a)%2==0) {
            y = a*l-(i%a)*l;
          } else {
            y = i%a*l;
          }
          pushMatrix();
          translate(x,y);
          if((i/a)%2==0) {
            rotate(PI/4);
          } else {
            rotate(-PI/4);
          }
          ((Velement)this.children.get(0)).render();
          popMatrix();
        }
    }
  }
}
