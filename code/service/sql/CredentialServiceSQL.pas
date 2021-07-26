{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit CredentialServiceSQL;

interface

uses
  SysUtils,
  DB,
  Statement,
  DatabaseEngine,
  ExecutionResult, FailedExecution, DatasetExecution,
  KeyCipher,
  Credential, CryptedCredential,
  CredentialService;

type
  TCredentialServiceSQL = class sealed(TInterfacedObject, ICredentialService)
  strict private
    _DBEngine: IDatabaseEngine;
    _Cipher: IKeyCipher;
  public
    function Add(const Credential: ICredential): Boolean;
    function Modify(const Credential: ICredential): Boolean;
    function Remove(const Credential: ICredential): Boolean;
    function Load(const User: WideString): ICredential;
    function IsValid(const Credential: ICredential): Boolean;
    constructor Create(const DBEngine: IDatabaseEngine; const Cipher: IKeyCipher);
    class function New(const DBEngine: IDatabaseEngine; const Cipher: IKeyCipher): ICredentialService;
  end;

implementation

function TCredentialServiceSQL.Add(const Credential: ICredential): Boolean;
var
  SQL: WideString;
begin
  SQL := 'INSERT INTO CREDENTIAL("USER", "PASSWORD")VALUES(%s,%s)';
  SQL := Format(SQL, [QuotedStr(Credential.User), QuotedStr(Credential.Password)]);
  Result := not _DBEngine.Execute(TStatement.New(SQL)).Failed;
end;

function TCredentialServiceSQL.Modify(const Credential: ICredential): Boolean;
var
  SQL: WideString;
begin
  SQL := 'UPDATE CREDENTIAL SET "PASSWORD"=%s WHERE "USER"=%s';
  SQL := Format(SQL, [QuotedStr(Credential.Password), QuotedStr(Credential.User)]);
  Result := not _DBEngine.Execute(TStatement.New(SQL)).Failed;
end;

function TCredentialServiceSQL.Remove(const Credential: ICredential): Boolean;
var
  SQL: WideString;
begin
  SQL := 'DELETE FROM CREDENTIAL WHERE "USER"=' + QuotedStr(Credential.User);
  Result := not _DBEngine.Execute(TStatement.New(SQL)).Failed;
end;

function TCredentialServiceSQL.Load(const User: WideString): ICredential;
var
  SQL: WideString;
  ExecutionResult: IExecutionResult;
  Dataset: TDataset;
begin
  Result := nil;
  SQL := 'SELECT "USER","PASSWORD" FROM CREDENTIAL WHERE "USER"=' + QuotedStr(User);
  ExecutionResult := _DBEngine.ExecuteReturning(TStatement.New(SQL), False);
  if not ExecutionResult.Failed and Supports(ExecutionResult, IDatasetExecution) then
  begin
    Dataset := (ExecutionResult as IDatasetExecution).Dataset;
    if not Dataset.IsEmpty then
      if Assigned(_Cipher) then
        Result := TCryptedCredential.New(Dataset.FieldByName('USER').AsString, Dataset.FieldByName('PASSWORD').AsString,
          _Cipher, True)
      else
        Result := TCredential.New(Dataset.FieldByName('USER').AsString, Dataset.FieldByName('PASSWORD').AsString);
  end;
end;

function TCredentialServiceSQL.IsValid(const Credential: ICredential): Boolean;
var
  SQL, Password: WideString;
  ExecutionResult: IExecutionResult;
  Dataset: TDataset;
begin
  Result := False;
  SQL := 'SELECT "PASSWORD" FROM CREDENTIAL WHERE "USER"=' + QuotedStr(Credential.User);
  ExecutionResult := _DBEngine.ExecuteReturning(TStatement.New(SQL), False);
  if not ExecutionResult.Failed and Supports(ExecutionResult, IDatasetExecution) then
  begin
    Dataset := (ExecutionResult as IDatasetExecution).Dataset;
    if not Dataset.IsEmpty then
    begin
      Password := Dataset.FieldByName('PASSWORD').AsString;
      Result := Password = Credential.Password;
    end;
  end;
end;

constructor TCredentialServiceSQL.Create(const DBEngine: IDatabaseEngine; const Cipher: IKeyCipher);
begin
  _DBEngine := DBEngine;
  _Cipher := Cipher;
end;

class function TCredentialServiceSQL.New(const DBEngine: IDatabaseEngine; const Cipher: IKeyCipher): ICredentialService;
begin
  Result := TCredentialServiceSQL.Create(DBEngine, Cipher);
end;

end.
