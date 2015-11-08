class Year
{
  
  int y;
  int google;
  int apple;
  int microsoft;
  color c;
  
  Year(String line)
  {
    
    String[] elements = line.split("\t");
    
    y = Integer.parseInt(elements[0]);
    google = Integer.parseInt(elements[1]);
    apple = Integer.parseInt(elements[2]);
    microsoft = Integer.parseInt(elements[3]);
    c = color(random(0, 255), random(0, 255), random(0, 255));
    
  }
  
  void display(){
    
    println(this.y + "- " + "Google: " + this.google + " Apple: " + this.apple + " Microsoft: "  + this.microsoft); 
    
  }
    
  
}
