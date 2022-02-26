type tResult=byte;
const _ok=0;_wa=1;_pe=2;_tl=3;_ml=4;_ol=5;_il=6;_re=7;_cr=8;_sv=9;_nc=10;_ce=11;
      _ns=12;_cp=13;_fl=14;_nt=15;_pc=16;
      _fail=_fl;
      _pcbase=100;//values for pc starts from _pcbase+1, not from _pcbase
const 
    eofChar  = #$1A;
    eofRemap = ' ';
    NumberBefore = [#10,#13,' ',#09];
    NumberAfter  = [#10,#13,' ',#09,eofChar];
    lineAfter    = [#10,#13,eofChar];
    Blanks       = [#10,#13,' ',#09];
    eolnChar     = [#10,#13,eofChar];

    BUFFER_SIZE = 1048576;

const minres=_ok;maxres=_pc;
      _stext:array[minres..maxres] of string=
              ('OK','WA','PE','TL','ML','OL','IL','RE','CR','SV','NC','CE','NS','CP','FL','NT','PC');
      _attrib:array[minres..maxres] of byte=
              (10,   12,  11,  9,   9,   9,    9,  4,    4,  3,   2,   13,  1,    2,  13,  13,14);
      _TextColor:array[minres..maxres] of longint=
              ($00aa00,$0000ff,$777700,$770000,$770000,$770000,$770000{IL},$000077,$000077,$000077,
                  $004400,$aa00aa{CE},$000000,$004400,$ff00ff,$004400,$00aaaa{PC});
      _ltext:array[minres..maxres] of string=
              ('Accepted',
               'Wrong answer',
               'Presentation error',
               'Time limit exceeded',
               'Memory limit exceeded',
               'Output limit exceeded',
               'Idleness limit exceeded',
               'Runtime error',
               'Crash',
               'Security violation',
               'Accepted, but not counted',
               'Compilation error',
               'Problem wasn''t submitted',
               'Compiled, but wasn''t tested',
               'Tester failed',
               'Not tested',
               'Partial correct');
      _RusText:array[minres..maxres] of string=
              ('Верно',
               'Неверный ответ',
               'Нарушен формат выходных данных',
               'Превышен предел времени исполнения',
               'Превышен предел памяти',
               'Превышен предел размера выходного файла',
               'Превышен предел вренени простоя',
               'Ненулевой код возврата',
               'Недопустимая операция', 
               'Нарушение правил',
               'Верно, но не зачтено',
               'Ошибка компиляции',
               'Задача не сдавалась',
               'Скомпилировано',
               'Ошибка тестирующей системы',
               'Не тестировано',
               'Частично верно');
      _XMLtext:array[minres..maxres] of string=
              ('accepted',
               'wrong-answer',
               'presentation-error',
               'time-limit-exceeded',
               'memory-limit-exceeded',
               'output-limit-exceeded',
               'idleness-limit-exceeded',
               'runtime-error',
               'crash',
               'security-violation',
               'accepted-not-counted',
               'compilation-error',
               'not-submitted',
               'compiled-not-tested',
               'fail',
               'not-tested',
               'partial-correct');
const maxtests=150;maxevaltypes=10;maxPC=10;
type tHisResults=record
                  ntests:integer;
                  test:array[1..maxtests] of record
                    res:tResult;
                    text:string;
                    evaltext:string;
                  end;
                 end;
type tOutcome=record
                    res:tResult;
                    text:string;
              end;
     tEvalTypes=array[1..MaxEvalTypes] of integer;
     tPoints=array[0..MaxPC] of integer;
     tTest=record
             input_href:string;
             answer_href:string;
             points:tPoints;
             evalt:tEvalTypes;
           end;
     tProblem=record
                id:string;
                name:string;
                ntests:integer;
                test:array[1..MaxTests] of tTest;
                input_name:string;
                output_name:string;
                input_href,
                answer_href:string;
                verifier,evaluator:string;
                tl,ml:longint;
              end;
