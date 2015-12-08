class Company {

  ArrayList<Integer> data = new ArrayList<Integer>();
  ArrayList<Integer> year = new ArrayList<Integer>();
  color colour;
  String name;

  Company(String comp, color c)
  {   
    this.colour = c;
    this.name = comp;
  }
  
  //displays the data
  void display() {

    println("\n\n" + name + ":");

    for (int i = 0; i < this.data.size(); i++)
    {
      println(this.year.get(i) + ": " + this.data.get(i));
    }

    println("Sum: " + this.sum());
    println("Average: " + this.average());
    println("Max: " + this.maximum() + "Min: " + this.minimum());
  }

  float sum() {

    float sum = 0;

    for (int i = 0; i < this.data.size(); i++)
    {
      sum += this.data.get(i);
    }

    return sum;
  }

  float maximum()
  {
    float max = 0;

    for (int i = 0; i < this.data.size(); i++)
    {
      if (this.data.get(i) > max)
      {
        max = this.data.get(i);
      }
    }

    return max;
  }

  float average() {

    float sum = this.sum();  
    float avg = sum / this.data.size();

    return avg;
  }

  float minimum() {

    float min = this.data.get(0);

    for (int i = 0; i < this.data.size(); i++) {

      if (this.data.get(i) < min)
      {
        min = this.data.get(i);
      }
    }

    return min;
  }
  
  float standardDev()
  {
    float temp[] = new float[this.data.size()];
    float sum = 0;
    float result;
    
    //square the result of each element in data array minus the mean and add it to sum
    for(int i = 0; i < this.data.size(); i++){
      
     sum += sq((this.data.get(i) - this.average())); 
    
    }
    
    //gett average of square results
    result = sqrt(sum / this.data.size());
    return result;
    
  }
  
  float correlation()
  {
    float[] temp = new float[this.data.size()];
    float[] x = new float[this.data.size()];
    float[] y = new float[this.data.size()];
    float sumX = 0;
    float avgX = 0;
    float aMultB = 0;
    float aSquared = 0;
    float bSquared = 0;
    float result;
    
    //getting mean of years
    for(int i = 0; i < this.year.size(); i++){    
     temp[i] = this.year.get(i) - 2000;
     
     sumX += temp[i];
    }
    avgX = sumX / this.year.size();
    
    for(int i = 0; i < this.year.size(); i++){    
      x[i] = temp[i] - avgX;
      y[i] = this.data.get(i) - this.average();
      println("x[" + i + "]: " + x[i] + "y[" + i + "]: " + y[i]);
      aMultB += (x[i] * y[i]);
      aSquared += sq(x[i]);
      bSquared += sq(y[i]);
    }
    
    
  result = aMultB / sqrt(aSquared * bSquared);
  return result;
  }
  
  //draws average line in line graph
  void averageLine()
  {
    stroke(this.colour);
    fill(this.colour);
    float x1 = border;
    float x2 = width - (border * 2);
    float y1 = map(this.average(), 0, google.maximum(), height - border, border);
    line(x1, y1, x2, y1);
  }
  
  //draws the line graph
  void drawTrendGraph() {

    for (int i = 1; i < google.data.size(); i ++)
    {
      stroke(this.colour);
      fill(this.colour);

      float x1 = map(i-1, 0, google.data.size(), border, width - border);
      float x2 = map(i, 0, google.data.size(), border, width - border);
      float y1 = map(this.data.get(i-1), 0, google.maximum(), height - border, border);
      float y2 = map(this.data.get(i), 0, google.maximum(), height - border, border);

      line((float)x1, y1, (float)x2, y2);
    }
  }

  void drawPieChart(float value)
  {
    float thetaPrev = 0;
    float scale = 0.8;
    float size = 170;
    float sum = 0;
    float max = 0;
    float theta = 0;
    float col = 0;
    float num = value - 2001;

    sum = this.sum();
    max = this.maximum();

    for (int i = 0; i < this.data.size(); i ++)
    {
      fill(this.colour);
      stroke(this.colour);
      theta = map(this.data.get(i), 0, sum, 0, TWO_PI);

      textAlign(CENTER);
      col = map(this.data.get(i), 0, max, 255, 100);

      float thetaNext = thetaPrev + theta;
      float radius = centX * 0.55f;
      float x = ((centX) + sin(thetaPrev + (theta * 0.5f) + HALF_PI) * radius);      
      float y = ((centY) - cos(thetaPrev + (theta * 0.5f) + HALF_PI) * radius);
      fill(255);
      
      //takes slider value and displays value at corresponding doughnut chart position and expand element size
      if (i == num) {
        text(this.year.get((int)num) + ": " + (int)map(this.data.get((int)num), 0, this.sum(), 0, 100) + "%", x, y);
        scale = 0.9f;
      }
      else{
        scale = 0.8f;
      }
      
      //Checks the name field of class and determines the fill and stroke of the arc
      if (this.name.equals("Google")) {      
        stroke(127);
        fill(0, col, col);
      } else if (this.name.equals("Apple")) {
        stroke(127);
        fill(col, col, col);
      } else if (this.name.equals("Microsoft")) {
        stroke(127);
        fill(col, 0, 0);
      }

      arc(centX, centY, centX * scale, centY * scale, thetaPrev, thetaNext, PIE);
      thetaPrev = thetaNext;

      fill(0);
      //draws circle on inside of circle to make it a doughnut chart
      ellipse(centX, centY, size, size);
      fill(this.colour);
      text(this.name, centX, centY);
    }
  }
}//end class