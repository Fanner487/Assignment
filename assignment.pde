import controlP5.*;
ArrayList<Company> companies = new ArrayList<Company>();

//instantiate each one first, then add values into its respective arrays then add to companies ArrayList
Company google = new Company("Google", color(0, 0, 255));
Company apple = new Company("Apple", color(255));
Company microsoft = new Company("Microsoft", color(255, 0, 0));
float centX, centY, highest, border, bX, bY;
boolean lineG, scatG, otherG, doughG, barG = false; // flags to determine what graphs get displayed in draw()
int bWidth= 150;
int bHeight = 50;
int imageWidth = 400; //image height and width
int imageHeight = 200;
int doughnutSlider = 2001; //makes value in slider an integer
PFont font;
PImage googleImg, appleImg, microsoftImg;
int dataIndexRange;

//buttons and slider
ControlP5 cp5;
Button line, scatter, coxComb, doughnut, bar, back; 
Slider dnSlider;

void setup()
{
  size(1366, 700);
  background(0);
  smooth();

  font = createFont("CopperplateGothic-Bold-15.vlw", 32);
  textFont(font);
  googleImg = loadImage("Google-logo.png");
  appleImg = loadImage("apple.png");
  microsoftImg = loadImage("microsoft.png");

  loadData();
  companies.add(google);
  companies.add(apple);
  companies.add(microsoft);
  dataIndexRange = google.data.size(); //used for iterating through arrays

  border = width * 0.05f;
  centX = height * 0.5f; //x and y coordinates used by table, coxcomb graph and doughnut charts
  centY = height * 0.5f;
  bX = width * 0.45f; // width and height of buttons
  bY = height * 0.8f;

  cp5 = new ControlP5(this);

  //instantiate buttons and slider
  line = cp5.addButton("Line Graph").setPosition(bX - (bWidth * 2), bY).setSize(bWidth, bHeight);
  scatter = cp5.addButton("Scatter Graph").setPosition(bX - bWidth, bY).setSize(bWidth, bHeight);
  coxComb = cp5.addButton("Bar Chart").setPosition(bX, bY).setSize(bWidth, bHeight);
  doughnut = cp5.addButton("Doughnut Chart").setPosition(bX + bWidth, bY).setSize(bWidth, bHeight);
  bar = cp5.addButton("Other").setPosition(bX + (bWidth * 2), bY).setSize(bWidth, bHeight);
  back = cp5.addButton("Back").setPosition(width - 130, height - 30).setSize(bWidth - 20, bHeight - 20);
  dnSlider = cp5.addSlider("doughnutSlider").setPosition(10, height - 40).setSize(300, 20).setRange(2001, 2015).setValue(google.year.get(0)).setNumberOfTickMarks(dataIndexRange).setSliderMode(Slider.FLEXIBLE);

  //only show menu options
  back.hide();
  dnSlider.hide();
  
  //display values 
  for(int i = 0; i < companies.size(); i++)
  {
    companies.get(i).display();
  }
}

void draw()
{ 
  background(0);
  textAlign(LEFT);
  fill(255);
  textSize(20);
  text("Data Visualisation of How Many Companies", 50 + imageWidth, 110);
  image(googleImg, 150, 100, imageWidth, imageHeight + 100);
  image(appleImg, 150 + imageWidth, 150, imageHeight  + 20, imageHeight - 20);
  image(microsoftImg, 150 + (imageWidth  * 1.5f), 60, (imageHeight * 2) + 100, imageHeight * 2);
  text("Have Acquired Since 2001", 125 + imageWidth, 200 + imageHeight );

  int x = mouseX; // used to pass into drawLineAndFigures()

  if (lineG == true) {

    background(0);
    title("Line Graph");
    drawAxis(dataIndexRange, 10, maxValue());
    for (int i = 0; i < companies.size(); i++)
    {
      companies.get(i).drawTrendGraph();      
      companies.get(i).averageLine();
    }
    drawLineAndFigures(x);
  }

  if (scatG == true) {
    background(0);
    title("Scatter Plot");
    drawAxis(dataIndexRange, 10, maxValue());
    //change this using a for loop
    scatterGraph();
  }

  if (otherG == true) {
    background(0);
    title("Other Information");
    drawCoxComb();

    pushMatrix();
    translate(width * 0.35f, -(height * 0.2f));
    drawTable();
    popMatrix();
  }

  if (doughG == true) {
    background(0);
    title("Doughnut Charts");
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
    drawAxis(dataIndexRange, 10, maxValue());
    drawBarChart();
  }
}//end draw

void title(String x)
{
  fill(255);
  textAlign(CENTER);
  textSize(20);
  text(x, width /2, 30);
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

  //title above table
  text("More information", centX * 1.6f, centY - 10);

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

//displays company names and colours at top right of graph
void drawCompanies()
{
  float spacing = 30;
  float offset = 10;
  for (int i = 0; i < companies.size(); i++)
  {
    fill(companies.get(i).colour);
    textAlign(LEFT, TOP);
    textSize(20);
    text(companies.get(i).name, border + offset, border + (spacing * i));
  }
}

void drawBarChart()
{
  float barWidth = 15;
  float offset = 3; // gap between each bar
  float r = 10; //setting radius on top

  drawCompanies();

  for (int i = 0; i < dataIndexRange; i ++)
  {
    for (int j = 0; j < companies.size(); j++) 
    {
      Company company = companies.get(j);
      //maps colour of company to value.
      float col = map(company.data.get(i), 0, maxValue(), 255, 100);

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

      float x = map(i, 0, dataIndexRange, border, width - (border));
      float y = map(companies.get(j).data.get(i), 0, maxValue(), border, height - (border* 2));
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
  
  float offset = 10;
  float textX = border + offset;
  float y = border;
  //only executes if x is within borders of graph
  if (x > border && x < width - (border * 2)) {
    //num maps passed in mouseX value and maps to integer index in data array range
    int num = (int)map(x, border, width - border, 0, dataIndexRange);

    if (x >= border && x <= width - (border * 2)) {
      stroke(255);
      text(google.year.get(num), textX, y);
      for (int i = 0; i < companies.size(); i++) {
        stroke(companies.get(i).colour);
        fill(companies.get(i).colour);
        text(companies.get(i).name + ": " + companies.get(i).data.get(num), textX, y + (30 * (i + 1)));
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
        text(companies.get(i).name + ": " + companies.get(i).data.get(dataIndexRange -1 ), textX, y + (30 * i));
      }
    }
  }
}

void scatterGraph()
{
  //displays copmanies at top left handd of graph
  drawCompanies();
  
  for (int i = 0; i < dataIndexRange; i ++)
  {
    float size = 100;
    float x, y;
    int count = 0; //used for rotating semi circle. If it is 1 then rotate in the loop.
    float[] sizeComp = new float[3];
    float[] values = new float[3];

    for (int j = 0; j < companies.size(); j++) {

      sizeComp[j] = map(companies.get(j).data.get(i), 0, maxValue(), 0, size);
      values[j] = companies.get(j).data.get(i);
    }

    //if Google and Apple values are the same at same year, draw semi circle for both values so both get shown
    if (google.data.get(i) == apple.data.get(i)) {

      //draws semicircles
      for (int p = 0; p < 2; p ++) {
        stroke(companies.get(p).colour);
        fill(companies.get(p).colour);

        pushMatrix();
        //maps x and y coordinates to the Scatter Graph to each element
        x = map(i, 0, dataIndexRange, border, width - border);
        y = map(values[p], 0, maxValue(), height - border, border);
        translate(x, y);

        //Only rotates semi-circle every two iterations
        if (count == 1) {
          rotate(PI);
        }      

        arc((float)0, 0, sizeComp[p], sizeComp[p], 0, PI);
        popMatrix();

        count++;
      }

      //draw remaining point
      x = map(i, 0, dataIndexRange, border, width - border);
      y = map(microsoft.data.get(i), 0, maxValue(), height - border, border);
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
        x = map(i, 0, dataIndexRange, border, width - border);
        y = map(values[p], 0, maxValue(), height - border, border);
        translate(x, y);

        if (count == 1) {
          rotate(PI);
        }

        arc((float)0, 0, sizeComp[p], sizeComp[p], 0, PI);
        popMatrix();
        count++;
      }

      //draws remaining point
      x = map(i, 0, dataIndexRange, border, width - border);
      y = map(apple.data.get(i), 0, maxValue(), height - border, border);
      stroke(apple.colour);
      fill(apple.colour);
      ellipse((float)x, y, sizeComp[1], sizeComp[1]);
    } else if (apple.data.get(i) == microsoft.data.get(i)) {

      for (int p = 1; p < 3; p ++) {
        stroke(companies.get(p).colour);
        fill(companies.get(p).colour);
        pushMatrix();
        x = map(i, 0, dataIndexRange, border, width - border);
        y = map(values[p], 0, maxValue(), height - border, border);
        translate(x, y);
        
        if (count == 1) {
          rotate(PI);
        }  
        
        arc((float)0, 0, sizeComp[p], sizeComp[p], 0, PI);
        popMatrix();
        count++;
      }
      
      //draws remaining point
      x = map(i, 0, dataIndexRange, border, width - border);
      y = map(google.data.get(i), 0, maxValue(), height - border, border);
      stroke(google.colour);
      fill(google.colour);
      ellipse((float)x, y, sizeComp[0], sizeComp[0]);
    }
    //or normally draw circles at three points
    else {
      y = 0;
      
      for (int k = 0; k < companies.size(); k++) {
        x = map(i, 0, dataIndexRange, border, width - border);
        y = map(values[k], 0, maxValue(), height - border, border);
        stroke(companies.get(k).colour);
        fill(companies.get(k).colour);
        ellipse((float)x, y, sizeComp[k], sizeComp[k]);
      }
    }
  }
}

void drawCoxComb()
{
  float newX, newY;
  newX = centX;
  newY = centY;
  //get mouse coordinates in relation to centre of circle
  float toMouseX = mouseX - centX;
  float toMouseY = mouseY - centY;
  float angle = atan2(toMouseY, toMouseX);
  float thetaPrev = 0;
  float totalOfThree = 0;
  
  textSize(15);
  text("CoxComb chart on % companies bought by each (angle)\n and standard deviation of each company (height)", centX, 80);
  //mapping negative angle into positive
  if (angle < 0)
  {
    angle = map(angle, -PI, 0, PI, TWO_PI);
  }

  //adding all sums of companies to sum 
  for (int i = 0; i < companies.size(); i ++)
  {
    totalOfThree += companies.get(i).sum();
  }

  for (int i = 0; i < companies.size(); i ++)
  {
    Company select = companies.get(i);
    //maps out the standard deviation of all companies to Googles. This maps how far out the standard deviation goes
    float mapX = map(select.standardDev(), 0, google.standardDev(), 0, centX);
    float mapY = map(select.standardDev(), 0, google.standardDev(), 0, centY);
    
    //angle determines how many companies they bought in proportion to total companies bought by the three.
    float theta = map(select.sum(), 0, totalOfThree, 0, TWO_PI);

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
    textSize(12);
    textAlign(CENTER); 
    //maps percentage of companies bought to total companies bought
    text(select.name + ": " + (int)map(select.sum(), 0, totalOfThree, 0, 100) + "%", x, y);
    text("Std Dev: " + select.standardDev(), x, y + 20);
    stroke(select.colour);
    fill(select.colour); 
    arc(centX, centY, mapX, mapY, thetaPrev, thetaNext);
    thetaPrev = thetaNext;
  }
}

void drawAxis(int horizontalIntervals, int verticalIntervals, float vertDataRange)
{
  textSize(12);
  stroke(200, 200, 200);
  fill(200, 200, 200);

  // Draw the horizontal axis
  stroke(255, 0, 0);
  line(border, height - border, width - (border * 2), height - border);

  float horizontalWindowRange = (width - (border * 2.0f));
  float horizontalDataGap = dataIndexRange / horizontalIntervals;
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

float maxValue()
{
  float max = 0;
  for (int i = 0; i < companies.size(); i++)
  {
    for (int j = 0; j < dataIndexRange; j++)
      if (companies.get(i).data.get(j) > max)
      {
        Company company = companies.get(i);
        max = company.data.get(j);
      }
  }

  return max;
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

//Show/hide buttons and set flags on what graphs can be drawn in draw()
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
    
    lineG = true;
    scatG = false;
    doughG = false;
    otherG = false;
    barG = false;
  }

  if (theEvent.getName().equals("Values")) {
    //back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    bar.hide();
    dnSlider.hide();
    doughnut.hide();
    
    lineG = false;
    scatG = false;
    doughG = false;
    otherG = false;
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
    
    lineG = false;
    scatG = false;
    doughG = false;
    otherG = false;
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

    lineG = false;
    scatG = true;
    doughG = false;
    otherG = false;
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


    lineG = false;
    scatG = false;
    doughG = true;
    otherG = false;
    barG = false;
  }

  if (theEvent.getName().equals("Other")) {

    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    doughnut.hide();
    bar.hide();
    dnSlider.hide();
    
    lineG = false;
    scatG = false;
    doughG = false;
    otherG = true;
    barG = false;
  }

  if (theEvent.getName().equals("Back")) {
    line.show();
    scatter.show();
    coxComb.show();
    doughnut.show();
    bar.show();
    back.hide();
    dnSlider.hide();
    
    lineG = false;
    scatG = false;
    doughG = false;
    otherG = false;
    barG = false;
  }

  if (theEvent.getName().equals("Bar Chart")) {
    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    doughnut.hide();
    bar.hide();

    lineG = false;
    scatG = true;
    doughG = false;
    otherG = false;
    barG = true;
  }
}