program Bomber4D.Client;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Delphi4D';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
