{$A-,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O-,P+,Q+,R+,S+,T-,U-,V+,W-,X+,Y+,Z1}
{$ifdef release}
{$D-,L-}
{$endif}
{$ifdef fpc}
{$mode delphi}
{$endif}
{ This file is part of IJE: the Integrated Judging Environment system }
{ (C) Kalinin Petr 2002-2008 }
{ $Id: XML.PAS 202 2008-04-19 11:24:40Z *KAP* $ }
unit xml;

interface
uses sysutils;

const strchars=['A'..'Z','a'..'z','-','_','~','0'..'9'];
      blanks=[' ',#13,#10,#9];
type pXMLattr=^tXMLattr;
     tXMLattr=record
       name,value:string;
       next:pXMLattr;
     end;

     pXMLelement=^tXMLelement;
     tXMLelement=record
       name:string;
       attr:pXMLattr;
       text:string;
       child:pXMLelement;
       next:pXMLelement;
     end;

procedure readXMLelement(var p:pXMLelement);
procedure readXMLattr(var p:pXMLattr);
procedure readXMLfile(fname:string;var p:pXMLelement);
procedure XMLdispose(var p:pXMLelement);
function findXMLelement(p:pXMLelement;name:string):pXMLelement;
function findXMLelementC(p:pXMLelement;name:string):pXMLelement;
function findXMLattr(p:pXMLattr;name:string):pXMLattr;
function findXMLattrE(p:pXMLelement;name:string):pXMLattr;
function findXMLelementCC(p:pXMLelement;name:string):pXMLelement;
function findXMLattrEC(p:pXMLelement;name:string;raiseonerror:boolean=true):string;
function findXMLelementEC(p:pXMLelement;name:string):pXMLelement;
function texttoXML(s:string):string;
function XMLtotext(s:string):string;

implementation
var curch:char;
    curs:string;
    oldline,oldpos,line,pos:integer;
    curfile:string;
    intag:boolean;
    text:string;
    textpos:integer;

procedure XMLerror(s:string);
begin
raise Exception.CreateFmt('XML error: while parsing %s, on line %d, in position %d: %s',[curfile,oldline,oldpos+1,s]);
end;

procedure nextch;
begin
if textpos>=length(text) then begin
   curch:=#26;
   exit;
end;
inc(textpos);
curch:=text[textpos];
inc(pos);
if curch=#13 then begin
   inc(line);
   pos:=0;
end;
if curch=#10 then pos:=0;
end;

procedure nexts;
begin
oldline:=line;oldpos:=pos;
curs:='';
if intag then while curch in blanks do nextch;
if curch=#26 then begin
   curs:=#26;
   exit;
end;
if curch='"' then begin
   curs:='"';
   nextch;
   while (curch<>'"')and(curch<>#26) do begin
         curs:=curs+curch;
         nextch;
   end;
   if curch=#26 then XMLerror('''"'' expected, bud EOF found');
   curs:=curs+'"';
   nextch;
   exit;
end;
if curch='<' then begin
   curs:=curch;
   nextch;
   if curch='/' then begin
      curs:=curs+curch;
      nextch;
   end;
   exit;
end;
if curch='/' then begin
   curs:=curch;
   nextch;
   if curch='>' then begin
      curs:=curs+curch;
      nextch;
   end;
   exit;
end;
if curch='?' then begin
   curs:=curch;
   nextch;
   if curch='>' then begin
      curs:=curs+curch;
      nextch;
   end;
   exit;
end;
curs:=curch;
nextch;
if not (curs[1] in strchars) then exit;
while curch in strchars do begin
      curs:=curs+curch;
      nextch;
end;
end;

function noq(s:string):string;
begin
if (s[1]='"')and(s[length(s)]='"') then
   result:=copy(s,2,length(s)-2)
else result:=s;
result:={XMltotext(}result{)};
end;

procedure readXMLattr(var p:pXMLattr);
begin
p:=nil;
if not (curs[1] in strchars) then exit;
new(p);
p^.name:=curs;
p^.next:=nil;
nexts;
if curs<>'=' then begin
   p^.value:='';
   readXMLattr(p^.next);
   exit;
end;
nexts;
if not(curs[1] in strchars+['"']) then
   XMLerror('Value of argument expected');
p^.value:=noq(curs);
nexts;
readXMLattr(p^.next);
end;

procedure readXMLelement(var p:pXMLelement);
var q:pXMLelement;
begin
intag:=true;
if curch in blanks then nexts;
p:=nil;
if curs=#26 then exit;
if curs<>'<' then XMLerror('Element expected');
nexts;
new(p);
p^.name:=curs;
p^.attr:=nil;
p^.text:='';
p^.child:=nil;
p^.next:=nil;
nexts;
readXMLattr(p^.attr);
if curs='/>' then begin
   nexts;
   exit;
end;
if (curs='?>')and(p^.name='?') then begin
   nexts;
   exit;
end;
if curs<>'>' then XMLerror('''>'' or ''/>'' expected');
nexts;
q:=nil;
p^.text:='';
p^.child:=nil;
intag:=false;
while true do begin
      if curs='<' then begin
         if q=nil then begin
            readXMLelement(p^.child);
            q:=p^.child;
         end else begin
             readXMLelement(q^.next);
             q:=q^.next;
         end;
      end else if curs='</' then begin
          nexts;
          if curs<>p^.name then XMLerror('Expected closing '''+p^.name+''', found '''+curs+'''');
          nexts;
          if curs<>'>' then XMLerror('''>'' expected');
          nexts;
          break;
      end else if curs=#26 then begin
          XMLerror('Expected closing '''+p^.name+''', found EOF');
      end else begin
          p^.text:=p^.text+curs;
{          XMLwarning('Text in tag found --- spaces will be omitted');}
          nexts;
      end;
end;
end;

procedure XMLdispose(var p:pXMLelement);
var q,qq:pXMLattr;
begin
if p=nil then exit;
q:=p^.attr;
while q<>nil do begin
      qq:=q^.next;
      dispose(q);
      q:=qq;
end;
XMLdispose(p^.child);
XMLdispose(p^.next);
dispose(p);
p:=nil;
end;

procedure readXMLfile(fname:string;var p:pXMLelement);
var q:pXMLelement;
    ch:char;
    f:file of char;
    nn:integer;
begin
try
  if fname[1]<>'^' then begin
     curfile:=fname;
     nn:=0;
     assign(f,fname);
     repeat
       try
         reset(f);
         break;
       except
         on e:exception do begin
            inc(nn);
            sleep(100);
            if nn>10 then
               raise;
         end;
       end;
     until false;
     p:=nil;
     text:='';
     while not eof(f) do begin
           read(f,ch);
           text:=text+ch;
     end;
     close(f);
     textpos:=0;
  end else begin
      curfile:='(string given)';
      text:=fname;
      textpos:=1;
  end;
  line:=1;pos:=0;
  nextch;
  nexts;
  intag:=true;
  readXMLelement(p);
  if p=nil then
     exit;
  try
    q:=p;
    repeat
      intag:=true;
      readXMLelement(q^.next);
      q:=q^.next;
    until q=nil;
  except
    XMLdispose(p);
    raise;
  end;
except
  on e:exception do
    raise Exception.create('While parsing '+fname+': '+e.message);
end;
end;

function findXMLelement(p:pXMLelement;name:string):pXMLelement;
begin
while (p<>nil)and(p^.name<>name) do p:=p^.next;
findXMLelement:=p;
end;

function findXMLattr(p:pXMLattr;name:string):pXMLattr;
begin
while (p<>nil)and(p^.name<>name) do p:=p^.next;
findXMLattr:=p;
end;

function findXMLattrE(p:pXMLelement;name:string):pXMLattr;
begin
if p=nil then
   findXMLattrE:=nil
else findXMLattrE:=findXMLattr(p^.attr,name);
end;

function findXMLelementC(p:pXMLelement;name:string):pXMLelement;
begin
if p=nil then findXMlelementC:=nil
else findXMLelementC:=findXMLelement(p^.child,name);
end;

function findXMLelementCC(p:pXMLelement;name:string):pXMLelement;
begin
result:=findXMLelementC(p,name);
if result=nil then
   raise Exception.Create(''''+name+''' element not found');
end;

function findXMLelementEC(p:pXMLelement;name:string):pXMLelement;
begin
result:=findXMLelement(p,name);
if result=nil then
   raise Exception.Create(''''+name+''' element not found');
end;

function findXMLattrEC(p:pXMLelement;name:string;raiseonerror:boolean=true):string;
var q:pXMlattr;
begin
q:=findXMLattrE(p,name);
if q=nil then begin
   if raiseonerror then
      raise Exception.Create(''''+name+''' attribute not found');
   findXMLattrEC:='';
end else findXMLattrEC:=q^.value;
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

function XMLtotext(s:string):string;
var i:integer;
    num:string;
begin
result:='';
i:=1;
while i<=length(s) do begin
      if s[i]='&' then begin
         if copy(s,i,5)='&amp;' then begin
            result:=result+'&';
            inc(i,5);
         end else if copy(s,i,4)='&lt;' then begin
            result:=result+'<';
            inc(i,4);
         end else if copy(s,i,4)='&gt;' then begin
            result:=result+'>';
            inc(i,4);
         end else if copy(s,i,6)='&quot;' then begin
            result:=result+'"';
            inc(i,6);
         end else if (i<length(s)) and (s[i+1]='#') then begin
             inc(i,2);
             num:='';
             while (i<=length(s))and(s[i] in ['0'..'9']) do begin
                   num:=num+s[i];
                   inc(i);
             end;
             if (i<=length(s))and(s[i]=';') then
                inc(i);
             result:=result+chr(StrToInt(num));
         end;
      end else begin
          result:=result+s[i];
          inc(i);
      end;
end;
end;

begin
end.