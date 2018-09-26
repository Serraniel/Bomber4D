program Bomber4D.Client;

{$R *.dres}

uses
  Vcl.Forms,
  MainForm in 'src\MainForm.pas' {FrmMain},
  Bomber4D.Classes in 'src\Bomber4D.Classes.pas',
  Bomber4D.GameEngine in 'src\Bomber4D.GameEngine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Delphi4D';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
