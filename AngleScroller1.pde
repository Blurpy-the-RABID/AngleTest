// delta = ((((T - C) + 540) % 360) - 180);
// T := Target angle
// C := Current angle
// This AngleScroller1 class will render a line in the Display Area that will alternate between two given angles (dCurrentAngle1 & dCurrentAngle2).  It can be
// animated to bounce between these two angles throughout the current cycle, or it can simply be set to snap between these two angles at the end of each cycle. 
// Whenever the User clicks in the Display Area, the angle from the mouse cursor to the centerpoint of the Display Area will be calculated and provided to the
// AngleScroller1 object as dNewAngle1 & dNewAngle2.  When the current cycle finishes, the values of dNewAngle1 & dNewAngle2 will be transferred to
// dCurrentAngle1 & dCurrentAngle2, and the correlating variables that calculate each incremental step between the two angles will be updated.
class AngleScroller1 {
  color lineColor;
  int lineWeight = 1;
  float posX, posY, pX, pY, lineLength; 
  float dCurrentAngle1, dNewAngle1, dCurrentAngle2, dNewAngle2, currentAngleD, targetAngleD, angleIncrD, angleRangeD, deltaD;
  float rCurrentAngle1, rNewAngle1, rCurrentAngle2, rNewAngle2, currentAngleR, targetAngleR, angleIncrR, angleRangeR, deltaR;
  // This variable will be used in converting the value of currentAngleD into a value between 0 and 360, as opposed to a value that goes from 0 to 180, and then
  // from -179.999 back to 0.
  float trueCurrentAngleD;
  float cycleLength;
  int currentFrCnt = 0;
  float multiplier = 1.0;
  boolean percentMode = false; // This variable dictates whether or not we multiply the dCurrentAngle1/2 variables by the multiplier variable.
  boolean advanceAng1to2 = true; // This variable dictates whether we're currently travelling from dCurrentAngle1 to dCurrentAngle2 (True), or vice-versa (False).
  boolean animateModeOn = true; // This variable will toggle On/Off whether or not the rendered line animates between  dNewAngle1 & dNewAngle2 during each cycle.
  
//--------------------------------------------------------------------------
// BEGIN Constructor Definition
//--------------------------------------------------------------------------
  AngleScroller1 (color colorLine, int weightLine, float Xpos, float Ypos, float lengthLine, float firstAngle, float lastAngle, float lengthCycle, float multi, boolean modePercent, boolean animated) {
    lineColor = colorLine;
    lineWeight = weightLine;
    currentAngleD = 0; // We always start currentAngleD at 0°.
    posX = Xpos;
    posY = Ypos;
    pX = posX + cos(currentAngleD) * circleRadius;
    pY = posY + sin(currentAngleD) * circleRadius;
    lineLength = lengthLine;
    cycleLength = lengthCycle;
    multiplier = multi;
    animateModeOn = animated;
    
    dNewAngle1 = firstAngle; // 10
    dNewAngle2 = lastAngle; // -90
    
    // Calculate which of the provided angles is larger, and assign values to the appropriate variables.
    int largerValue = getLargerValue(firstAngle, lastAngle);
    switch(largerValue) {
      // firstAngle is equal to lastAngle (ex. firstAngle = 10, lastAngle = 10)
      case 0:
        dNewAngle1 = firstAngle; // 10
        dNewAngle2 = lastAngle; // -90
        targetAngleD = dNewAngle2;
        break;
      // firstAngle is larger than lastAngle (ex. firstAngle = -90, lastAngle = 10)
      case 1:
        dNewAngle1 = firstAngle; // -90
        dNewAngle2 = lastAngle; // 10
        targetAngleD = dNewAngle1;
        break;
      // firstAngle is less than lastAngle (ex. firstAngle = 10, lastAngle = -90)
      case 2:
        dNewAngle1 = lastAngle; // 10
        dNewAngle2 = firstAngle; // -90
        targetAngleD = dNewAngle2;
        break;
    }
    
    // We start off our dCurrentAngle1/2 variables off at 0°.
    dCurrentAngle1 = 0;
    dCurrentAngle2 = 0;
    
    percentMode = modePercent;
    deltaD = ((((targetAngleD - currentAngleD) + 540) % 360) - 180);
    angleRangeD = abs(deltaD);
    angleIncrD =  ((deltaD / cycleLength) * multiplier);
    getTrueCurrentAngleD(); // Assigns a value to trueCurrentAngleD.
    
    // Radian conversion calculations
    rNewAngle1 = radians(dNewAngle1);
    rNewAngle2 = radians(dNewAngle2);
    currentAngleR = radians(currentAngleD);
    targetAngleR = radians(targetAngleD);
    angleIncrR = radians(angleIncrD);
    angleRangeR = radians(angleRangeD);
    deltaR = radians(deltaD);
    
    // Run recalcAngleParams() function to set all variables properly for the first cycle.
    recalcAngleParams();
  }
//--------------------------------------------------------------------------
// END OF Constructor Definition
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
// BEGIN Function Definitions
//--------------------------------------------------------------------------
  // This method will convert the current value of currentAngleD into a value between 0 and 360, and then return it.
  float getTrueCurrentAngleD() {
    if (currentAngleD < 0) {
      trueCurrentAngleD = ((180 + currentAngleD) + 180);
    }
    
    else if (currentAngleD >= 0) {
      trueCurrentAngleD = currentAngleD;
    }
    
    return trueCurrentAngleD;
  }
  
  // This function will recalculate all variables associated with determining what angleIncrD should be set to.
  // This function should be executed whenever the values of dNewAngle1 or dNewAngle2 are updated by the User.
  void recalcAngleParams() {
    // Update the values of dCurrentAngle1 & dCurrentAngle2 to reflect the most recently provided angle values from dNewAngle1 & dNewAngle2, respectively.
    dCurrentAngle1 = dNewAngle1;
    dCurrentAngle2 = dNewAngle2;
    
    // When advanceAng1to2 is set to True, we will advance from the currentAngleD towards (dNewAngle2 * multiplier).
    if (advanceAng1to2 == true) {
      targetAngleD = dCurrentAngle2;
      deltaD = ((((targetAngleD - currentAngleD) + 540) % 360) - 180);
      angleRangeD = abs(deltaD);
      angleIncrD =  ((deltaD / cycleLength) * multiplier);
    } //<>//
    
    // When advanceAng1to2 is set to False, we will change the value for targetAngleD, and then we'll advance from the currentAngleD towards the new targetAngleD.
    else if (advanceAng1to2 == false) {
      targetAngleD = dCurrentAngle1;
      deltaD = ((((targetAngleD - currentAngleD) + 540) % 360) - 180);
      angleRangeD = abs(deltaD);
      angleIncrD =  (deltaD / cycleLength);
    } //<>//
  }
  
  // This function updates all relevant variable values based on the current values for dNewAngle1 & dNewAngle2, and advances currentAngleD towards targetAngleD.
  void update() {
    if (animateModeOn == true) {
      // When advanceAng1to2 is set to True, we will advance from the currentAngleD towards (dNewAngle2 * multiplier).
      if (advanceAng1to2 == true) {
        currentAngleD += angleIncrD;
        currentFrCnt += 1; //<>//
        // If currentFrCnt becomes equal to the value of cycleLength, it's time to reverse directions.
        if (currentFrCnt >= cycleLength) { //<>//
          currentFrCnt = int(cycleLength);
          advanceAng1to2 = false;
          recalcAngleParams();
        }
      }
      
      // When advanceAng1to2 is set to False, we will change the value for targetAngleD, and then we'll advance from the currentAngleD towards the new targetAngleD.
      else if (advanceAng1to2 == false) {
        currentAngleD += angleIncrD;
        currentFrCnt -= 1;
        // If currentFrCnt reaches zero, then it's time to reverse direction again.
        if (currentFrCnt <= 0) {
          currentFrCnt = 0;
          advanceAng1to2 = true;
          recalcAngleParams();
        }
      }
    }
    
    // If animatedModeOn is set to False, then we don't want to animate the AngleScroller1 object; we simply want it to switch between dNewAngle1 & dNewAngle2 at the
    // end of each cycle.
    else if (animateModeOn == false) {
      if (advanceAng1to2 == true) {
        currentAngleD = dCurrentAngle1;
        currentFrCnt += 1;
        // If currentFrCnt becomes equal to the value of cycleLength, it's time to reverse directions.
        if (currentFrCnt >= cycleLength) {
          currentFrCnt = int(cycleLength);
          advanceAng1to2 = false;
          recalcAngleParams();
        }
      }
      
      else if (advanceAng1to2 == false) {
        currentAngleD = dCurrentAngle2;
        currentFrCnt -= 1;
        // If currentFrCnt becomes equal to the value of cycleLength, it's time to reverse directions.
        if (currentFrCnt <= 0) {
          currentFrCnt = 0;
          advanceAng1to2 = true;
          recalcAngleParams();
        }
      }
    }
  }
  
  // This method will return the smaller of the two provided angle values.
  float getSmallerAngle(float angle1, float angle2) {
    float smallerAngle = 0;
    int largerValue = getLargerValue(angle1, angle2);
    
    switch(largerValue) {
      // dNewAngle1 is equal to dNewAngle2 (ex. dNewAngle1 = 10, dNewAngle2 = 10)
      case 0:
        smallerAngle = angle2;
        break;
      // dNewAngle1 is larger than dNewAngle2 (ex. dNewAngle1 = 150, dNewAngle2 = 10)
      case 1:
        smallerAngle = angle2;
        break;
      // dNewAngle1 is less than dNewAngle2 (ex. dNewAngle1 = 10, dNewAngle2 = 150)
      case 2:
        smallerAngle = angle1;
        break;
    }
    
    return smallerAngle;
  }
  
  // This method will return the larger of the two provided angle values.
  float getLargerAngle(float angle1, float angle2) {
    float largerAngle = 0;
    int largerValue = getLargerValue(angle1, angle2);
    
    switch(largerValue) {
      // dNewAngle1 is equal to dNewAngle2 (ex. dNewAngle1 = 10, dNewAngle2 = 10)
      case 0:
        largerAngle = angle1;
        break;
      // dNewAngle1 is larger than dNewAngle2 (ex. dNewAngle1 = 150, dNewAngle2 = 10)
      case 1:
        largerAngle = angle1;
        break;
      // dNewAngle1 is less than dNewAngle2 (ex. dNewAngle1 = 10, dNewAngle2 = 150)
      case 2:
        largerAngle = angle2;
        break;
    }
    
    return largerAngle;
  }
  
  // This function will render a line at the current angle specified by currentAngleD (which gets converted to radians).
  void render() {
    currentAngleR = radians(currentAngleD);
    pX = posX + cos(currentAngleR) * lineLength;
    pY = posY + sin(currentAngleR) * lineLength;
    
    // Render line on Display Area.
    stroke(lineColor);
    strokeWeight(lineWeight);
    line(posX, posY, pX, pY);
    noStroke();
    strokeWeight(1);
  }
  
  // This method will take in two values and compare their absolute values to determine which is the larger of the two values.
  // If value1 is larger, this function returns 1.
  // If value2 is larger, this function returns 2.
  // If value1 and value2 are equal, this function returns 0.
  int getLargerValue(float value1, float value2) {
    if (abs(value1) > abs(value2)) {
      return 1;
    }
    
    else if (abs(value1) < abs(value2)) {
      return 2;
    }
    
    else {
      return 0;
    }
  }
  
  void setMultiplier(float newMult) {
    multiplier = newMult;
  }
  
  float getMultiplier() {
    return multiplier;
  }
  
  float getAngleRangeD() {
    return angleRangeD;
  }
  
  float getPX() {
    return pX;
  }
  
  float getPY() {
    return pY;
  }
  
  int getCurrentFrCnt() {
    return currentFrCnt;
  }
  
  float getCycleLength() {
    return cycleLength;
  }
  
  float getCurrentAngleD() {
    return currentAngleD;
  }
  
  float getTargetAngleD() {
    return targetAngleD;
  }
  
  float getAngleIncrD() {
    return angleIncrD;
  }
  
  float getDeltaD() {
    return deltaD;
  }
  
  float getCurrentAngleR() {
    return currentAngleR;
  }
  
  float getTargetAngleR() {
    return targetAngleR;
  }
  
  float getAngleIncrR() {
    return angleIncrR;
  }
  
  float getDeltaR() {
    return deltaR;
  }
  
  void setDNewAngle1(float newAngle) {
    dNewAngle1 = newAngle;
  }
  
  float getDNewAngle1() {
    return dNewAngle1;
  }
  
  void setDNewAngle2(float newAngle) {
    dNewAngle2 = newAngle;
  }
  
  float getDNewAngle2() {
    return dNewAngle2;
  }
//--------------------------------------------------------------------------
// END OF Function Definitions
//--------------------------------------------------------------------------
}
