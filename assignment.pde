//Scale some shitty pie charts. Create the bar chart
ArrayList<Year> years = new ArrayList<Year>();
int which = 0;
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
    pushMatrix();
    translate(width * 0.25f, 0);
    drawTotalPieChart();
    popMatrix();
   
  }
  
}//end draw

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
  //float max = maxValueOfThree();
  float thetaPrev = 0;
  float totalThree = total[0] + total[1] + total[2];

  for (int i = 0; i < total.length; i ++)
  {
   
    float mapX = map(total[i], 0, highestTotal, 0, centX);
    float mapY = map(total[i], 0, highestTotal, 0, centY);
    //Year year = years.get(i); 
    fill(companyColour[i]);
    stroke(companyColour[i]);

    float theta = map(total[i], 0, sum, 0, TWO_PI);
    textAlign(CENTER);
    textSize(15);
    //float col = map(total[i], 0, max, 255, 100);
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
    arc(newX, newY, centX, centY, thetaPrev, thetaNext);
    thetaPrev = thetaNext;
  }
}

void drawGooglePieChart()
{
  float sum = sumGoogle();
  float max = maxGoogle();
  float thetaPrev = 0;


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
   
  }
    
}

void drawApplePieChart()
{
  float sum = sumApple();
  float max = maxApple();
  float thetaPrev = 0;


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
    stroke(col);
    fill(col);               
    arc(centX, centY, centX * 0.8f, centY * 0.8f, thetaPrev, thetaNext);
    thetaPrev = thetaNext;

  }
}

void drawMicrosoftPieChart()
{
  float sum = sumMicrosoft();
  float max = maxMicrosoft();
  float thetaPrev = 0;


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
    //float radius = centX * 2.0f;
    float x = centX + sin(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;      
    float y = centY - cos(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;
    fill(255);
    textSize(12);
    text(year.y + ": " + (int)map(year.microsoft, 0, sumMicrosoft(), 0, 100) + "%", x, y);             
    stroke(col, 0, 0);
    fill(col, 0, 0);               
    arc(centX, centY, centX * 0.8f, centY * 0.8f, thetaPrev, thetaNext);
    thetaPrev = thetaNext;

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

