{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit DBEngineMock;

interface

uses
  Classes, SysUtils,
  DB,
  Statement,
  ExecutionResult,
  Credential,
  DataStorage,
  ConnectionSetting, FirebirdSetting, FirebirdSettingFactory,
  DatabaseEngine, DatabaseEngineLib;

type
  IDBEngineMock = interface(IDatabaseEngine)
    ['{05AEB32D-7440-4411-B71C-4F008E8EEE4B}']
  end;

  TDBEngineMock = class sealed(TInterfacedObject, IDBEngineMock)
  strict private
    _DatabaseEngineLib: IDatabaseEngineLib;
    _DatabaseEngine: IDatabaseEngine;
  private
    procedure RunDML(const FileName: WideString);
  public
    function InTransaction: Boolean;
    function BeginTransaction: Boolean;
    function CommitTransaction: Boolean;
    function RollbackTransaction: Boolean;
    function Connect(const Setting: IConnectionSetting; const PasswordKey: WideString = ''): Boolean;
    function Disconnect: Boolean;
    function IsConnected: Boolean;
    function Execute(const Statement: IStatement; const UseGlobalTransaction: Boolean = False): IExecutionResult;
    function ExecuteReturning(const Statement: IStatement; const CommitData: Boolean;
      const UseGlobalTransaction: Boolean = False): IExecutionResult;
    function ExecuteScript(const StatementList: IStatementList; const SkipErrors: Boolean = False)
      : IExecutionResultList;
    constructor Create;
    destructor Destroy; override;
    class function New: IDBEngineMock;
  end;

implementation

function TDBEngineMock.InTransaction: Boolean;
begin
  Result := _DatabaseEngine.InTransaction;
end;

function TDBEngineMock.BeginTransaction: Boolean;
begin
  Result := _DatabaseEngine.BeginTransaction;
end;

function TDBEngineMock.CommitTransaction: Boolean;
begin
  Result := _DatabaseEngine.CommitTransaction;
end;

function TDBEngineMock.RollbackTransaction: Boolean;
begin
  Result := _DatabaseEngine.RollbackTransaction;
end;

function TDBEngineMock.Connect(const Setting: IConnectionSetting; const PasswordKey: WideString = ''): Boolean;
begin
  Result := _DatabaseEngine.Connect(Setting, PasswordKey);
end;

function TDBEngineMock.Disconnect: Boolean;
begin
  Result := _DatabaseEngine.Disconnect;
end;

function TDBEngineMock.IsConnected: Boolean;
begin
  Result := _DatabaseEngine.IsConnected;
end;

function TDBEngineMock.Execute(const Statement: IStatement; const UseGlobalTransaction: Boolean): IExecutionResult;
begin
  Result := _DatabaseEngine.Execute(Statement, UseGlobalTransaction);
end;

function TDBEngineMock.ExecuteReturning(const Statement: IStatement; const CommitData, UseGlobalTransaction: Boolean)
  : IExecutionResult;
begin
  Result := _DatabaseEngine.ExecuteReturning(Statement, CommitData, UseGlobalTransaction);
end;

function TDBEngineMock.ExecuteScript(const StatementList: IStatementList; const SkipErrors: Boolean)
  : IExecutionResultList;
begin
  Result := _DatabaseEngine.ExecuteScript(StatementList, SkipErrors);
end;

procedure TDBEngineMock.RunDML(const FileName: WideString);
var
  FileContent: TStringList;
  StatementList: IStatementList;
  ResultList: IExecutionResultList;
begin
  if FileExists(FileName) then
  begin
    if _DatabaseEngine.InTransaction then
      _DatabaseEngine.RollbackTransaction;
    FileContent := TStringList.Create;
    try
      FileContent.LoadFromFile(FileName);
      StatementList := TStatementList.New;
      StatementList.LoadFromText(FileContent.Text);
      ResultList := _DatabaseEngine.ExecuteScript(StatementList, True);
    finally
      FileContent.Free;
    end;
  end;
end;

constructor TDBEngineMock.Create;
const
  DEPLOY_PATH = '..\..\..\..\dependencies\';
var
  DataStorage: IDataStorage;
  Settings: IConnectionSetting;
begin
  _DatabaseEngineLib := TDatabaseEngineLib.New(DEPLOY_PATH);
  _DatabaseEngine := _DatabaseEngineLib.NewFirebirdEngine;
  DataStorage := TINIDataStorage.New('..\..\..\dependencies\settings.ini');
  Settings := TFirebirdSettingFactory.New(nil).Build('FirebirdEngine30', DataStorage);
  _DatabaseEngine.Connect(Settings);
  RunDML('..\..\..\migration\CreateStructure.sql');
  RunDML('..\..\..\migration\InitialData.sql');
end;

destructor TDBEngineMock.Destroy;
begin
  _DatabaseEngine := nil;
  inherited;
end;

class function TDBEngineMock.New: IDBEngineMock;
begin
  Result := TDBEngineMock.Create;
end;

end.
