EnableExplicit

Structure Sticky
	win.i
	menu.i
	edit.i
	font.i
	content_changed.i
	filen.s
EndStructure

#TIMERID=100
#EVENT_NEWSTICKY = 1
Global menu
Global Dim stickies.Sticky(255)
Global gindex.i
Define event
Debug GetCurrentDirectory()

Declare NewSticky()
Declare EndProgram(i)
Declare MULTI_EndProgram()
Declare WINH_Size(i)

Procedure WINH_Move(i)
EndProcedure

Procedure MULTI_WINH_Move()
	Define i =0
	For i = 0 To ArraySize(stickies()) : If stickies(i)\win <> 0 : WINH_Move(i) : EndIf : Next
EndProcedure

Procedure WINH_Maximize(i)
	SetWindowState(stickies(i)\win,#PB_Window_Maximize)
EndProcedure

Procedure MULTI_WINH_Maximize()
	Define i =0
	For i = 0 To ArraySize(stickies()) : If stickies(i)\win <> 0 : WINH_Maximize(i) : EndIf : Next
EndProcedure


Procedure WINH_Minimize(i)
	SetWindowState(stickies(i)\win,#PB_Window_Minimize)
EndProcedure

Procedure MULTI_WINH_Minimize()
	Define i =0
	For i = 0 To ArraySize(stickies()) : If stickies(i)\win <> 0 : WINH_Minimize(i) : EndIf : Next
EndProcedure


Procedure WINH_Size(i)
	ResizeGadget(stickies(i)\edit,0,0,WindowWidth(stickies(i)\win),WindowHeight(stickies(i)\win))
	PostEvent(#PB_Event_Repaint)
EndProcedure

Procedure MULTI_WINH_Size()
	Define i =0
	For i = 0 To ArraySize(stickies()) : If stickies(i)\win <> 0 : WINH_Size(i) : EndIf : Next
EndProcedure

Procedure SaveSticky(i)
	Define contents.s= GetGadgetText(stickies(i)\edit)
	Define file
	file=CreateFile(#PB_Any,stickies(i)\filen)
	If file
		Debug "W " + stickies(i)\filen
		WriteString(file,contents)
		CloseFile(file)
	EndIf
EndProcedure

Procedure MULTI_SaveSticky()
	Define i =0
	For i = 0 To ArraySize(stickies()) : If stickies(i)\win <> 0 : SaveSticky(i) : EndIf : Next
EndProcedure

Procedure H_Gadget(i)
	If EventGadget() = stickies(i)\edit
		If EventType() = #PB_EventType_Change
			stickies(i)\content_changed=1
		EndIf
	EndIf
EndProcedure

Procedure MULTI_H_Gadget()
	Define i = 0 : For i = 0 To ArraySize(stickies()) : If stickies(i)\win <> 0 : H_Gadget(i) : EndIf : Next
EndProcedure

Procedure H_Timer(i)
	If stickies(i)\content_changed=1
		SaveSticky(i)
		stickies(i)\content_changed=0
	EndIf
EndProcedure

Procedure MULTI_H_Timer()
	Define i = 0 : For i = 0 To ArraySize(stickies()) : If stickies(i)\win <> 0 : H_Timer(i) : EndIf : Next
EndProcedure

Procedure LoadSticky(i)
	Define contents.s
	Define file
	file=ReadFile(#PB_Any,stickies(i)\filen)
	If file
		Debug "R " + stickies(i)\filen 
		contents=ReadString(file,#PB_File_IgnoreEOL)
		CloseFile(file)
		SetGadgetText(stickies(i)\edit,contents)
	Else
		
	EndIf
EndProcedure

Procedure NewWindow()
	;Window
	stickies(gindex)\win = OpenWindow(#PB_Any,0,0,300,400,"stickies", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
	If stickies(gindex)\win=0 : End : EndIf
	
	;Filename
	stickies(gindex)\filen="sticky"+Str(gindex)+".txt"
	
	;Timer
	If gindex=1 ; only need one timer
		AddWindowTimer(stickies(gindex)\win,#TIMERID,5000)
	EndIf
	
	;Font
	stickies(gindex)\font=LoadFont(#PB_Any, "UDDigiKyokashoN-R", 14)
	
	;Gadgets
	stickies(gindex)\edit=EditorGadget(#PB_Any,0,0,WindowWidth(stickies(gindex)\win),WindowHeight(stickies(gindex)\win),#PB_Editor_WordWrap)	
	SetGadgetFont(stickies(gindex)\edit,FontID(stickies(gindex)\font))
	
	;Menu
	menu=CreateMenu(#PB_Any,WindowID(stickies(gindex)\win))
	stickies(gindex)\menu=CreateMenu(#PB_Any,WindowID(stickies(gindex)\win))
	LoadSticky(gindex)
	
	AddKeyboardShortcut(stickies(gindex)\win, #PB_Shortcut_Control | #PB_Shortcut_N, #EVENT_NEWSTICKY)
	BindEvent(#PB_Event_SizeWindow, @MULTI_WINH_Size())
	BindEvent(#PB_Event_MoveWindow ,@MULTI_WINH_Move())
	BindEvent(#PB_Event_MaximizeWindow, @MULTI_WINH_Maximize())
	BindEvent(#PB_Event_MinimizeWindow, @MULTI_WINH_Minimize())
	BindEvent(#PB_Event_CloseWindow, @MULTI_EndProgram())
	BindEvent(#PB_Event_Timer,@MULTI_H_Timer())
	BindEvent(#PB_Event_Gadget, @MULTI_H_Gadget())
	BindMenuEvent(stickies(gindex)\menu,#EVENT_NEWSTICKY,@NewSticky())
EndProcedure

Procedure NewSticky()
	gindex=gindex+1;
	NewWindow()
EndProcedure

Procedure EndProgram(i)
	Debug "END"
	SaveSticky(i)
EndProcedure

Procedure MULTI_EndProgram()
	Define i = 0 : For i = 0 To ArraySize(stickies()) : If stickies(i)\win <> 0 : EndProgram(i) : EndIf : Next
EndProcedure

NewSticky()

Repeat
	event = WaitWindowEvent()
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 129
; FirstLine = 117
; Folding = ----
; EnableXP
; Executable = stickies
; CompileSourceDirectory