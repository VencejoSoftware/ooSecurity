{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program SecurityConsoleDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  SysUtils,
  Credential,
  KeyCipher,
  CryptLib,
  CryptedCredential,
  SecurityLib in '..\..\code\SecurityLib.pas';

const
  DEPLOY_PATH = '..\..\..\..\..\dependencies\';
{$IFDEF CPUX64}
  DLL_PATH = '..\..\..\..\..\dll\build\Win64\Debug\';
{$ELSE}
  DLL_PATH = '..\..\..\..\..\dll\build\Win32\Debug\';
{$ENDIF}

var
  SecurityLib: ISecurityLib;

procedure DemoCredential;
const
  SECRET_KEY = '771894B5-AEC3-4A11-9568-396D9EA3C2E5';
var
  Credential: ICredential;
  CryptLib: ICryptLib;
begin
  Credential := SecurityLib.NewCredential('user', 'password');
  WriteLn(Format('%s - %s', [Credential.User, Credential.Password]));
  CryptLib := TCryptLib.New(DEPLOY_PATH);
  CryptLib.ChangeKey(SECRET_KEY);
  Credential := SecurityLib.NewEncryptedCredential('user', '0WCKJ6o5TcE=', CryptLib, True);
  if Credential.IsValidPassword('password') then
    WriteLn('Crypted ok!');
  WriteLn((Credential as ICryptedCredential).RevealPassword(SECRET_KEY));
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    SecurityLib := TSecurityLib.New(DLL_PATH + 'SecurityLib.dll');
    DemoCredential;
    WriteLn('Press any key to exit');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
