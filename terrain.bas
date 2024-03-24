/'
  3dfrac 3.0 by Aaron Contorer 1987-1989
  Draws three-dimensional fractal landscapes.
  Version for EGA and VGA in Quick C 1.0

  Please send the author a copy of anything interesting you make
  that uses parts of this code or parts of its design.
'/


/'Graphic design'/
#define  DEEP 7 ' 7 to 10
#Define  XA 20
#define  XB 650
#define  YA 20
#define  ZA 20
#define  YADD 40


/' Color indices '/
#define WATERCOLOR 11
#define LANDCOLOR 2

Dim Shared As Single steep 
Dim Shared As Integer sealevel 
Dim Shared As Integer ybottom 



/' Function to draw the actual pixels onto the screen is defined as a
macro to increase execution speed. '/
Sub addline(x0 As integer,y0 As Integer,z0 As Integer, x1 As Integer,y1 As Integer,z1 As Integer) 
	 	If (z1 = -9999) Then 
    		Color WATERCOLOR
    		PSet ((y0 Shr 1) + x0, YADD + y0 + z0) 
	 	Else 
   		Color LANDCOLOR 
    		Line( (y0 Shr 1)+x0,  YADD+y0+z0 ) - ( (y1 Shr 1)+x1,  YADD+y1+z1 ) 
  		End If
End Sub


Sub fractal(depth As Integer , x0 As Integer , y0 As Integer , x2 As Integer , y2 As Integer , z0 As Integer , z1 As Integer , z2 As Integer , z3 As Integer)

  Dim As Integer newz  /' new center point '/
  Dim As Integer xmid,ymid,z01,z12,z23,z30 

  if (rnd(1) < 0.5) Then /' 50% chance '/
	 newz = (z0+z1+z2+z3) / 4 + Int(Rnd(1) * ((y2-y0)* steep)) 
  Else
	 newz = (z0+z1+z2+z3) / 4 - Int(Rnd(1) * ((y2-y0)* steep))
  EndIf
  
  xmid = (x0+x2) Shr 1 
  ymid = (y0+y2) Shr 1 
  z12 = (z1+z2) Shr 1 
  z30 = (z3+z0) Shr 1 
  z01 = (z0+z1) Shr 1 
  z23 = (z2+z3) Shr 1 
  
  depth-=1  
  if (depth>=0 ) Then 
  
    fractal(depth, x0,y0, xmid,ymid, z0,z01,newz,z30)
    fractal(depth, xmid,y0, x2,ymid, z01,z1,z12,newz) 
    fractal(depth, x0,ymid, xmid,y2, z30,newz,z23,z3) 
    fractal(depth, xmid,ymid, x2,y2, newz,z12,z2,z23) 
    
  Else
         
    if newz<=sealevel Then  /'above sea level'/
      /'L to R'/
      addline(xmid,ymid,newz, x2,ymid,z12) 
      addline(xmid,ymid,newz, x0,ymid,z30) 
    Else 
    	/'below "sea level"'/
      addline(xmid,ymid,sealevel, 0,0,-9999) 
    EndIf
  
  EndIf
  
End Sub


  Dim As Byte c 
  ybottom = 700
  
  Screen 20
  
	 '_remappalette(LANDCOLOR,_GREEN) 
	 '_remappalette(WATERCOLOR,_LIGHTBLUE) 
	 /' srand(something time-related) '/
    while 1  
    	
      Cls 
		steep = (rnd(1) / 2.5) + 0.5 
      sealevel = Int(17*rnd(1)) - 8 
		fractal(DEEP, XA,YA,XB,ybottom,ZA,ZA,ZA,ZA) 
      Sleep
      If InKey=Chr(27) Then end
      
    Wend
