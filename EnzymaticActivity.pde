//PARAMETERS
int size = 50; //number of cells along one side of screen
float framesPerSec = 10; //frame rate
float enzymeSaturation = 0.02; //enzyme concentration at start
float substrateSaturation = 0.15; //substrate concentration at start
float catalyzeParam = 1; //probability of enzymatic catalysis: 0 - never, 1 - certain
float feedbackParam = 0.5; //the rate of increase of the probability of feedback inhibition: 0 - no feedback inhibition, 1 - increases at same rate as product concentration

//TYPES OF PARTICLES
int inhibited = 4;
int product = 3;
int enzyme = 2;
int sub = 1;
int space = 0;

//GLOBAL VARIABLES
int[][] cellsNow = new int[size][size];
float numCells = pow(size, 2);
int numproducts = 0;
int order = 1;
IntList substrate, products, empty;
int randCell;
float rand;


void setup() {
  size(800, 800);
  frameRate(framesPerSec);
  noStroke();

  //INITIAL SETUP OF ARRAY
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      rand = random(1); 
      if (rand < enzymeSaturation) cellsNow[i][j] = enzyme; 
      else if (rand < enzymeSaturation+substrateSaturation) cellsNow[i][j] = sub;
      else cellsNow[i][j] = space;
    }
  }
}

void draw() {
  background(255);

  //DRAWING THE CELLS
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      if (cellsNow[i][j] == inhibited) {
        fill(0);
        rect(i*width/size, j*width/size, width/size, width/size);
      } else if (cellsNow[i][j] == product) {
        fill(0, 255, 0);
        rect(i*width/size, j*width/size, width/size, width/size);
      } else if (cellsNow[i][j] == enzyme) {
        fill(255, 0, 0);
        rect(i*width/size, j*width/size, width/size, width/size);
      } else if (cellsNow[i][j] == sub) {
        fill(0, 0, 255);
        rect(i*width/size, j*width/size, width/size, width/size);
      }
    }
  }

  //UPDATE FUNCTIONS; the reason I wrote these changes as separate functions and not as one function
  //is because I need to do all the catalysis first before I run inhibition, and all inhibition before I move, or the cells tend to follow a pattern/move one way
  //this means I have to iterate through CellsNow three times but I don't think there's an alternative
  enzymaticActivity();
  feedbackInhibition();
  move();
  order = -order;
}

void enzymaticActivity() {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) { //for every cell on the screen
      if (cellsNow[i][j] == enzyme) { // if the cell is an enzyme
        substrate = countCells(sub, i, j); //count the number of substrates nearby
        if (substrate.size() >= 4) { // if there are more than 2 substrates nearby (4 values in the array);
          rand = random(0, 1); //pick a number
          if (rand < catalyzeParam) { //if the number is less than the probability, it's catalyzing time!

            //pick a substrate that the enzyme is touching and set it to a product
            randCell = int(random(0, substrate.size()/2));
            cellsNow[substrate.get(randCell*2)][substrate.get(randCell*2+1)] = product;
            numproducts++;
            substrate.remove(randCell*2+1); //so that the same cell doesn't get picked again
            substrate.remove(randCell*2);

            //pick another substrate that the enzyme is touching and set it to blank
            randCell = int(random(0, substrate.size()/2));
            cellsNow[substrate.get(randCell*2)][substrate.get(randCell*2+1)] = space;
          }
        }
      }
    }
  }
}

void feedbackInhibition() {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) { //for every cell on the screen
      if (cellsNow[i][j] == enzyme) { //if the cell is an enzyme
        products = countCells(product, i, j); //count the number of products nearby
        if (products.size() >= 2) { // if there is at least 1 substrate nearby (2 values in the array);
          rand = random(0, 1); // pick a random number
          if (rand < feedbackParam*numproducts/numCells) { // if the number is less than the product concentration times feedbackParam, it's inhibition time!

            //pick a product that the enzyme is touching and set it to blank, then set the enzyme to inhibited 
            randCell = int(random(0, products.size()/2));
            cellsNow[products.get(randCell*2)][products.get(randCell*2+1)] = space;
            cellsNow[i][j] = inhibited; 
            numproducts--;
          }
        }
      }
    }
  }
}

void move() { //switches iteration order every frame to allow for random movement
  if (order == 1) {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) { // for every cell in the array
        if (cellsNow[i][j] != 0) { // if the cell isn't blank
          empty = countCells(0, i, j); // count blanks nearby
          if (empty.size() >= 2) { // if there is at least one blank
            randCell = int(random(0, empty.size()/2)); // select random blank cell and set it to whatever the current cell is
            cellsNow[empty.get(randCell*2)][empty.get(randCell*2+1)] = cellsNow[i][j];
            cellsNow[i][j] = space; // set current cell to blank
          }
        }
      }
    }
  } else { // same as above except in reverse iteration order
    for (int i = size-1; i > -1; i--) {
      for (int j = size-1; j > -1; j--) {
        if (cellsNow[i][j] != 0) {
          empty = countCells(0, i, j);
          if (empty.size() >= 2 && cellsNow[i][j] != 0) {
            randCell = int(random(0, empty.size()/2));
            cellsNow[empty.get(randCell*2)][empty.get(randCell*2+1)] = cellsNow[i][j];
            cellsNow[i][j] = space;
          }
        }
      }
    }
  }
}

IntList countCells(int type, int i, int j) {
  IntList count = new IntList();
  for (int a = -1; a < 2; a++) {
    for (int b = -1; b < 2; b++) {
      try {
        if (cellsNow[i + a][j + b] == type && (b !=0 || a !=0)) {
          count.append(i+a);
          count.append(j+b);
        }
      }
      catch( Exception e) {
      }
    }
  }
  return count;
}
