#define TBH 25   'titlebar height
#define MINW 80 'min width
#define MINH 30 'min height

Declare Sub NewWindow(id As Integer, x As Integer, y As Integer, w As Integer, h As Integer, title As String, c As ULong)
Declare Sub GetFocusWindow()
Declare Sub ResizeWindow()
Declare Sub MoveWindow()
Declare Sub CloseWindow()
Declare Sub MinimizeWindow()

Declare Sub WatchWindows()


Type hWindow '...'
    As Integer id				'id of window
    As Integer x, y, w, h		'x,y,width,heigt
    As Integer x2, y2, w2, h2		'hold old x,y,width,heigt
    As ULong c				'c as color
    As String title				'title as string
    As Boolean hasCloseButton
    As Boolean hasMinimizeButton
    As Boolean hasMaximizeButton
    Declare Constructor()
    Declare Constructor(As Integer, As Integer, As Integer, As Integer, As Integer, As String, As ULong)
    Declare Sub redraw()
    Declare Sub DoEvents()
    Declare Sub onCloseWindow()
    As Boolean doCloseWindow
    Declare Sub onFocusWindow()
    As Boolean doGetFocus
    Declare Sub onResizeWindow()
    As Boolean doResizeWindow
    Declare Sub onMoveWindow()
    As Boolean doMoveWindow
    Declare Sub onMinimizeWindow()
    As Boolean doMinimizeWindow
    Declare Sub onMaximizeWindow()
    As Boolean doMaximizeWindow
    As UInteger Zorder
    As Boolean doRestoreMinimize
    As Boolean doRestoreMaximize
    
End Type

Dim Shared iWindowPopulation As UInteger = 0	'holds the number of created windows
Dim Shared pWindows() As hWindow Ptr			'array of ptr windows


Constructor hWindow() '...'
End Constructor

Constructor hWindow(id As Integer, x As Integer, y As Integer, w As Integer, h As Integer, t As String, c As ULong) '...'
  This.id = id
  This.x = x
  This.y = y
  This.w = w
  This.h = h
  
  This.x2 = x
  This.y2 = y
  This.w2 = w
  This.h2 = h
  
  This.title = t
  This.c = c
  This.hasCloseButton = True
  This.hasMaximizeButton = True
  This.hasMinimizeButton = True
  This.doCloseWindow = False
  This.doGetFocus = False
  This.doResizeWindow = False
  This.doMoveWindow = False
  This.doMinimizeWindow = False
  This.doRestoreMinimize = False 
  This.doMaximizeWindow = False
  This.doRestoreMaximize = False 
  
  This.Zorder = 0
  redraw()
End Constructor

Sub hWindow.DoEvents() '...'
	This.onCloseWindow()
	This.onFocusWindow()
	This.onResizeWindow()
	This.onMoveWindow()
	This.onMinimizeWindow()
	This.onMaximizeWindow()
End Sub

Sub hWindow.onMoveWindow() '...'
	Dim As Integer mx, my, mb

    GetMouse mx, my, , mb
    If mb = 1 Then
    	If mx > This.x And mx < This.x + This.w And my > This.y And my < This.y + TBH Then
    		This.doMoveWindow = True
    		iActiveWindow = This.id
    	End If
    End If
End Sub

Sub hWindow.onMaximizeWindow() '...'
	Dim As Integer mx, my, mb

    GetMouse mx, my, , mb
    If mb = 1 Then
		If mx > x + w - 41 And mx < x + w - 41 + 6 And my > y + TBH / 2 - 3 And my < y + TBH Then
'			title = "Window " & id & " " & Str(mx) & " " & Str(my)
			This.doMinimizeWindow = False 
    		If This.doMaximizeWindow = False Then 
    			This.doMaximizeWindow = True
    			This.x2 = This.x
    			This.y2 = This.y
    			This.w2 = This.w
    			This.h2 = This.h
    		Else
    			This.doMaximizeWindow = False
    			This.doRestoreMaximize = True 
    			This.x = This.x2
    			This.y = This.y2
    			This.w = This.w2
    			This.h = This.h2
    		End If
    		iActiveWindow = This.id
    		This.doGetFocus = True
    		This.onFocusWindow()
    	End If
    End If
End Sub

Sub hWindow.onMinimizeWindow() '...'
	Dim As Integer mx, my, mb

    GetMouse mx, my, , mb
    If mb = 1 Then
		If mx > x + w - 27 And mx < x + w - 27 + 6 And my > y + TBH / 2 - 3 And my < y + TBH Then
'			title = "Window " & id & " " & Str(mx) & " " & Str(my)
			This.doMaximizeWindow = False 
    		If This.doMinimizeWindow = False Then 
    			This.doMinimizeWindow = True
    			This.h2 = This.h
    		Else
    			This.doMinimizeWindow = False
    			This.doRestoreMinimize = True 
    			This.h = This.h2
    		End If
    		iActiveWindow = This.id
    	End If
    End If
End Sub

Sub hWindow.onResizeWindow() '...'
	Dim As Integer mx, my, mb

    GetMouse mx, my, , mb
    If mb = 1 Then
    	If mx > This.x + This.w - 10 And mx < This.x + This.w And my > This.y + This.h - 10 And my < This.y + This.h Then
    		This.doResizeWindow = True
    		iActiveWindow = This.id
    	End If
    End If
End Sub

Sub hWindow.onFocusWindow() '...'
	Dim As Integer mx, my, mb

    GetMouse mx, my, , mb
    If mb = 1 Then
    	If mx > This.x And mx < This.x + This.w And my > This.y And my < This.y + This.h Then
    		This.doGetFocus = True
    		iActiveWindow = This.id
    	End If
    End If
End Sub

Sub hWindow.onCloseWindow() '...'
	Dim As Integer mx, my, mb

	GetMouse mx, my, , mb
	If mb = 1 Then
		If mx > x + w - 13 And mx < x + w - 13 + 6 And my > y + TBH / 2 - 3 And my < y + TBH Then
			'title = "Window " & id & " " & Str(mx) & " " & Str(my)
			doCloseWindow = True
			iActiveWindow = This.id 
		End If
	End If
End Sub

Sub hWindow.redraw() '...'
	Line(x, y) - (x + w, y + h), &hffffff, BF				'frame
	Line(x + w - 10, y + h - 10) - (x + w, y + h), 0, BF	'angle
	Line(x + 4, y + TBH) - (x + w - 4, y + h - 4), c, BF	'box
	Draw String(x + 4, y + 8), title						'title
	
	If This.hasCloseButton = True Then
		'close window button
		Circle (x + w - 10, (y + TBH / 2)), 6, RGB(255, 0, 0), , , , F
		Draw String(x + w - 13, y + TBH / 2 - 3), "X", RGB(255, 255, 255)
	EndIf
	
	If This.hasMinimizeButton = True Then 
		'minimize window button
		Circle (x + w - 24, (y + TBH / 2)), 6, RGB(0, 255, 0), , , , F
		Draw String(x + w - 27, y + TBH / 2 - 3), "-", RGB(255, 255, 255)
	EndIf
	
	If This.hasMaximizeButton = True Then 
		'maximize window button
		Circle (x + w - 38, (y + TBH / 2)), 6, RGB(0, 0, 255), , , , F
		Draw String(x + w - 41, y + TBH / 2 - 3), "+", RGB(255, 255, 255)
	EndIf
	
End Sub

Sub NewWindow(id As Integer, x As Integer, y As Integer, w As Integer, h As Integer, title As String, c As ULong) '...'
	'new window
	iWindowPopulation += 1
	ReDim Preserve pWindows(1 To iWindowPopulation)
	pWindows(iWindowPopulation) = New hWindow(iWindowPopulation, x, y, w, h, title, c)
End Sub

Sub WatchWindows()

	Dim As Integer mx, my, mb, x1, y1
    GetMouse mx, my, , mb
    x1 = mx
    y1 = my
    If mb = 1 Then
		For i As Integer = UBound(pWindows) To LBound(pWindows) Step -1
			If pWindows(i) = 0 Then Continue For
			'------- Resize -------------------------------------------------------
			If pWindows(i)->doResizeWindow = True Then 
				pWindows(i)->doResizeWindow = False
				If pWindows(i)->id = CInt(iActiveWindow) Then
					pWindows(i)->doMinimizeWindow = False	'reset minimize on resize
					pWindows(i)->doMaximizeWindow = False	'reset maximize on resize
					
	                Swap pWindows(i), pWindows(UBound(pWindows))
                    Do
                        GetMouse mx,my,,mb
                        pWindows(UBound(pWindows))->w += mx - x1
                        pWindows(UBound(pWindows))->h += my - y1

                        pWindows(UBound(pWindows))->doMinimizeWindow = False                        
                        pWindows(UBound(pWindows))->h2 += my - y1                        

                        x1 = mx
                        y1 = my
                        If pWindows(UBound(pWindows))->w < MINW Then  pWindows(UBound(pWindows))->w = MINW
                        If pWindows(UBound(pWindows))->h < MINH Then  pWindows(UBound(pWindows))->h = MINH
                        If pWindows(UBound(pWindows))->w >= MAXW Then  pWindows(UBound(pWindows))->w = MAXW
                        If pWindows(UBound(pWindows))->h >= MAXH Then  pWindows(UBound(pWindows))->h = MAXH
                        RePaint()
                        Sleep(1, 1)
                    Loop Until mb = 0
					Exit For
				End If
			End If
			'----- Move -------------------------------------------------------------
			If pWindows(i)->doMoveWindow = True Then
				pWindows(i)->doMoveWindow = False
				If pWindows(i)->id = CInt(iActiveWindow) Then
	                Swap pWindows(i), pWindows(UBound(pWindows))
                    Do
                        GetMouse mx,my,,mb
                        pWindows(UBound(pWindows))->x += mx - x1
                        pWindows(UBound(pWindows))->y += my - y1
                        x1 = mx
                        y1 = my
                        RePaint()
                        Sleep(1, 1)
                    Loop Until mb = 0
					Exit For
				EndIf
			End If
			'----Get Focus --------------------------------------------------
			If pWindows(i)->doGetFocus = True Then
				pWindows(i)->doGetFocus = False
				If pWindows(i)->id = CInt(iActiveWindow) Then
					Swap pWindows(i), pWindows(UBound(pWindows))
'					RePaint()
					Exit For
				EndIf
			End If
		Next
    End If

	For i As Integer = 1 To UBound(pWindows) 'doevents of every window
			If pWindows(i) = 0 Then Continue For	'skip deleted windows    
    			'---- Close -------------------------------------------------------------
			'if close window
			If pWindows(i)->doCloseWindow = True Then
				Delete pWindows(i)
				pWindows(i) = 0
			End If
			'--- Minimize ------------------------------------------------------
			'if minimize window
			If pWindows(i) = 0 Then Continue For	'skip deleted windows    
			If pWindows(i)->doMinimizeWindow = True Then
				pWindows(i)->h = MINH
			ElseIf pWindows(i)->doRestoreMinimize = True Then 
				pWindows(i)->h = pWindows(i)->h2
				pWindows(i)->doRestoreMinimize = False 
			End If
			'------ Maximize ------------------------------------------------------
			'if maximize window
			If pWindows(i) = 0 Then Continue For	'skip deleted windows    
			If pWindows(i)->doMaximizeWindow = True Then
				pWindows(i)->x = 0
				pWindows(i)->y = 0
				pWindows(i)->w = MAXW
				pWindows(i)->h = MAXH
			ElseIf pWindows(i)->doRestoreMaximize = True Then 
				pWindows(i)->x = pWindows(i)->x2
				pWindows(i)->y = pWindows(i)->y2
				pWindows(i)->w = pWindows(i)->w2
				pWindows(i)->h = pWindows(i)->h2
				pWindows(i)->doRestoreMaximize = False 
			End If
	Next
	RePaint()
End Sub


Sub ResizeWindow() '...'

	Dim As Integer mx, my, mb, x1, y1
    GetMouse mx, my, , mb
    x1 = mx
    y1 = my
    If mb = 1 Then
		For i As Integer = UBound(pWindows) To LBound(pWindows) Step -1
			If pWindows(i) = 0 Then Continue For
			If pWindows(i)->doResizeWindow = True Then
				pWindows(i)->doResizeWindow = False
				If pWindows(i)->id = CInt(iActiveWindow) Then
					pWindows(i)->doMinimizeWindow = False	'reset minimize on resize
					pWindows(i)->doMaximizeWindow = False	'reset maximize on resize
					
	                Swap pWindows(i), pWindows(UBound(pWindows))
                    Do
                        GetMouse mx,my,,mb
                        pWindows(UBound(pWindows))->w += mx - x1
                        pWindows(UBound(pWindows))->h += my - y1

                        pWindows(UBound(pWindows))->doMinimizeWindow = False                        
                        pWindows(UBound(pWindows))->h2 += my - y1                        

                        x1 = mx
                        y1 = my
                        If pWindows(UBound(pWindows))->w < MINW Then  pWindows(UBound(pWindows))->w = MINW
                        If pWindows(UBound(pWindows))->h < MINH Then  pWindows(UBound(pWindows))->h = MINH
                        If pWindows(UBound(pWindows))->w >= MAXW Then  pWindows(UBound(pWindows))->w = MAXW
                        If pWindows(UBound(pWindows))->h >= MAXH Then  pWindows(UBound(pWindows))->h = MAXH
                        RePaint()
                    Loop Until mb = 0
					Exit For
				EndIf
			End If
		Next
    End If
End Sub

Sub MoveWindow() '...'
	Dim As Integer mx, my, mb, x1, y1
'	RePaint()

    GetMouse mx, my, , mb
    x1 = mx
    y1 = my
    If mb = 1 Then
		For i As Integer = UBound(pWindows) To LBound(pWindows) Step -1
			If pWindows(i) = 0 Then Continue For
			If pWindows(i)->doMoveWindow = True Then
				pWindows(i)->doMoveWindow = False
				If pWindows(i)->id = CInt(iActiveWindow) Then
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
				EndIf
			End If
		Next
    End If
End Sub

Sub GetFocusWindow() '...'
		For i As Integer = UBound(pWindows) To LBound(pWindows) Step -1
			If pWindows(i) = 0 Then Continue For
			If pWindows(i)->doGetFocus = True Then
				pWindows(i)->doGetFocus = False
				If pWindows(i)->id = CInt(iActiveWindow) Then
					Swap pWindows(i), pWindows(UBound(pWindows))
'					RePaint()
					Exit For
				EndIf
			End If
		Next
	RePaint()
End Sub

Sub CloseWindow()
	For i As Integer = 1 To UBound(pWindows) 'doevents of every window
		If pWindows(i) = 0 Then Continue For	'skip deleted windows
		'if close window
		If pWindows(i)->doCloseWindow = True Then
			Delete pWindows(i)
			pWindows(i) = 0
'			RePaint()
		End If
	Next
	RePaint()
End Sub

Sub MinimizeWindow()
	For i As Integer = 1 To UBound(pWindows) 'doevents of every window
		If pWindows(i) = 0 Then Continue For	'skip deleted windows
		'if minimize window
		If pWindows(i)->doMinimizeWindow = True Then
			pWindows(i)->h = MINH
		ElseIf pWindows(i)->doRestoreMinimize = True Then 
			pWindows(i)->h = pWindows(i)->h2
			pWindows(i)->doRestoreMinimize = False 
		End If
'		RePaint()
	Next
	RePaint()
End Sub

Sub MaximizeWindow() '...'
	For i As Integer = 1 To UBound(pWindows) 'doevents of every window
		If pWindows(i) = 0 Then Continue For	'skip deleted windows
		'if maximize window
		If pWindows(i)->doMaximizeWindow = True Then
			pWindows(i)->x = 0
			pWindows(i)->y = 0
			pWindows(i)->w = MAXW
			pWindows(i)->h = MAXH
		ElseIf pWindows(i)->doRestoreMaximize = True Then 
			pWindows(i)->x = pWindows(i)->x2
			pWindows(i)->y = pWindows(i)->y2
			pWindows(i)->w = pWindows(i)->w2
			pWindows(i)->h = pWindows(i)->h2
			pWindows(i)->doRestoreMaximize = False 
		End If
'		RePaint()
	Next
	RePaint()
End Sub

