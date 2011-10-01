/*

  -- velement_template.pde
  
  description of the pattern
  
  Child      : up to 3
  Velocity   : 
  Octave     : 
  LifeSpan   : 
          
*/

import java.util.*;
import java.lang.*;

class Velement_Tree extends Velement {
  float angleOffset=radians(2.5);
  float angleOffsetB=radians(30);
  float maxSize = 12;
  float angle=0;
  int plus=1;
  float[] xs = new float[500];
  float[] ys = new float[500];
  float[] dotSizes = new float[500];
  float[] angles = new float[500];
  int count=0;
  color col;
  int[] childOffset = new int[10];
  int maxChild = 3;
  boolean childing=false;
  float rootAngle=0;
  float possibility = 0.02;
  
  public Velement_Tree(int vel, int pit, int since, Velement parent, int depth) {
    super(vel, pit, since, parent);
    /*
      initialization of private values / lifespan / others...
    */
    
    this.lifespan = int(vel*1.2*(0.9+random(0.2)));
    this.col = color(random(256), random(256), random(256));
    this.angle=0;
    
    if(this.depth==0) rootAngle = random(360);
    this.spread = 1;
    
    if(vel==127) {
      angleOffset=radians(15);
      possibility = 0.05;
    }
  }
  
  public boolean addChild(Velement elem) {
    /*
      add child node. you can call recursively this method.
    */
    if(this.depth<DEPTH_LIMIT) {
      if(this.stage()==1 && random(1)<0.5 && spreadCheck(elem)) {
        this.children.add(elem);
        elem.setParent(this);
        childing=true;
        return true;
      } else {
        if(this.children.size()>0) {
          return ((Velement)this.children.get(int(random(this.children.size())))).addChild(elem); 
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
    if(this.children.size()>=this.maxChild || this.ll > this.lifespan/4*3) return 2;
    if(this.children.size() < this.lifespan/4);
    return 1;
  }
  
  public void proc() {
    /*
      main routine called every frame.
    */
    if(childing || (ll%2==0 && this.stage()!=3)) {
      if(childing || random(1)<this.possibility) plus = -plus;
      angle += (float)plus * angleOffset;
      angles[count] = angle;
      if(count!=0) {
        dotSizes[count] = dotSizes[count-1]*0.99;
        xs[count] = xs[count-1] + dotSizes[count]*cos(angle);
        ys[count] = ys[count-1] + dotSizes[count]*sin(angle);
      }else {
        xs[count] = 0;
        ys[count] = 0;
        dotSizes[count] = maxSize;
      }
      if(childing) {
        childOffset[this.children.size()-1] = count;
        childing=false;
      }
      
      count++;
    }
    super.proc();
  }
  
  public void render() {
    if(this.depth==0) {
      pushMatrix();
      rotate(rootAngle);
    }
    /*
      rendering routine called every frame.
      multiple call is possible so you shouldn't write breakable code in this function.
    */
    if(this.stage()!=3) {
      fill(col, 64);
      for(int i=max(0, count-20); i<count; i++) {
        ellipse(xs[i], ys[i], dotSizes[i], dotSizes[i]);
      }
    }
    
    for(int i=0; i<this.children.size(); i++) {
      pushMatrix();
      translate(this.xs[childOffset[i]], this.ys[childOffset[i]]);
      rotate(angles[childOffset[i]]);
      scale(dotSizes[childOffset[i]]/maxSize);
      ((Velement)this.children.get(i)).render();
      popMatrix();
    }
    
    if(this.depth==0) {
      popMatrix();
    }
  }
}
