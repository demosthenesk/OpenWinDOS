#include once "hControl.bi"

Type hButton Extends hControl
	Declare Constructor()
	Declare Constructor(as String, As Integer, As Integer, As Integer, As Integer, As Integer, As Integer, As String, As ULong)
	Declare Sub redraw()
	As Integer x2,y2,w2,h2
	As Boolean IsVisible
End Type

Constructor hButton()
End Constructor

Constructor hButton(hName As String, id As Integer, pid As Integer, x As Integer, y As Integer, w As Integer, h As Integer, title As String, c As ULong)
  This.hName = hName
  This.id = id
  This.pid = pid
  This.x2 = x
  This.y2 = y
  This.w2 = w
  This.h2 = h
  This.x = pWindows(pid)->x + x + 4
  This.y = pWindows(pid)->y + y + TBH
  This.w = w
  This.h = h

  This.title = title
  This.c = c
  This.IsVisible = True
  redraw()
End Constructor

Sub hButton.redraw()
'	This.x = pWindows(This.pid)->x + 4
'	This.y = pWindows(This.pid)->y + TBH

'	This.x = pWindows(pid)->x + This.x2 + 4
'	This.y = pWindows(pid)->y + This.y2 + TBH

	Line(x, y) - (x + w, y + h), c, BF		'active frame
	Draw String(x + 4, y + 8), title		'title
End Sub

Dim Shared iButtonPopulation As UInteger = 0	'holds the number of created buttons
Dim Shared pButtons() As hButton Ptr			'array of ptr hButton

Declare Sub NewButton(hName As String, pid As Integer, x As Integer, y As Integer, w As Integer, h As Integer, title As String, c As ULong)

Sub NewButton(hName As String, pid As Integer, x As Integer, y As Integer, w As Integer, h As Integer, title As String, c As ULong)
	'new button
	iButtonPopulation += 1
	ReDim Preserve pButtons(1 To iButtonPopulation)
	pButtons(iButtonPopulation) = New hButton(hName, iButtonPopulation, pid, x, y, w, h, title, c)
End Sub



