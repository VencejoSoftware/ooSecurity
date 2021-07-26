{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit CredentialServiceSQL_test;

interface

uses
  Classes, SysUtils,
  Statement,
  DBEngineMock,
  Credential, CredentialService, CredentialServiceSQL,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework, TestExtensions
{$ENDIF};

type
  TDatabaseEngineSetup = class(TTestSetup)
  public
    class var _DBEngine: IDBEngineMock;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  end;

  TCredentialServiceSQLTest = class sealed(TTestCase)
  strict private
    _CredentialService: ICredentialService;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure AddReturnTrue;
    procedure ModifyReturnTrue;
    procedure RemoveReturnTrue;
    procedure LoadTestReturnObject;
    procedure IsValid123_PasswordIsTrue;
  end;

implementation

procedure TCredentialServiceSQLTest.AddReturnTrue;
var
  Item: ICredential;
begin
  Item := TCredential.New('ADD_TEST_temp', 'test password');
  CheckTrue(_CredentialService.Add(Item));
end;

procedure TCredentialServiceSQLTest.ModifyReturnTrue;
var
  Item, ModifiedItem: ICredential;
begin
  Item := TCredential.New('MODIFY_TEST_temp', 'test password');
  CheckTrue(_CredentialService.Add(Item));
  ModifiedItem := TCredential.New(Item.User, 'changed password');
  CheckTrue(_CredentialService.Modify(ModifiedItem));
end;

procedure TCredentialServiceSQLTest.RemoveReturnTrue;
var
  Item: ICredential;
begin
  Item := TCredential.New('TEST_REMOVE_temp', 'remove password');
  CheckTrue(_CredentialService.Add(Item));
  CheckTrue(_CredentialService.Remove(Item));
end;

procedure TCredentialServiceSQLTest.LoadTestReturnObject;
var
  Item, LoadedItem: ICredential;
begin
  Item := TCredential.New('LOAD_TEST_temp', 'password loaded');
  CheckTrue(_CredentialService.Add(Item));
  LoadedItem := _CredentialService.Load(Item.User);
  CheckEquals('LOAD_TEST_temp', LoadedItem.User);
end;

procedure TCredentialServiceSQLTest.IsValid123_PasswordIsTrue;
var
  Item: ICredential;
begin
  Item := TCredential.New('IS_VALID_TRUE_temp', '123_PassWorD');
  CheckTrue(_CredentialService.Add(Item));
  CheckTrue(_CredentialService.IsValid(TCredential.New('IS_VALID_TRUE_temp', '123_PassWorD')));
end;

procedure TCredentialServiceSQLTest.SetUp;
begin
  inherited;
  _CredentialService := TCredentialServiceSQL.New(TDatabaseEngineSetup._DBEngine, nil);
end;

procedure TCredentialServiceSQLTest.TearDown;
begin
  inherited;
  _CredentialService := nil;
end;

{ TDatabaseEngineSetup }

procedure TDatabaseEngineSetup.SetUp;
begin
  inherited;
  _DBEngine := TDBEngineMock.New;
end;

procedure TDatabaseEngineSetup.TearDown;
begin
  inherited;
  _DBEngine.Execute(TStatement.New('DELETE FROM CREDENTIAL WHERE USER LIKE ''%_temp'''));
end;

initialization

RegisterTest('Credential test', TDatabaseEngineSetup.Create(TCredentialServiceSQLTest {$IFNDEF FPC}.Suite {$ENDIF}));

end.
