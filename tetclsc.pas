unit Tetclsc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Tetris, ExtCtrls, StdCtrls, Menus, ComCtrls, ActnList, MPlayer, MMSystem;

type
  TTetclassic = class(TForm)
    Delay: TTimer;
    Panel1: TPanel;
    Status: TStatusBar;
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    Scr: TImage;
    Next: TImage;
    ScoreMon: TEdit;
    LevelMon: TEdit;
    lScore: TLabel;
    lLevel: TLabel;
    Action: TActionList;
    LevelChange: TAction;
    Exit: TMenuItem;
    Start: TAction;
    Pause: TAction;
    Start1: TMenuItem;
    Pause1: TMenuItem;
    RotateBlock: TAction;
    MoveDown: TAction;
    MoveRight: TAction;
    MoveLeft: TAction;
    N2: TMenuItem;
    TogleNext: TCheckBox;
    N3: TMenuItem;
    About1: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    lRecs: TLabel;
    Finish: TAction;
    pnNext: TPanel;
    miControls: TMenuItem;
    procedure LevelChangeExecute(Sender: TObject);
    procedure StartExecute(Sender: TObject);
    procedure PauseExecute(Sender: TObject);
    procedure MoveDownExecute(Sender: TObject);
    procedure RotateBlockExecute(Sender: TObject);
    procedure MoveRightExecute(Sender: TObject);
    procedure MoveLeftExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TogleNextClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure InitGame(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure miControlsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TRec = record
    Name: string[10];
    Score: integer;
  end;

const
  w=16;
  plt1:array [1..7] of Integer =
    (225,8454016,16711680,33023,
     16777088,65535,12632256);
  plt2:array [1..10] of Integer =
    (8733105,11171533,6988373,12112295,11571554,
     13215109,4367805,8635603,15129367,16249512);
var
  Tetclassic: TTetclassic;
  Game:TTetris;
  Score:TScore;
  x,y:integer; bcl:TColor;
  sh,nsh,a,na:Integer;
  Level:byte;
  Total:integer;
  Lines: Integer;
  Tetr,Trip,Doub,Sing:Integer;
  Rec: TRec;
  f: file of TRec;
  paused: boolean;
  RecScores: array [3..10] of integer;

implementation

uses About, Name, Contr;

{$R *.DFM}
{$R SOUND.RES}

procedure DrawBar(Canvas: TCanvas; x,y:Integer; cl:TColor);
begin
  x:=x*w; y:=y*w;
  with Canvas do begin
    Pen.Color:=bcl; Brush.Color:=cl;
    if cl<>bcl then begin
      Rectangle(x-w+1,y-w+1,x,y);
      Pen.Color:=clBtnHighlight;
      MoveTo(x-w+1,y-1);
      LineTo(x-w+1,y-w+1);
      LineTo(x-1,y-w+1);
      MoveTo(x-w+2,y-2);
      LineTo(x-w+2,y-w+2);
      LineTo(x-2,y-w+2);
      Pen.Color:=clBtnShadow;
      MoveTo(x-w+1,y-1);
      LineTo(x-1,y-1);
      LineTo(x-w+1,y-1);
      MoveTo(x-w+2,y-2);
      LineTo(x-2,y-2);
      LineTo(x-w+2,y-2);
    end else Rectangle(x-w+1,y-w+1,x,y);
  end;
end;

procedure DrawBlock(x,y:Integer; cl:TColor);
var i,j:integer;
begin
  for i:=1 to 4 do for j:=1 to 4 do
    if Game.Block[i,j]=1 then
      DrawBar(Tetclassic.Scr.Canvas,x+i,y+j,cl);
end;

procedure DrawField(cl:TColor);
var i,j:integer;
begin
  for i:=1 to mw do for j:=1 to mh do
    if Game.Field[i,j]=1 then DrawBar(Tetclassic.Scr.Canvas,i,j,cl)
    else DrawBar(Tetclassic.Scr.Canvas,i,j,bcl)
end;

procedure UpdateForm;
var i,j:integer;
begin
  Tetclassic.LevelMon.Text:=IntToStr(Level);
  Tetclassic.ScoreMon.Text:=IntToStr(Total);
  for i:=1 to 4 do for j:=1 to 4 do
    if Game.Block[i,j]=1 then
      DrawBar(Tetclassic.Next.Canvas,i+1,j+1,bcl);
  Game.Define(nsh,na);
  for i:=1 to 4 do for j:=1 to 4 do
    if Game.Block[i,j]=1 then
      DrawBar(Tetclassic.Next.Canvas,i+1,j+1,Plt1[nsh]);
  Game.Define(sh,a);
end;

procedure TTetclassic.LevelChangeExecute(Sender: TObject);
begin
  PlaySound(PChar('Next'), hInstance, snd_ASync or snd_Resource);
  Inc(Level);
  Delay.Interval:=(Delay.Interval-100) div 2 + 100;
  Tetclassic.LevelMon.Text:=IntToStr(level);
end;

procedure TTetclassic.StartExecute(Sender: TObject);
begin
  Delay.Enabled:=true;
  TogleNext.Enabled:=false;
  Paused:=false;
  Status.Panels[0].Text:='Чтобы приостановить нажмите PAUSE';
end;

procedure TTetclassic.PauseExecute(Sender: TObject);
begin
  Delay.Enabled:=false;
  TogleNext.Enabled:=true;
  Paused:=true;
  Status.Panels[0].Text:='Чтобы начать нажмите ENTER';
end;

procedure TTetclassic.MoveDownExecute(Sender: TObject);
begin
  if Paused then Status.Panels[0].Text:='Чтобы начать нажмите ENTER'
  else Status.Panels[0].Text:='Чтобы приостановить игру нажмите PAUSE';
 if not Paused then begin
  DrawBlock(x,y,bcl);
  if Game.Scan(x,y+1) then begin
    DrawBlock(x,y,bcl);
    sh:=nsh; a:=na; Game.Update(x,y);
    nsh:=Random(7)+1; na:=Random(4)+1;
    if Game.Score(Score) then begin
      if score[1]=1 then begin
        inc(total,4); inc(lines); inc(sing);
        Status.Panels[0].Text:='Один';
        if not TogleNext.Checked then inc(total,1);
      end;
      if score[2]=1 then begin
        inc(total,8); inc(lines,2); inc(doub);
        Status.Panels[0].Text:='Дубль';
        if not TogleNext.Checked then inc(total,2);
      end;
      if score[3]=1 then begin
        inc(total,12); inc(lines,3); inc(trip);
        Status.Panels[0].Text:='Триплет';
        if not TogleNext.Checked then inc(total,3);
      end;
      if score[4]=1 then begin
        inc(total,16); inc(lines,4); inc(tetr);
        Status.Panels[0].Text:='Тетрис!';
        if not TogleNext.Checked then inc(total,4);
      end;
      PlaySound(PChar('Line'), hInstance, snd_ASync or snd_Resource);
      if lines>=Level*2+10 then begin
        Lines:=0;
        total:=total+sing+doub*2+trip*9+tetr*16;
        LevelChangeExecute(Sender);
      end;
    end else
      PlaySound(PChar('Down'), hInstance, snd_ASync or snd_Resource);
    if y=0 then Finish.Execute
    else begin
      DrawField(Plt2[(level+10) mod 10]); y:=0; x:=3;
      Game.Define(sh,a); UpdateForm;
    end;
  end else inc(y); DrawBlock(x,y,Plt1[sh]);
 end;
end;

procedure TTetclassic.RotateBlockExecute(Sender: TObject);
begin
 if (Delay.Enabled) then begin
  DrawBlock(x,y,bcl);
  inc(a); if a=5 then a:=1;
  Game.Define(sh,a);
  if Game.Scan(x,y) then begin
    dec(a); if a=0 then a:=4;
    Game.Define(sh,a);
    DrawBlock(x,y,Plt1[sh]);
    Status.Panels[0].Text:='Вращение невозможно!';
    PlaySound(PChar('Cant'), hInstance, snd_ASync or snd_Resource);
  end else DrawBlock(x,y,Plt1[sh]);
 end;
end;

procedure TTetclassic.MoveRightExecute(Sender: TObject);
begin
  if (Delay.Enabled) and
     (not Game.Scan(x+1,y)) then begin
    DrawBlock(x,y,bcl); inc(x);
    DrawBlock(x,y,Plt1[sh]);
  end else Status.Panels[0].Text:='Правее нельзя!';
end;

procedure TTetclassic.MoveLeftExecute(Sender: TObject);
begin
  if (Delay.Enabled) and
     (not Game.Scan(x-1,y)) then begin
    DrawBlock(x,y,bcl); dec(x);
    DrawBlock(x,y,Plt1[sh]);
  end else Status.Panels[0].Text:='Левее нельзя!';
end;

procedure TTetclassic.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = Keys[1] then MoveLeftExecute(Sender)
  else if Key = Keys[2] then MoveRightExecute(Sender)
  else if Key = Keys[3] then MoveDownExecute(Sender)
  else if Key = Keys[4] then RotateBlockExecute(Sender)
  else case Key of
     VK_F1  : About1.Click;
     VK_F9  : miControls.Click;
     VK_PAUSE : if not Paused then Pause.Execute;
     VK_RETURN: if Paused then Start.Execute;
     VK_ESCAPE: if Paused then Start.Execute
                else Pause.Execute;
     VK_F10 : Close;
  end;
end;

procedure TTetclassic.TogleNextClick(Sender: TObject);
begin
  TogleNext.Checked:=not Next.Visible;
  Next.Visible:=TogleNext.Checked;
  if Next.Visible then Status.Panels[0].Text:='Показ следующей фигуры включен'
  else Status.Panels[0].Text:='Показ следующей фигуры выключен';
end;

procedure TTetclassic.About1Click(Sender: TObject);
begin
   Pause.Execute;
   ShowAboutBox;
end;

procedure TTetclassic.InitGame(Sender: TObject);

 function ExtractScore(S: String):integer;
 var i: integer; r: string;
 begin
   Result:=0;
   i:=length(S);
   while (S[i]<>' ') and (i>0) do begin
     insert(s[i],r,1); dec(i);
   end;
   if r<>'' then Result:=StrToInt(r);
 end;

 function ExtractName(S: String): String;
 var i,j: integer; r: string;
 begin
   i:=length(S);
   while (S[i]<>' ') and (i>0) do dec(i);
   if i>1 then for j:=i-1 downto 1 do insert(S[j],r,1);
   Result:=r;
 end;

var i,j: integer; s:string;
begin
  Pause.Execute;
  {Handle records}
  if Sender=Self then begin // On create
    AssignFile(f,'tetris.dat');
    {$I-} Reset(f); {$I+}
    if IOResult<>0 then Rewrite(f);
    // Retrieve records
    for i:=3 to 10 do begin
      if FilePos(f)<FileSize(f) then begin
        Read(f,Rec);
        TLabel(FindComponent('Label'+IntToStr(i))).Caption:=
          Rec.Name+' '+IntToStr(Rec.Score);
        RecScores[i]:=Rec.Score;
      end;
    end;
    CloseFile(f);
  end else begin  // While playing
    NameDlg.Edit1.Text:='Игрок';
    NameDlg.Edit2.Text:=ScoreMon.Text;
    j:=3; while RecScores[j]>StrToInt(ScoreMon.Text) do inc(j);
    case j of
      3: NameDlg.Label1.Caption:='Вы побили рекорд!';
      4,5: NameDlg.Label1.Caption:='Поздравляю! Вы заняли '+
              IntToStr(j-2)+'-е место!';
      6..9: NameDlg.Label1.Caption:='Вы заняли '+
              IntToStr(j-2)+'-е место.';
      10: NameDlg.Label1.Caption:='Вы вошли в восьмерку лучших.';
    end;
    // if Player is in first eight
    if (StrToInt(ScoreMon.Text)>RecScores[10]) and
      (NameDlg.ShowModal=mrOk) then begin
      for i:=10 downto j+1 do begin
        TLabel(FindComponent('Label'+IntToStr(i))).Caption:=
          TLabel(FindComponent('Label'+IntToStr(i-1))).Caption;
        RecScores[i]:=RecScores[i-1];
      end;
      TLabel(FindComponent('Label'+IntToStr(j))).Caption:=
         NameDlg.Edit1.Text+' '+NameDlg.Edit2.Text;
      RecScores[j]:=StrToInt(ScoreMon.Text);
      // Save records
      AssignFile(f,'tetris.dat');
      Rewrite(f);
      for i:=3 to 10 do begin
        s:=TLabel(FindComponent('Label'+IntToStr(i))).Caption;
        if s<>'<Свободно>' then begin
          Rec.Name:=ExtractName(s);
          Rec.Score:=ExtractScore(s);
          Write(f,Rec);
        end;
      end;
      CloseFile(f);
    end;
  end;
  {Reinit game}
  randomize;
  nsh:=Random(7)+1; na:=Random(4)+1;
  sh:=Random(7)+1; a:=Random(4)+1;
  Level:=1; Total:=0; Lines:=0;
  Tetr:=0; Trip:=0; Doub:=0; Sing:=0;
  X:=3; Y:=0;
  LevelMon.Text:='1';
  ScoreMon.Text:='0';
  bcl:=clBlack; Total:=0;
  Scr.Canvas.Pen.Color:=bcl;
  Scr.Canvas.Brush.Color:=bcl;
  Next.Canvas.Pen.Color:=bcl;
  Next.Canvas.Brush.Color:=bcl;
  Delay.Interval:=1124;
  Scr.Canvas.Rectangle(0,0,144,400);
  Next.Canvas.Rectangle(0,0,86,86);
  Game.Init; UpdateForm;
end;

procedure TTetclassic.ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TTetclassic.miControlsClick(Sender: TObject);
begin
  Pause.Execute;
  fmControls.ShowModal;
end;

end.
