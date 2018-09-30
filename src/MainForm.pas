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
  Vcl.ExtCtrls,
  Bomber4D.GameController;

type
  TFrmMain = class(TForm)
    GameController: TBMGameController;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TFrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GameController.HandleKeyCode(Key, Shift);
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  GameController.Init;
end;

end.
