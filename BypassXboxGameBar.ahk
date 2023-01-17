#SingleInstance, Force
#NoEnv
SendMode Input
#WinActivateForce
SetWorkingDir %A_ScriptDir%
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%"

PathToMagnifixer := "C:\Program Files\Magnifixer\Magnifixer.exe"

F1::
	SysGet, VirtualScreenWidth, 78
	SysGet, VirtualScreenHeight, 79
	Process, Close, Magnifixer.exe
	getSelectionCoords(x_start, x_end, y_start, y_end)
	
	;ToolTip %VirtualScreenWidth% %VirtualScreenHeight%
	Run, %PathToMagnifixer%
	Sleep 1000
	WinActivate, ahk_exe Magnifixer.exe	
	Send {Ctrl down}f{Ctrl up}	
	MouseMove, (x_start+x_end)/2, (y_start+y_end)/2
	Send {Ctrl down}f{Ctrl up}
	WinMove, ahk_exe Magnifixer.exe, , x_start-8, y_start-8, x_end-x_start+16, y_end-y_start+16
	WinMove, ahk_exe Magnifixer.exe, , VirtualScreenWidth-10, VirtualScreenHeight-10,,
	Send {LWin down}g{LWin up}
Return


F4::
	WinClose, ahk_exe Magnifixer.exe
	Process, Close, Magnifixer.exe
Return




getSelectionCoords(ByRef x_start, ByRef x_end, ByRef y_start, ByRef y_end) {
	SysGet, VirtualScreenWidth, 78
	SysGet, VirtualScreenHeight, 79
	
	;Mask Screen
	Gui, Color, FFFFFF
	Gui +LastFound
	WinSet, Transparent, 50
	Gui, -Caption 
	Gui, +AlwaysOnTop
	Gui, Show, x0 y0 h%VirtualScreenHeight% w%VirtualScreenWidth%,"AutoHotkeySnapshotApp"     
 
	;Drag Mouse
	CoordMode, Mouse, Screen
	CoordMode, Tooltip, Screen
	WinGet, hw_frame_m,ID,"AutoHotkeySnapshotApp"
	hdc_frame_m := DllCall( "GetDC", "uint", hw_frame_m)
	KeyWait, LButton, D 
	MouseGetPos, scan_x_start, scan_y_start 
	Loop
	{
		Sleep, 10   
		KeyIsDown := GetKeyState("LButton")
		if (KeyIsDown = 1)
		{
			MouseGetPos, scan_x, scan_y 
			DllCall( "gdi32.dll\Rectangle", "uint", hdc_frame_m, "int", 0,"int",0,"int", VirtualScreenWidth,"int",VirtualScreenWidth)
			DllCall( "gdi32.dll\Rectangle", "uint", hdc_frame_m, "int", scan_x_start,"int",scan_y_start,"int", scan_x,"int",scan_y)
		} else {
			break
		}
	}
 
	;KeyWait, LButton, U
	MouseGetPos, scan_x_end, scan_y_end
	Gui Destroy
 
	if (scan_x_start < scan_x_end)
	{
		x_start := scan_x_start
		x_end := scan_x_end
	} else {
		x_start := scan_x_end
		x_end := scan_x_start
	}
 
	if (scan_y_start < scan_y_end)
	{
		y_start := scan_y_start
		y_end := scan_y_end
	} else {
		y_start := scan_y_end
		y_end := scan_y_start
	}
}



F10::
	Pause
Return

F11::
	Reload
Return

F12::
	Exit
Return


