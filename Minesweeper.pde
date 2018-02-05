import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
int rows = 20;
int columns = 20;
boolean isLost = false;
int tileCount = 0;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton [rows] [columns];
    bombs = new ArrayList <MSButton>();
    //your code to declare and initialize buttons goes here
    for(int i = 0;i<columns;i++)
    {
        for(int j = 0; j < rows;j++){
            buttons[j][i]= new MSButton(j,i);
    }
}
    
    
    setBombs();
}
public void setBombs()
{  for (int i = 0; i < 50; i++) {
    final int r1 = (int)(Math.random()*20);
    final int r2 = (int)(Math.random()*20);
    if ((bombs.contains (buttons[r1][r2])) == false) {
      bombs.add(buttons[r1][r2]);
    }
    else {i +=-1;}
}
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{  
  
  return false;
}
public void displayLosingMessage()
{  
    
    for(int i=0;i<bombs.size();i++)
        if(bombs.get(i).isClicked()==false)
            bombs.get(i).mousePressed();
    isLost = true;
    buttons[rows/2][(columns/2)-4].setLabel("Y");
    buttons[rows/2][(columns/2)-3].setLabel("O");
    buttons[rows/2][(columns/2-2)].setLabel("U");
    buttons[rows/2][(columns/2-1)].setLabel("");
    buttons[rows/2][(columns/2)].setLabel("L");
    buttons[rows/2][(columns/2+1)].setLabel("O");
    buttons[rows/2][(columns/2+2)].setLabel("S");
    buttons[rows/2][(columns/2+3)].setLabel("E");
}
public void displayWinningMessage()
{
    isLost = true;
    buttons[rows/2][(columns/2)-4].setLabel("Y");
    buttons[rows/2][(columns/2)-3].setLabel("O");
    buttons[rows/2][(columns/2-2)].setLabel("U");
    buttons[rows/2][(columns/2)].setLabel("W");
    buttons[rows/2][(columns/2+1)].setLabel("I");
    buttons[rows/2][(columns/2+2)].setLabel("N");
    buttons[rows/2][(columns/2+3)].setLabel("!");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
         width = 400/columns;
         height = 400/rows;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
      if (isLost == false) {
        
        //if(marked) {clicked = false;}
        if (mouseButton == RIGHT) {
          marked = !marked;
          //if (!marked && bombs.contains(this)) {clicked = false;}
          //if (!marked && !bombs.contains(this)) {clicked = true;}
        }
        else if (marked == true) {}
        else if (bombs.contains(this)) {
          clicked = true;
          displayLosingMessage();
        }
        else if (countBombs(r,c) > 0) {
          label = ""+countBombs(r,c);
          if (!clicked) {tileCount+=1;}
          if (tileCount == 400-bombs.size()) {displayWinningMessage();}
          clicked = true;
        }
        else {
          //only running first case
          
          if (!clicked) {tileCount+=1;}
          if (tileCount == 400-bombs.size()) {displayWinningMessage();}
          clicked = true;
          
          if(isValid(r-1,c-1) && !buttons[r-1][c-1].isClicked()) {
          buttons[r-1][c-1].mousePressed();} 
          if(isValid(r-1,c) && !buttons[r-1][c].isClicked()) {
          buttons[r-1][c].mousePressed();}
          if(isValid(r-1,c+1) && !buttons[r-1][c+1].isClicked()){
          buttons[r-1][c+1].mousePressed();}
          
          if(isValid(r,c-1) && !buttons[r][c-1].isClicked()){
          buttons[r][c-1].mousePressed();}
          if(isValid(r,c+1) && !buttons[r][c+1].isClicked()){
          buttons[r][c+1].mousePressed();}
          
          if(isValid(r+1,c-1) && !buttons[r+1][c-1].isClicked()){
          buttons[r+1][c-1].mousePressed();}
          if(isValid(r+1,c) && !buttons[r+1][c].isClicked()){
          buttons[r+1][c].mousePressed();}
          if(isValid(r+1,c+1) && !buttons[r+1][c+1].isClicked()){
          buttons[r+1][c+1].mousePressed();}
        }
      }
    }

    public void draw () 
    {    
      if (marked)
            fill(0);
         
         else if( !marked && clicked && bombs.contains(this) ) 
             fill(255,0,0);
         else if( marked && bombs.contains(this) ) 
             fill(100);
         else if( !marked && clicked && !bombs.contains(this) ) 
             fill(200);
             
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r <rows && r >= 0 && c < columns && c >= 0) {return true;}
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if (isValid(row-1,col) == true && bombs.contains(buttons[row-1][col]))
        {
            numBombs++;
        }
        if (isValid(row+1,col) == true && bombs.contains(buttons[row+1][col]))
        {
            numBombs++;
        }
         if (isValid(row,col-1) == true && bombs.contains(buttons[row][col-1]))
        {
            numBombs++;
        }
         if (isValid(row,col+1) == true && bombs.contains(buttons[row][col+1]))
        {
            numBombs++;
        }
         if (isValid(row-1,col+1) == true && bombs.contains(buttons[row-1][col+1]))
        {
            numBombs++;
        }
         if (isValid(row-1,col-1) == true && bombs.contains(buttons[row-1][col-1]))
        {
            numBombs++;
        }
         if (isValid(row+1,col+1) == true && bombs.contains(buttons[row+1][col+1]))
        {
            numBombs++;
        }
         if (isValid(row+1,col-1) == true && bombs.contains(buttons[row+1][col-1]))
        {
            numBombs++;
        }
        return numBombs;
    }
}