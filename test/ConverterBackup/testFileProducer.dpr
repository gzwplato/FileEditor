program testFileProducer;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var f:textfile;
    c:array[1..1024*1024] of char;
    i,ii:integer;

begin
  Randomize;
  AssignFile(f,'testfile.txt');
  ReWrite(f);
  for i:=1 to 1000000000 do
  begin
    for ii:=1 to 1024*1024 { 1024*1024byte=1MB} do
    begin
      c[ii]:=char(round(random * 255));
    end;
    WriteLn(f,String(c));
  end;
  CloseFile(f);
end.
 