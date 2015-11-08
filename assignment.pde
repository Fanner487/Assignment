void setup()
{
   size(500, 500);
   
   loadData();
   displayFigures();
   
}

ArrayList<Year> years = new ArrayList<Year>();

void draw()
{
   
  
}

void displayFigures(){

  for(int i = 0; i < years.size(); i++){
    
    Year select  = years.get(i);
    select.display();
  }
  
  
}

void loadData(){
  
  String[] lines = loadStrings("newData.txt");
  
  for(int i = 0; i < lines.length; i++)
  {
    Year year = new Year(lines[i]);
    years.add(year); 
  }
}

