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

class Velement_ChainPoly extends Velement {
  public float a;
  int n;
  int lim;
  color col;
  int[] ks = new int[10];
  float[] as = new float[10];
  int[] ns = new int[10];
  boolean[] used = new boolean[10];

  public Velement_ChainPoly(int vel, int pit, int since, Velement parent, int depth) {
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
      n=6;
    }
    
    lifespan = 80;
    this.a = (random(0.5)+0.75)*30;
    this.col = color(random(256), random(256), random(256));
    this.lim = int(this.n*random(1))+1;
    
    this.spread = 6;
    for(int i=0; i<n; i++) used[i] = false;
  }
  
  public void setParent(Velement parent) {
    super.setParent(parent);
    if(parent!=null && parent.getClass().getName()=="visession$Velement_Chainpoly") {
      this.n = ((Velement_ChainPoly)parent).n;
    }
  }

  public boolean addChild(Velement elem) {
    if(this.depth<DEPTH_LIMIT) {
    /*
      add child node. you can call recursively this method.
    */
      if(this.stage()==1 && spreadCheck(elem) && random(1)>0.6) {
        this.children.add(elem);
        elem.setParent(this);
        if(elem.getClass().getName()=="visession$Velement_ChainPoly") {
          as[this.children.size()-1] = ((Velement_ChainPoly)elem).a;
          ns[this.children.size()-1] = ((Velement_ChainPoly)elem).n;
        } else {
//        print(elem.getClass().getName());
          as[this.children.size()-1] = 10;
        }
        while(true) {
          int tmp = int(random(1)*this.n);
          if(used[tmp]==false) {
            used[tmp]=true;
            ks[this.children.size()-1] = tmp;
            break;
          }
        }
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
    if(this.ll > this.lifespan) return 3;
    if(this.children.size() >= this.lim) return 2;
    return 1;
    
//    return 0;
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
     multiple call is possible so you shouldn't write breakable code in this function/.
     */
     if(this.stage()!=3) {
       fill(this.col, 24);
       for(int i=0; i<n; i++) {
         triangle(0.0,0.0,a*cos(PI*2/n*i),a*sin(PI*2/n*i), a*cos(PI*2/n*(i+1)),a*sin(PI*2/n*(i+1)));
       }
     }
     for(int i=0; i<this.children.size(); i++) {
       pushMatrix();
       
       rotate(PI*2*ks[i]/n);
       translate(a,0);
       if(this.children.get(i).getClass().getName()=="visession$Velement_ChainPoly") {
         translate(as[i],0);
         if(ns[i]%2==1) rotate(PI);
       }
       ((Velement)this.children.get(i)).render();
      
       popMatrix(); 
     }
  }
}

