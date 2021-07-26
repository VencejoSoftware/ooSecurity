{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ServerSerialization;

interface

uses
  SysUtils,
  JSON,
  Serialization, JSONSerialization,
  Server;

type
  TServerJSONItem = class sealed(TInterfacedObject, IItemSerialize<IServer>)
  public
    function Decompose(const Item: IServer): WideString;
    function Compose(const Text: WideString): IServer;
    class function New: IItemSerialize<IServer>;
  end;

  IServerSerialization = interface(ISerialization<IServer>)
    ['{75C60D27-B8F9-4A1E-914E-BD9DA6EC17F7}']
  end;

  TServerJSON = class sealed(TJSONSerialization<IServer>, IServerSerialization)
  public
    class function New(const NullValue: WideString = EMPTY_OBJECT): IServerSerialization;
  end;

implementation

function TServerJSONItem.Decompose(const Item: IServer): WideString;
const
  ITEM_TEMPLATE = '{"address":"%s","port":%d}';
begin
  Result := Format(ITEM_TEMPLATE, [Item.Address, Item.Port])
end;

function TServerJSONItem.Compose(const Text: WideString): IServer;
var
  JSonValue: TJSonValue;
begin
  JSonValue := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Text), 0);
  try
    Result := TServer.New(JSonValue.GetValue<String>('address'), JSonValue.GetValue<Word>('port'));
  finally
    JSonValue.Free;
  end;
end;

class function TServerJSONItem.New: IItemSerialize<IServer>;
begin
  Result := TServerJSONItem.Create;
end;

{ TServerJSON }

class function TServerJSON.New(const NullValue: WideString = EMPTY_OBJECT): IServerSerialization;
begin
  Result := TServerJSON.Create(TServerJSONItem.New, NullValue);
end;

end.
