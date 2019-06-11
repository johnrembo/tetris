














program Tetris32x;

uses
  Forms,
  Tetclsc in 'Tetclsc.pas' {Tetclassic},
  About in 'About.pas' {AboutBox},
  Name in 'Name.pas' {NameDlg},
  Contr in 'Contr.pas' {fmControls};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Tetris Classic 32 Local Edition';
  Application.CreateForm(TTetclassic, Tetclassic);
  Application.CreateForm(TNameDlg, NameDlg);
  Application.CreateForm(TfmControls, fmControls);
  Application.Run;
end.
