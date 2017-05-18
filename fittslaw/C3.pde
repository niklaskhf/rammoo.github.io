
int circleX = 0;
int circleY = 0;  // Position of circle button
int circleSize;   // Diameter of circle
int prevSize;
color circleColor, baseColor;
boolean circleOver = false;
int startTime;


double prevX = mouseX;
double prevY = mouseY;
double refreshTime = millis();

double startX;
double startY;

double velocity;

HashMap<Integer, ArrayList<Double[]>> circleTracking = new HashMap<Integer, ArrayList<Double[]>>();

int[] sizes = new int[] {5,10,20,30,50};

void setup() {
  size(1024,768);
  surface.setResizable(false);
  
  baseColor = color(167);
  circleColor = color(7,183,58);
  
  
  for(int i : sizes) {
    circleTracking.put(i, new ArrayList<Double[]>());
  }
  
  circleTracking.put(250, new ArrayList<Double[]>());
  
  initCircle();
  
  ellipseMode(CENTER);
}


void draw() {
  update(mouseX, mouseY);
  
  // not sure this is actually needed at any point
  calculateMouseSpeed();
}

void update(int x, int y) {
  if ( overCircle(circleX, circleY, circleSize) ) {
    circleOver = true;
  } else {
    circleOver = false;
  }
}

void mousePressed() {
  update(mouseX, mouseY);
  if (circleOver) {
    circleTracking.get(circleSize).add(new Double[] {(double) millis() - startTime, calcDistance(startX, startY), (double) circleSize});
    drawCircle();
    startX = mouseX;
    startY = mouseY;
  }
}


boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

void drawCircle() {
  int counter = 0;
  for (int i = 0; i < 5; i++) {
    counter += circleTracking.get(sizes[i]).size();
  }
  if (counter >= 100) {
    printResults();
  } else {
    prevSize = circleSize;
    pickRandomSize();
    pickRandomCircleCoordinates();
  
    println("Drawing circle at:\nX = " + circleX + "\nY = " + circleY + "\nr = " + circleSize);
    background(baseColor);
    fill(circleColor);
    ellipse(circleX, circleY, circleSize, circleSize);
    startTime = millis();
    velocit = 0;
  }
}

void initCircle() {
  circleX = 1024/2;
  circleY = 450;
  circleSize = 250;
  fill(circleColor);
  textSize(32);
  textAlign(CENTER);
  text("Click on the circle to start.", 1024/2, 200);
  ellipse(circleX, circleY, circleSize, circleSize);
}

void pickRandomSize() {
   int rand = (int) random(5);
   while (circleTracking.get(sizes[rand]).size() >= 20) {
     rand = (int) random(5);
   }
   circleSize = sizes[rand];
}

void pickRandomCircleCoordinates() {
  int circleNewX = (int) random(circleSize / 2, 1024 - (circleSize / 2));
  int circleNewY = (int) random(circleSize / 2, 768 - (circleSize / 2));
  
    while (overlapping(circleNewX, circleNewY)) {
      circleNewX = (int) random(circleSize / 2,1024 - (circleSize / 2));
      circleNewY = (int) random(circleSize / 2,768 - (circleSize / 2));
    }
    circleX = circleNewX;
    circleY = circleNewY;
}

boolean overlapping(int x, int y) {
  // pretty terrible name for what it does
  if (calcDistanceCircle(x,y) < 30) {
    return true;
  } else {
    return false;
  }
}

double calcDistanceCircle(int x, int y) {
  return Math.sqrt(
  Math.pow(2, (x - circleX)) + 
  Math.pow(2,(y - circleY))) - 
  (circleSize + prevSize);
}

double calcDistance(double x, double y) {
  return Math.sqrt(
  Math.pow(2, (x - circleX)) + 
  Math.pow(2,(y - circleY)));
}



void calculateMouseSpeed() {
  // not sure why I did this 
  double distanceTravelled = Math.sqrt(Math.pow(2,(prevX - mouseX)) + Math.pow(2, (prevY - mouseY)));
  if (velocity > 0) {
   velocity = (velocity + distanceTravelled / (millis() - refreshTime)) / 2;
  } else {
    velocity = distanceTravelled / (millis() - refreshTime);
  
  prevX = mouseX;
  prevY = mouseY;  
}


void printResults() {
  // TODO
  background(baseColor);
  textAlign(CENTER);
  textSize(32);
  text("TODO", 1024/2, 768/2);
}