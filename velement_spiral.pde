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

class Velement_Spiral extends Velement {
  int a;
  boolean embeded=false;
  
  public Velement_Spiral(int vel, int pit, int since, Velement parent, int depth) {
    super(vel, pit, since, parent);
    /*
      initialization of private values / lifespan / others...
    */
    
    this.lifespan = 90;
    a = 200;
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
        for(int i=lifespan-ll+15; i>lifespan-ll; i--) {
          float theta = ((float)i/360*2*PI)*5;
          float r = a/theta;
          if(depth%2==0) {
            ellipse(r*cos(theta), r*sin(theta), sqrt(theta)*4, sqrt(theta)*4);
          } else {
            ellipse(r*cos(-theta), r*sin(-theta), sqrt(theta)*4, sqrt(theta)*4);
          }
        }
      }
      
      if(this.children.size()>0) {
        pushMatrix();
        
        scale(0.7);
        if(depth%2==0) {
          rotate((float)90/360*2*PI);
        } else {
          rotate((float)-90/360*2*PI);
        }
        translate(80, 0);
        if(depth%2==0) {
          rotate((float)-15/360*2*PI);
        } else {
          rotate((float)15/360*2*PI);  
        }
        
        ((Velement)this.children.get(0)).render();
        popMatrix();
      }
    } else if(this.children.size()>0) {
      for(int i=ll-10; i<ll; i++) {
        float theta = ((float)(lifespan-i)/360*2*PI)*5;
        
        float r = a/theta;
        if(depth%2==0) {
          pushMatrix();
          rotate(theta);
          scale(0.9);
          translate(r*cos(theta), r*sin(theta));
          ((Velement)this.children.get(0)).render();
//          ellipse(r*cos(theta), r*sin(theta), sqrt(theta)*4, sqrt(theta)*4);
          popMatrix();
        } else {
          pushMatrix();
          rotate(-theta);
          scale(0.9);
          translate(r*cos(-theta), r*sin(-theta));
          ((Velement)this.children.get(0)).render();
//          ellipse(r*cos(-theta), r*sin(-theta), sqrt(theta)*4, sqrt(theta)*4);
          popMatrix();
        }
      }
    }
  }
}
