unit unitFormMain;

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Menus, ExtCtrls, Buttons, LazHelpHTML,
  Math, unitFormAboutBox;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonUp: TButton;
    ButtonDown: TButton;
    FontDialog1: TFontDialog;
    LabelCursorPos: TLabel;
    LabelLCT: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItemFont: TMenuItem;
    MenuItemAbout: TMenuItem;
    MenuItemShowHelp: TMenuItem;
    MenuItemHelp: TMenuItem;
    MenuItemView: TMenuItem;
    MenuItemFormat: TMenuItem;
    MenuItemEdit: TMenuItem;
    MenuItemNew: TMenuItem;
    MenuItemExit: TMenuItem;
    MenuItemSaveAs: TMenuItem;
    MenuItemSave: TMenuItem;
    MenuItemOpen: TMenuItem;
    MenuItemFile: TMenuItem;
    OpenDialog1: TOpenDialog;
    PanelMain: TPanel;
    PanelRightSideBar: TPanel;
    PanelLineNumber: TPanel;
    PanelText: TPanel;
    TimerCursor: TTimer;
    procedure ButtonUpClick(Sender: TObject);
    procedure ButtonDownClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure MenuItemFontClick(Sender: TObject);
    procedure MenuItemNewClick(Sender: TObject);
    procedure MenuItemOpenClick(Sender: TObject);
    procedure PanelLineNumberPaint(Sender: TObject);
    procedure PanelTextPaint(Sender: TObject);
    procedure TimerCursorTimer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

  procedure paintText(Panel:TPanel);
  procedure updateLines();
  procedure loadFile();
  procedure updateFittingLines();
  procedure init();

var
  FormMain: TFormMain;
  fittingLines:integer;
  line:integer = 1;
  lines:array of string;
  FileName:string;
  spaceBetweenLines:integer = 1;
  DefaultFont: TFont;
  allChrs: string;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.MenuItemNewClick(Sender: TObject);
begin
  lines:=nil;
  setLength(lines,2);
  lines[1]:='';
  FileName:='New File.TXT';
end;

procedure TFormMain.MenuItemExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormMain.MenuItemFontClick(Sender: TObject);
begin
  FontDialog1.Font := Font;
  if FontDialog1.Execute then
  begin
    DefaultFont := FontDialog1.Font;
    updateLines();
  end;
end;

procedure TFormMain.ButtonUpClick(Sender: TObject);
begin
  Dec(Line);
  if Line<1 then Line:=1;
  updateLines();
end;

procedure TFormMain.ButtonDownClick(Sender: TObject);
begin
  Inc(Line);
  if Line>=length(lines) then Line:=Length(Lines)-1;
  updateLines();
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=true;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  updateLines();
end;

procedure TFormMain.MenuItemAboutClick(Sender: TObject);
begin
  FormAboutBox.Show;
end;

procedure TFormMain.MenuItemOpenClick(Sender: TObject);
begin
  //OPEN DIALOG
  if OpenDialog1.Execute then
  begin
    FileName:=OpenDialog1.FileName;

    //OPEN FILE
    updateLines();
  end;
end;

procedure TFormMain.PanelLineNumberPaint(Sender: TObject);
var Panel:TPanel;
  TextRect:TRect;
  i:integer;
  margin:integer=3;
begin
  Panel := Sender as TPanel;

  Panel.Canvas.Brush.Color:=clBtnFace;
  Panel.Canvas.Rectangle(0,0,Panel.Width,Panel.Height);

  TextRect := TRect.Create(0,0,Panel.Width,Panel.Height);

  for i:=line to line + fittingLines do
  begin
    Panel.width:=(margin*2)+Panel.Canvas.TextWidth(IntToStr(line + fittingLines));
    if length(lines) >= line then
    Panel.Canvas.TextRect(TextRect,margin,(i-line) * (FormMain.PanelText.Canvas.TextHeight(allChrs)),IntToStr(i));
      //Panel.Canvas.TextRect(TextRect,margin,(i-line)*(Panel.Canvas.TextHeight(lines[line])+spaceBetweenLines),IntToStr(i));
  end;
end;

procedure TFormMain.PanelTextPaint(Sender: TObject);
begin
  updateLines();
end;

var show_cursor:boolean = true;
  cursor_x : integer = 1;
  cursor_y : integer = 1;
procedure TFormMain.TimerCursorTimer(Sender: TObject);
begin
  show_cursor := not show_cursor;
  updateLines();
end;

function isAlpha(c: char):boolean;
begin
  isAlpha := (upcase(c) in ['A'..'Z']) or (c in ['0'..'9'])
end;

procedure TFormMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP     : Dec(cursor_y);
    VK_DOWN   : Inc(cursor_y);
    VK_LEFT   : Dec(cursor_x);
    VK_RIGHT  : Inc(cursor_x);
    VK_RETURN : Begin Inc(cursor_y); cursor_x := 1; End;
    else
    begin
      if isalpha(chr(key))or(key=ord(' ')) then
      begin
        if cursor_y > length(lines) then
        begin
          setlength(lines, cursor_y+1);
          lines[cursor_y] := '';
        end;
        if cursor_x > length(lines[cursor_y])-1 then
        begin
          setlength(lines[cursor_y], cursor_x+1);
          lines[cursor_y][cursor_x] := ' ';
        end;
        lines[cursor_y][cursor_x] := chr(key);
        Inc(cursor_x);
      end;
    end;
  end;

  if (cursor_x < 1) then cursor_x := 1;
  if (cursor_y < 1) then begin cursor_y := 1; Dec(Line); end;

  if (cursor_y > fittingLines) then begin cursor_y := fittingLines; Inc(line); end;

  if Line < 1 then Line := 1;
  if Line > length(Lines) then Line := Length(Lines);

  updateLines();
end;

var margin: integer = 3;

const
  NrOfTabSpaces=8;

function ReplaceTabs(s:string):string;
var
 ss:string;
 j,k:integer;
begin
 ss:='';
 for j:=1 to length(s) do
 if (s[j]=chr(9))
 then
 begin
  for k:=1 to NrOfTabSpaces do ss:=ss+' '
 end
 else ss:=ss+s[j];
 Result:=ss;
end;

function CursorIndexInReplacedString(i:integer;s:string):integer;
var
 j:integer;
begin
 Result:=1;

 if i>=2 then
 for j:=2 to i do
 begin
   if length(s)>=j-1 then
   if (s[j-1]=chr(9))
   then Result:=Result+NrOfTabSpaces
   else Result:=Result+1;
 end;
end;


procedure drawCursor();
var x1, y1, x2, y2,cursor_x_tab2spc : integer;
  s:string;
begin
  if not show_cursor then exit;
  if (length(lines) > cursor_y) then
  begin
    s:=lines[cursor_y];
    if s='' then s:=' ';

    cursor_x_tab2spc:= CursorIndexInReplacedString(cursor_x,s);
    s:=ReplaceTabs(s);

    // if (length(lines) > cursor_y) and (length(lines[cursor_y]) > cursor_x) then
    y1 := cursor_y * (FormMain.PanelText.Canvas.TextHeight(allChrs));
    y2 := y1;

    x1 := FormMain.PanelText.Canvas.TextWidth(copy(s,1,cursor_x_tab2spc-1));
    x2 := FormMain.PanelText.Canvas.TextWidth(copy(s,1,cursor_x_tab2spc));

    if (x2-x1)<6 then x2:=x1+6;
    FormMain.PanelText.Canvas.Line(x1+margin, y1, x2+margin, y2);
    FormMain.PanelText.Canvas.Line(x1+margin, y1-1, x2+margin, y2-1);
  end;

  FormMain.LabelCursorPos.Caption := 'X:' + IntToStr(cursor_x) + ' Y:' + IntToStr(cursor_y);
end;



procedure paintText(Panel:TPanel);
var TextRect:TRect;
  i:integer;
  s:string;
begin
  Panel.Canvas.Brush.Color:=clBtnFace;
  Panel.Canvas.Rectangle(0,0,Panel.Width,Panel.Height);

  TextRect := TRect.Create(0,0,Panel.Width,Panel.Height);

  FormMain.LabelLCT.Caption:=IntToStr(fittingLines);
  for i:=0 to fittingLines do
  begin
    if length(lines) > line+i then
    begin
      s:=lines[line+i];
      Panel.Canvas.TextRect(TextRect,margin,i*(FormMain.PanelText.Canvas.TextHeight(allChrs)),ReplaceTabs(s));
    end;
  end;
end;

procedure updateLines();
begin
  FormMain.PanelText.Canvas.Font := DefaultFont;
  FormMain.PanelLineNumber.Canvas.Font := DefaultFont;
  FormMain.Font := DefaultFont;
  updateFittingLines();
  loadFile();
  paintText(FormMain.PanelText);
  FormMain.PanelLineNumberPaint(FormMain.PanelLineNumber);
  FormMain.PanelRightSideBar.Width := FormMain.LabelLCT.width + FormMain.ButtonDown.width;
  drawCursor();
end;

procedure loadFile();
var f:textfile;
  i:integer;
  s:string;
begin
  try
    if not fileexists(FileName) then exit;
    AssignFile(f,FileName);
    ReSet(f);
    lines:=nil;
    SetLength(lines,fittingLines);

    for i:=2 to line do
    begin
      ReadLn(f,s);
    end;
    for i:=0 to line+fittinglines do
    begin
      if not eof(f) then
      begin
        ReadLn(f,s);
        SetLength(lines,i+1);
        if lines[i] = '' then
          lines[i]:=s;
      end;
    end;
  except on E:Exception do
  begin
    MessageDlg('Could not load file "'+FileName+'". Error Message: '+E.Message, mtError, [mbOk], 0);
  end;
  end;
end;

procedure updateFittingLines();
var i:int16;
  s:shortstring;
  textHeight:int16;
begin

  for i:=0 to 255 do
  begin
    s := s + chr(i);
  end;

  textHeight:=DefaultFont.Size;
  fittingLines := Round(FormMain.PanelText.Height / (textHeight + spaceBetweenLines));
end;

procedure init();
var i: integer;
begin
  DefaultFont:=TFont.Create;
  DefaultFont.Size:=10;

  for i := 0 to 255 do
  begin
    allChrs := allChrs + chr(i);
  end;
end;

end.
