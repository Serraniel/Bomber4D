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

    procedure Simulate(ATickCount: Integer); virtual;

    property Location: TPoint read FLocation write FLocation;
    property Guid: string read FGuid write FGuid;
  end;

  TBMBackground = class(TBMElement)
  public
    function HitType: TBMHitType; override;
    function RenderLayer: UInt32; override;
  end;

  TBMGameElement = class(TBMElement)
  public
    function RenderLayer: UInt32; override;
  end;

  TBMPlayer = class(TBMGameElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMObstacle = class(TBMGameElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMItem = class(TBMGameElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMBomb = class(TBMGameElement)
  private
    FOwnerGuid: string;
  public
    function HitType: TBMHitType; override;
    function RenderLayer: UInt32; override;

    property OwnerGUID: string read FOwnerGuid;
  end;

implementation

uses
  System.SysUtils;

{ TBMPlayer }

function TBMPlayer.HitType: TBMHitType;
begin
  Result := htNone;
end;

function TBMPlayer.RenderLayer: UInt32;
begin
  Result := 1;
end;

{ TBMObstacle }

function TBMObstacle.HitType: TBMHitType;
begin
  Result := htStatic;
end;

{ TBMBomb }

function TBMBomb.HitType: TBMHitType;
begin
  Result := htMovable;
end;

function TBMBomb.RenderLayer: UInt32;
begin
  Result := 2;
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

procedure TBMElement.Simulate(ATickCount: Integer);
begin
  // do nothing
end;

end.
