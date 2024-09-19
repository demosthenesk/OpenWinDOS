#define MAXW 800 'max desktop width
#define MAXH 600 'max desktop height

#include once "fbgfx.bi"
#include Once "owd.bi"
Using FB

Declare Sub Init()
Declare Sub MAINLOOP()

Sub Init() '...'
	ScreenRes MAXW, MAXH, 32, 2
	ScreenSet( 0, 1 )
	Color RGB(0, 0, 0), RGB(15, 120, 180)
	Cls
	
	NewWindow("w1", 10, 10, 200, 140, "Window 1", &h9e9e9e) 
	NewWindow("w2", 40, 40, 200, 140, "Window 2", &h9e9e9e)
	NewWindow("w3", 80, 80, 200, 140, "Window 3", &h9e9e9e)
	NewWindow("w4", 120, 120, 200, 140, "Window 4", &h9e9e9e)
	NewWindow("w5", 160, 160, 200, 140, "Window 5", &h9e9e9e)
	
	NewButton("btn3", 3, 40, 50, 50, 20, "hello3", &hff0000)
	NewButton("btn51", 5, 40, 0, 60, 20, "hello51", &hff0000)
	NewButton("btn52", 5, 40, 50, 60, 20, "hello52", &hff0000)
	NewButton("btn2", 2, 40, 50, 50, 20, "hello2", &hff0000)

	RePaint()
End Sub

Sub MAINLOOP() '...'
	Do
		DoEvents()
'		Sleep( 1, 1 )
	Loop Until MultiKey(SC_ESCAPE) 'loop until ESC pressed

End Sub

Init()
MAINLOOP()

