#define TBH 25   'titlebar height
#define MINWH 80 'min width/height
Type hWindow
    As UInteger id				'id of window
    As Integer x, y, w, h		'x,y,width,heigt
    As UInteger c				'c as color
    As String title				'title as string
    As Boolean hasCloseButton
    As Boolean hasMinimizeButton
    As Boolean hasMaximizeButton
    Declare Constructor()
    Declare Constructor(As UInteger, As Integer, As Integer, As Integer, As Integer, As String, As UInteger)
    Declare Sub redraw()
    Declare Sub DoEvents()
    Declare Sub onCloseWindow()
    As Boolean doCloseWindow
End Type

Constructor hWindow()
End Constructor

Constructor hWindow(id As UInteger, x As Integer, y As Integer, w As Integer, h As Integer, t As String, c As UInteger)
  This.id = id
  This.x = x
  This.y = y
  This.w = w
  This.h = h
  This.title = t
  This.c = c
  This.hasCloseButton = True
  This.hasMaximizeButton = True
  This.hasMinimizeButton = True
  This.doCloseWindow = False 
  redraw()
End Constructor

Sub hWindow.DoEvents()
	This.onCloseWindow()
End Sub

Sub hWindow.onCloseWindow()
	Dim As Integer mx, my, mb

	GetMouse mx, my, , mb
	If mb = 1 Then
		If mx > x + w - 13 And mx < x + w - 13 + 6 And my > y + TBH / 2 - 3 And my < y + TBH Then
			'title = "Window " & id & " " & Str(mx) & " " & Str(my)
			doCloseWindow = True 
		End If
	End If
End Sub

Sub hWindow.redraw()
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

