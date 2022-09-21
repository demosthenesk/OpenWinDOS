Type hControl Extends Object
	As String hName					'unique name of control
    As Integer id					'id of control
    As Integer pid					'parent id
    As Integer x, y, w, h			'x,y,width,heigt
    As ULong c						'c as color
    As String title					'title as string
    Declare Abstract Sub redraw()	'redraw sub
End Type

