import controlP5.*;
ArrayList<Company> companies = new ArrayList<Company>();
Company google = new Company("Google", color(0, 0, 255));
Company apple = new Company("Apple", color(255));
Company microsoft = new Company("Microsoft", color(255, 0, 0));
float centX, centY, highest, border, bX, bY;
boolean lineG, scatG, coxG, doughG, barG = false;
boolean drawLine = true;
boolean drawAvg = false;
int bWidth= 150;
int bHeight = 50;
PImage googleImg, appleImg, microsoftImg;
int imageWidth = 400;
int imageHeight = 200;
int doughnutSlider = 2001; //makes value in slider an integer

ControlP5 cp5;
Button line, scatter, coxComb, doughnut, bar, back, lines, averages ;

Slider dnSlider;

void setup()
{
  size(1366, 700);
  background(0);
  smooth();
  googleImg = loadImage("Google-logo.png");
  appleImg = loadImage("apple.png");
  microsoftImg = loadImage("microsoft.png");

  loadData();
  companies.add(google);
  companies.add(apple);
  companies.add(microsoft);

  border = width * 0.05f;
  centX = height * 0.5f;
  centY = height * 0.5f;
  bX = width * 0.45f;
  bY = height * 0.8f;

  for (int i = 0; i < companies.size(); i++)
  {
    println(companies.get(i).correlation());
  }

  cp5 = new ControlP5(this);

  //instantiate buttons and slider
  line = cp5.addButton("Line Graph").setPosition(bX - (bWidth * 2), bY).setSize(bWidth, bHeight);
  scatter = cp5.addButton("Scatter Graph").setPosition(bX - bWidth, bY).setSize(bWidth, bHeight);
  coxComb = cp5.addButton("Coxcomb Graph").setPosition(bX, bY).setSize(bWidth, bHeight);
  doughnut = cp5.addButton("Doughnut Chart").setPosition(bX + bWidth, bY).setSize(bWidth, bHeight);
  bar = cp5.addButton("Bar Chart").setPosition(bX + (bWidth * 2), bY).setSize(bWidth, bHeight);
  back = cp5.addButton("Back").setPosition(width - 130, height - 30).setSize(bWidth - 20, bHeight - 20);
  lines = cp5.addButton("Values").setPosition(50, 20).setSize(100, 10);
  averages = cp5.addButton("Averages").setPosition(150, 20).setSize(100, 10);
  dnSlider = cp5.addSlider("doughnutSlider").setPosition(10, height - 40).setSize(300, 20).setRange(2001, 2015).setValue(google.year.get(0)).setNumberOfTickMarks(google.data.size()).setSliderMode(Slider.FLEXIBLE);

  //only show menu options
  back.hide();
  dnSlider.hide();
  lines.hide();
  averages.hide();
}

void draw()
{ 

  image(googleImg, 20, 20, imageWidth, imageHeight + 100);
  image(appleImg, 20 + imageWidth, 70, imageHeight  + 20, imageHeight - 20);
  image(microsoftImg, 20 + (imageWidth  * 1.5f), 10, (imageHeight * 2) + 100, imageHeight * 2);
  int x = mouseX; // used to pass into drawLineAndFigures()
  if (lineG == true) {
    
    

    for (int i = 0; i < companies.size(); i++)
    {
      if (drawLine == true) {
        background(0);
        drawAxis(google.data.size(), 10, google.maximum(), border);
        companies.get(i).drawTrendGraph();
        drawLineAndFigures(x);
      }
      if(drawAvg == true){
        background(0);
        drawAxis(google.data.size(), 10, google.maximum(), border);
        companies.get(i).averageLine();
      }
    }
  }


  if (scatG == true) {
    background(0);
    drawAxis(google.data.size(), 10, google.maximum(), border);
    //change this using a for loop
    scatterGraph();
  }

  if (coxG == true) {
    background(0);
    //drawTotalPieChart();
    drawTable();
  }

  if (doughG == true) {
    background(0);
    pushMatrix();
    translate(-(width * 0.05f), -(width * 0.1f));
    google.drawPieChart(dnSlider.getValue());
    popMatrix();

    pushMatrix();
    translate(width * 0.25f, height * 0.2f);
    apple.drawPieChart(dnSlider.getValue());
    popMatrix();

    pushMatrix();
    translate(width * 0.55f, -(width * 0.1f));
    microsoft.drawPieChart(dnSlider.getValue());
    popMatrix();
  }

  if (barG == true) {
    background(0);
    drawAxis(google.data.size(), 10, google.maximum(), border);
    drawBarChart();
  }
}//end draw

void title(String x)
{
  textAlign(CENTER);
  text(x, width /2, 10);
}

void drawTable() {
  stroke(255);
  fill(255);
  textSize(15);
  float cellWidth = 0.3f;
  float cellHeight = 0.1f;
  float paddingLeft = 35;
  float paddingTop = 20;
  String[] calcs = new String[5];
  calcs[0] = "Sum";
  calcs[1] = "Average";
  calcs[2] = "Maximum";
  calcs[3] = "Std Dev";
  calcs[4] = "Corr Coef";
  for (int row = 0; row < companies.size() + 2; row++)
  { 
    //draw rows and columns
    for (int col = 0; col < calcs.length + 2; col++)
    {
      line(centX + ((centX * cellWidth) * row), centY, centX + ((centX * cellWidth) * row), centY + ((centY * cellHeight) * col));
      line(centX, centY + ((centY * cellHeight) * col), centX + ((centX * cellWidth) * row), centY + ((centY * cellHeight) * col));
      text(calcs[row], centX + (cellWidth * row + 1) + paddingLeft, centY + ((centY * cellHeight) * (row + 1)) + paddingTop);
    }
  }
  //maybe a nested for loop?
  for (int i = 0; i < calcs.length; i++) {
  }

  for (int i = 1; i < companies.size() + 1; i++) {
    //display companies
    text(companies.get(i-1).name, centX + ((centX * cellWidth) * i) + paddingLeft, (centY + cellHeight) + paddingTop);

    //display sum, average, max, std deviation and correlation in table
    text((int)companies.get(i-1).sum(), centX + ((centX * cellWidth) * i) + paddingLeft, centY + ((centY * cellHeight) + paddingTop));
    text(companies.get(i-1).average(), centX + ((centX * cellWidth) * i) + paddingLeft, ((centY + ((centY * cellHeight)) * 2) + paddingTop));
    text((int)companies.get(i-1).maximum(), centX + ((centX * cellWidth) * i) + paddingLeft, ((centY + ((centY * cellHeight)) * 3) + paddingTop));
    text(companies.get(i-1).standardDev(), centX + ((centX * cellWidth) * i) + paddingLeft, ((centY + ((centY * cellHeight)) * 4) + paddingTop));
    text(companies.get(i-1).correlation(), centX + ((centX * cellWidth) * i) + paddingLeft, ((centY + ((centY * cellHeight)) * 5) + paddingTop));
  }
}

void drawBarChart()
{
  float barWidth = 15;
  float offset = 3; // gap between each bar
  float r = 10; //setting radius on top

  for (int i = 0; i < google.data.size(); i ++)
  {
    for (int j = 0; j < companies.size(); j++) 
    {
      Company company = companies.get(j);
      //maps colour of company to value.
      float col = map(company.data.get(i), 0, google.maximum(), 255, 100);

      //checks company instance name and uses stroke and fill according to which one is selected 
      if (company.name.equals("Google")) {      
        stroke(255);
        fill(0, col, col);
      } else if (company.name.equals("Apple")) {
        stroke(255);
        fill(col, col, col);
      } else if (company.name.equals("Microsoft")) {
        stroke(255);
        fill(col, 0, 0);
      }

      float x = map(i, 0, google.data.size(), border, width - (border));
      float y = map(companies.get(j).data.get(i), 0, google.maximum(), border, height - (border* 2));
      rect((float)x + ((barWidth + offset) * j), height - border, (float)barWidth, -y, r, r, 0, 0);
    }
  }
}



void drawLineAndFigures(int x)
{
  //draws vertical line at position mouseX on Line Graph. Sticks to left or right border if mouse is not within graph range 
  if (x > border && x < width - (border * 2)) 
  {
    line(x, border, x, height - border);
  } else if (x > width - (border * 2)) {

    line(width - (border * 2), border, width - (border*2), height - border);
  } else if (x < border) {

    line(border, border, border, height - border);
  }

  float textX = width - (border * 2);
  float y = border;
  //only executes if x is within borders of graph
  if (x > border && x < width - (border * 2)) {
    //num maps passed in mouseX value and maps to integer index in data array range
    int num = (int)map(x, border, width - border, 0, google.data.size());

    if (x >= border && x <= width - (border * 2)) {
      for (int i = 0; i < companies.size(); i++) {
        stroke(companies.get(i).colour);
        fill(companies.get(i).colour);
        text(companies.get(i).name + ": " + companies.get(i).data.get(num), textX, y + (30 * i));
      }
    }
    //returns first data values of each instance if x is less than left border
    else if (x < border) { 
      for (int i = 0; i < companies.size(); i++) {
        stroke(companies.get(i).colour);
        fill(companies.get(i).colour);
        text(companies.get(i).name + ": " + companies.get(i).data.get(0), textX, y + (30 * i));
      }
    } 
    //returns last data values of each instance if x is less than right border
    else if (x > border - (width * 2)) {

      for (int i = 0; i < companies.size(); i++) {
        stroke(companies.get(i).colour);
        fill(companies.get(i).colour);
        text(companies.get(i).name + ": " + companies.get(i).data.get(google.data.size() -1 ), textX, y + (30 * i));
      }
    }
  }
}

void controlEvent(ControlEvent theEvent)
{

  if (theEvent.getName().equals("Line Graph")) {
    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    doughnut.hide();
    dnSlider.hide();
    bar.hide();
    lines.show();
    averages.show();
    lineG = true;
    scatG = false;
    doughG = false;
    coxG = false;
    barG = false;
  }
  
  if (theEvent.getName().equals("Values")) {
    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    bar.hide();
    dnSlider.hide();
    doughnut.hide();
    lines.show();
    averages.show();
    drawLine = true;
    drawAvg = false;
    lineG = false;
    scatG = false;
    doughG = false;
    coxG = false;
    barG = false;
  }
  
  if (theEvent.getName().equals("Averages")) {
    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    bar.hide();
    dnSlider.hide();
    doughnut.hide();
    lines.show();
    averages.show();
    drawLine = false;
    drawAvg = true;
    lineG = false;
    scatG = false;
    doughG = false;
    coxG = false;
    barG = false;
  }
    

  if (theEvent.getName().equals("Scatter Graph")) {
    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    bar.hide();
    dnSlider.hide();
    doughnut.hide();
    lines.hide();
    averages.hide();

    lineG = false;
    scatG = true;
    doughG = false;
    coxG = false;
    barG = false;
  }

  if (theEvent.getName().equals("Doughnut Chart")) {       
    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    doughnut.hide();
    dnSlider.show();
    bar.hide();
    lines.hide();
    averages.hide();

    lineG = false;
    scatG = false;
    doughG = true;
    coxG = false;
    barG = false;
  }

  if (theEvent.getName().equals("Coxcomb Graph")) {

    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    doughnut.hide();
    bar.hide();
    dnSlider.hide();
    lines.hide();
    averages.hide();


    lineG = false;
    scatG = false;
    doughG = false;
    coxG = true;
    barG = false;
  }

  if (theEvent.getName().equals("Back")) {
    background(0);
    lineG = false;
    scatG = false;
    doughG = false;
    coxG = false;
    barG = false;
    back.hide();
    dnSlider.hide();
    lines.hide();
    averages.hide();
    line.show();
    scatter.show();
    coxComb.show();
    doughnut.show();
    bar.show();
  }

  if (theEvent.getName().equals("Bar Chart")) {
    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    doughnut.hide();
    bar.hide();
    lines.hide();
    averages.hide();

    lineG = false;
    scatG = true;
    doughG = false;
    coxG = false;
    barG = true;
  }
}

void scatterGraph()
{
  for (int i = 0; i < google.data.size(); i ++)
  {

    float size = 100;
    float x, y;
    int count = 0; //used for rotating semi circle. If it is 1 then rotate in the loop.
    float[] sizeComp = new float[3];
    float[] values = new float[3];

    for (int j = 0; j < companies.size(); j++) {

      sizeComp[j] = map(companies.get(j).data.get(i), 0, google.maximum(), 0, size);
      values[j] = companies.get(j).data.get(i);
    }

    //if Google and Apple values are the same at same year, draw semi circle for both values
    if (google.data.get(i) == apple.data.get(i)) {

      //draws semicircles
      for (int p = 0; p < 2; p ++) {
        stroke(companies.get(p).colour);
        fill(companies.get(p).colour);

        pushMatrix();
        //maps x and y coordinates to the Scatter Graph to each element
        x = map(i, 0, google.data.size(), border, width - border);
        y = map(values[p], 0, google.maximum(), height - border, border);
        translate(x, y);

        //Only rotates semi-circle every two iterations
        if (count == 1) {
          rotate(-PI);
        }      

        arc((float)0, 0, sizeComp[p], sizeComp[p], 0, PI);
        popMatrix();

        count++;
      }

      //draws remaining point
      x = map(i, 0, google.data.size(), border, width - border);
      y = map(microsoft.data.get(i), 0, google.maximum(), height - border, border);
      stroke(microsoft.colour);
      fill(microsoft.colour);
      ellipse((float)x, y, sizeComp[2], sizeComp[2]);
    } 
    //if Google and Microsoft values are the same at same year, draw semi circle for both values
    else if (google.data.get(i) == microsoft.data.get(i)) {

      for (int p = 0; p < 3; p += 2) {
        stroke(companies.get(p).colour);
        fill(companies.get(p).colour);
        pushMatrix();
        x = map(i, 0, google.data.size(), border, width - border);
        y = map(values[p], 0, google.maximum(), height - border, border);
        translate(x, y);

        if (count == 1) {
          rotate(-PI);
        }

        arc((float)0, 0, sizeComp[p], sizeComp[p], 0, PI);
        popMatrix();
        count++;
      }

      //draws remaining point
      x = map(i, 0, google.data.size(), border, width - border);
      y = map(apple.data.get(i), 0, google.maximum(), height - border, border);
      stroke(apple.colour);
      fill(apple.colour);
      ellipse((float)x, y, sizeComp[1], sizeComp[1]);
    } else if (apple.data.get(i) == microsoft.data.get(i)) {

      for (int p = 1; p < 3; p ++) {
        stroke(companies.get(p).colour);
        fill(companies.get(p).colour);
        pushMatrix();
        x = map(i, 0, google.data.size(), border, width - border);
        y = map(values[p], 0, google.maximum(), height - border, border);
        translate(x, y);
        if (count == 1) {
          rotate(-PI);
        }  
        arc((float)0, 0, sizeComp[p], sizeComp[p], 0, PI);
        popMatrix();
        count++;
      }
      //draws remaining point
      x = map(i, 0, google.data.size(), border, width - border);
      y = map(google.data.get(i), 0, google.maximum(), height - border, border);
      stroke(google.colour);
      fill(google.colour);
      ellipse((float)x, y, sizeComp[0], sizeComp[0]);
    }
    //or normally draw points at three points
    else {
      y = 0;
      for (int k = 0; k < companies.size(); k++) {
        x = map(i, 0, google.data.size(), border, width - border);
        y = map(values[k], 0, google.maximum(), height - border, border);
        stroke(companies.get(k).colour);
        fill(companies.get(k).colour);
        ellipse((float)x, y, sizeComp[k], sizeComp[k]);
      }
    }
  }
}

void drawTotalPieChart()
{
  float newX, newY;
  newX = centX;
  newY = centY;
  //get mouse coordinates in relation to centre of circle
  float toMouseX = mouseX - centX;
  float toMouseY = mouseY - centY;
  float angle = atan2(toMouseY, toMouseX);
  float thetaPrev = 0;

  //mapping negative angle into positive
  if (angle < 0)
  {
    angle = map(angle, -PI, 0, PI, TWO_PI);
  }

  float totalOfThree = 0;

  //adding all sums of companies to sum 
  for (int i = 0; i < companies.size(); i ++)
  {
    totalOfThree += companies.get(i).sum();
  }

  for (int i = 0; i < companies.size(); i ++)
  {
    Company select = companies.get(i);
    float mapX = map(select.sum(), 0, google.sum(), 0, centX);
    float mapY = map(select.sum(), 0, google.sum(), 0, centY);

    float theta = map(select.sum(), 0, totalOfThree, 0, TWO_PI);
    textAlign(CENTER);   
    float thetaNext = thetaPrev + theta;
    float radius = newX * 0.6f;  
    float x = newX + sin(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;      
    float y = newY - cos(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;
    if (angle > thetaPrev && angle < thetaNext) {
      mapX = centX * 1.1f;
      mapY = centY * 1.1f;

      //if statements to scale out text values in coxcomb graph whenever mouse is within boundaries
      if (angle > 0 && angle < 3) {
        x *= 1.1f;
        y *= 1.1f;
      }
      if (angle > 3 && angle < 4) {
        x *= 0.9f;
        y *= 0.9f;
      }
      if (angle > 4) {
        x *= 1.1f;
        y *= 0.9f;
      }
    }
    fill(255);
    text(select.name + ": " + (int)map(select.sum(), 0, totalOfThree, 0, 100) + "%", x, y);

    stroke(select.colour);
    fill(select.colour); 
    arc(centX, centY, mapX, mapY, thetaPrev, thetaNext);
    thetaPrev = thetaNext;
  }
}

void drawAxis(int horizontalIntervals, int verticalIntervals, float vertDataRange, float border)
{
  textSize(12);
  stroke(200, 200, 200);
  fill(200, 200, 200);

  // Draw the horizontal axis
  stroke(255, 0, 0);
  line(border, height - border, width - (border * 2), height - border);

  float horizontalWindowRange = (width - (border * 2.0f));
  float horizontalDataGap = google.data.size() / horizontalIntervals;
  float horizontalWindowGap = horizontalWindowRange / horizontalIntervals;
  float tickSize = border * 0.1f;

  float firstYear = google.year.get(0);

  // Draw the ticks
  for (int i = 0; i < horizontalIntervals; i ++)
  {

    float x = border + (i * horizontalWindowGap);
    line(x, height - (border - tickSize), x, (height - border));
  }

  for (int i = 0; i < horizontalIntervals; i += 2) {
    float x = border + (i * horizontalWindowGap);
    float textY = height - (border * 0.5f);
    // Print every two years
    textAlign(CENTER, CENTER);
    text((int)(firstYear + i * horizontalDataGap), x, textY);
  }

  // Draw the vertical axis
  line(border, border, border, height - border);

  float verticalDataGap = vertDataRange / verticalIntervals;
  float verticalWindowRange = height - (border * 2 );
  float verticalWindowGap = verticalWindowRange / verticalIntervals;

  for (int i = 0; i <= verticalIntervals; i ++)
  {
    //draw vertical ticks
    float y = (height - border) - (i * verticalWindowGap);
    line(border - tickSize, y, border, y);
    float hAxisLabel = verticalDataGap * i;

    textAlign(RIGHT, CENTER);
    text(round(hAxisLabel), border - (tickSize * 2.0f), y);
  }
  textSize(15);
}

void loadData() {

  String[] lines = loadStrings("newData.txt");

  for (int i = 0; i < lines.length; i++)
  {
    String[] elements = lines[i].split("\t");

    //add year column to year field of each instance
    google.year.add(Integer.parseInt(elements[0]));
    apple.year.add(Integer.parseInt(elements[0]));
    microsoft.year.add(Integer.parseInt(elements[0]));

    //append corresponding value column to data array of each instance
    google.data.add(Integer.parseInt(elements[1]));
    apple.data.add(Integer.parseInt(elements[2]));    
    microsoft.data.add(Integer.parseInt(elements[3]));
  }
}