unit About;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    Image1: TImage;
    BuildInfo: TLabel;
    Contacts: TLabel;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
  end;

procedure ShowAboutBox;

var
  AboutBox:TAboutBox;

implementation

uses ShellAPI;

{$R *.DFM}

procedure ShowAboutBox;
begin
  with TAboutBox.Create(Application) do
    try
      ShowModal;
    finally
      Free;
    end;
end;
procedure TAboutBox.Button1Click(Sender: TObject);
begin
  close;
end;

end.
