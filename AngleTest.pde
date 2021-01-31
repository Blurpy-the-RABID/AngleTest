// Global variables
float midWidth, midHeight;
float circleRadius = 250;

// Angle variables
float deg1 = -90.0;
float deg2 = 10.0;
float angleMult = 1.0;
float currentAngle, targetAngle;
float mX, mY;

// Color variables.r
color clr1, clr2, clr3, clr4, clr5, clr6, clr7, clr8, clr9, clr10, clr11, clr12, clr13, clr14, clr15, clr16, clr17, clr18, clr19;
color white, black, gray, clear;
int X_AXIS = 2; // Left to right gradient.

// Frame Rate variables
float bpm = 64;
float fps = (3600 / bpm);
int cycleLength = int(fps); // This variable will be used to set how many frames will make up a single refresh cycle.
int currentFrCnt = 0; // This variable will be used to count alongside of frameCount to track when a refresh cycle should restart.

AngleScroller1 lineHue1, lineHue2;

float speed = 0.015;
float a;
//========================================================================================================================================================

void setup() {
  size(500, 500);
  colorMode(HSB, TWO_PI, 1.0, 1.0, 1.0);
  
  midWidth = (width / 2);
  midHeight = (height / 2);
  
  // clrX HSB color definitions.
  clr1 = color(radians(0), 100, 100, 100);
  clr2 = color(radians(20), 100, 100, 100);
  clr3 = color(radians(40), 100, 100, 100);
  clr4 = color(radians(60), 100, 100, 100);
  clr5 = color(radians(80), 100, 100, 100);
  clr6 = color(radians(100), 100, 100, 100);
  clr7 = color(radians(120), 100, 100, 100);
  clr8 = color(radians(140), 100, 100, 100);
  clr9 = color(radians(160), 100, 100, 100);
  clr10 = color(radians(180), 100, 100, 100);
  clr11 = color(radians(200), 100, 100, 100);
  clr12 = color(radians(220), 100, 100, 100);
  clr13 = color(radians(240), 100, 100, 100);
  clr14 = color(radians(260), 100, 100, 100);
  clr15 = color(radians(280), 100, 100, 100);
  clr16 = color(radians(300), 100, 100, 100);
  clr17 = color(radians(320), 100, 100, 100);
  clr18 = color(radians(340), 100, 100, 100);
  clr19 = color(radians(360), 100, 100, 100);
  white = color(radians(0),0,100,100);
  black = color(radians(0),0,0,100);
  gray = color(radians(0),0,50,100);
  clear = color(radians(0),100,100,0);
  
  lineHue1 = new AngleScroller1(black, 3, midWidth, midHeight, circleRadius, deg1, deg2, cycleLength, angleMult, false, true);
  lineHue2 = new AngleScroller1(black, 3, midWidth, midHeight, circleRadius, deg1, deg2, cycleLength, angleMult, false, false);
  // AngleScroller1 (color colorLine, int weightLine, float Xpos, float Ypos, float lengthLine, float firstAngle, float lastAngle, float lengthCycle, float multi, boolean modePercent, boolean animated)
}
//========================================================================================================================================================

void draw() {
  background(0,0,100,100); // White background.
  fill(0,0,0,100);
  text("a = " + a, 10, 10);
  text("currentFrCnt = " + currentFrCnt, 10, 20);
  text("lineHue1.getCycleLength() = " + lineHue1.getCycleLength(), 10, 30);
  text("lineHue1.getCurrentFrCnt() = " + lineHue1.getCurrentFrCnt(), 10, 40);
  text("angleMult = " + angleMult, 10, 50);
  
  text("lineHue1.getdAngle1() = " + lineHue1.getDNewAngle1(), 250, 10);
  text("lineHue1.getdAngle2() = " + lineHue1.getDNewAngle2(), 250, 20);
  text("lineHue1.getCurrentAngleR() = " + lineHue1.getCurrentAngleR(), 250, 30);
  text("lineHue1.getTargetAngleR() = " + lineHue1.getTargetAngleR(), 250, 40);
  text("lineHue1.getAngleIncrR() = " + lineHue1.getAngleIncrR(), 250, 50);
  text("lineHue1.getDeltaR() = " + lineHue1.getDeltaR(), 250, 60);
  
  text("lineHue1.getCurrentAngleD() = " + lineHue1.getCurrentAngleD(), 250, 80);
  text("lineHue1.getTargetAngleD() = " + lineHue1.getTargetAngleD(), 250, 90);
  text("lineHue1.getAngleIncrD() = " + lineHue1.getAngleIncrD(), 250, 100);
  text("lineHue1.getDeltaD() = " + lineHue1.getDeltaD(), 250, 110);
  text("lineHue1.getAngleRangeD() = " + lineHue1.getAngleRangeD(), 250, 120);
  
//  text("lineHue1.getPX() = " + lineHue1.getPX(), 250, 50);
//  text("lineHue1.getPY() = " + lineHue1.getPY(), 250, 60);
  
  noFill();
  stroke(radians(270),100,100,100);
  circle(midWidth, midHeight, circleRadius);
  point(midWidth, midHeight);
  
  drawQuadrants();
   
  float px = midWidth + cos(a) * circleRadius;
  float py = midHeight + sin(a) * circleRadius;

  stroke(radians(0),100,100,100);
  strokeWeight(3);
  line(midWidth,midHeight,px,py);
  a+=speed;
  
  // Increment currentFrCnt by 1 every time the frameCount has moved to the next iteration.
  if (currentFrCnt < frameCount) {
    currentFrCnt++;
  }
  
  // If currentFrCnt becomes equal to our refresh cycle's length, then we'll reset it to zero and execute our refresh events.
  if (currentFrCnt >= cycleLength) {
    currentFrCnt = 0;
//    lineHue1.update();
  }
  
  lineHue1.setMultiplier(angleMult); //<>//
  lineHue1.update();
  lineHue1.render();
  
  lineHue2.setMultiplier(angleMult);
  lineHue2.update();
  lineHue2.render();
}
//========================================================================================================================================================
float getAngle(float pX1,float pY1, float pX2,float pY2){
  return atan2(pY2 - pY1, pX2 - pX1)* 180/ PI;
}

void mousePressed() {
  // Left mouse button will set the angle from the centerpoint to the mouse cursor to lineHue1's dAngle1 variable.
  if (mouseButton == LEFT) {
    mX = mouseX;
    mY = mouseY;
    float mouseAngle = getAngle(midWidth, midHeight, mX, mY);
    lineHue1.setDNewAngle1(mouseAngle);
    lineHue2.setDNewAngle1(mouseAngle);
  }
  
  // Right mouse button will set the angle from the centerpoint to the mouse cursor to lineHue1's dAngle2 variable.
  else if (mouseButton == RIGHT) {
    mX = mouseX;
    mY = mouseY;
    float mouseAngle = getAngle(midWidth, midHeight, mX, mY);
    lineHue1.setDNewAngle2(mouseAngle);
    lineHue2.setDNewAngle2(mouseAngle);
  }
}

// This function will handle various keyboard inputs that the User can utilize to control various elements of this ScrollerTest sketch.
void keyPressed() {
  if (keyCode == UP) {
    bpm += 1;
  }
  
  else if (keyCode == DOWN) {
    bpm -= 1;
    
    if (bpm < 0) {
      bpm = 0;
    }
  }
  
  else if (keyCode == RIGHT) {
    angleMult += 0.0500;
    
    if (angleMult > 1.0) {
      angleMult = 1.0;
    }
  }
  
  else if (keyCode == LEFT) {
    angleMult -= 0.0500;
    
    if (angleMult < 0.0) {
      angleMult = 0.0;
    }
  }
}

// This function will draw quadrant dividing lines in the Display Area.
void drawQuadrants() {
  noFill();
  strokeWeight(1);
  stroke(radians(240),100,100,100);
  // 0°
  float px = width/2 + cos(0) * circleRadius;
  float py = height/2 + sin(0) * circleRadius;
  line(width/2,height/2,px,py);
  
  // 90°
  px = width/2 + cos(radians(90)) * circleRadius;
  py = height/2 + sin(radians(90)) * circleRadius;
  line(width/2,height/2,px,py);
  
  // 180°
  px = width/2 + cos(radians(180)) * circleRadius;
  py = height/2 + sin(radians(180)) * circleRadius;
  line(width/2,height/2,px,py);
  
  // 270°
  px = width/2 + cos(radians(270)) * circleRadius;
  py = height/2 + sin(radians(270)) * circleRadius;
  line(width/2,height/2,px,py);
  
  stroke(radians(170),100,100,100);
  // 15°
  px = width/2 + cos(radians(15)) * circleRadius;
  py = height/2 + sin(radians(15)) * circleRadius;
  line(width/2,height/2,px,py);
  
  // 30°
  px = width/2 + cos(radians(30)) * circleRadius;
  py = height/2 + sin(radians(30)) * circleRadius;
  line(width/2,height/2,px,py);
  
  stroke(radians(220),100,100,100);
  // 45°
  px = width/2 + cos(radians(45)) * circleRadius;
  py = height/2 + sin(radians(45)) * circleRadius;
  line(width/2,height/2,px,py);
  
  stroke(radians(170),100,100,100);
  // 60°
  px = width/2 + cos(radians(60)) * circleRadius;
  py = height/2 + sin(radians(60)) * circleRadius;
  line(width/2,height/2,px,py);
  
  // 75°
  px = width/2 + cos(radians(75)) * circleRadius;
  py = height/2 + sin(radians(75)) * circleRadius;
  line(width/2,height/2,px,py);
  
  stroke(radians(170),100,100,100);
  // 105°
  px = width/2 + cos(radians(105)) * circleRadius;
  py = height/2 + sin(radians(105)) * circleRadius;
  line(width/2,height/2,px,py);
  
  // 120°
  px = width/2 + cos(radians(120)) * circleRadius;
  py = height/2 + sin(radians(120)) * circleRadius;
  line(width/2,height/2,px,py);
  
  stroke(radians(220),100,100,100);
  // 135°
  px = width/2 + cos(radians(135)) * circleRadius;
  py = height/2 + sin(radians(135)) * circleRadius;
  line(width/2,height/2,px,py);
  
  stroke(radians(170),100,100,100);
  // 150°
  px = width/2 + cos(radians(150)) * circleRadius;
  py = height/2 + sin(radians(150)) * circleRadius;
  line(width/2,height/2,px,py);
  
  // 165°
  px = width/2 + cos(radians(165)) * circleRadius;
  py = height/2 + sin(radians(165)) * circleRadius;
  line(width/2,height/2,px,py);
  
    stroke(radians(170),100,100,100);
  // 195°
  px = width/2 + cos(radians(195)) * circleRadius;
  py = height/2 + sin(radians(195)) * circleRadius;
  line(width/2,height/2,px,py);
  
  // 210°
  px = width/2 + cos(radians(210)) * circleRadius;
  py = height/2 + sin(radians(210)) * circleRadius;
  line(width/2,height/2,px,py);
  
  stroke(radians(220),100,100,100);
  // 225°
  px = width/2 + cos(radians(225)) * circleRadius;
  py = height/2 + sin(radians(225)) * circleRadius;
  line(width/2,height/2,px,py);
  
  stroke(radians(170),100,100,100);
  // 240°
  px = width/2 + cos(radians(240)) * circleRadius;
  py = height/2 + sin(radians(240)) * circleRadius;
  line(width/2,height/2,px,py);
  
  // 255°
  px = width/2 + cos(radians(255)) * circleRadius;
  py = height/2 + sin(radians(255)) * circleRadius;
  line(width/2,height/2,px,py);
  
  stroke(radians(170),100,100,100);
  // 285°
  px = width/2 + cos(radians(285)) * circleRadius;
  py = height/2 + sin(radians(285)) * circleRadius;
  line(width/2,height/2,px,py);
  
  // 300°
  px = width/2 + cos(radians(300)) * circleRadius;
  py = height/2 + sin(radians(300)) * circleRadius;
  line(width/2,height/2,px,py);
  
  stroke(radians(220),100,100,100);
  // 315°
  px = width/2 + cos(radians(315)) * circleRadius;
  py = height/2 + sin(radians(315)) * circleRadius;
  line(width/2,height/2,px,py);
  
  stroke(radians(170),100,100,100);
  // 330°
  px = width/2 + cos(radians(330)) * circleRadius;
  py = height/2 + sin(radians(330)) * circleRadius;
  line(width/2,height/2,px,py);
  
  // 345°
  px = width/2 + cos(radians(345)) * circleRadius;
  py = height/2 + sin(radians(345)) * circleRadius;
  line(width/2,height/2,px,py);
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {
  // This function will create a gradient.
  noFill();
  strokeWeight(1);

  if (axis == 1) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == 2) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}
