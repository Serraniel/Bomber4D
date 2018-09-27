﻿unit Bomber4D.GameEngine;

interface

uses
  Bomber4D.Classes;

type

  // TBoard = array of array of TBMElement; // rows of coloums of TBMElement
  TBoard = array of array of char; // rows of coloums of char; use TBMElement later

  TBMGameEngine = class
  private
    FBoard: TBoard;
  protected
  public
    procedure Init;

    property Board: TBoard read FBoard;
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
begin
  AStream := TResourceStream.Create(HInstance, 'MAP', RT_RCDATA);
  AData := TStringList.Create;
  try
    AData.LoadFromStream(AStream);

    if AData.Count = 0 then
      raise Exception.CreateFmt('Invalid map height [%d].', [AData.Count]);

    SetLength(FBoard, AData.Count);

    // string rows are 1 char longer than original file.... thanks delphi for...reasons?  👀
    ACheckSquareLength := length(AData[0]) + 1;

    // initialize rows
    for row := 0 to AData.Count - 1 do
    begin
      if length(AData[row]) + 1 <> ACheckSquareLength then
        raise Exception.CreateFmt('Invalid map width [%d / %d].',
          [ACheckSquareLength, length(AData[row])]);

      SetLength(FBoard[row], ACheckSquareLength);
      // intialize column values
      for col := 0 to ACheckSquareLength do
      begin
        FBoard[row, col] := AData[row][col];
      end;
    end;
  finally
    AData.Free;
    AStream.Free;
  end;
end;

end.
