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

class Velement_Tile extends Velement {
  int n;
  int c;
  int span = 15;
  int front, back;
  boolean embeded = false;
  color col;
  
  public Velement_Tile(int vel, int pit, int since, Velement parent, int depth) {
    super(vel, pit, since, parent);
    /*
      initialization of private values / lifespan / others...
    */
    
    n=1;
    if(vel>32) n=2;
    if(vel>92) n=3;
    
    c=0;
    this.lifespan = (n+1)*span;
    
    this.col = color(random(255), random(255), random(255));
    this.spread = (2*n+1)*(2*n+1) / 2;
  }
  
  public boolean addChild(Velement elem) {
    if(this.depth<DEPTH_LIMIT) {
    /*
      add child node. you can call recursively this method.
    */
      if(this.stage()==1 && spreadCheck(elem)) {
        if(this.generating || random(1)>0.8) {
          this.embeded = true;
          this.children.add(elem);
          elem.setParent(this);
          return true;
        }
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
    if(this.ll > this.lifespan) return 3;
    if(this.children.size()>0) return 2;
    if(this.generating || this.children.size()==0) {
      return 1;
    }
    
    return 0;
  }
  
  public void proc() {
    /*
      main routine called every frame.
    */
    front = int((float)ll/span);
    back = int((float)(ll-span*4)/span);
    
    super.proc();
    if(this.stage()==3) this.ll=lifespan+1;
  }
  
  int[] dx = new int[]{1, 0, -1, 0};
  int[] dy = new int[]{0, 1, 0, -1};
  
  public void render() {
    /*
      rendering routine called every frame.
      multiple call is possible so you shouldn't write breakable code in this function.
    */
    if(!this.embeded) {
      if(this.stage()!=3) {
        for(int i=0; i<front; i++) {
          fill(this.col, 16);
          for(int j=0; j<i*2+1; j++) {
            for(int k=0; k<i*2+1; k++) {
              if((j==0 || j==i*2) || (k==0 || k==i*2)) {
                if(i>back & (j+k)%2==0) rect(-50*i-20+50*j, -50*i-20+50*k, 40, 40);
              }
            }
          }
        }
      }
    } else if(this.children.size()>0) {
      for(int i=front-1; i<front; i++) {
        for(int j=0; j<i*2+1; j++) {
          for(int k=0; k<i*2+1; k++) {
            if((j==0 || j==i*2) || (k==0 || k==i*2)) {
              if(i>back && j%2==0 && k%2==0) {
                pushMatrix();
                translate(-50*i-20+50*j, -50*i-20+50*k);
                rotate(PI/2*(j+k/2));
                ((Velement)this.children.get(0)).render();
                popMatrix();
              }
            }
          }
        }
      }
    }
  }
}
