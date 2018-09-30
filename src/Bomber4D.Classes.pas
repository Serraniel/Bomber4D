unit Bomber4D.Classes;

interface

uses
  System.Types,
  System.Generics.Collections;

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

    class function MapInitializationID: UInt32; virtual; abstract;

    function HitType: TBMHitType; virtual; abstract;
    function SpriteIndex: TPoint; virtual;
    function SpriteID: UInt32;

    procedure Simulate(ATickCount: UInt32); virtual;

    property Location: TPoint read FLocation write FLocation;
    property Guid: string read FGuid write FGuid;
  end;

  TBMElementClass = class of TBMElement;

  TBMElementClassList = class(TList<TBMElementClass>)
  public
    function ElementClassByID(ElementID: UInt32): TBMElementClass;
  end;

  TBMBackground = class(TBMElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMDirt = class(TBMBackground)
  public
    class function MapInitializationID: UInt32; override;

    function SpriteIndex: TPoint; override;
  end;

  TBMGrass = class(TBMBackground)
  public
    class function MapInitializationID: UInt32; override;

    function SpriteIndex: TPoint; override;
  end;

  TBMGameElement = class(TBMElement)
  public
  end;

  TBMCharacter = class(TBMGameElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMPlayer = class(TBMCharacter)
  private
    FPlayerID: UInt32;
  public
    function SpriteIndex: TPoint; override;

    property PlayerID: UInt32 read FPlayerID write FPlayerID;
    property Location: TPoint read FLocation write FLocation;
  end;

  TBMObstacle = class(TBMGameElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMBox = class(TBMGameElement)
  public
    class function MapInitializationID: UInt32; override;

    function SpriteIndex: TPoint; override;
  end;

  TBMWall = class(TBMGameElement)
  public
    class function MapInitializationID: UInt32; override;

    function SpriteIndex: TPoint; override;
  end;

  TBMWall2 = class(TBMGameElement)
  public
    class function MapInitializationID: UInt32; override;

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
    constructor Create(ALifeTimeTicks: UInt32); reintroduce;

    function HitType: TBMHitType; override;
    function SpriteIndex: TPoint; override;

    procedure Simulate(ATickCount: UInt32); override;

    property OwnerGUID: string read FOwnerGuid;
    property LifeTimeTicks: Int64 read FLifeTimeTicks;
  end;

function GlobalMapElements: TBMElementClassList;

implementation

uses
  System.SysUtils;

var
  __GlobalMapElements: TBMElementClassList;

function GlobalMapElements: TBMElementClassList;
begin
  if not Assigned(__GlobalMapElements) then
  begin
    __GlobalMapElements := TBMElementClassList.Create;
  end;

  Result := __GlobalMapElements;
end;

{ TBMCharacter }

function TBMCharacter.HitType: TBMHitType;
begin
  Result := htNone;
end;

{ TBMPlayer }

function TBMPlayer.SpriteIndex: TPoint;
begin
  Result := Point(0, 2 + FPlayerID);
end;

{ TBMObstacle }

function TBMObstacle.HitType: TBMHitType;
begin
  Result := htStatic;
end;

{ TBMBomb }

constructor TBMBomb.Create(ALifeTimeTicks: UInt32);
begin
  inherited Create;

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

function TBMElement.SpriteID: UInt32;
begin
  Result := SpriteIndex.X + SpriteIndex.Y * 16;
end;

function TBMElement.SpriteIndex: TPoint;
begin
  Result := Point(0, 4); // transparent
end;

{ TBMDirt }

class function TBMDirt.MapInitializationID: UInt32;
begin
  Result := $01;
end;

function TBMDirt.SpriteIndex: TPoint;
begin
  Result := Point(0, 0);
end;

{ TBMGrass }

class function TBMGrass.MapInitializationID: UInt32;
begin
  Result := $02;
end;

function TBMGrass.SpriteIndex: TPoint;
begin
  Result := Point(1, 0);
end;

{ TBMWall }

class function TBMWall.MapInitializationID: UInt32;
begin
  Result := $4C;
end;

function TBMWall.SpriteIndex: TPoint;
begin
  Result := Point(11, 4);
end;

{ TBMWall2 }

class function TBMWall2.MapInitializationID: UInt32;
begin
  Result := $5C;
end;

function TBMWall2.SpriteIndex: TPoint;
begin
  Result := Point(11, 5);
end;

{ TBMElementClassList }

function TBMElementClassList.ElementClassByID(ElementID: UInt32): TBMElementClass;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
    if Items[i].MapInitializationID = ElementID then
      exit(Items[i]);
end;

{ TBMBox }

class function TBMBox.MapInitializationID: UInt32;
begin
  Result := $5B;
end;

function TBMBox.SpriteIndex: TPoint;
begin
  Result := Point(10, 5);
end;

initialization

GlobalMapElements.Add(TBMDirt);
GlobalMapElements.Add(TBMGrass);
GlobalMapElements.Add(TBMWall);
GlobalMapElements.Add(TBMWall2);
GlobalMapElements.Add(TBMBox);

end.
