#include "window.bi"
#define MAXW 800 'max desktop width
#define MAXH 600 'max desktop height

Dim Shared iWindowPopulation As UInteger = 0	'holds the number of created windows
Dim Shared pWindows() As hWindow Ptr			'array of ptr windows

Declare Sub Init()
Declare Sub NewWindow(id As UInteger, x As Integer, y As Integer, w As Integer, h As Integer, title As String, c As Integer)
Declare Sub MAINLOOP()
Declare Sub RePaint()

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

Sub NewWindow(id As UInteger, x As Integer, y As Integer, w As Integer, h As Integer, title As String, c As Integer) '...'
	'new window
	iWindowPopulation += 1
	ReDim Preserve pWindows(1 To iWindowPopulation)
	pWindows(iWindowPopulation) = New hWindow(id, x, y, w, h, title, c)
End Sub

Sub MAINLOOP()

Dim As Integer mx, my, mb, x1, y1


Do
    GetMouse mx,my,,mb
    x1 = mx
    y1 = my
    If mb = 1 Then
        For i As Integer = UBound(pWindows) To LBound(pWindows) Step -1
            If (mx > pWindows(i)->x And mx < pWindows(i)->x + pWindows(i)->w) And (my > pWindows(i)->y And my < pWindows(i)->y + pWindows(i)->h) Then
				If i = 1 And UBound(pWindows) > 1 Then
					Swap pWindows(1), pWindows(UBound(pWindows))
				End If
				
				If i > 1 Then
                	For m As Integer = LBound(pWindows) To UBound(pWindows) Step 1
                		If m + 1 > UBound(pWindows) Then Exit For
                		Swap pWindows(m), pWindows(UBound(pWindows))
                	Next
				End If
				
                If i < UBound(pWindows) Then RePaint()
                
                If mx > (pWindows(UBound(pWindows))->x + pWindows(UBound(pWindows))->w - 10) And my > (pWindows(UBound(pWindows))->y + pWindows(UBound(pWindows))->h - 10) Then
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
                ElseIf my < (pWindows(UBound(pWindows))->y + TBH) Then
                    Do
                        GetMouse mx,my,,mb
                        pWindows(UBound(pWindows))->x += mx - x1
                        pWindows(UBound(pWindows))->y += my - y1
                        x1 = mx
                        y1 = my
                        RePaint()
                    Loop Until mb = 0
                End If
                Exit For
            End If
        Next i
    End If
    
    RePaint()
    
    Sleep( 1, 1 )
Loop Until MultiKey(&h01) 'loop until ESC pressed

End Sub

Sub RePaint()
	Cls
	For i As Integer = 1 To UBound(pWindows)
		pWindows(i)->redraw()
	Next
	Flip()
End Sub


Init()
MAINLOOP()



