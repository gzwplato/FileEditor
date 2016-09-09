unit unitFormAboutBox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormAboutBox }

  TFormAboutBox = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormAboutBox: TFormAboutBox;

implementation

{$R *.lfm}

end.

