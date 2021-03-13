import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_MINES = 40;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean game_over = false;
private int check_tiles = NUM_ROWS*NUM_COLS - NUM_MINES;

public void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int j = 0; j < buttons.length; j++){
      for (int i = 0; i < buttons[j].length; i++){
        buttons[j][i] = new MSButton(j, i);
    }
    }
    for (int i = 0; i < NUM_MINES; i++){
      setMines();
    }
}
public void setMines()
{
    int row = (int)(Math.random()*20);
    int col = (int)(Math.random()*20);
    if (mines.contains(buttons[row][col]) == false){
      mines.add(buttons[row][col]);
    }
    else{
      setMines();
    }
    
}

public void draw ()
{
    background( 0 );
    if(isWon() == true){
        displayWinningMessage();
    }
}
public boolean isWon()
{
    if (check_tiles == 0){
      return true;
    }
    return false;
}
public void displayLosingMessage()
{
    for (int n = -4; n < 4; n++){
      buttons[NUM_ROWS/2][(NUM_COLS/2)+n].special = true;
    }
    for (int j = 0; j < NUM_ROWS; j++){
      for (int i = 0; i < NUM_COLS; i++){
        if (mines.contains(buttons[j][i])){
              buttons[j][i].clicked = true;
              buttons[j][i].setLabel("x");
        }
      }
    }
    buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("Y");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("O");
    buttons[NUM_ROWS/2][(NUM_COLS/2-2)].setLabel("U");
    buttons[NUM_ROWS/2][(NUM_COLS/2-1)].setLabel("");
    buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("L");
    buttons[NUM_ROWS/2][(NUM_COLS/2+1)].setLabel("O");
    buttons[NUM_ROWS/2][(NUM_COLS/2+2)].setLabel("S");
    buttons[NUM_ROWS/2][(NUM_COLS/2+3)].setLabel("E");
    game_over = true;
}
public void displayWinningMessage()
{
    for (int n = -4; n < 4; n++){
      buttons[NUM_ROWS/2][(NUM_COLS/2)+n].special = true;
    }
    buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("Y");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("O");
    buttons[NUM_ROWS/2][(NUM_COLS/2-2)].setLabel("U");
    buttons[NUM_ROWS/2][(NUM_COLS/2-1)].setLabel("");
    buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("W");
    buttons[NUM_ROWS/2][(NUM_COLS/2+1)].setLabel("I");
    buttons[NUM_ROWS/2][(NUM_COLS/2+2)].setLabel("N");
    buttons[NUM_ROWS/2][(NUM_COLS/2+3)].setLabel("!"); 
    game_over = true;
}
public boolean isValid(int r, int c)
{
    if (((r < NUM_ROWS && r >= 0) && (c < NUM_COLS && c >= 0))){
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int j = row - 1; j <= (row + 1); j++){
      for (int i = col - 1; i <= (col + 1); i++){
        if (!((j == row) && (i == col))){
            if (isValid(j, i) == true && mines.contains(buttons[j][i])){
              numMines++;
            }
        }
      }
  }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged, special;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = special = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      if (game_over == false){
        clicked = true;
        check_tiles--;
        if (mouseButton == RIGHT){
          flagged = !flagged;
          if (flagged == false){
            clicked = false;
          }
        }
        else if (mines.contains(this)){
          displayLosingMessage();
        }
        else if (countMines(myRow, myCol) > 0){
          myLabel = "" + countMines(myRow, myCol);
        }
        else{
  
          if (isValid(myRow, myCol + 1) && buttons[myRow][myCol+1].clicked == false){
            buttons[myRow][myCol+1].mousePressed();
          }
          if (isValid(myRow + 1, myCol) && buttons[myRow + 1][myCol].clicked == false){
            buttons[myRow+1][myCol].mousePressed();
          }
          if (isValid(myRow, myCol - 1) && buttons[myRow][myCol-1].clicked == false){
            buttons[myRow][myCol-1].mousePressed();
          }
          if (isValid(myRow - 1, myCol) && buttons[myRow - 1][myCol].clicked == false){
            buttons[myRow-1][myCol].mousePressed();
          }
          if (isValid(myRow + 1, myCol + 1) && buttons[myRow + 1][myCol+1].clicked == false){
            buttons[myRow+1][myCol+1].mousePressed();
          }
          if (isValid(myRow - 1, myCol - 1) && buttons[myRow - 1][myCol-1].clicked == false){
            buttons[myRow-1][myCol-1].mousePressed();
          }
          if (isValid(myRow + 1, myCol - 1) && buttons[myRow + 1][myCol-1].clicked == false){
            buttons[myRow+1][myCol-1].mousePressed();
          }
          if (isValid(myRow - 1, myCol+1) && buttons[myRow - 1][myCol+1].clicked == false){
            buttons[myRow-1][myCol+1].mousePressed();
          }
      
        }
      }
        
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if (special)
            fill(0,100,255);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );
        

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
     
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
