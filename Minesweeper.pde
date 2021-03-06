import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(600, 600);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[20][20];
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r,c);
        }
    }
    
    
    
    setBombs();
}
public void setBombs()
{
    while (bombs.size() < NUM_BOMBS) {
        int r = (int)(Math.random() * 20);
        int c = (int)(Math.random() * 20);
        if (bombs.contains(buttons[r][c])) {
            r = (int)(Math.random()*20);
            c = (int)(Math.random()*20);
        }
        else {
            bombs.add(buttons[r][c]);
            //System.out.println(r + ", " + c);
        }
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
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (buttons[r][c].isClicked() == false && buttons[r][c].isMarked() == false) {
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    String losingMessage = "YOU LOSE";
    for (int i = 0; i < losingMessage.length(); i++) {
        buttons[10][i+6].setLabel(losingMessage.substring(i, i+1));
    }
    for (int row = 0; row < 20; row++) {
        for (int col = 0; col < 20; col++) {
            if (bombs.contains(buttons[row][col]) && buttons[row][col].isClicked() == false) {
                buttons[row][col].mousePressed();
            }
        }
    }
}
public void displayWinningMessage()
{
    String winningMessage = "YOU WIN ";
    for (int i = 0; i < winningMessage.length(); i++) {
        buttons[10][i+6].setLabel(winningMessage.substring(i, i+1));
    }
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
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
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton == RIGHT) {
            marked = !marked;
            if (marked == false) {
                clicked = false;
            }
        }
        else if (bombs.contains( this )) { 
            displayLosingMessage();
        }
        else if (countBombs(r, c) > 0) {
            label = ""+countBombs(r,c);
        }
        else {
            for (int row = r-1; row < r+2; row++) {
                for (int col = c-1; col < c+2; col++) {
                    if (isValid(row, col) == true && buttons[row][col].isClicked() == false) {
                        buttons[row][col].mousePressed();
                    }
                }
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill( 183,32,157 );
        else if( clicked && bombs.contains(this) ) 
            fill( 173, 53, 26 );
        else if(clicked)
            fill( 93,204,57 );
        else 
            fill( 33, 90, 183 );

        rect(x, y, width, height);
        fill(0);
        textSize(12);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0) {
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for (int r = row-1; r < row+2; r++) {
            for (int c = col-1; c < col+2; c++) {
                if (isValid(r, c) == true && bombs.contains(buttons[r][c]) == true) {
                    numBombs++;
                }
            }
        }
        return numBombs;
    }
}