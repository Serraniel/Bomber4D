unit Bomber4D.GameRenderer;

interface

uses
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Classes,
  Bomber4D.GameEngine,
  System.SysUtils;

type
  TBMGamePanel = class(TPanel)
  private
    FGameEngine: TBMGameEngine;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init; virtual;
  end;

implementation

uses
  System.Types,
  Vcl.Graphics,
  Vcl.Imaging.pngimage;

{ TGamePanel }

constructor TBMGamePanel.Create(AOwner: TComponent);
begin
  inherited;

  FGameEngine := TBMGameEngine.Create;
end;

destructor TBMGamePanel.Destroy;
begin
  FGameEngine.Free;

  inherited;
end;

procedure TBMGamePanel.Init;
begin
  FGameEngine.Init;
end;

procedure TBMGamePanel.Paint;
var
  row: Integer;
  AColCount: Integer;
  col: Integer;
  AStream: TResourceStream;
  ASpriteMap: Tpicture;
  c: Integer;
  ASpriteCol: Integer;
  ASpriteRow: Integer;
  ASpritBitMap: TBitmap;
begin
  inherited;

  if Length(FGameEngine.Board) = 0 then
    raise Exception.CreateFmt('Invalid map height [%d].', [FGameEngine.Board]);

  AColCount := Length(FGameEngine.Board[0]);

  if AColCount = 0 then
    raise Exception.CreateFmt('Invalid map width [%d].', [AColCount]);

  AStream := TResourceStream.Create(HInstance, 'SPRITES', RT_RCDATA);
  ASpriteMap := Tpicture.Create;
  ASpritBitMap := TBitmap.Create;
  try
    ASpriteMap.LoadFromStream(AStream);
    ASpritBitMap.Assign(ASpriteMap.Graphic);

    for row := 0 to Length(FGameEngine.Board) - 1 do
    begin
      for col := 0 to AColCount - 1 do
      begin
        c := ord(FGameEngine.Board[row][col]) - 1; // map ist 1 basiert

        // extract image
        ASpriteCol := c mod 16;
        ASpriteRow := c div 16;

        Canvas.CopyRect(Rect(col * 32, row * 32, col * 32 + 32, row * 32 + 32), ASpritBitMap.Canvas,
          Rect(ASpriteCol * 16, ASpriteRow * 16, ASpriteCol * 16 + 16, ASpriteRow * 16 + 16));
      end;
    end;
  finally
    ASpritBitMap.Free;
    ASpriteMap.Free;
    AStream.Free;
  end;
end;

end.
