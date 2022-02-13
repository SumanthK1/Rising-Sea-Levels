int n=100; //number of cells (changeable)
float fps=3  ; //frames per second (changeable)
int numIslands=5; //maximum number of islands (changeable)
int maxIslandSize=18; // maximum size for an island (changeable)                                                                                    
int[][] cells=new int[n][n]; //current cell array
int [][] cellsNext=new int[n][n]; //upcoming cell array
int cellSize; //size of each cell

void setup(){
  size(1000,1000); //grid size (changeable)  
  frameRate( fps );
  noStroke();

  cellSize=(width/n)+1;
  for(int x=0;x<numIslands;x++){
    plantIsland(); //drawing islands depending on number specified
  }
}

void draw() { //1=dark blue, 2=light blue, 3=sand
    for(int i=0; i<n; i++) {
      float y=i*height/n;
      for(int j=0; j<n; j++) {
        float x=j*width/n;        
        if (cells[i][j]==3){ //3 means sand
          fill(int(random(200,219)), int(random(195,210)), int(random(170,200))); //(changeable)
        }
        else if(cells[i][j]==2){ //if cell is 2(light blue), make it 1 (dark blue) next
          fill(130, 198, 250); //(changeable)
          cellsNext[i][j]=1; //dark blue     
        }
        else
          fill(int(random(1,40)),int(random(27,40)),int(random(80,130))); //remaining water cells all around (changeable)         
        rect(x, y, cellSize, cellSize);
      }       
    } 
    setNextGeneration();
    copyNextGenerationToCurrentGeneration();
    textPlate();
}

void plantIsland() {
  //creating random values for island starting point
  int x=int(random(0,n));
  int y=int(random(0,n));
  int iSize=int(random(3,maxIslandSize));                                    
  cells[x][y]=3;                                                            
  
  //expanding the island outwards to a perfect square
  for(int a = -iSize; a <= iSize; a++) {
    for(int b = -iSize; b <= iSize; b++) {
      try{
          cells[x+a][y+b] = 3;
      }
      catch(Exception e){}
    }
  }
  
  //creates random speckle effect on the perimeter of the island                                                                          
  for(int a = -iSize-3; a <= iSize+3; a++) { //the 3 can be increased for more randomness on the edges, like more mini islands being created,
    for(int b = -iSize-3; b <= iSize+3; b++) { //or decreased to make the island more perfect (changeable)
      try{
        int randd = int(random(0,2)); //50% chance of a random island speckle occuring at the edges of the island (changeable)     
        if(randd == 0)
          cells[x+a][y+b] = 3;
      }
      catch(Exception e){}
    }
  }
}

void setNextGeneration(){
  //finding water thats touching each cell
  for(int i=0; i<n; i++) {  
    for(int j=0; j<n; j++) {
      int numWaterNeighbours=countWaterNeighbours(i,j);
      
      //if there are 3 or more water cells next to a sand cell, there is a 50% it will become water                          
      if (cells[i][j]==3){
       if(numWaterNeighbours>=3){
         int randWater=int(random(0,2)); //probability of sand becoming light blue water (changeable)
         if(randWater==0)
           cellsNext[i][j]=2; //make the sand cell light blue water
       }
       else
         cellsNext[i][j]=3; //keep it sand      
      }       
    }
   }
}

int countWaterNeighbours(int i,int j) { //counting how many water cells are touching current cell            
  int count=0;
  for(int a=-1; a<=1; a++) {
    for(int b=-1; b<=1; b++) {
      
      try {
        if (cells[i+a][j+b] != 3 && !(a==0 && b==0)) //if the cell is not sand and it is not the middle cell
          count++;    
      }   
      catch(Exception e) {
      }
    }
  } 
  return count;
}

void copyNextGenerationToCurrentGeneration() { //overwriting cells with new cells
    for(int i=0; i<n; i++) 
      for(int j=0; j<n; j++) 
        cells[i][j] = cellsNext[i][j];
}

void textPlate(){ //title
    fill(255);
    textSize((width+height)/75);
    text("Disappearing Islands Due To Rising Sea Levels", width/4.5, height/20);
  }
