program Bomber4D.Client;

uses
  Vcl.Forms,
  MainForm in 'src\MainForm.pas' {FrmMain},
  Bomber4D.Classes in 'src\Bomber4D.Classes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Delphi4D';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
