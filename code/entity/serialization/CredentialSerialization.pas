{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit CredentialSerialization;

interface

uses
  SysUtils,
  JSON,
  Serialization, JSONSerialization,
  KeyCipher,
  Credential, CryptedCredential;

type
  TCredentialJSONItem = class sealed(TInterfacedObject, IItemSerialize<ICredential>)
  strict private
    _Cipher: IKeyCipher;
  public
    function Decompose(const Item: ICredential): WideString;
    function Compose(const Text: WideString): ICredential;
    constructor Create(const Cipher: IKeyCipher);
    class function New(const Cipher: IKeyCipher): IItemSerialize<ICredential>;
  end;

  ICredentialSerialization = interface(ISerialization<ICredential>)
    ['{8DE48D03-E2BD-45FB-9B04-0E8EAAB74216}']
  end;

  TCredentialJSON = class sealed(TJSONSerialization<ICredential>, ICredentialSerialization)
  public
    class function New(const Cipher: IKeyCipher; const NullValue: WideString = EMPTY_OBJECT): ICredentialSerialization;
  end;

implementation

function TCredentialJSONItem.Decompose(const Item: ICredential): WideString;
const
  ITEM_TEMPLATE = '{"User":"%s","password":"%s"}';
begin
  Result := Format(ITEM_TEMPLATE, [Item.User, Item.Password])
end;

function TCredentialJSONItem.Compose(const Text: WideString): ICredential;
var
  JSonValue: TJSonValue;
begin
  JSonValue := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Text), 0);
  try
    Result := TCryptedCredential.New(JSonValue.GetValue<String>('User'), JSonValue.GetValue<String>('password'),
      _Cipher, True);
  finally
    JSonValue.Free;
  end;
end;

constructor TCredentialJSONItem.Create(const Cipher: IKeyCipher);
begin
  _Cipher := Cipher;
end;

class function TCredentialJSONItem.New(const Cipher: IKeyCipher): IItemSerialize<ICredential>;
begin
  Result := TCredentialJSONItem.Create(Cipher);
end;

{ TCredentialJSON }

class function TCredentialJSON.New(const Cipher: IKeyCipher; const NullValue: WideString = EMPTY_OBJECT)
  : ICredentialSerialization;
begin
  Result := TCredentialJSON.Create(TCredentialJSONItem.New(Cipher), NullValue);
end;

end.
