/*

  -- velement.pde
  
  main class for Visual Synthesis

*/

import java.util.*;
import java.lang.*;

abstract class Velement {
  
  Velement parent;
  ArrayList children;
  public int velocity;
  public int pitch;
  public int ll;
  public int lifespan;
  public int gs;
  public boolean generating;
  public int since;
  public int id;
  int depth;
  int DEPTH_LIMIT=5;
  public int particle=1;
  public int spread=1;
  
  Velement(int vel, int pit, int since, Velement parent) {
    this.velocity = vel;
    this.pitch = pit;
    this.children = new ArrayList();
    this.ll = 0;
    this.lifespan = 255; // default life span
    this.gs = 0; // default
    this.generating = true;
    this.since = since;
    this.parent = parent;
    
    this.id = int(random(2147483647));
  }
  
  public boolean alive() {
    if(this.stage()==3) {
      boolean result = false;
      for(int i=0; i<this.children.size(); i++) {
        result = ((Velement)this.children.get(i)).alive();
      }
      return result;
    }
    return true;
  }
  
  // adding child
  public boolean addChild(Velement elem) {
    this.children.add(elem);
    return true;
  }
  
  public boolean spreadCheck(Velement elem) {
//    println(this.particle * elem.spread);
    if(this.particle * elem.spread > PARTICLE_LIMIT) {
      return false;
    }
    return true;
  }
  
  public void setParent(Velement parent) {
    this.parent = parent;
    if(parent==null) {
      this.particle = this.spread;
//      println("root");
    } else {
      this.depth = this.parent.depth + 1;
      this.particle = parent.particle * this.spread;
    }
//    println(this.particle);
  }
  
  // life stage of the element.
  // -1:fetus 0:young 1:mature 2:old 3:dead
  // default stage plan. always reproductive.
  public int stage() {
    if(this.ll>this.lifespan) return 3;
    if(this.generating) return -1;
    return 1;
  }
  
  public void proc() {
    for(int i=0; i<children.size(); i++) {
      ((Velement)children.get(i)).proc();
    }
    if(this.generating) {
      this.gs++;
    }
    if(this.stage()!=3) {
      this.ll++;
    }
    
    // body collection
    for(int i=0; i<children.size(); i++) {
      Velement elem = (Velement)children.get(i);
      // remove dead element
      if(!elem.alive()) {
        this.children.remove(i);
        i--;
      } 
    }
  }
  /*
  public void transform(matrixMath matrix) {
    this.transformation = matrix;
    
    for(int i=0; i<this.children.size(); i++) {
      ((Velement)children.get(i)).transform(matrix);
    }
  }
  */
  public void render() {
    for(int i=0; i<children.size(); i++) {
      ((Velement)children.get(i)).render(); 
    }
  }
  
  public void released() {
    this.generating = false;
  }
}

