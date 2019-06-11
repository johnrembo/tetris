unit Contr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls;

type
  TfmControls = class(TForm)
    gbKeys: TGroupBox;
    lLeft: TLabel;
    lRight: TLabel;
    lDown: TLabel;
    lRotate: TLabel;
    eLeft: TEdit;
    eRight: TEdit;
    eDown: TEdit;
    eRotate: TEdit;
    btnCancel: TButton;
    btnOk: TButton;
    procedure eLeftKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function KeyToStr(Key: Word): string;
  end;

var
  fmControls: TfmControls;
  f: file of word;
  Keys, BackUp: array[1..4] of word;

implementation

{$R *.DFM}

{ TfmControls }

function TfmControls.KeyToStr(Key: Word): string;
var R: string;
begin
  case Key of
    48..90     : R:=Chr(Byte(Key));
    166..255   : R:=Chr(Byte(Key));
    VK_BACK    : R:='�����';
    VK_SPACE   : R:='������';
    VK_PRIOR   : R:='�������� �����';
    VK_NEXT    : R:='�������� ����';
    VK_END     : R:='� �����';
    VK_HOME    : R:='� ������';
    VK_LEFT    : R:='������� �����';
    VK_UP      : R:='������� �����';
    VK_RIGHT   : R:='������� �������';
    VK_DOWN    : R:='������� ����';
    VK_INSERT  : R:='�������';
    VK_DELETE  : R:='��������';
    VK_LWIN    : R:='����� ������ Windows';
    VK_RWIN    : R:='������ ������ Windows';
    VK_APPS    : R:='������ ������������ ����';
    VK_NUMPAD0 : R:='0 (numeric keypad)';
    VK_NUMPAD1 : R:='1 (numeric keypad)';
    VK_NUMPAD2 : R:='2 (numeric keypad)';
    VK_NUMPAD3 : R:='3 (numeric keypad)';
    VK_NUMPAD4 : R:='4 (numeric keypad)';
    VK_NUMPAD5 : R:='5 (numeric keypad)';
    VK_NUMPAD6 : R:='6 (numeric keypad)';
    VK_NUMPAD7 : R:='7 (numeric keypad)';
    VK_NUMPAD8 : R:='8 (numeric keypad)';
    VK_NUMPAD9 : R:='9 (numeric keypad)';
    VK_DECIMAL : R:='����������� ����� (numeric keypad)';
    else R:='�� ��������'
  end;
  Result:=R;
end;

procedure TfmControls.eLeftKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (KeyToStr(Key)<>'�� ��������') and not
     ((Key=Keys[1]) or (Key=Keys[2]) or
      (Key=Keys[3]) or (Key=Keys[4])) then begin
    TEdit(Sender).Text:=KeyToStr(Key);
    Keys[TComponent(Sender).Tag]:=Key;
  end;
end;

procedure TfmControls.FormCreate(Sender: TObject);
var i: integer;
begin
 AssignFile(f,'tetkeys.dat');
 {$I-} Reset(f); {$I+}
 if IOResult<>0 then begin
   Keys[1]:=VK_LEFT;
   Keys[2]:=VK_RIGHT;
   Keys[3]:=VK_DOWN;
   Keys[4]:=VK_SPACE;
 end else begin
   for i:=1 to 4 do Read(f,Keys[i]);
   CloseFile(f);
 end;
end;

procedure TfmControls.btnCancelClick(Sender: TObject);
begin
  Keys:=BackUp;
end;

procedure TfmControls.FormClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
begin
  AssignFile(f,'tetkeys.dat'); Rewrite(f);
  for i:=1 to 4 do Write(f,Keys[i]);
  CloseFile(f);
end;

procedure TfmControls.FormShow(Sender: TObject);
begin
  eLeft.Text:=KeyToStr(Keys[1]);
  eRight.Text:=KeyToStr(Keys[2]);
  eDown.Text:=KeyToStr(Keys[3]);
  eRotate.Text:=KeyToStr(Keys[4]);
  BackUp:=Keys;
end;

end.
