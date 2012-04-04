/*
Author: Krysten Thomas
Title: ParSim
Last Edit: March 23, 2012
*/

import controlP5.*;
import java.util.*;
import java.util.concurrent.*;

//Declare ControlP5 Object 
public ControlP5 controlP5;

//Declare ControlWindow Object 
public ControlWindow controlWindow;

//Declare Particle Object
public Particle particle1; 

//Declare CopyOnWriteArrayList Object for Points
public CopyOnWriteArrayList<Point> PointArray;

//Declare CopyOnWriteArrayList Object for Rectangles
public CopyOnWriteArrayList<Rect> RectArray;

//Declare Graphical Components
public Textlabel topLabel;
public Textfield angleField;
public Textfield velField; 
public Textfield distanceField;
public Textfield heightField;
public Textfield coefXField;
public Textfield coefYField;
public Textfield accXField;
public Textfield accYField;
public Textlabel colorLabel;
public Textlabel obsLabel;
public RadioButton r;
public RadioButton obs;
public controlP5.Button start;
public controlP5.Button stop;
public controlP5.Button erase;
public controlP5.Button resume;
public Textlabel timeLabel;
public Textfield timeField;
public controlP5.Button generate;
public Textlabel sampleLabel;
public Textlabel collideLabel;
public Textlabel leftBoundary;
public Textlabel rightBoundary;
public Textlabel bottomBoundary;
public Textlabel topBoundary;
public RadioButton lB;
public RadioButton rB;
public RadioButton bB;
public RadioButton tB;
public Textlabel gridLabel;
public Textlabel tnLabel;
public Textfield tNfield;
public Textlabel pathLabel;
public Textlabel velPath;
public CheckBox checkbox;
public CheckBox checkboxVX;
public CheckBox checkboxVY;
public CheckBox checkboxTotV;
public CheckBox vxBox;
public CheckBox vyBox;
public CheckBox totVBox;
public Textlabel vxLabel;
public Textlabel vyLabel;
public Textlabel totVLabel;
public controlP5.Button AddObstacle;
public controlP5.Button DeleteObstacle;
public Textlabel obstacleLabel;
public Textfield obstacleX;
public Textfield obstacleY;
public Textfield obstacleWidth;
public Textfield obstacleHeight;
public Textfield timefield;

//This boolean variable will keep track of
//whether the path should be shown
public boolean path = false;

//The following boolean variables will determine if a velocity component
//path will be shown
public boolean vxpath = false;
public boolean vypath = false;
public boolean totvpath = false; 

//Variables needed for motion of particle
//Values are stored as floats to maintain precision
//All of these values can be specified by the user
public color c;
public float xpos;
public float ypos;
public float vel;
public float xspeed;
public float yspeed;
public float new_ypos;
public float xacc;
public float yacc;
public float angle;
public float time;
public float dTime;
public float epX;
public float epY;
public int tN; 
public int plotColor = color(0, 0, 0);
public int obsColor = color(0, 0, 0);
public int white = color(255, 255, 255, 255);
public int black = color(0, 0, 0);
public int orange = color(224, 90, 7);

//This variable determines wheter or not to erase the drawing area
public boolean flag = false;

//Variable that determines which color to choose from radio box
public float rbValue = 0;
public int int_rbValue = 0;

//Time Counter  
public int t1 = 0;

//Stores the particle's old position 
public float oldXpos;
public float oldYpos;

//Stores the particle's old velocity
public float oldXspeed;
public float oldYspeed;

//These boolean variables keep track which collisional conditions are on or off
public boolean lrep = false;
public boolean lref = false;
public boolean lnon = false;
public boolean rrep = false;
public boolean rref = false;
public boolean rnon = false;
public boolean trep = false;
public boolean tref = false;
public boolean tnon = false;
public boolean brep = false;
public boolean bref = false;
public boolean bnon = false;

//This will allow output to get printed to a text file
public PrintWriter output;

public int n_path;
public int n1_path;
public int n2_path;
public int n3_path;

//Control variables for adding and deleting obstacles
public boolean addObstacle = false;
public boolean deleteObstacle = false;

//The following variables for the obstacle
public int obsX = 0;
public int obsY = 0;
public int obsWidth = 0;
public int obsHeight = 0;

//Used to capture x and y coordinates of mouse
public int mx = 0;
public int my = 0;

//Control variables for selecting and deselecting obstacles
public boolean highlightRect = false;
public boolean unhighlightRect = false;

//Used for redrawing selected and unselected obstacles
public int d_x;
public int d_y;
public int d_width;
public int d_height;

//Stores the last point drawn to the screen
public Point lastPoint;

//Controls redrawing of velocity lines
public boolean eraseVlines = false;

public float dy = 0;

public float startingX = 0;
public float startingY = 0;
boolean starting = false;

public float vinitial = 0;
public float gravity = 0;
public float timeclock = 0;

void setup() 
{
  //Size of Window size(width, height)
  size(800, 600); //900, 700
  //Background Color
  background(255);
  //All geometric shapes with smooth rendering
  smooth();
  //All geometric shapes with round edges
  strokeCap(ROUND);
  //All geometric shapes with 3.5 stroke weight unless specified otherwise
  strokeWeight(3.5);
  smooth();
  
  //Initialize ControlP5 Object with this instance
  controlP5 = new ControlP5(this);
  //Configure control window
  controlP5.setAutoDraw(false);
  //Window will be 400x600
  controlWindow = controlP5.addControlWindow("Control Panel  ", 100, 100, 350, 600);
  controlWindow.hideCoordinates(); 
  
  //The following code will configure the three different tabs
  
  controlWindow.tab("default").activateEvent(true);
  controlWindow.tab("default").setLabel("Home");
  controlWindow.tab("default").setId(1);
  
  controlWindow.tab("Obstacle Configuration").activateEvent(true);
  controlWindow.tab("Obstacle Configuration").setId(2);
  
  controlWindow.tab("Particle Cosmetics").activateEvent(true);
  controlWindow.tab("Particle Cosmetics").setId(3);

  //Configure graphical components
  topLabel = controlP5.addTextlabel ("label","Enter intitial conditions in the fields below:",20,25);
  topLabel.setColorValue(0xffcccccc);
  topLabel.setWindow(controlWindow);
  
  angleField = controlP5.addTextfield("Angle (Degrees)", 20, 38, 100, 20);
  angleField.setWindow(controlWindow);
  
  velField = controlP5.addTextfield("Velocity (m/s)", 168, 38, 100, 20);
  velField.setWindow(controlWindow);
  
  distanceField = controlP5.addTextfield("X Pos. (m)", 20, 88, 100, 20);
  distanceField.setWindow(controlWindow);
  
  heightField = controlP5.addTextfield("Y Pos. (m)", 168, 88, 100, 20);
  heightField.setWindow(controlWindow);
  
  coefXField = controlP5.addTextfield("Horizontal Elasticity", 20, 138, 100, 20);
  coefXField.setWindow(controlWindow);
  
  coefYField = controlP5.addTextfield("Vertical Elasticity", 168, 138, 100, 20);
  coefYField.setWindow(controlWindow);
  
  accXField = controlP5.addTextfield("Horizontal Acc. m/s^2", 20, 188, 100, 20);
  accXField.setWindow(controlWindow);
  
  accYField = controlP5.addTextfield("Vertical Acc. m/s^2", 168, 188, 100, 20);
  accYField.setWindow(controlWindow);
  
  colorLabel = controlP5.addTextlabel("label1", "Select particle color: ", 20, 25);
  colorLabel.setWindow(controlWindow);
  colorLabel.setTab("Particle Cosmetics");
  
  obsLabel = controlP5.addTextlabel("label11", "Select obstacle color: ", 20, 250);
  obsLabel.setWindow(controlWindow);
  obsLabel.setTab("Obstacle Configuration");
  
  start = controlP5.addButton("Start", 0, 20, 248, 49, 20);
  start.setWindow(controlWindow);
  
  stop = controlP5.addButton("Stop", 2, 90, 248, 49, 20);
  stop.setWindow(controlWindow);
  
  generate = controlP5.addButton("Generate", 4, 90, 288, 49, 20);
  generate.setWindow(controlWindow);
  
  erase = controlP5.addButton("Erase", 6, 20, 288, 49, 20); 
  erase.setWindow(controlWindow);
  
  resume = controlP5.addButton("Resume", 8, 160, 248, 49, 20);
  resume.setWindow(controlWindow);
  
  r = controlP5.addRadioButton("cRB", 20, 40);
  r.setItemsPerRow(4);
  r.setSpacingColumn(50);
  r.addItem("Black", 0.0);
  r.addItem("Red", 1.0);
  r.addItem("Blue", 2.0);
  r.addItem("Green", 3.0);
  r.moveTo(controlWindow);
  r.setTab("Particle Cosmetics");
  
  obs = controlP5.addRadioButton("obsRB", 20, 270);
  obs.setItemsPerRow(4);
  obs.setSpacingColumn(50);
  obs.addItem("-Black", 5.0);
  obs.addItem("-Red", 6.0);
  obs.addItem("-Blue", 7.0);
  obs.addItem("-Green", 8.0);
  obs.moveTo(controlWindow);
  obs.setTab("Obstacle Configuration");
  
  leftBoundary = controlP5.addTextlabel("label3", "Select the type of boundary condition for Left Boundary:", 20, 25);
  leftBoundary.setColorValue(0xffcccccc);
  leftBoundary.setWindow(controlWindow);
  leftBoundary.setTab("Obstacle Configuration");
  
  lB = controlP5.addRadioButton("leftB", 20, 40);
  lB.setItemsPerRow(3);
  lB.setSpacingColumn(94);
  lB.addItem("Repeating(L)", 0.0);
  lB.addItem("Reflecting(L)", 1.0);
  lB.addItem("None(L)", 2.0);
  lB.moveTo(controlWindow);
  lB.setTab("Obstacle Configuration");
  
  rightBoundary = controlP5.addTextlabel("label4", "Select the type of boundary condition for Right Boundary:", 20, 60);
  rightBoundary.setColorValue(0xffcccccc);
  rightBoundary.setWindow(controlWindow);
  rightBoundary.setTab("Obstacle Configuration");
  
  rB = controlP5.addRadioButton("rightB", 20, 80);
  rB.setItemsPerRow(3);
  rB.setSpacingColumn(94);
  rB.addItem("Repeating(R)", 0.0);
  rB.addItem("Reflecting(R)", 1.0);
  rB.addItem("None(R)", 2.0);
  rB.moveTo(controlWindow);
  rB.setTab("Obstacle Configuration");
  
  topBoundary = controlP5.addTextlabel("label5", "Select the type of boundary condition for Top Boundary:", 20, 100);
  topBoundary.setColorValue(0xffcccccc);
  topBoundary.setWindow(controlWindow);
  topBoundary.setTab("Obstacle Configuration");
  
  tB = controlP5.addRadioButton("topB", 20, 120);
  tB.setItemsPerRow(3);
  tB.setSpacingColumn(94);
  tB.addItem("Repeating(T)", 0.0);
  tB.addItem("Reflecting(T)", 1.0);
  tB.addItem("None(T)", 2.0);
  tB.moveTo(controlWindow);
  tB.setTab("Obstacle Configuration");
  
  bottomBoundary = controlP5.addTextlabel("label6", "Select the type of boundary condition for Bottom Boundary:", 20, 140);
  bottomBoundary.setColorValue(0xffcccccc);
  bottomBoundary.setWindow(controlWindow);
  bottomBoundary.setTab("Obstacle Configuration");
  
  bB = controlP5.addRadioButton("bottomB", 20, 160);
  bB.setItemsPerRow(3);
  bB.setSpacingColumn(94);
  bB.addItem("Repeating(B)", 0.0);
  bB.addItem("Reflecting(B)", 1.0);
  bB.addItem("None(B)", 2.0);
  bB.moveTo(controlWindow);
  bB.setTab("Obstacle Configuration");
  
  pathLabel = controlP5.addTextlabel("label7", "Click the checkbox to turn on/off particle path :", 20, 80);
  pathLabel.setColorValue(0xffcccccc);
  pathLabel.setWindow(controlWindow);
  pathLabel.setTab("Particle Cosmetics");
  
  checkbox = controlP5.addCheckBox("checkBox", 244 , 80);
  checkbox.addItem(" ", 0);
  checkbox.moveTo(controlWindow);
  checkbox.setTab("Particle Cosmetics");
  checkbox.activateAll();
  
  tnLabel = controlP5.addTextlabel("label8", "How often to draw a point to the screen:", 20, 60);
  tnLabel.setColorValue(0xffcccccc);
  tnLabel.setWindow(controlWindow);
  tnLabel.setTab("Particle Cosmetics");
  
  tNfield = controlP5.addTextfield("", 230, 58, 50, 12);
  tNfield.setWindow(controlWindow);
  tNfield.setText("1");
  tNfield.setTab("Particle Cosmetics");
  
  velPath = controlP5.addTextlabel("label9", "Click the checkbox to turn on/off each velocity vector:", 20, 100);
  velPath.setColorValue(0xffcccccc);
  velPath.setWindow(controlWindow);
  velPath.setTab("Particle Cosmetics");
  
  checkboxVX = controlP5.addCheckBox("checkBox1", 20 , 120);
  checkboxVX.addItem("vx", 0);
  checkboxVX.moveTo(controlWindow);
  checkboxVX.setTab("Particle Cosmetics");
  
  checkboxVY = controlP5.addCheckBox("checkBox2", 70 , 120);
  checkboxVY.addItem("vy", 0);
  checkboxVY.moveTo(controlWindow);
  checkboxVY.setTab("Particle Cosmetics");
  
  checkboxTotV = controlP5.addCheckBox("checkBox3", 120 , 120);
  checkboxTotV.addItem("Total Vel", 0);
  checkboxTotV.moveTo(controlWindow);
  checkboxTotV.setTab("Particle Cosmetics");
  
  obstacleLabel = controlP5.addTextlabel("label10", "Enter the obstacle's width, height, x position, and y position:", 20, 190); 
  obstacleLabel.setColorValue(0xffcccccc);
  obstacleLabel.setWindow(controlWindow);
  obstacleLabel.setTab("Obstacle Configuration");
  
  obstacleX = controlP5.addTextfield("xpos", 20, 205, 50, 18);
  obstacleX.setWindow(controlWindow);
  obstacleX.setTab("Obstacle Configuration");
  
  obstacleY = controlP5.addTextfield("ypos", 90, 205, 50, 18);
  obstacleY.setWindow(controlWindow);
  obstacleY.setTab("Obstacle Configuration");
  
  obstacleWidth = controlP5.addTextfield("width", 160, 205, 50, 18);
  obstacleWidth.setWindow(controlWindow);
  obstacleWidth.setTab("Obstacle Configuration");
  
  obstacleHeight = controlP5.addTextfield("height", 230, 205, 50, 18);
  obstacleHeight.setWindow(controlWindow);
  obstacleHeight.setTab("Obstacle Configuration");
  
  AddObstacle = controlP5.addButton("Add_Obstacle", 10, 20, 330, 89, 20);
  AddObstacle.setWindow(controlWindow);
  AddObstacle.setTab("Obstacle Configuration");
  
  DeleteObstacle = controlP5.addButton("Delete_Obstacle", 12, 150, 330, 89, 20);
  DeleteObstacle.setWindow(controlWindow);
  DeleteObstacle.setTab("Obstacle Configuration");
  
  timefield = controlP5.addTextfield("Elapsed Time (s)", 20, 328, 100, 20);
  timefield.setWindow(controlWindow);
  
  //Initialize Particle Object
  particle1 = new Particle(); 
  
  //Initialize CopyOnWriteArrayList Object
  PointArray = new CopyOnWriteArrayList<Point>();

  //Initialize CopyOnWriteArrayList Object
  RectArray = new CopyOnWriteArrayList<Rect>();
  
  //Create Writer Object
  //output = createWriter("position.txt"); 
  
  //In the text file that is generated, the first row will display "x speed" and "y speed"
  //output.print("xpos \t ypos");
  //output.println();
  
  //This method call will generate the grid to be displayed. 
  //The only other time this method is called is on an Erase routine
  showGraph();
  
  //Initally, the program will not make any calls to the draw() method.
  //When the user clicks Start, then will the program begin automatically calling the draw method 60 frames per second (by default)
  noLoop();
    
} //End of Setup

//This method handles the various controller events
public void controlEvent(ControlEvent theEvent)
{ 
  //If a controller is registered...
  if(theEvent.isGroup())
  {
    //If the color radio box is registered...
    if(theEvent.group().name() == "cRB") 
    {
      //Store the color that was chosen
      int_rbValue = int(theEvent.group().value());
      
      //And decide which color to store in the color object plotColor
      switch(int_rbValue)
      {
        case(0): plotColor = color(0, 0, 0); break;
        case(1): plotColor = color(188, 17, 17); break;
        case(2): plotColor = color(17, 44, 188); break;
        case(3): plotColor = color(12, 155, 54); break;
      }
    }
    
     //If the color radio box is registered...
    if(theEvent.group().name() == "obsRB") 
    {
      //Store the color that was chosen
      int_rbValue = int(theEvent.group().value());
      
      //And decide which color to store in the color object plotColor
      switch(int_rbValue)
      {
        case(5): obsColor = color(0, 0, 0); break;
        case(6): obsColor = color(91, 0, 5); break;
        case(7): obsColor = color(0, 0, 61); break;
        case(8): obsColor = color(19, 73, 56); break;
      }
    }
    
    //The following blocks of if statements handles collision condition configuration
    //Each boundary has its own set of possible conditions
    //Once one is registered for each boundary, the corresponding collision condition is turned on, 
    //and the other possible choices are turned off to ensure that there is no conflict between the various conditions
    if(theEvent.group().name() == "leftB")
    {
      if(theEvent.group().value() == 0.0)
      {
        lrep = true;
        lref = false;
        lnon = false;
      }
      if(theEvent.group().value() == 1.0)
      {
        lref = true;
        lrep = false;
        lnon = false;
      }
      if(theEvent.group().value() == 2.0)
      {
        lnon = true;
        lrep = false;
        lref = false;
      }
    }
    
    if(theEvent.group().name() == "rightB")
    {
      if(theEvent.group().value() == 0.0)
      {
        rrep = true;
        rref = false;
        rnon = false;
      }
      if(theEvent.group().value() == 1.0)
      {
        rref = true;
        rrep = false;
        rnon = false;
      }
      if(theEvent.group().value() == 2.0)
      {
        rnon = true;
        rrep = false;
        rref = false;
      }
    }
    
    if(theEvent.group().name() == "topB")
    {
      if(theEvent.group().value() == 0.0)
      {
        trep = true;
        tref = false;
        tnon = false;
      }
      if(theEvent.group().value() == 1.0)
      {
        tref = true;
        trep = false;
        tnon = false;
      }
      if(theEvent.group().value() == 2.0)
      {
        tnon = true;
        tref = false;
        trep = false;
      }
    }
    
    if(theEvent.group().name() == "bottomB")
    {
      if(theEvent.group().value() == 0.0)
      {
        brep = true;
        bref = false;
        bnon = false;
      }
      if(theEvent.group().value() == 1.0)
      {
        bref = true;
        brep = false;
        bnon = false;
      }
      if(theEvent.group().value() == 2.0)
      {
        bnon = true;
        bref = false;
        brep = false;
      }
    }
    
    if(theEvent.group().name() == "checkBox")
    {
      for(int i=0;i<theEvent.group().arrayValue().length;i++) 
     {
       n_path = (int)theEvent.group().arrayValue()[i];
       if(n_path==1) //n_path ==1
       {
         path = true; //true
       }
      
       else
       {
         path = false; //false
       }
      }
    }
    
    if(theEvent.group().name() == "checkBox1")
    {
      for(int i=0;i<theEvent.group().arrayValue().length;i++) 
     {
       n1_path = (int)theEvent.group().arrayValue()[i];
       if(n1_path==1) 
       {
         vxpath = true;
       }
      
       else
       {
         vxpath = false;
       }
      }
    }
    
    if(theEvent.group().name() == "checkBox2")
    {
      for(int i=0;i<theEvent.group().arrayValue().length;i++) 
     {
       n2_path = (int)theEvent.group().arrayValue()[i];
       if(n2_path==1) 
       {
         vypath = true;
       }
      
       else
       {
         vypath = false;
       }
      }
    }
    
    if(theEvent.group().name() == "checkBox3")
    {
      for(int i=0;i<theEvent.group().arrayValue().length;i++) 
     {
       n3_path = (int)theEvent.group().arrayValue()[i];
       if(n3_path==1) 
       {
         totvpath = true; 
       }
      
       else
       {
         totvpath = false; 
       }
      }
    }
  }
} //End of ControlEvent
  
//This method is automatically called when the Start button is pressed
public void Start(int v1)
{  
  //When the Start button is pressed, 
  //the values in the text fields are gathered and stored in their respective variables 
  angle = float(angleField.getText());
  vel = float(velField.getText());
  xpos = float(distanceField.getText());
  ypos = float(heightField.getText());
  epX = float(coefXField.getText());
  epY = float(coefYField.getText());
  xacc = float(accXField.getText());
  yacc = float(accYField.getText());
  tN = int(tNfield.getText());
  
  vinitial = vel;
  gravity = yacc;
  
  //a new ypos variable will be used to account for the new coordinate system
  //because (0,0) is in the top left corner of the windows
  new_ypos = height - ypos;

  ///x speed and y speed are calculated
  xspeed = vel*cos(radians(angle));  // +
  yspeed = -vel*sin(radians(angle)); // -

  //time and deltaTime are initialized
  time = 0;
  dTime = .1;
  
  //Flag equals false, this means that when calls are made to the draw method, the program knows not to perform any erases
  flag = false;
  
  eraseVlines = false;
     
  drawObstacle();
  
  //This call means that the program can now start calling the draw method 60 frame rates per second
  loop();
  
} //End of Start

//This method is called when the Stop button is pressed
public void Stop(int v2)
{
  //When the stop button is pressed, the output text file is closed successfully and the data is saved in the text file
  //output.flush(); // Writes the remaining data to the file
  //output.close(); // Finishes the file
  
  //This call will end all automatic calls to the draw method
  noLoop();
} //End of Stop

//This method is called when the Erase button is pressed
public void Erase(int v3)
{   
  //flag = true, so when the draw method is called only once, it knows to erase all drawing and re-display the grid
  flag = true;
  
  redraw();
    
  //This call to the reset method will re initialize all user specified variables to 0
  reset();
  
  //The current value in each text field in the GUI is cleared
  /*
  angleField.setText(" ");
  velField.setText(" ");
  distanceField.setText(" ");
  heightField.setText(" ");
  coefXField.setText(" ");
  coefYField.setText(" ");
  accXField.setText(" ");
  accYField.setText(" ");
  */
  
  timefield.setText("");
  
  //Removes all points in collection
  PointArray.clear();
  
  eraseVlines = true;
} //End of Erase

//This method is called when the Generate button is pressed
public void Generate(int v4)
{
  //When pressed, this button will enter in each text field predefined values so
  //the user won't have to manually enter in values into the text fields each time
  angleField.setText("30");
  velField.setText("50");
  distanceField.setText("0");
  heightField.setText("0");
  coefXField.setText(".8");
  coefYField.setText(".9");
  accXField.setText("0");
  accYField.setText("-9.8");
  //obstacleX.setText("200");
  //obstacleY.setText("400");
  //obstacleWidth.setText("400");
  //obstacleHeight.setText("400");
} //End of Generate

//This method is called when the Resume button is pressed
public void Resume(int v6)
{
  //This will start program execution
  loop();
} //End of Resume

//This method will draw the user defined obstacle to the plot area
public void Add_Obstacle(int v7)
{  
  //Retrieve obtacle specifications
  obsX = int(obstacleX.getText());
  obsY = int(obstacleY.getText());
  obsWidth = int(obstacleWidth.getText());
  obsHeight = int(obstacleHeight.getText());
  
  //Convert y coordinte to cartesian coordinate system
  obsY = height - obsY;
  
  //Add the newly generated point to the array
  RectArray.add(new Rect(obsX, obsY, obsWidth, obsHeight, 0)); 
  
  //This variable will tell the draw method that an obstacle needs to be generated
  addObstacle = true;
  
  //Make sure this is false
  deleteObstacle = false;
  
  //Makes one call to the draw method, which will draw the obstacle to the screen
  redraw();
} //End of Add_Obstacle

public void Delete_Obstacle(int v8)
{ 
  //Just to make sure
  addObstacle = false;
  
  //So when redraw() is called, the draw method knows to execute the right block of code
  deleteObstacle = true;
    
  //Delete all obstacles which have been selected
  for(Iterator<Rect> it = RectArray.iterator(); it.hasNext();)
  {
     Rect ra = it.next();
     
     //If this class variable equals 1 then the obstacle was selected
     if(ra.e == 1)
     {
       RectArray.remove(ra);
     }
  }
  
  redraw();
} //End of Delete_Obstacle
  
//Unless specified, this method is called continually until the program is stopped
void draw() 
{  
  //If flag = true; that means an erase needs to happen
  //the background will be set to white and the coordinate grid will be re-displayed 
  if(flag)
   {
     fill(255);
     background(255);
     showGraph();
     
     drawObstacle();
     
     //Reset this variable so that the next call to this method will allow other else blocks to execute
     flag = false;
     
     //System.out.println("1");
   }
   
   //Whenever addObstacle is true, an obstacle will get generated
   else if(addObstacle)
   {          
     //Redraw the rectangles that weren't deleted back to the screen
     drawObstacle();
     
     //The plot color is also specified for the stroke and fill methods
     stroke(plotColor); fill(plotColor);
     
     //Line thickness = 4
     strokeWeight(4);
     
     //We have to reedraw the lines since they were erased 
     for(Iterator<Point> it = PointArray.iterator(); it.hasNext();)
     {
          Point pa = it.next();
          drawPoint(pa);
     }
             
     //Redraw velocity lines
     if(!eraseVlines)
     {
       //The plot color for the velocity lines
       stroke(orange); fill(orange);
        
       //this will display the velocity path in the x direction if the user clicks the check box
       if(vxpath == true)
       {
         line(oldXpos, oldYpos, oldXpos + oldXspeed*2, oldYpos); //Draws the velocity in the x direction
         text("VX", oldXpos + oldXspeed*2, oldYpos); 
       }
          
       //this will display the velocity path in the y direction if the user clicks the check box
       if(vypath == true)
       {
          line(oldXpos, oldYpos, oldXpos, oldYpos + oldYspeed*2); //Draws the velocity in the y direction
          text("VY", oldXpos, oldYpos + oldYspeed*2);   
       }
          
       //this will display the total velocity path if the user clicks the check box
       if(totvpath == true)
       {
         line(oldXpos, oldYpos, oldXpos + oldXspeed*2, oldYpos + oldYspeed*2); //Draws the total velocity
         text("Total Vel", oldXpos + oldXspeed*2, oldYpos + oldYspeed*2);
       }
     }
     
     //Reset this variable so that the next call to this method will allow other else blocks to execute
     addObstacle = false;
     
     //System.out.println("3");
   }
   
   else if(deleteObstacle)
   {           
     fill(255);
     background(255);
     showGraph();
     
     //Redraw the rectangles that weren't deleted back to the screen
     drawObstacle();
    
     //The plot color is also specified for the stroke and fill methods
     stroke(plotColor); fill(plotColor);
     
     //Line thickness = 4
     strokeWeight(4);
     
     //We have to reedraw the lines since they were erased 
     for(Iterator<Point> it = PointArray.iterator(); it.hasNext();)
     {
          Point pa = it.next();
          drawPoint(pa);
     }
     
     //Redraw velocity lines
     if(!eraseVlines)
     {
       //The plot color for the velocity lines
       stroke(orange); fill(orange);
        
       //this will display the velocity path in the x direction if the user clicks the check box
       if(vxpath == true)
       {
         line(oldXpos, oldYpos, oldXpos + oldXspeed*2, oldYpos); //Draws the velocity in the x direction
         text("VX", oldXpos + oldXspeed*2, oldYpos); 
       }
          
       //this will display the velocity path in the y direction if the user clicks the check box
       if(vypath == true)
       {
          line(oldXpos, oldYpos, oldXpos, oldYpos + oldYspeed*2); //Draws the velocity in the y direction
          text("VY", oldXpos, oldYpos + oldYspeed*2);   
       }
          
       //this will display the total velocity path if the user clicks the check box
       if(totvpath == true)
       {
         line(oldXpos, oldYpos, oldXpos + oldXspeed*2, oldYpos + oldYspeed*2); //Draws the total velocity
         text("Total Vel", oldXpos + oldXspeed*2, oldYpos + oldYspeed*2);
       }
     }

     //Reset this variable so that the next call to this method will allow other else blocks to execute
     deleteObstacle = false;
     
     //System.out.println("4");
   }
  
   //This will highlight the obstacle selected
   else if(highlightRect)
   {          
     strokeWeight(4);
     fill(obsColor);
     stroke(orange);
     rect(d_x, d_y, d_width, d_height);
     
     highlightRect = false;
     unhighlightRect = false;
     
     //The plot color is also specified for the stroke and fill methods
     stroke(plotColor); fill(plotColor);
     
     //Line thickness = 4
     strokeWeight(4);
     
     //We have to reedraw the lines since they were erased 
     for(Iterator<Point> it = PointArray.iterator(); it.hasNext();)
     {
          Point pa = it.next();
          drawPoint(pa);
     }
      
     //Redraw velocity lines       
     if(!eraseVlines)
     {
       //The plot color for the velocity lines
       stroke(orange); fill(orange);
        
       //this will display the velocity path in the x direction if the user clicks the check box
       if(vxpath == true)
       {
         line(oldXpos, oldYpos, oldXpos + oldXspeed*2, oldYpos); //Draws the velocity in the x direction
         text("VX", oldXpos + oldXspeed*2, oldYpos); 
       }
          
       //this will display the velocity path in the y direction if the user clicks the check box
       if(vypath == true)
       {
          line(oldXpos, oldYpos, oldXpos, oldYpos + oldYspeed*2); //Draws the velocity in the y direction
          text("VY", oldXpos, oldYpos + oldYspeed*2);   
       }
          
       //this will display the total velocity path if the user clicks the check box
       if(totvpath == true)
       {
         line(oldXpos, oldYpos, oldXpos + oldXspeed*2, oldYpos + oldYspeed*2); //Draws the total velocity
         text("Total Vel", oldXpos + oldXspeed*2, oldYpos + oldYspeed*2);
       }
     }
     //System.out.println("5");
   }
   
   //This will unhighlight the obstacle selected
   else if(unhighlightRect)
   {     
     strokeWeight(4);
     fill(obsColor);
     stroke(obsColor);
     rect(d_x, d_y, d_width, d_height);
     
     highlightRect = false;
     unhighlightRect = false;
     
     //The plot color is also specified for the stroke and fill methods
     stroke(plotColor); fill(plotColor);
     
     //Line thickness = 4
     strokeWeight(4);
     
     //We have to reedraw the lines since they were erased 
     for(Iterator<Point> it = PointArray.iterator(); it.hasNext();)
     {
          Point pa = it.next();
          drawPoint(pa);
     }
             
     //Redraw velocity lines  
     if(!eraseVlines)
     {
       //The plot color for the velocity lines
       stroke(orange); fill(orange);
        
       //this will display the velocity path in the x direction if the user clicks the check box
       if(vxpath == true)
       {
         line(oldXpos, oldYpos, oldXpos + oldXspeed*2, oldYpos); //Draws the velocity in the x direction
         text("VX", oldXpos + oldXspeed*2, oldYpos); 
       }
          
       //this will display the velocity path in the y direction if the user clicks the check box
       if(vypath == true)
       {
          line(oldXpos, oldYpos, oldXpos, oldYpos + oldYspeed*2); //Draws the velocity in the y direction
          text("VY", oldXpos, oldYpos + oldYspeed*2);   
       }
          
       //this will display the total velocity path if the user clicks the check box
       if(totvpath == true)
       {
         line(oldXpos, oldYpos, oldXpos + oldXspeed*2, oldYpos + oldYspeed*2); //Draws the total velocity
         text("Total Vel", oldXpos + oldXspeed*2, oldYpos + oldYspeed*2);
       }
     }
    //System.out.println("6");
   }
   
   //else flag = false, simply call the particle's run method  
   else
   {
     particle1.run();
     //System.out.println("7");
   }  
} //End of Draw

//This method reinitializes all user specified variables
public void reset()
{
  xpos = 0;
  ypos = 0;
  new_ypos = 0;
  xspeed = 0;
  yspeed = 0;
  vel = 0;
  yacc = 0;
  xacc = 0;
  epX = 0;
  epY = 0;
  angle = 0;
  time = 0;
  dTime = .1; //.0001
  tN = 1;
} //End of Reset

//This method configures the coordinate grid
public void showGraph()
{
  int i = 0;
  
  //Defines the stroke color to be gray and the fill to be black
  stroke (179); fill(0);
  
  //The line thickness = 5
  strokeWeight(5);
  
  //The following two lines display the vertical and horizontal axis respectively
  //width and height are global variables that can be used anytime.
  //They are used in this case so as to keep the drawing general
  line(200, 100, 200, height - 100);
  line(200, height - 100, width - 200, height - 100);
  
  //line thickness of 1 will be used to draw the tick marks
  strokeWeight(1);
  
  //The following two for loops will draw the tick marks for the vertical and horizontal axis respectively
  for(i = 0; i < (height - 100); i+=100)
  {
    line(200, 100 + i, 220, 100 + i);
    text(height - (100 + i), 170, 100 + i); 
  }
  
  for(i = 0; i < width - 300; i+=100)
  {
    //line((width - 200) - i, height - 100, (width - 200) - i, height - 120);
    line(200 + i, height - 100, 200 + i, height - 120);
    text(200 + i, 195 + i, height - 80);
  }
} //End of showGraph()

//Iterates through each user defined rectangle and draws them to the screen
public void drawObstacle()
{
  stroke(0);
  fill(0);
  
  for(Iterator<Rect> it = RectArray.iterator(); it.hasNext();)
  {
    Rect ra = it.next();
     drawRect(ra);
  }
} //End of drawObstacle()

//Draws an individual rectangle to the screen provided they haven't been deleted
//Each obstacle will get drawn with the correct color depending on if the user selected it
public void drawRect(Rect RectArray)
{
  //If obstacle was not selected, redraw normally
  if(RectArray.e == 0)
  {
    strokeWeight(4);
    stroke(obsColor);
    fill(obsColor);
    rect(RectArray.x, RectArray.y, RectArray.w, RectArray.h);
  }
 
 //If the obstacle was selected, redraw with highlight
  else
  {
    strokeWeight(4);
    stroke(orange);
    fill(obsColor);
    rect(RectArray.x, RectArray.y, RectArray.w, RectArray.h);
  }
} //End of drawRect

//Draws a point to the screen
public void drawPoint(Point PointArray)
{
  point(PointArray.a, PointArray.b);
} //End of drawPoint()

public void mouseClicked()
{
  //Store coordinates of where mouse was clicked
  mx = mouseX;
  my = mouseY;
  
  //Loop through all obstacles to determine which one was selected
  for(Iterator<Rect> it = RectArray.iterator(); it.hasNext();)
  {
    Rect ra = it.next();
    if(mx > ra.x && mx < ra.x + ra.w && my > ra.y && my < ra.y + ra.h)
    {
      //Obstacle has been selected
      if(ra.e == 0)
      {
        ra.e = 1;
        highlightRect = true;
        unhighlightRect = false;
        //Save obstacle dimensions
        d_x = ra.x; d_y = ra.y; d_width = ra.w; d_height = ra.h;
        redraw();
      }
      
      //Obstacle has been deselected
      else
      {
        ra.e = 0;
        highlightRect = false;
        unhighlightRect = true;
        //Save obstacle dimensions
        d_x = ra.x; d_y = ra.y; d_width = ra.w; d_height = ra.h;
        redraw();
      }
    }
  }
} //End of mouseClicked()

//Particle Class
public class Particle 
{ 
  //Creates instance of Particle Object; Called when the particle object is instantiated
  Particle()
  { 
    xpos = 0;
    ypos = 0;
    new_ypos = 0;
    xspeed = 0;
    yspeed = 0;
    vel = 0;
    yacc = 0;
    xacc = 0;
    epX = 0;
    epY = 0;
    angle = 0;
    time = 0;
    dTime = .1;
    tN = 1;
  }

  //This method displays each individual point to the screen
  public void display() 
  {    
    if(path == false)
      {
        //Because of these two calls, no previous lines will exist on the canvas. Essentially all old data will be erase
        background(255); showGraph();
        
        //Redraw the rectangles that weren't deleted back to the screen 
        drawObstacle();
        
        //The plot color is also specified for the stroke and fill methods
        stroke(plotColor); fill(plotColor);
        
        //Line thickness = 4
        strokeWeight(4);
    
        //The point method takes in two parameters, in this case
        //The xpos and the new ypos that is configured as a result of the new coordinate system
        //This point will be drawn to the screen but won't be visible since the vertex of the velocity lines will cover it 
        point(xpos, new_ypos);
          
        //The plot color for the velocity lines
        stroke(orange); fill(orange);
        
        //this will display the velocity path in the x direction if the user clicks the check box
        if(vxpath == true)
        {
          line(xpos, new_ypos, xpos + xspeed*2, new_ypos); //Draws the velocity in the x direction
          text("VX", xpos + xspeed*2, new_ypos); 
        }
          
        //this will display the velocity path in the y direction if the user clicks the check box
        if(vypath == true)
        {
          line(xpos, new_ypos, xpos, new_ypos + yspeed*2); //Draws the velocity in the y direction
          text("VY", xpos, new_ypos + yspeed*2);   
        }
          
        //this will display the total velocity path if the user clicks the check box
        if(totvpath == true)
        {
          line(xpos, new_ypos, xpos + xspeed*2, new_ypos + yspeed*2); //Draws the total velocity
          text("Total Vel", xpos + xspeed*2, new_ypos + yspeed*2);
        }
       
        //Removes all points from PointArray
        PointArray.clear();
      }
      
      else
      {     
        //All old data is still wiped out, but because we are using a list, the data will be redrawn to the canvas. 
        //The velocity lines will still be erase  
        background(255); showGraph(); 
        
        //Redraw the rectangles that weren't deleted back to the screen
        drawObstacle();
          
        //The plot color is also specified for the stroke and fill methods
        stroke(plotColor); fill(plotColor);
        
        //Line thickness = 4
        strokeWeight(4); 
          
        //Draw particle path to screen
        for(Iterator<Point> it = PointArray.iterator(); it.hasNext();)
        {
          Point pa = it.next();
          drawPoint(pa);
        }
          
        //The plot color for the velocity lines
        stroke(orange); fill(orange);
          
         //this will display the velocity path in the x direction if the user clicks the check box
        if(vxpath == true)
        {
          line(xpos, new_ypos, xpos + xspeed*2, new_ypos); //Draws the velocity in the x direction
          text("VX", xpos + xspeed*2, new_ypos); 
        }
        
        //this will display the velocity path in the y direction if the user clicks the check box
        if(vypath == true)
        {
          line(xpos, new_ypos, xpos, new_ypos + yspeed*2); //Draws the velocity in the y direction
          text("VY", xpos, new_ypos + yspeed*2);   
        }
 
        //this will display the total velocity path if the user clicks the check box
        if(totvpath == true)
        {
          line(xpos, new_ypos, xpos + xspeed*2, new_ypos + yspeed*2); //Draws the total velocity
          text("Total Vel", xpos + xspeed*2, new_ypos + yspeed*2);
        }
      }
  } 
 
  //This method will calculate the values needed for the particle's motion using kinematic equations for velocity, poition and acceleration
  //Collision response is also handled and depending upon which condition is specified by the user the appropriate chunk of code will handle collision of the particle on each boundary
  public void run() 
  {    
    //Obstacle detection and response
    for(Iterator<Rect> it = RectArray.iterator(); it.hasNext(); )
    {
      Rect ra = it.next();
      //if the previous position of particle is outside area of obstacle and the current position of particle is inside the area of the obstacle we have a collission
      if ((xpos > ra.x && xpos < ra.x + ra.w && new_ypos > ra.y && new_ypos < ra.y + ra.h) && (oldXpos < ra.x || oldXpos > ra.x + ra.w || oldYpos < ra.y || oldYpos > ra.y + ra.h))
      {
        //Collision with left side of obstacle
        if(oldXpos < ra.x && xspeed > 0)
        {
          System.out.println("Collision with left side of obstacle"); 
          xspeed = -epX*xspeed;
          yspeed = epY*(yspeed + yacc*dTime);
        }
        
        //Collision with right side of obstacle
        else if((oldXpos > (ra.x + ra.w) && xspeed < 0  && yspeed < 0) || (oldXpos > (ra.x + ra.w) && xspeed < 0  && yspeed > 0) )
        {
          System.out.println("Collision with right side of obstacle"); 
          xspeed = -epX*xspeed;
          yspeed = epY*(yspeed + yacc*dTime);
        }
       
        //Collision with top side of obstacle
        //We already converted the y coor of the obstacle so when now it can be properly compared with oldYpos
        else if((oldYpos < ra.y && yspeed > 0 && xspeed < 0) || (oldYpos < ra.y && yspeed > 0 && xspeed > 0 ))
        {          
          System.out.println("Collision with top side of obstacle"); 
          xspeed = epX*xspeed;
          yspeed = -epY*(yspeed + yacc*dTime);  
          
          //Determine the distance the particle went past the boundary that it collided with
          dy = ra.y - new_ypos;
          
          //Update the new ypos of the particle by adding twice that amount to the ypos
          //The xpos of the particle past the boundary will stay the same
          new_ypos = new_ypos + 2*dy;
        }
        
        //Collision with bottom side of obstacle
        //We already converted the y coor of the obstacle so when now it can be properly compared with oldYpos
        else if((new_ypos < (ra.y + ra.h) && yspeed < 0 && xspeed < 0) || (new_ypos < (ra.y + ra.h) && yspeed < 0 && xspeed > 0))
        {
          System.out.println("Collision with bottom side of obstacle"); 
          xspeed = epX*xspeed;
          yspeed = -epY*(yspeed + yacc*dTime);    
        }
        
        else
        {
          
        }
      }
    }

    //Time is incremened by dTime
    time = time + dTime;
    
    //This variable is updated each time "time" is updated - time counter
    t1++; 
    
    //tN cannot be 0; so if it is change it to 1
    if(tN == 0)
    {
      tNfield.setText("1");
      tN = 1;
    }
        
    //This controlls how frequent a point is displayed onto the screen
    //tN can be specified by the user but its default value is 1
    if(t1 % tN == 0) //when t1 is a multiple of tN..
      particle1.display(); //display a point to the screen
      
    //The previous x pos and y pos are saved into two variables
    oldXpos = xpos;
    oldYpos = new_ypos;
    
    //The previous x speed and y speed are saved into two variables
    oldXspeed = xspeed;
    oldYspeed = yspeed;
   
    //Velocity in the x and y direction are updated
    //Note: to reconfigure the coordinate system vy has to have the opposite direction thus the negative sign used
    xspeed = xspeed + xacc*dTime; // + 
    yspeed = yspeed - yacc*dTime; // -
    
    //x pos and new y pos are calculated
    xpos = xpos + xspeed*dTime;
    
    //As mentioned previously, to reconfigure the coordinate system, the new y pos value needs to have a negative value to account for the new direction. magnitude is kept the same
    new_ypos = new_ypos + yspeed*dTime - (.5*yacc*(dTime*dTime)); // + -

    PointArray.add(new Point(xpos, new_ypos)); //Add the newly generated point to the array
    
    //Update time text field
    timefield.setText("" + (double)Math.round(time * 100000) / 100000);
        
    //The following if blocks of code handle collision depending on which one was specifed by the user
    
    //Reflecting Boundary Condition for Bottom Boundary
    if(bref == true)
    {
      //if the particle exceeds the bottom boundary or height in this case for the y poss
      if(new_ypos > height)
      {
        //recalculate vx and vy by multipling the xspeed and yspeed by the predefined coefficient of restitution
        //also reverse the direction of the y velocity 
        xspeed = epX*xspeed;
        yspeed = -epY*(yspeed + yacc*dTime);
        
        //Print vx and vy to the screen
        //output.print(xspeed + "\t" + yspeed);
        //output.println();

        //Reset the y pos to be the ground floor, so we don't loos the particle
        new_ypos = height;      
      }
    }
    
    //Repeating Boundary Condition for Bottom Boundary
    if(brep == true)
    {
      //if the particle exceeds the bottom boundary or height in this case for the y pos
      if(new_ypos > height)
      {
        //the new ypos will equal height and so height - height will equal 0; 0 in this case being the top boundary  
        new_ypos = new_ypos - height; 
      }
    }
    
    //Reflectig Boundary Condition for Top Boundary
    if(tref == true)
    {
      //if particle exceeds the top boundary or 0 in this case for the ypos
      if(new_ypos < 0)
      {
         //recalculate vx and vy by multipling the xspeed and yspeed by the predefined coefficient of restitution
        //also reverse the direction of the y velocity 
        xspeed = epX*xspeed;
        yspeed = -epY*(yspeed + yacc*dTime);
        
        //Print vx and vy to the screen
        //output.print(xspeed + "\t" + yspeed);
        //output.println();

        //reset y pos to be the top boundary so as not to lose the particle 
        new_ypos = 0;  
      }
    }
    
    //Repeating Boundary Condition for Top Boundary
    if(trep == true)
    {
      //if the particle exceeds the top boundary or  0 in this case for the ypos
      if(new_ypos < 0)
      {
        //the ypos of the particle will be 0 so 0 plus height will reset it to the bottom boundary
        new_ypos = new_ypos + height;
      }
    }
   
    //Reflecting Boundary Condition for Right Boundary
    if(rref == true)
    {
      //if xpos exceeds the right boundary or width in this case for xpos
      if(xpos > width)
      {
         //recalculate vx and vy by multipling the xspeed and yspeed by the predefined coefficient of restitution
        //also reverse the direction of the y velocity 
        xspeed = -epX*xspeed;
        yspeed = epY*(yspeed + yacc*dTime);
        
        //Print vx and vy to the screen
        //output.print(xspeed + "\t" + yspeed);
        //output.println();
 
        //reset the xpos to be the right boundary so as not to lose the particle
        xpos = width;
      }
    }
    
    //Repeating Boundary Condition for Right Boundary
    if(rrep == true)
    {
      //if the particle exceeds the right boundary or width in this case for xpos
      if(xpos > width)
      {
        //the xpos will be equal to the width of the window so width - width = 0
        //the particle will be reset to the left boundary or 0 in this case
        xpos = xpos - width;
      }
    }
    
    //Reflecting Boundary Condition for Left Boundary
    if(lref == true)
    {
      //if the particle exceeds the left boundary or 0 in this case for xpos
      if(xpos < 0)
      {
        //recalculate vx and vy by multipling the xspeed and yspeed by the predefined coefficient of restitution
        //also reverse the direction of the y velocity 
        xspeed = -epX*xspeed;
        yspeed = epY*(yspeed + yacc*dTime);
        
        //Print vx and vy to the screen
        //output.print(xspeed + "\t" + yspeed);
        //output.println();

        //reset the xpos to be the left boundary so as not to lose the particle
        xpos = 0;
      }
    }
    
    //Repeating Boundary Condition for Left Boundary
    if(lrep == true)
    {
      //if the particle exceeds the left boundary or 0 in this case for xpos
      if(xpos < 0)
      {
        //the xpos of the particle will be 0 so 0 + width will reset the particle to the right boundary
        xpos = width + xpos;
      }
    }
  }
} //End of Particle Class

//Point Class
public class Point 
{
  float a;
  float b;
  
  public Point(float a, float b)
  {
    this.a = a;
    this.b = b;
  }
} //End of Point Class

//Rectangle/Obstacle Class
public class Rect
{
  int x;
  int y;
  int w;
  int h;
  int e;
  
  public Rect(int x, int y, int w, int h, int e)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.e = e;
  }
} //End of Rect
  




