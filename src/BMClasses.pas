unit BMClasses;

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
  public
    function HitType: TBMHitType; virtual; abstract;

    property Location: TPoint read FLocation write FLocation;
  end;

  TBMPlayer = class(TBMElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMObstacle = class(TBMElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMBomb = class(TBMElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMItem = class(TBMElement)
  public
    function HitType: TBMHitType; override;
  end;

  TBMBoard = class

  end;

implementation

{ TBMPlayer }

function TBMPlayer.HitType: TBMHitType;
begin
  Result := htNone;
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

{ TBMItem }

function TBMItem.HitType: TBMHitType;
begin
  Result := htNone;
end;

end.
