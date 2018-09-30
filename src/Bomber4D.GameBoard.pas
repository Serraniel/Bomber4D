unit Bomber4D.GameBoard;

interface

uses
  Bomber4D.Classes;

type

  TBMBoard = array of array of TBMElement; // rows of coloums of TBMElement

  TBMGameEngine = class
  private
    FBoard: TBMBoard;
  protected
  public
    procedure Init;

    property Board: TBMBoard read FBoard;
  end;

implementation

uses
  System.Classes,
  System.Types,
  System.SysUtils;

{ TBMGameEngine }

procedure TBMGameEngine.Init;
var
  AStream: TResourceStream;
  AData: TStringList;
  ACheckSquareLength: Integer;
  row: Integer;
  col: Integer;
  AMapElementID: UInt32;
  AClass: TBMElementClass;
begin
  AStream := TResourceStream.Create(HInstance, 'MAP', RT_RCDATA);
  AData := TStringList.Create;
  try
    AData.LoadFromStream(AStream);

    if AData.Count = 0 then
      raise Exception.CreateFmt('Invalid map height [%d].', [AData.Count]);

    SetLength(FBoard, AData.Count);

    ACheckSquareLength := length(AData[0]);

    // initialize rows
    for row := 0 to AData.Count - 1 do
    begin
      if length(AData[row]) <> ACheckSquareLength then
        raise Exception.CreateFmt('Invalid map width [%d / %d].',
          [ACheckSquareLength, length(AData[row])]);

      SetLength(FBoard[row], ACheckSquareLength);
      // intialize column values
      for col := 0 to ACheckSquareLength - 1 do
      begin
        AMapElementID := ord(AData[row][col + 1]); // +1 because strings are 1 indexed
        AClass := GlobalMapElements.ElementClassByID(AMapElementID);

        if not Assigned(AClass) then
          raise Exception.CreateFmt('Map element not found [%d].', [AMapElementID]);

        FBoard[row, col] := AClass.Create;
      end;
    end;
  finally
    AData.Free;
    AStream.Free;
  end;
end;

end.
