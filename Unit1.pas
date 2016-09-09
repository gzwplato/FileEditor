unit Unit1;

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ExtCtrls, Buttons, Math;

type

  { TFormMain }

  TFormMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItemNew: TMenuItem;
    MenuItemExit: TMenuItem;
    MenuItemSaveAs: TMenuItem;
    MenuItemSave: TMenuItem;
    MenuItemOpen: TMenuItem;
    MenuItemFile: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    PanelText: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure MenuItemNewClick(Sender: TObject);
    procedure MenuItemOpenClick(Sender: TObject);
    procedure PanelTextPaint(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

  procedure init();

var
  FormMain: TFormMain;
  fittingLines:integer;
  line:integer = 1;
  lines:array of string;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.MenuItemNewClick(Sender: TObject);
begin
end;

procedure TFormMain.MenuItemExitClick(Sender: TObject);
begin
  halt;
end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  Dec(Line);
  if Line<1 then Line:=1;
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  Inc(Line);
  if Line>=length(lines) then Line:=Length(Lines)-1;
end;

procedure TFormMain.MenuItemOpenClick(Sender: TObject);
var f:textfile;
  i:integer;
  s:string;
begin
  //OPEN DIALOG
  if OpenDialog1.Execute then
  begin
    //OPEN FILE
    AssignFile(f,OpenDialog1.FileName);
    ReSet(f);
    lines:=nil;
    SetLength(lines,fittingLines);

    for i:=1 to line do
    begin
      ReadLn(f,s);
    end;
    for i:=line to line+fittinglines do
    begin
      if not eof(f) then
      begin
        ReadLn(f,s);
        lines[i]:=s;
      end;
    end;
  end;
end;

procedure TFormMain.PanelTextPaint(Sender: TObject);
var Panel:TPanel;
  TextRect:TRect;
  i:integer;
  spaceBetweenLines:integer = 5;
  s:string;
begin
  Panel := Sender as TPanel;

  TextRect := TRect.Create(0,0,Panel.Width,Panel.Height);

  fittingLines := Floor {Abrunden}(Panel.Height / (Panel.Canvas.Font.Size + spaceBetweenLines));
  Label1.Caption:=IntToStr(fittingLines);
  for i:=1 to fittingLines+1 do
  begin
    if length(lines) >= i then
    begin
      s:=lines[i];
      Panel.Canvas.TextRect(TextRect,0,i*(Panel.Canvas.Font.Size + spaceBetweenLines),s);
    end;
  end;
end;

procedure init();
begin
end;

end.
