{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ServerSerialization_test;

interface

uses
  Classes, SysUtils,
  IterableList,
  Server, ServerSerialization,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TServerJSONTest = class sealed(TTestCase)
  strict private
    _Serialization: IServerSerialization;
  public
    procedure SetUp; override;
  published
    procedure SerializeReturnJSONText;
    procedure DeserializeJSONReturnObject;
    procedure ListSerializeReturnJSONText;
  end;

implementation

procedure TServerJSONTest.SerializeReturnJSONText;
const
  JSON_RETURN = '{"address":"127.0.0.1","port":666}';
begin
  CheckEquals(JSON_RETURN, _Serialization.Decompose(TServer.New('127.0.0.1', 666)));
end;

procedure TServerJSONTest.DeserializeJSONReturnObject;
const
  JSON_CONTENT = '{"address":"127.0.0.1","port":666}';
var
  Item: IServer;
begin
  Item := _Serialization.Compose(JSON_CONTENT);
  CheckTrue(Assigned(Item));
  CheckEquals('127.0.0.1', Item.Address);
  CheckEquals(666, Item.Port);
end;

procedure TServerJSONTest.ListSerializeReturnJSONText;
const
  JSON_RETURN = '[{"address":"192.168.1.1","port":8080},{"address":"localhost","port":666}]';
var
  List: IIterableList<IServer>;
begin
  List := TIterableList<IServer>.New;
  List.Add(TServer.New('192.168.1.1', 8080));
  List.Add(TServer.New('localhost', 666));
  CheckEquals(JSON_RETURN, _Serialization.ListDecompose(List));
end;

procedure TServerJSONTest.SetUp;
begin
  inherited;
  _Serialization := TServerJSON.New;
end;

initialization

RegisterTests('Server test', [TServerJSONTest {$IFNDEF FPC}.Suite {$ENDIF}]);

end.
