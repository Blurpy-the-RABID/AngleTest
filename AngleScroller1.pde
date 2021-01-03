// delta = ((((T - C) + 540) % 360) - 180);
// T := Target angle
// C := Current angle

class AngleScroller1 {
  color lineColor;
  int lineWeight = 1;
  float posX, posY, pX, pY, lineLength; 
  float dAngle1, dAngle2, currentAngleD, targetAngleD, angleIncrD, angleRangeD, deltaD;
  float rAngle1, rAngle2, currentAngleR, targetAngleR, angleIncrR, angleRangeR, deltaR;
  float cycleLength;
  int currentFrCnt = 0;
  float multiplier = 1.0;
  boolean percentMode = false;
  boolean advanceAng1to2 = true;
  
//--------------------------------------------------------------------------
// BEGIN Constructor Definition
//--------------------------------------------------------------------------
  AngleScroller1 (color colorLine, int weightLine, float Xpos, float Ypos, float lengthLine, float firstAngle, float lastAngle, float lengthCycle, float multi, boolean modePercent) {
    lineColor = colorLine;
    lineWeight = weightLine;
    posX = Xpos;
    posY = Ypos;
    pX = posX + cos(currentAngleD) * circleRadius;
    pY = posY + sin(currentAngleD) * circleRadius;
    lineLength = lengthLine;
    currentAngleD = 0; // We always start currentAngleD at 0°.
    cycleLength = lengthCycle;
    multiplier = multi;
    
    dAngle1 = firstAngle; // 10
    dAngle2 = lastAngle; // -90
    
    // Calculate which of the provided angles is larger, and assign values to the appropriate variables.
    int largerValue = getLargerValue(firstAngle, lastAngle);
    switch(largerValue) {
      // firstAngle is equal to lastAngle (ex. firstAngle = 10, lastAngle = 10)
      case 0:
        dAngle1 = firstAngle; // 10
        dAngle2 = lastAngle; // -90
        targetAngleD = (dAngle2 * multiplier);
        break;
      // firstAngle is larger than lastAngle (ex. firstAngle = -90, lastAngle = 10)
      case 1:
        dAngle1 = firstAngle; // -90
        dAngle2 = lastAngle; // 10
        targetAngleD = (dAngle1 * multiplier);
        break;
      // firstAngle is less than lastAngle (ex. firstAngle = 10, lastAngle = -90)
      case 2:
        dAngle1 = lastAngle; // 10
        dAngle2 = firstAngle; // -90
        targetAngleD = (dAngle2 * multiplier);
        break;
    }
    
    percentMode = modePercent;
    deltaD = ((((targetAngleD - currentAngleD) + 540) % 360) - 180); // -90
    angleRangeD = abs(deltaD); // 90
    angleIncrD =  (deltaD / cycleLength); // -1.60714...
//    angleIncrD =  (angleRangeD / cycleLength); // 2.67857...
    
    // Radian conversion calculations
    rAngle1 = radians(dAngle1);
    rAngle2 = radians(dAngle2);
    currentAngleR = radians(currentAngleD);
    targetAngleR = radians(targetAngleD);
    angleIncrR = radians(angleIncrD);
    angleRangeR = radians(angleRangeD);
    deltaR = radians(deltaD);
  }
//--------------------------------------------------------------------------
// END OF Constructor Definition
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
// BEGIN Function Definitions
//--------------------------------------------------------------------------
  // This function will recalculate all variables associated with determining what angleIncrD should be set to.
  // This function should be executed whenever the values of dAngle1 or dAngle2 are updated by the User.
  void recalcAngleParams() {
    // When advanceAng1to2 is set to True, we will advance from the currentAngleD towards (dAngle2 * multiplier).
    if (advanceAng1to2 == true) {
        targetAngleD = (dAngle2 * multiplier);
        deltaD = ((((targetAngleD - currentAngleD) + 540) % 360) - 180);
        angleRangeD = abs(deltaD);
        angleIncrD =  (angleRangeD / cycleLength);
      }
    
    // When advanceAng1to2 is set to False, we will change the value for targetAngleD, and then we'll advance from the currentAngleD towards the new targetAngleD.
    else if (advanceAng1to2 == false) {
      targetAngleD = dAngle1;
      deltaD = ((((targetAngleD - currentAngleD) + 540) % 360) - 180);
      angleRangeD = abs(deltaD);
      angleIncrD =  (angleRangeD / cycleLength);
    }
  } //<>//
  
  // This function updates all relevant variable values based on the current values for dAngle1 & dAngle2, and advances currentAngleD towards targetAngleD.
  void update() {
    // When advanceAng1to2 is set to True, we will advance from the currentAngleD towards (dAngle2 * multiplier).
    if (advanceAng1to2 == true) {
      currentAngleD += angleIncrD;
      currentFrCnt += 1; //<>//
      // If currentFrCnt becomes equal to the value of cycleLength, it's time to reverse directions.
      if (currentFrCnt >= cycleLength) {
        currentFrCnt = int(cycleLength);
        advanceAng1to2 = false;
        recalcAngleParams();
        
//        currentAngleD = targetAngleD; // Ensure that we always start at the right point before we reverse directions.
        //targetAngleD = dAngle1;
        //deltaD = ((((targetAngleD - currentAngleD) + 540) % 360) - 180);
        //angleRangeD = abs(deltaD);
        //angleIncrD =  (angleRangeD / cycleLength); //<>//
      }
    }
    
    // When advanceAng1to2 is set to False, we will change the value for targetAngleD, and then we'll advance from the currentAngleD towards the new targetAngleD.
    else if (advanceAng1to2 == false) {
      currentAngleD -= angleIncrD;
      currentFrCnt -= 1;
      // If currentFrCnt reaches zero, then it's time to reverse direction again.
      if (currentFrCnt <= 0) {
        currentFrCnt = 0;
        advanceAng1to2 = true;
        recalcAngleParams();
        
//        currentAngleD = targetAngleD; // Ensure that we always start at the right point before we reverse directions.
        //targetAngleD = (dAngle2 * multiplier);
        //deltaD = ((((targetAngleD - currentAngleD) + 540) % 360) - 180);
        //angleRangeD = abs(deltaD);
        //angleIncrD =  (angleRangeD / cycleLength);
      }
    }
  }
  
  // This method will return the smaller of the two provided angle values.
  float getSmallerAngle(float angle1, float angle2) {
    float smallerAngle = 0;
    int largerValue = getLargerValue(angle1, angle2);
    
    switch(largerValue) {
      // dAngle1 is equal to dAngle2 (ex. dAngle1 = 10, dAngle2 = 10)
      case 0:
        smallerAngle = angle2;
        break;
      // dAngle1 is larger than dAngle2 (ex. dAngle1 = 150, dAngle2 = 10)
      case 1:
        smallerAngle = angle2;
        break;
      // dAngle1 is less than dAngle2 (ex. dAngle1 = 10, dAngle2 = 150)
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
      // dAngle1 is equal to dAngle2 (ex. dAngle1 = 10, dAngle2 = 10)
      case 0:
        largerAngle = angle1;
        break;
      // dAngle1 is larger than dAngle2 (ex. dAngle1 = 150, dAngle2 = 10)
      case 1:
        largerAngle = angle1;
        break;
      // dAngle1 is less than dAngle2 (ex. dAngle1 = 10, dAngle2 = 150)
      case 2:
        largerAngle = angle2;
        break;
    }
    
    return largerAngle;
  }
  
  // This function will render a line at the current angle specified by currentAngleD (which gets converted to radians).
  void render() {
//    rAngle1 = radians(dAngle1);
//    rAngle2 = radians(dAngle2); 
    currentAngleR = radians(currentAngleD);
//    targetAngleR = radians(targetAngleD);
//    angleIncrR = radians(angleIncrD);
//    angleRangeR = radians(angleRangeD);
//    deltaR = radians(deltaD);
    
//    pX = posX + cos(deltaR) * lineLength;
//    pY = posY + sin(deltaR) * lineLength;
    pX = posX + cos(currentAngleR) * lineLength;
    pY = posY + sin(currentAngleR) * lineLength;
    
    stroke(lineColor);
    strokeWeight(lineWeight);
//    line(posX, posY, (posX+cos(currentAngleD) * lineLength), (posY-sin(currentAngleD) * circleRadius));
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
  
  void setdAngle1(float newAngle) {
    dAngle1 = newAngle;
    recalcAngleParams();
  }
  
  float getdAngle1() {
    return dAngle1;
  }
  
  void setdAngle2(float newAngle) {
    dAngle2 = newAngle;
    recalcAngleParams();
  }
  
  float getdAngle2() {
    return dAngle2;
  }
//--------------------------------------------------------------------------
// END OF Function Definitions
//--------------------------------------------------------------------------
}
