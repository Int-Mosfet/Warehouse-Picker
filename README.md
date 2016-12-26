# Warehouse-Picker
An assembly program mimicking operation of a warehouse

This was a final project for a class. The project was very hard, I didn't finish all the features but I got a decent grade on it.  The board used was a senior design project at my school, so that's the only place where this code will run or make any sense. I will update this eventually to show some pictures of the board used.

Some of the requirements (not complete, it was a lot) include:
1) Making a stepper motor extend and retract (turning in 2 directions). Grade: 3/5
2) Making a DC motor move faster or slower based on the package size. Grade: 3/5
3) Make a password with a hex keypad.  Be able to set local and GMT time, be able to key in containers and some parameters about them (large or medium, fragile or not, heavy or light). Grade: 4/5
4) Use potentiometer as a manual override (when a separate pushbutton is pressed) to the stepper motor and DC motor. Grade: 0/5
5) Display relevant information on a 16X2 LCD. Grade: 4/5
6) Enter into a manual mode if a pushbutton is pressed, and take a timestamp of that press. Grade: 4/5
7) Enter a new container into memory with the flip of a dipswitch. Grade: 2/5
8) A speaker is used to sound beeps whenever keys are pressed, and to play a song during a fire, or when an item is taken or placed in the warehouse. Grade: 5/5
9) LED's are used to signify if a forklift is coming or going. Grade: 3/5
10) An "IRQ" button (with an interrupt service routine added in the interrupt vector table) which fires an interrupt if pressed, alerts staff of a fire in the warehouse. Grade: 5/5
11) Three extra features created on your own (back button, debounce routine for pushbutton, and potentiometer controls menu items). Grade: 7/5
12) Real time interrupt (RTI) controls timing of simulation (I also made a custom variation of the "Wait for Interrupt" (WAI) instruction which would waiting for the seconds variable to change). Grade: 5/5

Ended up getting a B on the project.  It was a massive time-suck throughout the semester and the most challenging project I've ever had at the time (I stayed in the lab most every night throughout the month we could work on it).  I was mostly done with a week to go, got it graded early and had a day to try and get up to an A but decided since I had a good enough grade (at least a C or B) and already had an A in the class that I would focus on studying for finals.  I was glad to push through it though, I learned assembly for the most part because of it.
