
ArrayList<Year> years = new ArrayList<Year>();
int which = 0;
float zeroX, zeroY;
float centX, centY;
float highest, border;
String[] company;
color[] companyColour; 

PFont font;

void setup()
{
  size(1366, 700);
  font = loadFont("BritannicBold-15.vlw");
  textFont(font);
  background(0);
  smooth();

  zeroX = 0;
  zeroY = 0;

  loadData();
  displayFigures();

  company = new String[3];
  company[0] = "Google";
  company[1] = "Apple";
  company[2] = "Microsoft";

  companyColour = new color[3];
  companyColour[0] = color(0, 0, 255);
  companyColour[1] = color(255);
  companyColour[2] = color(255, 0, 0);


  border = width * 0.05f;
  centX = height * 0.5f;
  centY = height * 0.5f;
}



void draw()
{
  background(0);
  int x = mouseX;

  if (keyPressed) {
    if ( key == '0')
    {
      which = 0;
    } else if ( key == '1')
    {
      which = 1;
    } else if ( key == '2')
    {
      which = 2;
    } else if ( key == '3')
    {
      which = 3;
    } else if ( key == '4')
    {
      which = 4;
    } else if ( key == '5')
    {
      which = 5;
    }
  }

  if (which == 0)
  {
    drawAxis(years.size(), 10, maxGoogle(), border);
    drawTrendGraph(border, maxGoogle());
    redLine(x);
    drawCircle(x);
  } else if (which == 1)
  {
    pushMatrix();
    translate(-(width * 0.05f), -(width * 0.1f));
    drawGooglePieChart();
    popMatrix();

    pushMatrix();
    translate(width * 0.25f, height * 0.2f);
    drawApplePieChart();
    popMatrix();

    pushMatrix();
    translate(width * 0.55f, -(width * 0.1f));
    drawMicrosoftPieChart();
    popMatrix();
  } else if (which == 2)
  {
    drawAxis(years.size(), 10, maxGoogle(), border);
    drawBarChart();
  } else if (which == 3)
  {
    drawAxis(years.size(), 10, maxGoogle(), border);
    scatterGraph();
  }
  if (which == 4)
  {
    pushMatrix();
    translate(width * 0.25f, 0);
    drawTotalPieChart();
    popMatrix();
  }
}//end draw


void scatterGraph()
{

  stroke(0, 0, 255);
  fill(0, 0, 255);

  for (int i = 0; i < years.size (); i ++)
  {
    Year value = years.get(i);
    float size = 100;
    float sizeGoogle = map(value.google, 0, maxValueOfThree(), 0, size);
    float sizeApple = map(value.apple, 0, maxValueOfThree(), 0, size);;
    float sizeMicrosoft = map(value.microsoft, 0, maxValueOfThree(), 0, size);;

    stroke(companyColour[0]);
    fill(companyColour[0]);
    float x = map(i, 0, years.size(), border, width - border);
    float y = map(value.google, 0, maxGoogle(), height - border, border);

    ellipse((float)x, y, sizeGoogle, sizeGoogle);

    x = map(i, 0, years.size(), border, width - border);
    y = map(value.apple, 0, maxGoogle(), height - border, border);

    stroke(companyColour[1]);
    fill(companyColour[1]);
    ellipse((float)x, y, sizeApple, sizeApple);

    x = map(i, 0, years.size(), border, width - border);
    y = map(value.microsoft, 0, maxGoogle(), height - border, border);

    stroke(companyColour[2]);
    fill(companyColour[2]);
    ellipse((float)x, y, sizeMicrosoft, sizeMicrosoft);
  }
}

void drawBarChart()
{
  float horizontalWindowSize = width - (border / 3);
  //float verticalWindowSize = height - (border / 2);
  float sizeInterval = horizontalWindowSize / (float)years.size();
  float sizeEachBar = sizeInterval / 3;

  for (int i = 0; i < years.size (); i++)
  {
    Year value = years.get(i);
    fill(255);
    float x = border + (sizeInterval * i);
    float y = x;
    float barWidth = sizeEachBar;
    float barHeight = map(value.google, 0, maxGoogle(), height - border, border);
    rect((float)x, y, barWidth, barHeight);
  }
}

void redLine(int x)
{
  if (x > border && x < width - (border * 2)) 
  {

    line(x, border, x, height - border);
  } else if (x > width - (border * 2)) {

    line(width - (border*2), border, width - (border*2), height - border);
  } else if (x < border) {

    line(border, border, border, height - border);
  }
}

void drawTotalPieChart()
{
  int[] total = new int[3]; 
  float newX, newY;
  float highestTotal = 0;

  newX = width * 0.25f;
  newY = height * 0.5f;

  total[0] = sumGoogle();
  total[1] = sumApple();
  total[2] = sumMicrosoft();
  
  for (int i = 0; i < total.length; i ++)
  {
    if (total[i] > highestTotal){
      highestTotal = total[i];
    }
  }
  

  float sum = sumGoogle() + sumApple() + sumMicrosoft();
  float thetaPrev = 0;
  float totalThree = total[0] + total[1] + total[2];

  for (int i = 0; i < total.length; i ++)
  {
   
    float mapX = map(total[i], 0, highestTotal, 0, centX);
    float mapY = map(total[i], 0, highestTotal, 0, centY); 
    fill(companyColour[i]);
    stroke(companyColour[i]);

    float theta = map(total[i], 0, sum, 0, TWO_PI);
    textAlign(CENTER);
    textSize(15);
    float thetaNext = thetaPrev + theta;
    float radius = newX * 0.6f;
    //float radius = centX * 2.0f;
    float x = newX + sin(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;      
    float y = newY - cos(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;
    fill(255);
    textSize(11);
    text(company[i] + ": " + (int)map(total[i], 0, sum, 0, 100) + "%", x, y);             
    stroke(companyColour[i]);
    fill(companyColour[i]);               
    arc(newX, newY, mapX, mapY, thetaPrev, thetaNext);
    thetaPrev = thetaNext;
  }
}

void drawCircle(int x)
{
  float textX = width - (border * 2);
  float y = border;
  //only executes if x is within borders of graph
  if (x > border && x < width - (border * 2)) {
    int num = (int)map(x, border, width - border, 0, years.size());
    float mapX = map(x, 0, years.size(), border, height - border);

    Year year = years.get(num);

    float googleY = map(year.google, 0, maxValueOfThree(), height - border, border);
    float appleY = map(year.apple, 0, maxValueOfThree(), height - border, border);
    float microsoftY = map(year.microsoft, 0, maxValueOfThree(), height - border, border);

    stroke(companyColour[0]);
    fill(companyColour[0]);
    ellipse(mapX, googleY, 10, 10);

    stroke(companyColour[1]);
    fill(companyColour[1]);
    ellipse(mapX, appleY, 10, 10);

    stroke(companyColour[2]);
    fill(companyColour[2]);
    ellipse(mapX, microsoftY, 10, 10);

    //PUT DISPLAY ON GRAPH SIDE
    //printing year and GDP amount beside red circle
    textAlign(LEFT, LEFT);
    textSize(15);
    
    
    if (x >= border && x <= width - (border * 2)) {
      fill(companyColour[0]);
      text("Google: " + year.google, textX, y);
      fill(companyColour[1]);
      text("Apple: " + year.apple, textX, y + 30);
      fill(companyColour[2]);
      text("Microsoft: " + year.microsoft, textX, y + 60);
    }
    else if(x < border){      
      fill(companyColour[0]);
      text("Google: " + years.get(0).google, textX, y);
      fill(companyColour[1]);
      text("Apple: " + years.get(0).apple, textX, y + 30);
      fill(companyColour[2]);
      text("Microsoft: " + years.get(0).microsoft, textX, y + 60);
    }
    else if(x > border - (width * 2)){
      fill(companyColour[0]);
      text("Google: " + years.get(years.size() - 1).google, textX, y);
      fill(companyColour[1]);
      text("Apple: " + years.get(years.size() - 1).apple, textX, y + 30);
      fill(companyColour[2]);
      text("Microsoft: " + years.get(years.size() - 1).microsoft, textX, y + 60);
    }
    
    
  }
}

//possibility to use a button, slider or some shit to go through the years. 

void drawGooglePieChart()
{
  float sum = sumGoogle();
  float max = maxGoogle();
  float thetaPrev = 0;
  float size = 170;


  for (int i = 0; i < years.size (); i ++)
  {
    Year year = years.get(i);
    fill(year.c);
    stroke(year.c);

    float theta = map(year.google, 0, sum, 0, TWO_PI);
    textAlign(CENTER);

    float col = map(year.google, 0, max, 255, 100);
    float thetaNext = thetaPrev + theta;
    float radius = centX * 0.55f;
    //float radius = centX * 2.0f;
    float x = ((centX) + sin(thetaPrev + (theta * 0.5f) + HALF_PI) * radius);      
    float y = ((centY) - cos(thetaPrev + (theta * 0.5f) + HALF_PI) * radius);
    fill(255);
    textSize(12);
    text(year.y + ": " + (int)map(year.google, 0, sumGoogle(), 0, 100) + "%", x, y);             
    stroke(0, col, col);
    fill(0, col, col);               
    arc(centX, centY, centX * 0.8, centY * 0.8f, thetaPrev, thetaNext);
    thetaPrev = thetaNext;
    
    stroke(255);
    fill(0);
    ellipse(centX, centY, size, size);
    
  }
}

void drawApplePieChart()
{
  float sum = sumApple();
  float max = maxApple();
  float thetaPrev = 0;
  float size = 170;

  for (int i = 0; i < years.size (); i ++)
  {
    Year year = years.get(i);
    fill(year.c);
    stroke(year.c);

    float theta = map(year.apple, 0, sum, 0, TWO_PI);
    textAlign(CENTER);
    textSize(11);
    float col = map(year.apple, 0, max, 255, 100);
    float thetaNext = thetaPrev + theta;
    float radius = centX * 0.55f;
    float x = centX + sin(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;      
    float y = centY - cos(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;
    fill(255);
    textSize(12);
    text(year.y + ": " + (int)map(year.apple, 0, sumApple(), 0, 100) + "%", x, y);             
    stroke(col, 0, col);
    fill(col, 0, col);               
    arc(centX, centY, centX * 0.8f, centY * 0.8f, thetaPrev, thetaNext);
    thetaPrev = thetaNext;
    
    stroke(255);
    fill(0);
    ellipse(centX, centY, size, size);
  }
}

void drawMicrosoftPieChart()
{
  float sum = sumMicrosoft();
  float max = maxMicrosoft();
  float thetaPrev = 0;
  float size = 170;


  for (int i = 0; i < years.size (); i ++)
  {
    Year year = years.get(i);
    fill(year.c);
    stroke(year.c);

    float theta = map(year.microsoft, 0, sum, 0, TWO_PI);
    textAlign(CENTER);
    float col = map(year.microsoft, 0, max, 255, 100);
    float thetaNext = thetaPrev + theta;
    float radius = centX * 0.55f;
    float x = centX + sin(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;      
    float y = centY - cos(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;
    fill(255);
    textSize(12);
    text(year.y + ": " + (int)map(year.microsoft, 0, sumMicrosoft(), 0, 100) + "%", x, y);             
    stroke(col, 0,0);
    fill(col, 0, 0);               
    arc(centX, centY, centX * 0.8f, centY * 0.8f, thetaPrev, thetaNext);
    thetaPrev = thetaNext;
    
    stroke(255);
    fill(0);
    ellipse(centX, centY, size, size);
    stroke(255);
    fill(companyColour[2]);
    textAlign(CENTER);
    textSize(25);
    text(company[2], centX, centY);
    
  }
}

void drawAxis(int horizontalIntervals, int verticalIntervals, float vertDataRange, float border)
{
  stroke(200, 200, 200);
  fill(200, 200, 200);

  int fromLast = 50;
  int offset = 5;

  // Draw the horizontal axis
  stroke(256, 0, 0);
  line(border, height - border, width - (border * 2), height - border);

  float horizontalWindowRange = (width - (border * 2.0f));
  float horizontalDataGap = years.size() / horizontalIntervals;
  float horizontalWindowGap = horizontalWindowRange / horizontalIntervals;
  float tickSize = border * 0.1f;

  float firstYear = years.get(0).y;

  // Draw the ticks
  for (int i = 0; i < horizontalIntervals; i ++)
  {

    float x = border + (i * horizontalWindowGap);
    line(x, height - (border - tickSize), x, (height - border));
    //float textY = height - (border * 0.5f);
  }

  for (int i = 0; i < horizontalIntervals; i += 2) {
    float x = border + (i * horizontalWindowGap);
    float textY = height - (border * 0.5f);
    // Print the date
    textAlign(CENTER, CENTER);
    textSize(12);
    text((int)(firstYear + i * horizontalDataGap), x, textY);
  }

  // Draw the vertical axis
  line(border, border, border, height - border);

  float verticalDataGap = vertDataRange / verticalIntervals;
  float verticalWindowRange = height - (border * 2.0f);
  float verticalWindowGap = verticalWindowRange / verticalIntervals;

  for (int i = 0; i <= verticalIntervals; i ++)
  {
    float y = (height - border) - (i * verticalWindowGap);
    line(border - tickSize, y, border, y);
    float hAxisLabel = verticalDataGap * i;

    textAlign(RIGHT, CENTER);

    text((int)hAxisLabel, border - (tickSize * 2.0f), y);
  }
}

void drawTrendGraph(float border, float maxValue) {



  for (int i = 1; i < years.size (); i ++)
  {
    stroke(0, 0, 255);
    fill(0, 0, 255);
    Year value = years.get(i);
    Year minusValue = years.get(i-1);
    float x1 = map(i-1, 0, years.size(), border, width - border);
    float x2 = map(i, 0, years.size(), border, width - border);
    float y1 = map(minusValue.google, 0, maxValue, height - border, border);
    float y2 = map(value.google, 0, maxValue, height - border, border);
    line((float)x1, y1, (float)x2, y2);

    //Apple
    stroke(255);
    fill(255);
    x1 = map(i-1, 0, years.size(), border, width - border);
    x2 = map(i, 0, years.size(), border, width - border);
    y1 = map(minusValue.apple, 0, maxValue, height - border, border);
    y2 = map(value.apple, 0, maxValue, height - border, border);
    line(x1, y1, x2, y2);

    //Microsoft
    stroke(255, 0, 0 );
    fill(255, 0, 0);
    x1 = map(i-1, 0, years.size(), border, width - border);
    x2 = map(i, 0, years.size(), border, width - border);
    y1 = map(minusValue.microsoft, 0, maxValue, height - border, border);
    y2 = map(value.microsoft, 0, maxValue, height - border, border);
    line(x1, y1, x2, y2);
  }
}


int maxValueOfThree() {

  int[] arr = new int[3];
  int max = 0;

  arr[0] = maxGoogle();
  arr[1] = maxApple();
  arr[2] = maxMicrosoft();

  for (int i = 0; i < arr.length; i++) {

    if (arr[i] > max) {

      max = arr[i];
    }
  }

  return max;
}

//APPLE MAX, MIN, ETC FUNCTIONS

int sumGoogle()
{
  int sum = 0;

  for (int i = 0; i < years.size (); i++) {

    Year select = years.get(i);
    sum += select.google;
  }

  return sum;
}

float averageGoogle() {

  int total = sumGoogle();

  float avg = total / years.size();

  return avg;
}

int maxGoogle() {

  int max = 0;

  for (int i = 0; i < years.size (); i++) {
    Year n = years.get(i);

    if (n.google > max) {

      max = n.google;
    }
  }

  return max;
}



//APPLE MAX, MIN, ETC FUNCTIONS

int sumApple()
{
  int sum = 0;

  for (int i = 0; i < years.size (); i++) {

    Year select = years.get(i);
    sum += select.apple;
  }

  return sum;
}


float averageApple() {

  int total = sumApple();

  float avg = total / years.size();

  return avg;
}

int maxApple() {

  int max = 0;

  for (int i = 0; i < years.size (); i++) {
    Year n = years.get(i);

    if (n.apple > max) {

      max = n.apple;
    }
  }

  return max;
}


//MICROSOFT MAX, MIN, ETC FUNCTIONS

int sumMicrosoft()
{
  int sum = 0;

  for (int i = 0; i < years.size (); i++) {

    Year select = years.get(i);
    sum += select.microsoft;
  }

  return sum;
}

float averageMicrosoft() {

  int total = sumMicrosoft();

  float avg = total / years.size();

  return avg;
}

int maxMicrosoft() {

  int max = 0;

  for (int i = 0; i < years.size (); i++) {
    Year n = years.get(i);

    if (n.microsoft > max) {

      max = n.microsoft;
    }
  }

  return max;
}

void loadData() {

  String[] lines = loadStrings("newData.txt");

  for (int i = 0; i < lines.length; i++)
  {
    Year year = new Year(lines[i]);
    years.add(year);
  }
}

void displayFigures() {

  for (int i = 0; i < years.size (); i++) {

    Year select  = years.get(i);
    select.display();
  }
}

