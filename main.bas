#include "window.bi"
#define MAXW 800 'max desktop width
#define MAXH 600 'max desktop height

Dim Shared iWindowPopulation As UInteger = 0	'holds the number of created windows
Dim Shared pWindows() As hWindow Ptr			'array of ptr windows

Declare Sub Init()
Declare Sub NewWindow(id As UInteger, x As Integer, y As Integer, w As Integer, h As Integer, title As String, c As UInteger)
Declare Sub MAINLOOP()
Declare Sub DoEvents()
Declare Sub RePaint()

Declare Sub GetFocusWindow()
Declare Sub ResizeWindow()
Declare Sub MoveWindow()

Sub Init()
	ScreenRes MAXW, MAXH, 32, 2
	ScreenSet( 0, 1 )
	Color RGB(0, 0, 0), RGB(15, 120, 180)
	Cls
	
	NewWindow(1, 10, 10, 200, 140, "Window 1", &h9e9e9e) 
	NewWindow(2, 40, 40, 200, 140, "Window 2", &h9e9e9e)
	NewWindow(3, 80, 80, 200, 140, "Window 3", &h9e9e9e)
	NewWindow(4, 120, 120, 200, 140, "Window 4", &h9e9e9e)
	NewWindow(5, 160, 160, 200, 140, "Window 5", &h9e9e9e)

End Sub

Sub NewWindow(id As UInteger, x As Integer, y As Integer, w As Integer, h As Integer, title As String, c As UInteger) '...'
	'new window
	iWindowPopulation += 1
	ReDim Preserve pWindows(1 To iWindowPopulation)
	pWindows(iWindowPopulation) = New hWindow(id, x, y, w, h, title, c)
End Sub

Sub ResizeWindow() '...'
	Dim As Integer mx, my, mb, x1, y1
	RePaint()

    GetMouse mx, my, , mb
    x1 = mx
    y1 = my
    If mb = 1 Then
		For i As Integer = UBound(pWindows) To LBound(pWindows) Step -1
			If pWindows(i) = 0 Then Continue For
			If pWindows(i)->doResizeWindow = True Then
				pWindows(i)->doResizeWindow = False
                Swap pWindows(i), pWindows(UBound(pWindows))
                    Do
                        GetMouse mx,my,,mb
                        pWindows(UBound(pWindows))->w += mx - x1
                        pWindows(UBound(pWindows))->h += my - y1
                        x1 = mx
                        y1 = my
                        If pWindows(UBound(pWindows))->w < MINWH Then  pWindows(UBound(pWindows))->w = MINWH
                        If pWindows(UBound(pWindows))->h < MINWH Then  pWindows(UBound(pWindows))->h = MINWH
                        If pWindows(UBound(pWindows))->w >= MAXW Then  pWindows(UBound(pWindows))->w = MAXW
                        If pWindows(UBound(pWindows))->h >= MAXH Then  pWindows(UBound(pWindows))->h = MAXH
                        RePaint()
                    Loop Until mb = 0
				Exit For
			End If
		Next
    End If
End Sub

Sub MoveWindow() '...'
	Dim As Integer mx, my, mb, x1, y1
	RePaint()

    GetMouse mx, my, , mb
    x1 = mx
    y1 = my
    If mb = 1 Then
		For i As Integer = UBound(pWindows) To LBound(pWindows) Step -1
			If pWindows(i) = 0 Then Continue For
			If pWindows(i)->doMoveWindow = True Then
				pWindows(i)->doMoveWindow = False
                Swap pWindows(i), pWindows(UBound(pWindows))
                    Do
                        GetMouse mx,my,,mb
                        pWindows(UBound(pWindows))->x += mx - x1
                        pWindows(UBound(pWindows))->y += my - y1
                        x1 = mx
                        y1 = my
                        RePaint()
                    Loop Until mb = 0
				Exit For
			End If
		Next
    End If
End Sub

Sub GetFocusWindow() '...'
Dim As Integer mx, my, mb
	RePaint()
    GetMouse mx, my, , mb
    If mb = 1 Then
		For i As Integer = UBound(pWindows) To LBound(pWindows) Step -1
			If pWindows(i) = 0 Then Continue For
			If pWindows(i)->doGetFocus = True Then
				pWindows(i)->doGetFocus = False
                Swap pWindows(i), pWindows(UBound(pWindows))
				RePaint()
				Exit For
			End If
		Next
    End If
End Sub

Sub DoEvents()
	GetFocusWindow()
	ResizeWindow()
	MoveWindow()
	
	For i As Integer = 1 To UBound(pWindows)	'doevents of every window
		If pWindows(i) = 0 Then Continue For	'skip deleted windows
		pWindows(i)->DoEvents
		
		'if close window
		If pWindows(i)->doCloseWindow = True Then
			Delete pWindows(i)
			pWindows(i) = 0
		End If
	Next
End Sub

Sub MAINLOOP()
	Do
		DoEvents()
		Sleep( 1, 1 )
	Loop Until MultiKey(&h01) 'loop until ESC pressed

End Sub

Sub RePaint() '...'
	Cls
	For i As Integer = 1 To UBound(pWindows)
		If pWindows(i) = 0 Then Continue For
		pWindows(i)->redraw()
	Next
	Flip()
End Sub


Init()
MAINLOOP()



