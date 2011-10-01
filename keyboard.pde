/*

  -- keyboard.pde
  
  Wrapper class of Midi keyboard input.
  Basic input can be used as a substance.

*/

import java.util.*;
import java.lang.*;

class Keyboard {
  boolean[] isNoteOn = new boolean[255];
  boolean[] isEntering = new boolean[255];
  boolean[] isEnding = new boolean[255];
  int[] velocity = new int[255];
  int[] onTime = new int[255];
  
  // public methods
  class KeyState {
    public int pitch;
    public int velocity;
    public boolean on;
    public boolean changed;
    public int length;
    KeyState(int p, int v, boolean o, boolean c, int l) {
      this.pitch = p;
      this.velocity = v;
      this.on = o;
      this.changed = c;
      this.length = l;
    }
  }
  
  public Keyboard.KeyState getState(int pitch) {
    KeyState ks = new KeyState(pitch, velocity[pitch], isNoteOn[pitch], (isEntering[pitch] || isEnding[pitch]), isNoteOn[pitch] ? millis()-onTime[pitch] : 0);
    isEntering[pitch] = false;
    isEnding[pitch] = false;
    return ks;
  }
  
  // constructor
  Keyboard() {
    this.keymap.put('a', 48);
    this.keymap.put('w', 49);
    this.keymap.put('s', 50);
    this.keymap.put('e', 51);
    this.keymap.put('d', 52);
    this.keymap.put('f', 53);
    this.keymap.put('t', 54);
    this.keymap.put('g', 55);
    this.keymap.put('y', 56);
    this.keymap.put('h', 57);
    this.keymap.put('u', 58);
    this.keymap.put('j', 59);
    this.keymap.put('k', 60);
    for(int i=0; i<255; i++) {
      this.isNoteOn[i] = false;
      this.isEntering[i] = false;
      this.isEnding[i] = false;
      this.velocity[i] = 0;
      this.onTime[i] = 0;
    }
  }
  
  // general input
  void noteOn(int pitch, int velocity) {
    if(!isNoteOn[pitch]) {
      this.isNoteOn[pitch] = true;
      this.isEntering[pitch] = true;
      this.isEnding[pitch] = false;
      this.velocity[pitch] = velocity;
      this.onTime[pitch] = millis();
    }
  }
  void noteOff(int pitch) {
    if(isNoteOn[pitch]) {
      this.isNoteOn[pitch] = false;
      this.isEnding[pitch] = true;
      this.isEntering[pitch] = false;
      this.velocity[pitch] = 0;
      this.onTime[pitch] = 0;
    }
  }
  
  // midi input
  public void midiNoteOn(Note note) {
    this.noteOn(note.getPitch(), note.getVelocity());
  }
  
  public void midiNoteOff(Note note) {
    this.noteOff(note.getPitch());
  }
  
  //  pc input
  /*
        [wC]    [eD]        [tF]    [yG]    [uA]
    [aC]    [sD]    [dE][fF]    [gG]    [hA]    [jB][kC]
    
        [49]    [51]        [54]    [56]    [58]
    [48]    [50]    [52][53]    [55]    [57]    [59][60]
  */
  HashMap keymap = new HashMap();
  
  public void pcNoteOn(char key) {
    if(this.keymap.containsKey(key)) {
      this.noteOn((Integer)this.keymap.get(key), 127);
    }
  }
  
  public void pcNoteOff(char key) {
    if(this.keymap.containsKey(key)) {
      this.noteOff((Integer)this.keymap.get(key));
    }
  }
}

