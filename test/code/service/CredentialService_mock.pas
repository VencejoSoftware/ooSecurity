{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit CredentialService_mock;

interface

uses
  SysUtils,
  Generics.Collections,
  KeyCipher, CryptLib,
  Credential, CryptedCredential,
  CredentialService;

type
  TCredentialServiceMock = class sealed(TInterfacedObject, ICredentialService)
  strict private
    _Cipher: IKeyCipher;
    _List: TList<ICredential>;
  private
    function ItemByUser(const User: WideString): ICredential;
  public
    function Add(const Credential: ICredential): Boolean;
    function Modify(const Credential: ICredential): Boolean;
    function Remove(const Credential: ICredential): Boolean;
    function Load(const User: WideString): ICredential;
    function IsValid(const Credential: ICredential): Boolean;
    constructor Create;
    destructor Destroy; override;
    class function New: ICredentialService;
  end;

implementation

function TCredentialServiceMock.Add(const Credential: ICredential): Boolean;
begin
  Result := _List.Add(Credential) > -1;
end;

function TCredentialServiceMock.ItemByUser(const User: WideString): ICredential;
var
  Item: ICredential;
begin
  Result := nil;
  for Item in _List do
    if SameText(User, Item.User) then
      Exit(Item);
end;

function TCredentialServiceMock.Modify(const Credential: ICredential): Boolean;
var
  Item: ICredential;
begin
  Item := ItemByUser(Credential.User);
  _List.Remove(Item);
  Result := _List.Add(Credential) > -1;
end;

function TCredentialServiceMock.Remove(const Credential: ICredential): Boolean;
begin
  Result := _List.Remove(Credential) > -1;
end;

function TCredentialServiceMock.Load(const User: WideString): ICredential;
begin
  Result := ItemByUser(User);
end;

function TCredentialServiceMock.IsValid(const Credential: ICredential): Boolean;
var
  Item: ICredential;
begin
  Item := ItemByUser(Credential.User);
  Result := SameText(Item.Password, Credential.Password);
end;

constructor TCredentialServiceMock.Create;
begin
  _List := TList<ICredential>.Create;
  _Cipher := TCryptLib.New('..\..\..\..\dependencies\');
  _List.Add(TCryptedCredential.New('ADMIN', '1234@_P:;L-*{}[]!"#$%&/()=?¡', _Cipher));
  _List.Add(TCryptedCredential.New('ANALYST', 'Password_1234', _Cipher));
  _List.Add(TCryptedCredential.New('QA', 'QA_qa', _Cipher));
end;

destructor TCredentialServiceMock.Destroy;
begin
  _List.Free;
  inherited;
end;

class function TCredentialServiceMock.New: ICredentialService;
begin
  Result := TCredentialServiceMock.Create;
end;

end.
