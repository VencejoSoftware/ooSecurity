{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
library SecurityLib;

uses
  SimpleShareMem,
  SysUtils,
  Version,
  VersionStage,
  VersionFormat,
  KeyCipher,
  Credential in '..\..\code\entity\Credential.pas',
  CryptedCredential in '..\..\code\entity\CryptedCredential.pas',
  Server in '..\..\code\entity\Server.pas';

{$R *.res}

function Version: IVersion; stdcall;
begin
  Result := TVersion.New(1, 0, 0, 0, TVersionStage.New(TVersionStageCode.Productive), EncodeDate(2021, 07, 23));
end;

function NewServer(const Address: WideString; const Port: Word): IServer; stdcall; export;
begin
  Result := TServer.New(Address, Port);
end;

function NewCredential(const Login, Password: WideString): ICredential; stdcall; export;
begin
  Result := TCredential.New(Login, Password);
end;

function NewEncryptedCredential(const Login, Password: WideString; const Cipher: IKeyCipher; const IsEncoded: Boolean)
  : ICryptedCredential; stdcall; export;
begin
  Result := TCryptedCredential.New(Login, Password, Cipher, IsEncoded);
end;

exports
  Version,
  NewServer,
  NewCredential,
  NewEncryptedCredential;

begin
  IsMultiThread := True;

end.
