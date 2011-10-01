import processing.video.*;
import processing.opengl.*;

/*
  
  -- visession.pde
  It is the main file of VS.
  Basic input methods and rendering logics are here.
  All input data are sent to the "scene" instance.

*/

import fullscreen.*;
import promidi.*;

boolean fullScreen = true;
boolean usePCKeyForMidi = true;
boolean useMidiKeyboard = false;
int PARTICLE_LIMIT = 5000;

Scene scene;

MidiIO midiIO;
MidiOut out;

Keyboard keyboard;

MovieMaker mm;

void setup() {
  // midi initialization
  keyboard = new Keyboard();
  midiIO = MidiIO.getInstance(this);
  try {
    if(useMidiKeyboard) {
      midiIO.openInput(0,0);
      midiIO.printDevices();
      out = midiIO.getMidiOut(0,2);
    } else {
      this.midiIO = null;
    }
  } catch(Exception e) {
    this.midiIO = null;
    println("not using midi");
  }
  
  // logic initialization
  scene = new Scene(this, keyboard);
  
  // rendering options
  size(800, 600);
  smooth();
  background(255);
  noStroke();
  frameRate(60);
  strokeCap(ROUND);
  strokeWeight(2);
  ellipseMode(CENTER);
  
  // fullscreen mode
  if(fullScreen) {
    FullScreen fs = new FullScreen(this);
    fs.enter();
  }
}

// main loop
void draw() {
  scene.proc(); 
  scene.render();
//  mm.addFrame();
}

// midi methods
void noteOn(Note note, int deviceNumber, int midiChannel) {
  keyboard.midiNoteOn(note);
  out.sendNote(note);
}

void noteOff(Note note, int deviceNumber, int midiChannel) {
  keyboard.midiNoteOff(note);  
}

void mouseClicked() {
}

// keyboard methods
void keyPressed() {
  if(usePCKeyForMidi) {
    keyboard.pcNoteOn(key);
  }
}

void keyReleased() {
  if(usePCKeyForMidi) {
    keyboard.pcNoteOff(key);
  }
}
