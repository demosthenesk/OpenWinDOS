#define MAXW 800 'max desktop width
#define MAXH 600 'max desktop height

#include once "fbgfx.bi"
Using FB

Dim Shared iActiveWindow As Integer = 0

Declare Sub Init()
Declare Sub MAINLOOP()
Declare Sub DoEvents()
Declare Sub RePaint()

#include once "window.bi"

Sub Init() '...'
	ScreenRes MAXW, MAXH, 32, 2
	ScreenSet( 0, 1 )
	Color RGB(0, 0, 0), RGB(15, 120, 180)
	Cls
	
	NewWindow(1, 10, 10, 200, 140, "Window 1", &h9e9e9e) 
	NewWindow(2, 40, 40, 200, 140, "Window 2", &h9e9e9e)
	NewWindow(3, 80, 80, 200, 140, "Window 3", &h9e9e9e)
	NewWindow(4, 120, 120, 200, 140, "Window 4", &h9e9e9e)
	NewWindow(5, 160, 160, 200, 140, "Window 5", &h9e9e9e)

	RePaint()
End Sub

Sub DoEvents()
	For i As Integer = 1 To UBound(pWindows)	'doevents of every window
		If pWindows(i) = 0 Then Continue For	'skip deleted windows
		pWindows(i)->DoEvents
	Next
	
	WatchWindows()
	
'	CloseWindow()
'	ResizeWindow()
'	MoveWindow()
'	MinimizeWindow()
'	MaximizeWindow()
'	GetFocusWindow()
End Sub

Sub MAINLOOP() '...'
	Do
		DoEvents()
'		Sleep( 1, 1 )
	Loop Until MultiKey(SC_ESCAPE) 'loop until ESC pressed

End Sub

Sub RePaint()
	Cls
	For i As Integer = 1 To UBound(pWindows)
		If pWindows(i) = 0 Then Continue For
		pWindows(i)->redraw()
		pWindows(i)->Zorder = i
'		pWindows(1)->title = Str(iActiveWindow)
	Next
	Flip()
	Sleep( 1, 1 )
End Sub

Init()
MAINLOOP()

