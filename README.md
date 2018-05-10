# Snake_MIPS
The popular game Snake in MIPS.

How to build the game : 

  Open the application Mars.jar
  
  Open the file Snake.asm
  
  Click on "Assemble the current file and clear breakpoints"
 
How to run the game :

  Open the Tool "Bitmap Display" :
    Set "Unit Width in Pixels" on 16            ;
    Set "Unit Height in Pixels" on 16           ;
    Set "Display Width in Pixels" on 256        ;
    Set "Display Height in Pixels" on 256       ;
    Set "Base address for display" on 0x10010000;
    Connect to MIPS.
    
  Open the Tool "Keyboard and Display MMIO Simulator" :
    Connect to MIPS.
    
  Go back to MARS and click on "Run the current program"
  
How to play the game :

  Z -> to go up   ;
  S -> to go down ;
  Q -> to move the snake to the left  ;
  D -> to move the snake to the right ;
  
  Red blocks          ->  obstacles ;
  Mauve Candy         ->  Food      ;
  The block in Green  ->  Snake Head;
