program Bomber4D.Client;

{$R *.dres}

uses
  Vcl.Forms,
  MainForm in 'src\MainForm.pas' {FrmMain},
  Bomber4D.Classes in 'src\Bomber4D.Classes.pas',
  Bomber4D.GameBoard in 'src\Bomber4D.GameBoard.pas',
  Bomber4D.GameController in 'src\Bomber4D.GameController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Delphi4D';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
