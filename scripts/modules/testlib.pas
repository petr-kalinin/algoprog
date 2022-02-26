{ Copyright(c) SPb-IFMO CTD Developers, 2000 }
{ Copyright(c) Anton Sukhanov, 1996 }

{ $Id: testlib.pas 192 2007-10-30 15:22:24Z *KAP* $ }

{ Evaluating programs support stuff }

{$ifdef VER70}
{$ERROR}
{$ELSE}
{$I-,O+,Q+,R+,S+}
{$endif}

{$ifdef fpc}
{$mode delphi}
{$endif}

(*
    Program, using testlib running format:
      CHECK <Input_File> <Output_File> <Answer_File> [<Result_File> [-xml]],

    If result file is specified it will contain results.
*)

(*
    Modifications log:
      dd.mm.yyyy  modified by          modification log
      22.01.2010  Petr Kalinin         Modified for IJE stand-alone pack and to run under FPC
      14.01.2007  Petr Kalinin         Modified to support different encodings
      23.02.2006  Petr Kalinin         Modified for IJE 5.0
      09.07.2004  Petr Kalinin         ReadInt64 proc added
      19.07.2003  Petr Kalinin         Modified for IJE
      01.05.2003  Maxim Babenko        Support for custom xml tags added
      31.03.2003  Georgiy Korneev      -xml switch added instead of -appes.
                                       XML header for DOS-encoding added
      27.10.2002  Andrew Stankevich    Buffered input (speedup up to 2 times on big files)
                                       BP7.0 compatibility removed
      17.09.2000  Andrew Stankevich    XML correct comments
      01.08.2000  Andrew Stankevich    Messages translated to English
                                       APPES support added
                                       FAIL name changed
      07.02.1998  Roman Elizarov       Correct EOF processing
      12.02.1998  Roman Elizarov       SeekEoln corrected
                                       eoln added
                                       nextLine added
                                       nextChar is now function
*)

unit testlib;

interface

{$i interface.inc.pas}

type
    CharSet = set of char;
    TMode   = (_Input, _Output, _Answer);
              {
                _ok - accepted,
                _wa - wrong answer,
                _pe - output format mismatch,
                _fail - when everything fucks up
                _dirt - for inner using
              }

    InStream = object
        f: file; { file }
        name: string; { file name }
        mode: TMode;
        opened: boolean;
        fpos: integer;
        size: integer;

        buffer: array [0..BUFFER_SIZE - 1] of char;
        bpos: integer;
        bsize: integer;

        { for internal usage }
        procedure fillbuffer;
        constructor init(fname: string; m: TMode);

        function curchar: char; { returns cur }
        procedure skipchar;  { skips current char }
        function nextchar: char;  { moves to next char }
        function readchar: char;  { moves to next char }

        procedure Reset;

        function Eof: boolean;
        function SeekEof: boolean;

        function Eoln: boolean;
        function SeekEoln: boolean;

        procedure NextLine; { skips current line }

        { Skips chars from given set }
        { Does not generate errors }
        procedure Skip(setof: CharSet);

        { Read word. Skip before all chars from `before`
          and after all chars from `after`. }
        function ReadWord(Before, After: CharSet): string;

        { reads int64 }
        { _pe if error }
        function ReadInt64: int64;

        { reads integer }
        { _pe if error }
        function ReadLongint: integer;

        { = readlongint }
        function ReadInteger: integer;

        { reads real }
        { _pe if error }
        function ReadReal: extended;

        { same as readword([], [#13 #10]) }
        function ReadString: string;

        { for internal usage }
        procedure Quit(res: TResult; msg: string);
        procedure Close;

    end;


procedure Quit(res: TResult; msg: string); overload;
procedure QuitPC(pctype: longint; msg: string);
procedure Quit(res: TResult; pctype:longint; msg: string); overload;
function cutHelp(help : string; adds : string = '...') : string;
function str(i:int64):string;
function ConvertEncoding(srcEnc,destEnc:integer;s:string):string;

var
    inf, ouf, ans: InStream;
    ResultName: string; { result file name }
    XMLMode: boolean;
    WorkingEncoding: integer =1251;

implementation

uses
    sysutils
    {$ifdef WINDOWS}
    , windows,  crt32
    {$ENDIF}
    ;

{$i implementation.inc.pas}

const
    LightGray = $07;
    LightRed  = $0c;
    LightCyan = $0b;
    LightGreen = $0a;
    Yellow = $0e;

const
  maxTags = 256;

type
  TTag = record
    name : string;
    value : string;
  end;

procedure QuitPC(pctype: longint; msg: string);
begin
    quit(_pc, pctype, msg);
end;

procedure Quit(res: TResult; msg: string); overload;
begin
Quit(res,0,msg);
end;


function ConvertEncoding(srcEnc,destEnc:integer;s:string):string;
var s1:pWideChar;
    s2:pChar;
    res:string;
begin
{$ifdef WINDOWS}
if s='' then begin
   res:='';
   exit;
end;
GetMem(s1,length(s)*4);
GetMem(s2,length(s)*4);
MultiByteToWideChar(srcEnc,0,PChar(s),-1,s1,length(s)*2);
WideCharToMultiByte(destEnc,0,s1,-1,s2,length(s)*4,nil,nil);
res:=s2;
FreeMem(s1);
FreeMem(s2);
result:=res;
{$ELSE}
result:=s;
{$ENDIF}
end;

procedure Quit(res: TResult; pctype:longint; msg: string); overload;
var
    errorname: string;
    outcome:tOutcome;

    procedure scr(color: word; msg: string);
    begin
       if resultname = '' then { if no result file }
       begin
          TextColor(color); write(msg); TextColor(LightGray);
       end;
    end;

begin
    if (res = _ok)and(ouf.opened) then
    begin
        if not ouf.seekeof then quit(_pe, 'Extra information in the output file');
    end;
    {$ifdef WINDOWS}
    if res=_fail then
       beep(100,300);
    {$endif}
    if not (res in [minres..maxres]) then
       quit(_fail,'What is this code: _'+inttostr(byte(res)));
    errorname:=stext(res);
    Scr(attrib(res),errorname);
    if ResultName <> '' then begin //only XML is now supported
       outcome.res:=res;
       outcome.text:=ConvertEncoding(WorkingEncoding,1251,msg);
       if outcome.res=_pc then
          outcome.res:=_pcbase+pctype;
       SaveOutcome(ResultName,outcome);
    end;
    Scr(LightGray, ' '+ConvertEncoding(WorkingEncoding,866,msg));
    writeln;
    if Res = _fail then HALT;
    close(inf.f);
    if ouf.opened then close(ouf.f); 
    close(ans.f);
    TextColor(LightGray);
    if (res = _ok) or (ResultName <> '') then
        halt(0)
    else
        halt(ord(res));
end;

procedure InStream.fillbuffer;
var
    left: integer;
begin
    left := size - fpos;
    bpos := 0;

    if left = 0 then
    begin
        bsize := 1;
        buffer[0] := eofchar;
    end else begin
        blockread(f, buffer, buffer_size, bsize);
        fpos := fpos + bsize;
    end;
end;

procedure InStream.Reset;
begin
    if opened then
        close;

    fpos := 0;
    system.reset(f, 1);

    size := filesize(f);

    if ioresult <> 0 then
    begin
        if mode = _output then
            quit(_pe, 'File not found: "' + name + '"');
        bsize := 1;
        bpos := 0;
        buffer[0] := eofchar;
    end else begin
        fillbuffer;
    end;

    opened := true;
end;

constructor InStream.init(fname: string; m: TMode);
begin
    opened := false;
    name := fname;
    mode := m;

    assign(f, fname);

    reset;
end;

function InStream.Curchar: char;
begin
    curchar := buffer[bpos];
end;

function InStream.NextChar: char;
begin
    NextChar := buffer[bpos];
    skipchar;
end;

function InStream.ReadChar: char;
begin
    ReadChar := buffer[bpos];
    skipchar;
end;

procedure InStream.skipchar;
begin
    if buffer[bpos] <> EofChar then
    begin
        inc(bpos);
        if bpos = bsize then
            fillbuffer;
    end;
end;

procedure InStream.Quit(res: TResult; msg: string);
begin
    if mode = _Output then
        testlib.quit(res, msg)
    else
        testlib.quit(_fail, msg + ' (' + name + ')');
end;

function InStream.ReadWord(Before, After: CharSet): string;
begin
    while buffer[bpos] in Before do skipchar;

    if (buffer[bpos] = EofChar) and not (buffer[bpos] in after) then
        quit(_pe, 'Unexpected end of file');

    result := '';
    while not ((buffer[bpos] in After) or (buffer[bpos] = EofChar))  do
    begin
        result := result + nextchar;
    end;
end;

function cutHelp(help : string; adds : string = '...') : string;
begin
  if length(help) > 30 then
    cutHelp := copy(help, 1, 30) + adds
  else
    cutHelp := help;
end;

function InStream.ReadInt64: int64;
var
    help: string;
    code: integer;
begin
    while (buffer[bpos] in NumberBefore) do skipchar;

    if (buffer[bpos] = EofChar) then
        quit(_pe, 'Unexpected end of file - integer expected');

    help := '';
    while not (buffer[bpos] in NumberAfter) do
        help := help + nextchar;
    val(help, result, code);
    if code <> 0 then Quit(_pe, 'Expected integer instead of "' + cutHelp(help) + '"');
end;

function InStream.ReadInteger: integer;
var
    help: string;
    code: integer;
begin
    while (buffer[bpos] in NumberBefore) do skipchar;

    if (buffer[bpos] = EofChar) then
        quit(_pe, 'Unexpected end of file - integer expected');

    help := '';
    while not (buffer[bpos] in NumberAfter) do
        help := help + nextchar;
    val(help, result, code);
    if code <> 0 then Quit(_pe, 'Expected integer instead of "' + cutHelp(help) + '"');
end;

function InStream.ReadLongint: integer;
var
    help: string;
    code: integer;
begin
    while (buffer[bpos] in NumberBefore) do skipchar;

    if (buffer[bpos] = EofChar) then
        quit(_pe, 'Unexpected end of file - integer expected');

    help := '';
    while not (buffer[bpos] in NumberAfter) do
        help := help + nextchar;
    val(help, result, code);
    if code <> 0 then Quit(_pe, 'Expected integer instead of "' + cutHelp(help) + '"');
end;

function InStream.ReadReal: extended;
var
    help: string;
    code: integer;
begin
    help := ReadWord (NumberBefore, NumberAfter);
    val(help, result, code);
    if code <> 0 then Quit(_pe, 'Expected real instead of "' + cutHelp(help) + '"');
end;

procedure InStream.skip(setof: CharSet);
begin
    while (buffer[bpos] in setof) and (buffer[bpos] <> eofchar) do skipchar;
end;

function InStream.eof: boolean;
begin
    eof := buffer[bpos] = eofChar;
end;

function InStream.seekEof: boolean;
begin
    while (buffer[bpos] in Blanks) do skipchar;
    seekeof := buffer[bpos] = EofChar;
end;

function InStream.eoln: boolean;
begin
    eoln:= buffer[bpos] in eolnChar;
end;

function InStream.SeekEoln: boolean;
begin
    skip([' ', #9]);
    seekEoln := eoln;
end;

procedure InStream.nextLine;
begin
    while not (buffer[bpos] in eolnChar) do skipchar;
    if buffer[bpos] = #13 then skipchar;
    if buffer[bpos] = #10 then skipchar;
end;

function InStream.ReadString: string;
begin
    readstring := ReadWord([], lineAfter);
    nextLine;
end;

procedure InStream.close;
begin
    if opened then system.close(f);
    opened := false;
end;

initialization
    if sizeof(integer) <> 4 then
        quit(_fail, '"testlib" unit assumes "sizeof(integer) = 4"');

    if (ParamCount < 2) or (ParamCount > 5) then
        quit(_fail, 'Program must be run with the following arguments: ' +
            '<input-file> <output-file> <answer-file> [<report-file> [-xml]]');

    case ParamCount of
        2, 3:
            begin
                ResultName := '';
                XMLMode := false;
            end;
        4:
            begin
                ResultName := ParamStr(4);
                XMLMode := false;
            end;
        5: begin
                if (uppercase(ParamStr(5)) <> '-APPES') and (uppercase(ParamStr(5)) <> '-XML') then
                    quit(_fail, 'Program must be run with the following arguments: ' +
                        '<input-file> <output-file> <answer-file> [<report-file> [<-xml>]]');
                ResultName := ParamStr(4);
                XMLMode := true;
           end;
    end; { case }

   inf.init (ParamStr (1), _Input);
   if (ParamCount > 2) then begin
     ouf.init (ParamStr (2), _Output);
     ans.init (ParamStr (3), _Answer);
   end else begin
     ans.init (ParamStr (2), _Answer);
   end;

end.
