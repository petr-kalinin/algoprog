{$A-,B-,C-,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q+,R+,S+,T-,U-,V+,W-,X+,Y-,Z1}
{$ifdef release}
{$D-,L-}
{$endif}
{$ifdef fpc}
{$mode delphi}
{$endif}
{ (C) Kalinin Petr 2002-2008 }
{ $Id: crt32.pas 202 2008-04-19 11:24:40Z *KAP* $ }
unit crt32;
interface
Uses
  Messages,Windows;
Const
  Black       = 0;
  Blue        = 1;
  Green       = 2;
  Cyan        = 3;
  Red         = 4;
  Magenta     = 5;
  Brown       = 6;
  LightGray   = 7;
  DarkGray    = 8;
  LightBlue   = 9;
  LightGreen  = 10;
  LightCyan   = 11;
  LightRed    = 12;
  LightMagenta= 13;
  Yellow      = 14;
  White       = 15;
Var
 SizeX: Word;          { Window upper left coordinates }
 SizeY: Word;          { Window lower right coordinates }

Function GetHWND:HWND;

Function OutputInfo:_CONSOLE_SCREEN_BUFFER_INFO;
  {Same as GetColsoleScreenBufferInfo(cout,*) }

procedure SetWindowPos(x,y:integer);

procedure SetTitle(s:string);
  {Set a title at the console-window}

Function ReadKey:Char;
  {ABSOLUTELY like BP readkey, including behavior with such keys
   as INS, DEL, arrows, F1..F10, etc.}

Function ReadKeyEvent:_KEY_EVENT_RECORD;
  {As executing ReadConsoleInput until ...}

Function KeyPressed:Boolean;
  {As the normal KeyPressed function}

Procedure GotoXY(X,Y:Integer);
  {Moves the cursor to a position at X,Y}

Function WhereX:Integer;
  {Where is the cursor, X-direction}

Function WhereY:Integer;
  {Where is the cursor, Y-direction}

Procedure TextColor(c:byte);
  {Set the textcolor}

Procedure TextBackground(c:byte);
  {Set the Backgroundcolor}

Function GetTextBackGround:integer;
  {Returns with the color (one of the constants) that TextBackGround
   is using right now}

Function GetTextColor:integer;
  {Returns with color (one of the constants) that TextColor is
   using right now}

Procedure SetTextAttr(c:byte);
  {Set the colors, both Background and Textcolor. Use it with TextAttr
   to set a value. Save TextAttr, do some colorchanges, and restore the
   colors by setting this to the saved value}

Procedure OutXY(x,y: integer; const s: string; col: integer);
  {Output string s from position x,y with color col}
  
Procedure WriteA(s:string);
  {Output string s, converting commands like \$0f; and \10; to changing colors;
   for ex. s='\$0f;a\10;b' will output white-on-black letter 'a' and then
   green-on-black letter 'b'}

Procedure WriteLnA(s:string);

Function TextAttr:byte;

Procedure ClrScr;
  {Clear the screen, and return cursor to 0,0}

Function CurrentCols:Integer;
  {How many cols are the screen right now?}

Function CurrentRows:Integer;
  {How many rows are the screen right now?}

Procedure Delay(L:Word);
  {A delay-function that waits for at least Msec milliseconds}

Function OutputHandle:THandle;

Function InputHandle:THandle;

Function ErrorHandle:THandle;

Function GetChr(X,Y:Integer):Char;
  {Read a char from the screen in position X,Y}

Function GetScreenAttr(x,y:integer):byte;
  {Read attributes from (X,Y) position of the screen}

procedure InitConsole;
   {Reinit internal handlers --- when allocating a new console, for example}
   
procedure MaximizeConsole;

implementation

uses SysUtils;

var cin,cout,cerr:THandle;
    chwnd:hwnd;

Function GetHWND:HWND;
begin
GetHWND:=chwnd;
end; 

procedure SetTitle(s:string);
begin
setconsoletitle(PChar(s));
end;

procedure SetWindowPos(x,y:integer);
begin
windows.SetWindowPos(chwnd,0,x,y,0,0,SWP_NOSIZE+SWP_NOZORDER);
end;

procedure GotoCoord(a:tCoord);
begin
dec(a.X);
dec(a.y);
SetConsoleCursorPosition(cout,a);
end;

procedure GotoXY(X,Y:Integer);
var c:tcoord;
begin
c.x:=x;c.y:=y;
GotoCoord(c);
end;

Function GetCoord:tCoord;
var a:_coord;
begin
a:=OutputInfo.dwCursorPosition;
inc(a.x);
inc(a.y);
GetCoord:=a;
end;

function wherex:integer;
begin
wherex:=GetCoord.x;
end;

function wherey:integer;
begin
wherey:=GetCoord.y;
end;

procedure textcolor(c:byte);
begin
settextattr((textattr and $f0)or c);
end;

procedure textbackground(c:byte);
begin
settextattr((textattr and $0f) or (c shl 4));
end;

function gettextbackground:integer;
begin
gettextbackground:=(textattr and $f0) shr 4;
end;

function gettextcolor:integer;
begin
gettextcolor:=textattr and $0f;
end;

procedure settextattr(c:byte);
begin
SetConsoleTextAttribute(cout,c);
end;

procedure OutXY(x,y: integer; const s: string; col: integer);
var c: tcoord;
  r: cardinal;
begin
  c.x:=x-1;
  c.y:=y-1;
  WriteConsoleOutputCharacter(cout,pchar(s),length(s),c,r);
  FillConsoleOutputAttribute(cout,col,length(s),c,r);
end;

procedure WriteA(s:string);
var i:integer;
    ss:string;
    a:integer;
    oa:integer;
begin
oa:=TextAttr;
i:=1;
while i<=length(s) do begin
     if s[i]='\' then begin
         try
           ss:='';
           if (i<length(s)) and (s[i+1]='\') then
              raise Exception.Create('');
           repeat
             inc(i);
             if (i>length(s)) or (s[i]=';') then
                break;
             ss:=ss+s[i];
           until (not (s[i] in ['$','*','0'..'9','a'..'f','A'..'F']));
           if i<=length(s) then begin
              if ss='*' then
                 a:=oa
              else 
                 a:=strtoint(ss)
           end else
             raise Exception.Create('";" not found');
           settextattr(a);
         except
              write('\',ss);
         end;
      end else write(s[i]);
      inc(i);
end;
SetTextAttr(oa);
end;

procedure WriteLnA(s:string);
begin
writea(s);
writeln;
end;

Function OutputInfo:_CONSOLE_SCREEN_BUFFER_INFO;
begin
GetConsoleScreenBufferInfo(cout,result);
end;

Function TextAttr:byte;
begin
textattr:=OutputInfo.wAttributes;
end;

Procedure ClrScr;
var s:string;
    i,j:integer;
begin
s:='';
for i:=1 to CurrentRows do
    for j:=1 to CurrentCols do
        s:=s+' ';
outxy(1,1,s,TextAttr);
gotoxy(1,1);
end;

Function CurrentCols:Integer;
begin
CurrentCols:=OutputInfo.dwSize.X;
end;

Function CurrentRows:Integer;
begin
CurrentRows:=OutputInfo.dwSize.Y;
end;

Procedure Delay(L:word);
begin
Sleep(L);
end;

Function OutputHandle:THandle;
begin
OutputHandle:=cout;
end;

Function InputHandle:THandle;
begin
InputHandle:=cin;
end;

Function ErrorHandle:THandle;
begin
ErrorHandle:=cerr;
end;

Function ReadKeyEvent:_KEY_EVENT_RECORD;
var ir:_Input_Record;
    r:Cardinal;
begin
repeat
  ReadConsoleInput(cin,ir,1,r);
  if r=0 then continue;
  if ir.EventType<>KEY_EVENT then continue;
  if not ir.Event.KeyEvent.bKeyDown then continue;
  break;
until false;
ReadKeyEvent:=ir.Event.KeyEvent;
end;

function PascalCode(i:Word):char;
begin
case i of
     VK_F1:PascalCode:=#59;
     VK_F2:PascalCode:=#60;
     VK_F3:PascalCode:=#61;
     VK_F4:PascalCode:=#62;
     VK_F5:PascalCode:=#63;
     VK_F6:PascalCode:=#64;
     VK_F7:PascalCode:=#65;
     VK_F8:PascalCode:=#66;
     VK_F9:PascalCode:=#67;
     VK_F10:PascalCode:=#68;
     
     VK_F11:PascalCode:=#69;//not as in BP
     VK_F12:PascalCode:=#70;//not as in BP
     
     VK_INSERT:PascalCode:=#82;
     VK_HOME:PascalCode:=#71;
     VK_PRIOR:PascalCode:=#73;
     VK_DELETE:PascalCode:=#83;
     VK_END:PascalCode:=#79;
     VK_NEXT:PascalCode:=#81;
     VK_UP:PascalCode:=#72;
     VK_DOWN:PascalCode:=#80;
     VK_RIGHT:PascalCode:=#77;
     VK_LEFT:PascalCode:=#75;
     else PascalCode:=#0;
end;
end;

Function ReadKey:char;
var k:_KEY_EVENT_RECORD;
    ir:packed array[0..1] of _INPUT_RECORD;
    r:Cardinal;
begin
k:=ReadKeyEvent;
ReadKey:=k.AsciiChar;
ir[0].EventType:=KEY_EVENT;
ir[1].EventType:=KEY_EVENT;

ir[0].Event.KeyEvent.bKeyDown:=true;
ir[1].Event.KeyEvent.bKeyDown:=false;

ir[0].Event.KeyEvent.wRepeatCount:=1;
ir[1].Event.KeyEvent.wRepeatCount:=1;

ir[0].Event.KeyEvent.wVirtualKeyCode:=0;
ir[1].Event.KeyEvent.wVirtualKeyCode:=0;

ir[0].Event.KeyEvent.wVirtualScanCode:=0;
ir[1].Event.KeyEvent.wVirtualScanCode:=0;

ir[0].Event.KeyEvent.dwControlKeyState:=k.dwControlKeyState;
ir[1].Event.KeyEvent.dwControlKeyState:=k.dwControlKeyState;
if PascalCode(k.wVirtualKeyCode)<>#0  then begin
   ir[0].Event.KeyEvent.AsciiChar:=PascalCode(k.wVirtualKeyCode);
   ir[1].Event.KeyEvent.AsciiChar:=PascalCode(k.wVirtualKeyCode);;
   WriteConsoleInput(cin,ir[0],2,r);
end;
end;

Function KeyPressed:Boolean;
var ir:_INPUT_RECORD;
    r:cardinal;
begin
KeyPressed:=false;
repeat
  PeekConsoleInput(cin,ir,1,r);
  if r=0 then exit;
  if ir.EventType<>KEY_EVENT then begin
     ReadConsoleInput(cin,ir,1,r);
     continue;
  end;
  if not ir.Event.KeyEvent.bKeyDown then begin
     ReadConsoleInput(cin,ir,1,r);
     continue;
  end;
  break;
until false;
keypressed:=true;
end;

Function GetChr(X,Y:Integer):Char;
var ch:char;
    r:Cardinal;
    c:_Coord;
begin
c.x:=x-1;c.y:=y-1;
ReadConsoleOutputCharacter(cout,@ch,1,c,r);
GetChr:=ch;
end;

Function GetScreenAttr(x,y:integer):byte;
var r:Cardinal;
    c:_Coord;
    a:byte;
begin
c.x:=x-1;
c.y:=y-1;
ReadConsoleOutputAttribute(cout,@a,1,c,r);
GetScreenAttr:=a;
end;

function GetConsoleWindow:HWnd; stdcall; external kernel32 name 'GetConsoleWindow';

procedure InitConsole;
begin
cout:=getstdhandle(STD_OUTPUT_HANDLE);
cin:=getstdhandle(STD_INPUT_HANDLE);
cerr:=getstdhandle(STD_ERROR_HANDLE);
chwnd:=GetConsoleWindow;
end;

procedure MaximizeConsole;
var a:_coord;
    h:tHandle;
    rect:_SMALL_RECT;
begin
h:=getstdhandle(STD_OUTPUT_HANDLE);
a:=GetLargestConsoleWindowSize(h);
dec(a.y);
SetConsoleScreenBufferSize(h,a);
rect.Left:=0;
rect.Top:=0;
rect.Right:=a.X-1;
rect.Bottom:=a.Y-1;
SetConsoleWindowInfo(h,true,rect);
ShowWindow(GetConsoleWindow,SW_MAXIMIZE);
end;

begin
InitConsole;
//clrscr;
end.


