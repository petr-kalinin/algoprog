function stext(a:tresult):string;
begin
if a<_pcbase then
   result:=_stext[a]
else result:=_stext[_pc];
end;

function attrib(a:tresult):byte;
begin
if a<_pcbase then
   result:=_attrib[a]
else result:=_attrib[_pc];
end;

function TextColor(a:tresult):longint;
begin
if a<_pcbase then
   result:=_TextColor[a]
else result:=_TextColor[_pc];
end;

function ltext(a:tresult):string;
begin
if a<_pcbase then
   result:=_ltext[a]
else result:=_ltext[_pc]+format('(%d)',[a-_pcbase]);
end;

function RusText(a:tresult):string;
begin
if a<_pcbase then
   result:=_Rustext[a]
else result:=_Rustext[_pc]+format('(%d)',[a-_pcbase]);
end;

function XmlText(a:tresult):string;
begin
if a<_pcbase then
   result:=_XMLtext[a]
else result:=_XMLtext[_pc]+'-'+inttostr(a-_pcbase);
end;
               
function str(i:int64):string;
begin
result:=inttostr(i);
end;

function texttoXML(s:string):string;
var i:integer;
begin
result:='';
for i:=1 to length(s) do
    case s[i] of
         '&':result:=result+'&amp;';
         '<':result:=result+'&lt;';
         '>':result:=result+'&gt;';
         '"':result:=result+'&quot;';
         #0..#31:result:=result+'&#'+inttostr(ord(s[i]))+';';
         else result:=result+s[i];
    end;
end;

procedure SaveOutcome(fname:string;var a:tOutcome);
var pctype:integer;
    f:text;
    buf:packed array[0..8191] of byte;
begin
assign(f,fname);rewrite(f);SetTextBuf(f,buf,sizeof(buf));
if a.res>_pcbase then
   pctype:=a.res-_pcbase
else pctype:=0;
writeln(f,'<?xml version="1.0" encoding="Windows-1251"?>');
  write(f,'<result');
  write(f,format(' outcome="%s"',[Xmltext(a.res)]));
  write(f,format(' comment="%s"',[TextToXML(a.text)]));
  write(f,format(' pc-type="%d"',[pctype]));
  writeln(f,'/>');
close(f);
end;

