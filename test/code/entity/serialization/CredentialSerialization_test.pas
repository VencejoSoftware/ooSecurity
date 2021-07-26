{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit CredentialSerialization_test;

interface

uses
  Classes, SysUtils,
  IterableList,
  KeyCipher, CryptLib,
  Credential, CredentialSerialization,
  CredentialService, CredentialService_mock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TCredentialJSONTest = class sealed(TTestCase)
  strict private
    _Service: ICredentialService;
    _Serialization: ICredentialSerialization;
  public
    procedure SetUp; override;
  published
    procedure SerializeReturnJSONText;
    procedure ListSerializeReturnJSONText;
    procedure DeserializeJSONReturnObject;
  end;

implementation

procedure TCredentialJSONTest.SerializeReturnJSONText;
const
  JSON_RETURN = '{"User":"ADMIN","password":"6eQYkYh3Xe96SaQp3wbPe0dtdJzXqn+mR3af6Q=="}';
begin
  CheckEquals(JSON_RETURN, _Serialization.Decompose(_Service.Load('ADMIN')));
end;

procedure TCredentialJSONTest.DeserializeJSONReturnObject;
const
  JSON_CONTENT = '{"User":"ADMIN","password":"6eQYkYh3Xe96SaQp3wbPe0dtdJzXqn+mR3af6Q=="}';
var
  Item: ICredential;
begin
  Item := _Serialization.Compose(JSON_CONTENT);
  CheckTrue(Assigned(Item));
  CheckEquals('ADMIN', Item.User);
  CheckEquals('6eQYkYh3Xe96SaQp3wbPe0dtdJzXqn+mR3af6Q==', Item.Password);
end;

procedure TCredentialJSONTest.ListSerializeReturnJSONText;
const
  JSON_RETURN = '[{"User":"ADMIN","password":"6eQYkYh3Xe96SaQp3wbPe0dtdJzXqn+mR3af6Q=="},' +
    '{"User":"ANALYST","password":"iLdY1r9Hf7EeNLswkA=="}]';
var
  List: IIterableList<ICredential>;
begin
  List := TIterableList<ICredential>.New;
  List.Add(_Service.Load('ADMIN'));
  List.Add(_Service.Load('ANALYST'));
  CheckEquals(JSON_RETURN, _Serialization.ListDecompose(List));
end;

procedure TCredentialJSONTest.SetUp;
var
  Cipher: IKeyCipher;
begin
  inherited;
  _Service := TCredentialServiceMock.New;
  Cipher := TCryptLib.New('..\..\..\..\dependencies\');
  _Serialization := TCredentialJSON.New(Cipher);
end;

initialization

RegisterTests('Credential test', [TCredentialJSONTest {$IFNDEF FPC}.Suite {$ENDIF}]);

end.
