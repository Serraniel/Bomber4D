unit MainForm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Bomber4D.GameEngine;

type
  TFrmMain = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    FGameEngine: TBMGameEngine;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}
{ TFrmMain }

constructor TFrmMain.Create(AOwner: TComponent);
begin
  inherited;

  FGameEngine := TBMGameEngine.Create;
end;

destructor TFrmMain.Destroy;
begin
  FreeAndNil(FGameEngine);

  inherited;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  FGameEngine.Init;
end;

end.
