program Bomber4D.Client;

uses
  Vcl.Forms,
  MainForm in 'src\MainForm.pas' {FrmMain},
  BMClasses in 'src\BMClasses.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Delphi4D';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
