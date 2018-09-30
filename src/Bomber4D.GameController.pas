unit Bomber4D.GameController;

interface

uses
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Classes,
  Bomber4D.GameBoard,
  System.SysUtils,
  System.Generics.Collections,
  Vcl.Graphics,
  Bomber4D.Classes;

type
  TBMSpriteDictionary = TObjectDictionary<UInt32, TBitMap>;

type
  TBMGameController = class(TPanel)
  private
    FSpriteDictionary: TBMSpriteDictionary;
  protected
    FGameEngine: TBMGameEngine;
    FPlayerFirst: TBMPlayer;
    FPlayerSecond: TBMPlayer;

    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure HandleKeyCode(Key: Word; Shift: TShiftState);

    procedure Init; virtual;
  published
    { Published-Deklarationen }
  end;

procedure Register;

implementation

uses
  System.Types,
  Vcl.Imaging.pngimage,
  Winapi.Windows;

procedure Register;
begin
  RegisterComponents('Bomber4D', [TBMGameController]);
end;

{ TBMGameController }

constructor TBMGameController.Create(AOwner: TComponent);
begin
  inherited;

  FSpriteDictionary := TBMSpriteDictionary.Create;
  FGameEngine := TBMGameEngine.Create;
  FPlayerFirst := TBMPlayer.Create;
  FPlayerSecond := TBMPlayer.Create;
end;

destructor TBMGameController.Destroy;
begin
  FSpriteDictionary.Free;
  FGameEngine.Free;

  inherited;
end;

procedure TBMGameController.HandleKeyCode(Key: Word; Shift: TShiftState);
var
  AWasHandled: Boolean;
begin
  AWasHandled := false;

  // player 1 movement
  if Key = VK_UP then
  begin
    FPlayerFirst.Move(dUp);
    AWasHandled := true;
  end
  else if Key = VK_RIGHT then
  begin
    FPlayerFirst.Move(dRight);
    AWasHandled := true;
  end
  else if Key = VK_DOWN then
  begin
    FPlayerFirst.Move(dDown);
    AWasHandled := true;
  end
  else if Key = VK_LEFT then
  begin
    FPlayerFirst.Move(dLeft);
    AWasHandled := true;
  end
  // player 2 movement
  else if Key = ord('W') then
  begin
    FPlayerSecond.Move(dUp);
    AWasHandled := true;
  end
  else if Key = ord('D') then
  begin
    FPlayerSecond.Move(dRight);
    AWasHandled := true;
  end
  else if Key = ord('S') then
  begin
    FPlayerSecond.Move(dDown);
    AWasHandled := true;
  end
  else if Key = ord('A') then
  begin
    FPlayerSecond.Move(dLeft);
    AWasHandled := true;
  end;

  if AWasHandled then
    Invalidate;
end;

procedure TBMGameController.Init;
var
  AStream: TResourceStream;
  ASpriteMap: TPicture;
  ASpriteBitMap: Vcl.Graphics.TBitMap;
  row: Integer;
  col: Integer;
  ASprite: Vcl.Graphics.TBitMap;
begin
  // Loading sprites
  AStream := TResourceStream.Create(HInstance, 'SPRITES', RT_RCDATA);
  ASpriteMap := TPicture.Create;
  ASpriteBitMap := Vcl.Graphics.TBitMap.Create;
  try
    ASpriteMap.LoadFromStream(AStream);
    ASpriteBitMap.Assign(ASpriteMap.Graphic);

    for row := 0 to (ASpriteBitMap.Height div 16) - 1 do
    begin
      for col := 0 to (ASpriteBitMap.Width div 16) - 1 do
      begin
        ASprite := Vcl.Graphics.TBitMap.Create;
        try
          ASprite.Width := 16;
          ASprite.Height := 16;

          ASprite.Canvas.CopyRect(Rect(0, 0, 16, 16), ASpriteBitMap.Canvas,
            Rect(col * 16, row * 16, col * 16 + 16, row * 16 + 16));

          FSpriteDictionary.Add(row * 16 + col, ASprite);
        except
          ASprite.Free;
          raise;
        end;
      end;
    end;
  finally
    ASpriteBitMap.Free;
    ASpriteMap.Free;
    AStream.Free;
  end;

  // initializing players
  FPlayerFirst.PlayerID := 1;
  FPlayerFirst.Location := Point(1, 1);
  FPlayerFirst.ViewDirection := dDown;

  FPlayerSecond.PlayerID := 2;
  FPlayerSecond.Location := Point(13, 11);
  FPlayerSecond.ViewDirection := dUp;

  // initializing board
  FGameEngine.Init;
end;

procedure TBMGameController.Paint;
var
  row: Integer;
  AColCount: Integer;
  col: Integer;
  ASpriteID: Integer;
begin
  inherited;

  if not(csDesigning in ComponentState) then
  begin
    Canvas.Brush.Color := $FF00FF;
    Canvas.Brush.Style := bsClear;

    // Board
    if Length(FGameEngine.Board) = 0 then
      raise Exception.CreateFmt('Invalid map height [%d].', [FGameEngine.Board]);

    AColCount := Length(FGameEngine.Board[0]);

    if AColCount = 0 then
      raise Exception.CreateFmt('Invalid map width [%d].', [AColCount]);

    for row := 0 to Length(FGameEngine.Board) - 1 do
    begin
      for col := 0 to AColCount - 1 do
      begin
        Canvas.BrushCopy(Rect(col * 32, row * 32, col * 32 + 32, row * 32 + 32),
          FSpriteDictionary.Items[FGameEngine.Board[row][col].SpriteID],
          Rect(0, 0, 16, 16), $FF00FF);
      end;
    end;

    // Players
    Canvas.BrushCopy(Rect(FPlayerFirst.Location.X * 32, FPlayerFirst.Location.Y * 32,
        FPlayerFirst.Location.X * 32 + 32, FPlayerFirst.Location.Y * 32 + 32),
      FSpriteDictionary.Items[FPlayerFirst.SpriteID], Rect(0, 0, 16, 16), $FF00FF);

    Canvas.BrushCopy(Rect(FPlayerSecond.Location.X * 32, FPlayerSecond.Location.Y * 32,
        FPlayerSecond.Location.X * 32 + 32, FPlayerSecond.Location.Y * 32 + 32),
      FSpriteDictionary.Items[FPlayerSecond.SpriteID], Rect(0, 0, 16, 16), $FF00FF);
  end;
end;

end.
