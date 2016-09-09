program FileEditor;

uses
  Forms, Interfaces,
  unitFormMain in 'unitformmain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Init();
  Application.CreateForm(TFormMain, FormMain);
  Application.Title:='Text Editor';
  Application.ShowMainForm:=True;
  Application.Run;
end.
