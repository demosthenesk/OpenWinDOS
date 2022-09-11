#define TBH 20   'titlebar height
#define MINWH 80 'min width/height
Type hWindow
    As UInteger id				'id of window
    As Integer x, y, w, h		'x,y,width,heigt
    As UInteger c				'c as color
    As String title				'title as string
    Declare Constructor()
    Declare Constructor(As UInteger, As Integer, As Integer, As Integer, As Integer, As String, As Integer)
    Declare Sub redraw()
End Type

Constructor hWindow()
End Constructor

Constructor hWindow(id As UInteger, x As Integer, y As Integer, w As Integer, h As Integer, t As String, c As Integer)
  This.id = id
  This.x = x
  This.y = y
  This.w = w
  This.h = h
  This.title = t
  This.c = c
  redraw()
End Constructor

Sub hWindow.redraw()
    Line(x,y)-(x+w,y+h),&hffffff,BF    'frame
    Line(x+w-10,y+h-10)-(x+w,y+h),0,BF 'angle
    Line(x+4,y+TBH)-(x+w-4,y+h-4),c,BF 'box
    Draw String(x+4,y+8),title
End Sub

