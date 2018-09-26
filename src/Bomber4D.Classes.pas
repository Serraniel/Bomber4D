unit Bomber4D.Classes;

interface

uses
  System.Types;

type

  TBMHitType = (htNone, htStatic, htMovable);

  IExplodable = interface
    procedure Explode;
  end;

  TBMElement = class
  private
    FLocation: TPoint;
    FGuid: string;
  public
    constructor Create; virtual;

    function HitType: TBMHitType; virtual; abstract;
    function RenderLayer: UInt32; virtual; abstract;
    function SpriteIndex: TPoint; virtual;

    procedure Simulate(ATickCount: UInt32); virtual;

    property Location: TPoint read FLocation write FLocation;
    property Guid: string read FGuid write FGuid;
  end;

  TBMBackground = class(TBMElement)
  public
    function HitType: TBMHitType; override;
    function RenderLayer: UInt32; override;
  end;

  TBMDirt = class(TBMBackground)
  public
    function SpriteIndex: TPoint; override;
  end;

  TBMGrass = class(TBMBackground)
  public
    function SpriteIndex: TPoint; override;
  end;

  TBMGameElement = class(TBMElement)
  public
    function RenderLayer: UInt32; override;
  end;

  TBMCharacter = class(TBMGameElement)
  public
    function HitType: TBMHitType; override;
    function RenderLayer: UInt32; override;
  end;

  TBMPlayer = class(TBMCharacter)
  public
    function SpriteIndex: TPoint; override;
  end;

  TBMObstacle = class(TBMGameElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMWall = class(TBMGameElement)
  public
    function SpriteIndex: TPoint; override;
  end;

  TBMWall2 = class(TBMGameElement)
  public
    function SpriteIndex: TPoint; override;
  end;

  TBMItem = class(TBMGameElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMBomb = class(TBMGameElement)
  private
    FOwnerGuid: string;
    FLifeTimeTicks: Int64;
  public
    constructor Create(ALifeTimeTicks: UInt32); virtual;

    function HitType: TBMHitType; override;
    function SpriteIndex: TPoint; override;

    procedure Simulate(ATickCount: UInt32); override;

    property OwnerGUID: string read FOwnerGuid;
    property LifeTimeTicks: Int64 read FLifeTimeTicks;
  end;

implementation

uses
  System.SysUtils;

{ TBMCharacter }

function TBMCharacter.HitType: TBMHitType;
begin
  Result := htNone;
end;

function TBMCharacter.RenderLayer: UInt32;
begin
  Result := 2;
end;

{ TBMPlayer }

function TBMPlayer.SpriteIndex: TPoint;
begin

end;

{ TBMObstacle }

function TBMObstacle.HitType: TBMHitType;
begin
  Result := htStatic;
end;

{ TBMBomb }

constructor TBMBomb.Create(ALifeTimeTicks: UInt32);
begin
  FLifeTimeTicks := ALifeTimeTicks;
end;

function TBMBomb.HitType: TBMHitType;
begin
  Result := htMovable;
end;

procedure TBMBomb.Simulate(ATickCount: UInt32);
begin
  inherited;

  FLifeTimeTicks := FLifeTimeTicks - ATickCount;

  { TODO : caluclate explosion and hitboxes }
end;

function TBMBomb.SpriteIndex: TPoint;
begin
  if FLifeTimeTicks > 3000 then
    Result := Point(12, 2)
  else if FLifeTimeTicks > 2000 then
    Result := Point(12, 3)
  else if FLifeTimeTicks > 1000 then
    Result := Point(12, 4)
  else if FLifeTimeTicks > 600 then
    Result := Point(15, 3)
  else if FLifeTimeTicks > 400 then
    Result := Point(15, 4)
  else if FLifeTimeTicks > 200 then
    Result := Point(15, 5)
  else if FLifeTimeTicks <= 0 then
    Result := Point(2, 5);
end;

{ TBMItem }

function TBMItem.HitType: TBMHitType;
begin
  Result := htNone;
end;

{ TBBackgroun }

function TBMBackground.HitType: TBMHitType;
begin
  Result := htNone;
end;

function TBMBackground.RenderLayer: UInt32;
begin
  Result := 0;
end;

{ TBMGameElement }

function TBMGameElement.RenderLayer: UInt32;
begin
  Result := 1;
end;

{ TBMElement }

constructor TBMElement.Create;
var
  AGuid: TGUID;
begin
  CreateGUID(AGuid);

  FGuid := GUIDToString(AGuid);
end;

procedure TBMElement.Simulate(ATickCount: UInt32);
begin
  // do nothing
end;

function TBMElement.SpriteIndex: TPoint;
begin
  Result := Point(0, 4); // transparent
end;

{ TBMDirt }

function TBMDirt.SpriteIndex: TPoint;
begin
  Result := Point(0, 0);
end;

{ TBMGrass }

function TBMGrass.SpriteIndex: TPoint;
begin
  Result := Point(1, 0);
end;

{ TBMWall }

function TBMWall.SpriteIndex: TPoint;
begin
  Result := Point(11, 4);
end;

{ TBMWall2 }

function TBMWall2.SpriteIndex: TPoint;
begin
  Result := Point(11, 5);
end;

end.
