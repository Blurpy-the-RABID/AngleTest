# AngleScroller1
This is a test environment to allow me to figure out a new ColorScroller algorithm for my LEDSoundBar project.

Objective:
==========
The purpose of this AngleScroller1 algorithm is to eventually replace the way I've been handling the ColorScroller classes in my LEDSoundBar project.  The previous ColorScroller classes have treated the HSB color spectrum as a linear graph.  The AngleScroller1 algorithm is my first step towards addressing color changes as they're meant to be handled - by changing the colors via angles on a Color Wheel.

What Does It Do:
================
The AngleScroller1 object simply renders a line every frame; this line will change its angle as it bounces back and forth between two provided angles.

How it Works:
=============
The AngleScroller1 object is given a number of parameters at the point of creation:
- a desired line color
- a desired line weight
- an X & Y coordinate point designated which to draw its line from
- a desired line length
- dAngle1
- dAngle2
- a cycle Length (counted in frames)
- a percentage multiplier (defaults to 1.0)

The AngleScroller1 object will analyze the provided angles (dAngle1 & dAngle2) to determine the delta (deltaD) between these angles.  It'll then take this delta value and divide it by the cycle length to determine how much it must alter the angle of the rendered line on each frame (stored in the angleIncrD variable).

The AngleScroller1 object also keeps an internal counter to track its progress as it bounces from one angle to the other.  Once the counter is equal to the provided cycle length, it reverses the direction of the line rendering and proceeds towards dAngle1.  All calculations for deltaD, angleIncrD, and so on are done every time that the line rendering reverses directions.

User Controls:
==============
The User can use the Left & Right Mouse buttons to select a new dAngle1 and dAngle2 value respectively by clicking anywhere within the Display Area of the Sketch.  The angle from where the mouse cursor is located and the centerpoint of the Display Area is calculated, and then passed on to the relevant angle variable within the AngleScroller1 object.

The User can also use the Left & Right Arrow keys on the keyboard to adjust the value of the percentage multiplier variable within the AngleScroller1 object.  It starts at 1.0 by default, and can be scrolled in increments of 0.05 between the values of 0.0 and 1.0.  As long as everything is working properly (see What Needs Fixing section below), the AngleScroller1 object will scroll between dAngle1 and (dAngle2 * multiplier).

What Needs Fixing:
==================
I'm currently trying to figure out a smoother algorithm for when the values for dAngle1 & dAngle2 are changed whilst the AngleScroller1 is in the middle of scrolling between the previously established angle values.  Depending on which quadrant the User clicks in as they assign new angle values via the mouse buttons, there can be some unwanted results where the rendered line doesn't bounce between the newly established angles.  If such an error occurs, the User can re-assign angle values in such a way that dAngle1 is a smaller angle than dAngle2; by doing this, the program seems to auto-correct itself.  I wish to eliminate this glitch in the mathwork, so I've still got my work cut out for me.

What I Plan To Use This For:
============================
Once I perfect this algorithm, I'm going to convert it into a new ColorScroller class for my LEDSoundBar project.  Specifically, I want to implement this algorithm to handle the way that the LEDSoundBar shifts the Hue value between the two provided HSB color values that are provided by the User.  

As mentioned earlier, my current algorithm treats the color spectrum like a linear percentage graph, with position 0 representing red and position 100 representing red again.  The graph goes from Red (0) to Orange, to Yellow, to Green, etc. until it loops back around at Red (100).  The User picks two colors between positions 0 and 100, and the ColorScroller will bounce between those two colors.  When audio is pumped into the Sketch, the ColorScroller will bounce from the first color up to a percentage-based distance towards the second color; this is what gives the ColorScroller its ability to dynamically alter itself based on the incoming audio and the provided BPM value.

The problem with this algorithm is that it's impossible to have the ColorScroller take the shortest path between two colors if they're on the extreme ends of this line graph.  For example, if the User sets the first color to Orange and the second color to Purple, the ColorScroller will change from Orange->Yellow->Green->Cyan->Blue->Purple before reversing direction.  The shortest color scrolling "path" between Orange and Purple would obviously be to scroll from Orange->Red->Purple before reversing direction.

By switching the model in which my ColorScroller is designed around (from a linear graph to angles on a color wheel), I should be able to calculate the shortest path between two provided color "angles" on the color wheel.  This would allow the ColorScroller to scroll from Orange to Purple by going Orange->Red->Purple->Red->Orange->etc.

This realization of the flaw in my ColorScroller logic has helped to enlighten me in thinking of color swapping in a more appropriate manner.  Sometimes one can get so stuck in thinking of solutions in a certain manner that one forgets to see how the rest of the world has already been addressing a particular subject.  I've been a graphic designer for most of my life, so I was kicking myself when I realized that I hadn't considered modeling my ColorScroller algorithm around the concept of the color wheel - an element of graphic design that I've been using this whole time.  D'oh!
