unit Bomber4D.GameRenderer;

interface

uses
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Classes,
  Bomber4D.GameEngine,
  System.SysUtils,
  System.Generics.Collections,
  Vcl.Graphics;

type
  TBMSpriteDictionary = TObjectDictionary<UInt32, TBitMap>;

  TBMGamePanel = class(TPanel)
  private
    FGameEngine: TBMGameEngine;
    FSpriteDictionary: TBMSpriteDictionary;
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

  Vcl.Imaging.pngimage;

{ TGamePanel }

constructor TBMGamePanel.Create(AOwner: TComponent);
begin
  inherited;

  FSpriteDictionary := TBMSpriteDictionary.Create;
  FGameEngine := TBMGameEngine.Create;
end;

destructor TBMGamePanel.Destroy;
begin
  FSpriteDictionary.Free;
  FGameEngine.Free;

  inherited;
end;

procedure TBMGamePanel.Init;
var
  AStream: TResourceStream;
  ASpriteMap: TPicture;
  ASpritBitMap: TBitMap;
  row: Integer;
  col: Integer;
  ASprite: TBitMap;
begin
  AStream := TResourceStream.Create(HInstance, 'SPRITES', RT_RCDATA);
  ASpriteMap := TPicture.Create;
  ASpritBitMap := TBitMap.Create;
  try
    ASpriteMap.LoadFromStream(AStream);
    ASpritBitMap.Assign(ASpriteMap.Graphic);

    for row := 0 to (ASpritBitMap.Height div 16) - 1 do
    begin
      for col := 0 to (ASpritBitMap.Width div 16) - 1 do
      begin
        ASprite := TBitMap.Create;
        try
          ASprite.Width := 16;
          ASprite.Height := 16;

          ASprite.Canvas.CopyRect(Rect(0, 0, 16, 16), ASpritBitMap.Canvas,
            Rect(col * 16, row * 16, col * 16 + 16, row * 16 + 16));

          FSpriteDictionary.Add(row * 16 + col, ASprite);
        except
          ASprite.Free;
          raise;
        end;
      end;
    end;
  finally
    ASpritBitMap.Free;
    ASpriteMap.Free;
    AStream.Free;
  end;

  FGameEngine.Init;
end;

procedure TBMGamePanel.Paint;
var
  row: Integer;
  AColCount: Integer;
  col: Integer;
  ASpriteCol: Integer;
  ASpriteRow: Integer;
  ASpriteID: Integer;
begin
  inherited;

  if Length(FGameEngine.Board) = 0 then
    raise Exception.CreateFmt('Invalid map height [%d].', [FGameEngine.Board]);

  AColCount := Length(FGameEngine.Board[0]);

  if AColCount = 0 then
    raise Exception.CreateFmt('Invalid map width [%d].', [AColCount]);

  for row := 0 to Length(FGameEngine.Board) - 1 do
  begin
    for col := 0 to AColCount - 1 do
    begin
      // extract image
      ASpriteCol := FGameEngine.Board[row][col].SpriteIndex.X;
      ASpriteRow := FGameEngine.Board[row][col].SpriteIndex.Y;

      ASpriteID := ASpriteRow * 16 + ASpriteCol;

      Canvas.CopyRect(Rect(col * 32, row * 32, col * 32 + 32, row * 32 + 32),
        FSpriteDictionary.Items[ASpriteID].Canvas, Rect(0, 0, 16, 16));
    end;
  end;
end;

end.
