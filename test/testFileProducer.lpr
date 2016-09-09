program testFileProducer;

{$MODE Delphi}

{$APPTYPE CONSOLE}

uses
  SysUtils;

var f:textfile;
    c:array[1..1024*1024*1024] of char;
    i,ii:integer;

begin
  Randomize;
  AssignFile(f,'testfile.txt');
  ReWrite(f);
  for i:=1 to 1000000000 do
  begin
    for ii:=1 to 1024*1024*1024 { 1024*1024*1024byte=1GB} do
    begin
      c[ii]:=char(round(random * 255));
      if random > 0.9 then
      if random > 0.5 then c[ii]:=#10
      else c[ii]:=#13
    end;
    WriteLn(f,String(c));
    WriteLn('1 GB written');
  end;
  CloseFile(f);
end.
 
