program FileEditor;

uses
  Forms, Interfaces,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Init();
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
