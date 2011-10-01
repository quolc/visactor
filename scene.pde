/*

  -- scene.pde
  
  Core of VS.
  proc() is the logic.
  render() is the rendering logic.

*/

import java.util.*;
import java.lang.*;

class Scene {
  PApplet parent;
  
  // components
  Keyboard keyboard;
  ArrayList rootElements; // visible elements
  HashMap rootTranslations; // transformations for rootElements
  ArrayList activeElements; // currently pressed elements
  
  // constructor
  Scene(PApplet parent, Keyboard kb) { 
    this.parent = parent;
    this.keyboard = kb;
    this.rootElements = new ArrayList();
    this.activeElements = new ArrayList();
    this.rootTranslations = new HashMap();
  }
  
  // new element processing
  public void procElem(Velement elem) {
    boolean end=false;
    
    // generating random array
    int[] ra = new int[this.rootElements.size()];
    for(int i=0; i<this.rootElements.size(); i++) ra[i] = -1;
    for(int i=0; i<this.rootElements.size(); i++) {
      int tmp = int(random(0, this.rootElements.size()));
      if(ra[tmp]==-1) {
        ra[tmp] = i;
      } else {
        i--;
      }
    }
    
    if(int(random(1000))!=0) {
      for(int i=0; i<this.rootElements.size(); i++) {
        Velement parent = (Velement)this.rootElements.get(ra[i]);
        if(parent.addChild(elem)) {
          end=true;
          /*
            TODO
            multiple processing needed?
          */
          break; 
        }
      } 
    }
    if(!end) {
      println("rootElement added - "+elem.id);
      this.rootElements.add(elem);
      elem.setParent(null);
      /*
        TODO
        how to decide root transformations?
      */
      
      // Center of screen
//      this.rootTranslations.put(elem.id, new float[]{400.0, 300.0});
      this.rootTranslations.put(elem.id, new float[]{float(int(random(width/25))*25), float(int(random(height/25))*25)});
      
    }
  }
  
  // main procedure
  public void proc() {
    int ticks = millis();
    // Input Processing
    for(int i=0; i<255; i++) {
      Keyboard.KeyState ks = this.keyboard.getState(i);
      if(ks.changed) {
        if(ks.on) { // a key is pressed
          Velement elem = null;
          switch(i%12) {
            case 0:
              elem = new Velement_CircleTraffic(ks.velocity, ks.pitch, ticks, null, 0);
              break;
            case 1:
              elem = new Velement_ChainPoly(127, ks.pitch, ticks, null, 0);
              break;
            case 2:
              elem = new Velement_nPoly(ks.velocity, ks.pitch, ticks, null, 0);
              break;
            case 3:
              elem = new Velement_Zigzag(127, ks.pitch, ticks, null, 0); 
              break;
            case 4:
              elem = new Velement_Spiral(ks.velocity, ks.pitch, ticks, null, 0);
              break;
            case 5:
              elem = new Velement_Bubble(ks.velocity, ks.pitch, ticks, null, 0);
              break;
            case 6:
              elem = new Velement_Tile(ks.velocity, ks.pitch, ticks, null, 0);
              break;
            case 7:
              elem = new Velement_Tree(ks.velocity, ks.pitch, ticks, null, 0);
              break;
            case 8:
              elem = new Velement_Tree(127, ks.pitch, ticks, null, 0);
              break;
            case 9:
              elem = new Velement_Network(ks.velocity, ks.pitch, ticks, null, 0);
              break;
            case 10:
              elem = new Velement_CircleTraffic(127, ks.pitch, ticks, null, 0);
              break;
            case 11:
              elem = new Velement_Gear(ks.velocity, ks.pitch, ticks, null, 0);
              break;
          }
          if(elem!=null) {
            this.activeElements.add(elem);
            this.procElem(elem);
          }
        } else { // a key is released
          for(int j=0; j<this.activeElements.size(); j++) {
            if(((Velement)this.activeElements.get(j)).pitch == ks.pitch) {
              ((Velement)this.activeElements.get(j)).released();
              this.activeElements.remove(j);
              j--;
            }
          }
        }
      }
    }
    
    // Calling proc() of each root rootElements.
    for(int i=0; i<rootElements.size(); i++) {
      ((Velement)rootElements.get(i)).proc();
    }
    
    // Body collection
    
    for(int i=0; i<rootElements.size(); i++) {
      Velement elem = (Velement)rootElements.get(i);
      // remove dead element
      if(!elem.alive()) {
        this.rootElements.remove(i);
        this.rootTranslations.remove(elem.id);
        i--;
        /*
        for(int j=0; j<elem.children.size(); j++) {
          this.rootElements.add(elem.children.get(j));
          ((Velement)elem.children.get(j)).setParent(null);
        }
        */
      } 
    }
    
    
//    print(this.rootElements.size());
//    println();
  }
  
  // rendering
  public void render() {
//    background(255);
    
    if(!(frameCount%15==0)) {
      fill(255,255,255,10);
       fill(0,0,0,10);
      rect(0,0,width,height);
    }
    
    for(int i=0; i<rootElements.size(); i++) {
      Velement elem = (Velement)this.rootElements.get(i);
      pushMatrix();
      translate(((float[])rootTranslations.get(elem.id))[0], ((float[])rootTranslations.get(elem.id))[1]);
      ((Velement)rootElements.get(i)).render();
      popMatrix();
    }
  }
}

