//camera
import processing.video.*;
//gamepad
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
//spacial mapping
import deadpixel.keystone.*;
//camera
Capture cam;
//spacial mapping
Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;

//gamepad
ControlIO control;
ControlDevice gpad;
//gamepad controls
float xAxis;
float yAxis;
boolean zero;
boolean one;
boolean two;
boolean three;
boolean four;
boolean five;
boolean six;
boolean sixDown;
boolean seven;
boolean sevenDown;
//time variables
int lastTime;
float deltaTime = 0;

PImage level;
PImage altLevel;
int[] data;

int spawnX = 0;
int spawnY = 0;
int numPoints = 0;
//platformer physics
float x;
float y;
float velX;
float velY;
float maxVelX = 3;
float maxVelY = 6;
float minJumpVel = 3;
float maxJumpVel = 8;
boolean jump = true;
boolean grounded = false;
int pWidth = 20;
int pHeight = 30;
//multithreading bools for comminication
boolean updateData = false;
boolean cameraReady = false;
boolean processing = false;

enum mode {
  EMPTY,
  CAMERA,
  COLORS
}
mode displayMain = mode.EMPTY;
boolean displayPaletteFrame = false;
boolean displayPaletteColors = false;

int ground = color(50,50,50,0);
int deadly = color(235,70,0,0);
int start = color(31,44,89,0);
int finish = color(8,129,124,0);
int groundR = color(198,159,0);
int deadlyR = color(175,47,154);
int startR = color(80,255,0);
int finishR = color(0,246,255);

int messageIndex = 0;
String[] introMessages = new String[] 
{
  "Press Start",
  "Draw something that can be seen\nby the camera",
  "Position projector/warp image with mouse\nto make projector align",
  "Fill in the color table",
  "Press Start to confirm\nB to reconfigure",
  "Press Start"
};
void settings() {
  level = new PImage(1280,720);
  altLevel = new PImage(1280,720);
  size(level.width, level.height,P3D);
  data = new int[altLevel.width*altLevel.height];
}
void setup() {
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    //camera 53 is the 1280x720 one that works
    cam = new Capture(this, cameras[53]);
    cam.start();    
  }
  Thread processCameraFeed = new Thread(new ProcessCameraFeed());
  processCameraFeed.start();
  
  // Initialise the ControlIO
  control = ControlIO.getInstance(this);
  // Find a device that matches the configuration file
  gpad = control.getMatchedDevice("snes");
  if (gpad == null) {
    println("No suitable device configured");
    //System.exit(-1); // End the program NOW!
  }
  
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(level.width, level.height, 20);
  offscreen = createGraphics(level.width,level.height, P3D);
  //surface.moveTo(0,0);
}

void draw() {
  //gamepad controls
  if (gpad != null) {
    xAxis = gpad.getSlider("X").getValue();
    yAxis = gpad.getSlider("Y").getValue();
    zero = gpad.getButton("ZERO").pressed();
    one = gpad.getButton("ONE").pressed();
    two = gpad.getButton("TWO").pressed();
    three = gpad.getButton("THREE").pressed();
    four = gpad.getButton("FOUR").pressed();
    five = gpad.getButton("FIVE").pressed();
    sixDown = (gpad.getButton("SIX").pressed()&&!six)?true:false;
    six = gpad.getButton("SIX").pressed();
    sevenDown = (gpad.getButton("SEVEN").pressed()&&!seven)?true:false;
    seven = gpad.getButton("SEVEN").pressed();
  }
  //get deltaTime
  deltaTime = (millis()-lastTime)/1000f;
  lastTime = millis();
  
  if (sevenDown) {
    Intro(messageIndex+1);
  }
  if (sixDown) {
    print("color assigned");
    ReadPalette();
  }
  
  /*
  //physics
  DoPhysics();
  */
  
  //camera feed
  if (cam.available() == true) {
    cam.read();
    if (!processing) {
      level = cam;
      cameraReady = true;
    }
  }
  //main screen
  offscreen.beginDraw();
  switch (displayMain) {
    case EMPTY:
      offscreen.background(0);
      break;
    case CAMERA:
      offscreen.image(cam,0,0);
      break;
    case COLORS:
      if (updateData) {
        offscreen.image(altLevel,0,0);
        updateData = false;
      }
      break;
  }
  if (messageIndex > -1) {
    offscreen.fill(255);
    offscreen.textAlign(CENTER);
    offscreen.textSize(30);
    offscreen.text(introMessages[messageIndex],level.width/2,level.height/2);
  }
  if (displayPaletteFrame) {
    DrawPaletteFrame();
  }
  if (displayPaletteColors) {
    DrawPaletteColors();
  }
  offscreen.endDraw();
  // render the scene, transformed using the corner pin surface
  background(0);
  surface.render(offscreen);
  //debug screens
  //image(cam,0,0,cam.width/2,cam.height/2);
  /*if (updateData) {
    image(altLevel,0,altLevel.height/2,altLevel.width/2,altLevel.height/2);
    updateData = false;
  }*/
  
}

void keyDown() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;
  case 'w':
    yAxis = 1;
    break;
  case 'a':
    xAxis = -1;
    break;
  case 's':
    yAxis = -1;
    break;
  case 'd':
    xAxis = 1;
    break;
  case 'q':
    sevenDown = true;
  }
}

//HD USB cam, $30
//projector