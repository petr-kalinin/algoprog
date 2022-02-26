{$A-,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O-,P+,Q+,R+,S+,T-,U-,V+,W-,X+,Y+,Z1}
{$ifdef release}
{$D-,L-}
{$endif}

{$ifdef fpc}
{$mode delphi}
{$endif}

{ This file is part of IJE: the Integrated Judging Environment system }
{ (C) Kalinin Petr 2002-2008 }
{ $Id: ievallib.pas 202 2008-04-19 11:24:40Z *KAP* $ }
unit ievallib;

interface

uses sysutils;

{$i interface.inc.pas}

var hisres:tHisResults;
    p:tproblem;

procedure init;
procedure finish;
function hastype(i,j:integer):boolean;

implementation

uses xml;
{$i implementation.inc.pas}

function StringToML(s:string):longint;
var ss,sss:string;
    i:integer;
    rez:longint;
begin
i:=1;ss:='';
while s[i] in ['0'..'9'] do begin
      ss:=ss+s[i];
      inc(i);
end;
sss:=copy(s,i,length(s)-i+1);
if ss='' then begin
   result:=0;
   exit;
end;
rez:=StrToInt(ss);
if (sss='M')or(sss='Mb')or(sss='MB') then
   rez:=rez*1024*1024
else if (sss='K')or(sss='Kb')or(sss='KB') then
    rez:=rez*1024
else if (sss='b')or(sss='')or(sss='B') then
else raise Exception.Create(format('Strange unit in ML - %s',[sss]));
result:=rez;
end;

function StringToTL(s:string):longint;
var ss,sss:string;
    i:integer;
    rez:longint;
begin
i:=1;ss:='';
while s[i] in ['0'..'9'] do begin
      ss:=ss+s[i];
      inc(i);
end;
sss:=copy(s,i,length(s)-i+1);
if ss='' then begin
   result:=0;
   exit;
end;
rez:=StrToInt(ss);
if (sss='s')or(sss='sec')or(sss='S')or(ss='Sec') then
   rez:=rez*1000
else if (sss='msec')or(sss='ms') then
else raise Exception.Create(format('Strange unit in TL - %s',[sss]));
result:=rez;
end;

procedure ExplodeArray(s:string;var a:array of integer);
var i,p:integer;
    cur:string;
begin
s:=s+#0;
cur:='';
p:=-1;
for i:=1 to length(s) do begin
    case s[i] of
         '0'..'9':cur:=cur+s[i];
         else if cur<>'' then begin
              inc(p);
              if p>High(a) then
                 raise Exception.Create(format('Too long string: number of elements exceeds %d',[High(a)]));
              a[p]:=StrToInt(cur);
              cur:='';
         end;
    end;
end;
for i:=p+1 to High(a) do
    a[i]:=-1;
end;

procedure ImplodeArray(var a:array of integer;var s:string);
var i:integer;
begin
s:='';
for i:=High(a) downto 0 do
    if a[i]<>-1 then
       break;
if (i<0) or (a[i]=-1) then
   exit;
for i:=i downto 0 do
    s:=' '+IntToStr(a[i])+s;
delete(s,1,1);
end;

procedure MakeTestFileName(fmt:string;number:integer;var fname:string);
var s:array[1..2] of string;
    nn:integer;
    p:integer;
    ff:string;
    i:integer;
begin
s[1]:='';s[2]:='';
p:=1;
nn:=0;
for i:=1 to length(fmt) do
    if fmt[i]='#' then begin
       inc(nn);
       if p=1 then p:=2;
    end else
      s[p]:=s[p]+fmt[i];
ff:=s[1]+'%'+inttostr(nn)+'.'+inttostr(nn)+'d'+s[2];
fname:=format(ff,[number]);
end;

procedure LoadProblem(fname:string;var a:tProblem);
var raw_points:array[1..maxtests] of string;
    raw_eval:array[1..maxtests] of string;
    root0:pXMLelement;
    root:pXMLelement;
    name:pXMLelement;
    judging:pXMLelement;
    script:pXMLelement;
    verifier:pXMLelement;
    binary:pXMLelement;
    evaluator:pXMLelement;
    binary1:pXMLelement;
    testset:pXMLelement;
    test:pXMLelement;
    i:integer;
begin
fillchar(a,sizeof(a),0);
readXMlfile(fname,root0);
try
  root:=findXMLelementEC(root0,'problem');
  a.id:=XMLtoText(findXMLattrEC(root,'id'));
  name:=findXMLelementCC(root,'name');
    a.name:=XMLtoText(findXMLattrEC(name,'value'));
  judging:=findXMLelementCC(root,'judging');
    script:=findXMLelementCC(judging,'script');
      verifier:=findXMLelementCC(script,'verifier');
        binary:=findXMLelementCC(verifier,'binary');
          a.verifier:=XMLtoText(findXMLattrEC(binary,'href'));
      evaluator:=findXMLelementC(script,'evaluator');
        binary1:=findXMLelementC(evaluator,'binary');
          a.evaluator:=XMLtoText(findXMLattrEC(binary1,'href',false));
      testset:=findXMLelementCC(script,'testset');
        a.input_name:=XMLtoText(findXMLattrEC(testset,'input-name'));
        a.output_name:=XMLtoText(findXMLattrEC(testset,'output-name'));
        a.input_href:=XMLtoText(findXMLattrEC(testset,'input-href'));
        a.answer_href:=XMLtoText(findXMLattrEC(testset,'answer-href'));
        a.tl:=StringToTL(findXMLattrEC(testset,'time-limit'));
        a.ml:=StringToML(findXMLattrEC(testset,'memory-limit'));
        test:=findXMLelementCC(testset,'test');
        i:=0;
        while test<>nil do begin
          inc(i);
          raw_points[i]:=XMLtoText(findXMLattrEC(test,'points'));
          raw_eval[i]:=XMLtoText(findXMLattrEC(test,'eval-types',false));

          test:=findXMLelement(test^.next,'test');
        end;
        a.ntests:=i;
  for i:=1 to a.ntests do begin
     ExplodeArray(raw_points[i],a.test[i].points);
     ExplodeArray(raw_eval[i],a.test[i].evalt);
     MakeTestFileName(a.input_href,i,a.test[i].input_href);
     MakeTestFileName(a.answer_href,i,a.test[i].answer_href);
  end;
finally
  XMldispose(root0);
end;
end;

function XMltoResult(s:string):tresult;
begin
for result:=minres to maxres do
    if XMLtext(result)=s then
       exit;
for result:=_pcbase+1 to _pcbase+maxpc do
    if XMLtext(result)=s then
       exit;
raise Exception.Create('Strange XML result: '''+s+'''');
end;

procedure LoadHisResults(fname:string;var a:tHisResults);
var root0:pXMLelement;
    root:pXMLelement;
    test:pXMLelement;
    i:integer;
begin
fillchar(a,sizeof(a),0);
readXMlfile(fname,root0);
try
  root:=findXMLelementEC(root0,'hisresults');
  test:=findXMLelementCC(root,'test');
  i:=0;
  while test<>nil do begin
    inc(i);
    a.test[i].res:=XmlToResult(findXMLattrEC(test,'res'));
    a.test[i].text:=XMLtoText(findXMLattrEC(test,'text'));
    a.test[i].evaltext:=XMLtoText(findXMLattrEC(test,'evaltext'));

    test:=findXMLelement(test^.next,'test');
  end;
  a.ntests:=i;
finally
  XMldispose(root0);
end;
end;

procedure SaveHisResults(fname:string;var a:tHisResults);
var f:text;
    buf:packed array[0..8191] of byte;
    i:integer;
begin
assign(f,fname);rewrite(f);SetTextBuf(f,buf,sizeof(buf));
writeln(f,'<?xml version="1.0" encoding="Windows-1251"?>');
  write(f,'<hisresults');
  writeln(f,'>');
  for i:=1 to a.ntests do begin
    write(f,'  <test');
    write(f,format(' res="%s"',[Xmltext(a.test[i].res)]));
    write(f,format(' text="%s"',[TextToXML(a.test[i].text)]));
    write(f,format(' evaltext="%s"',[TextToXML(a.test[i].evaltext)]));
    writeln(f,'/>');
  end;
  writeln(f,'</hisresults>');
close(f);
end;

procedure init;
begin
if paramcount<>2 then begin
   writeln('Evaluator usage: <program name> <problem.xml> <results-file(.xml)>');
   halt;
end;
loadproblem(paramstr(1),p);
LoadHisresults(paramstr(2),hisres);
end;

procedure finish;
begin
SaveHisResults(paramstr(2),hisres);
end;

function hastype(i,j:integer):boolean;
var k:integer;
begin
hastype:=true;
for k:=1 to MaxEvalTypes do
    if p.test[i].evalt[k]=j then
       exit;
hastype:=false;
end;

begin
end.