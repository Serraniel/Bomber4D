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
  Bomber4D.GameRenderer,
  Vcl.ExtCtrls;

type
  TFrmMain = class(TForm)
    pnlGame: TBMGamePanel;
    procedure FormShow(Sender: TObject);
  private
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

end;

destructor TFrmMain.Destroy;
begin

  inherited;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  pnlGame.Init;
end;

end.
