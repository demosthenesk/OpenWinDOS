
Dim Shared iActiveWindow As Integer = 0
Declare Sub DoEvents()
Declare Sub RePaint()
Declare Sub CloseWindow()

#include once "hWindow.bi"
#include once "hButton.bi"

Sub DoEvents() '...'
	For i As Integer = 1 To UBound(pWindows)	'doevents of every window
		If pWindows(i) = 0 Then Continue For	'skip deleted windows
		pWindows(i)->DoEvents
	Next

	WatchWindows()
	CloseWindow()
	
End Sub

Sub RePaint() '...'
	Cls
	'for each window
	For i As Integer = 1 To UBound(pWindows)
		If pWindows(i) = 0 Then Continue For
		pWindows(i)->redraw()
		pWindows(i)->Zorder = i
		
		'for each Button in each Window
		For a As Integer = 1 To UBound(pButtons)
			If pButtons(a) = 0 Then Continue For
				If pButtons(a)->pid = pWindows(i)->id Then	'if window has buttons Then
					'if window width is smaller than buttons position hide them
					If (pButtons(a)->x2 + pButtons(a)->w + 8) >= pWindows(i)->w Then
						pButtons(a)->IsVisible = False 
						Continue For
					End If
					'if window height is smaller than buttons position hide them
					If (pButtons(a)->y2 + pButtons(a)->h + TBH + 4) >= pWindows(i)->h Then 
						pButtons(a)->IsVisible = False 
						Continue For
					End If
					pButtons(a)->x = pWindows(i)->x + pButtons(a)->x2 + 4
					pButtons(a)->y = pWindows(i)->y + pButtons(a)->y2 + TBH
					pButtons(a)->IsVisible = True 
					pButtons(a)->redraw()
				EndIf
		Next
	Next
	
	Flip()
	Sleep( 1, 1 )
End Sub

Sub CloseWindow()
	For i As Integer = 1 To UBound(pWindows) 'for every window
			If pWindows(i) = 0 Then Continue For	'skip deleted windows    
    			'---- Close -------------------------------------------------------------
			'if close window
			If pWindows(i)->doCloseWindow = True Then
				'delete each control
				'delete pButtons ----------------------------
				For a As Integer = 1 To UBound(pButtons)
					If pButtons(a) = 0 Then Continue For	'skip deleted controls
					If pButtons(a)->pid = pWindows(i)->id Then
						Delete pButtons(a)
						pButtons(a) = 0
					End If
				Next
				'---------------------------------------------
				'delete window
				Delete pWindows(i)
				pWindows(i) = 0
				RePaint()
			End If
	Next
'	RePaint()
End Sub
