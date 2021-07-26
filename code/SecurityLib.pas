{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}

unit SecurityLib;

interface

uses
  LibraryCore,
  Version,
  KeyCipher,
  Credential, CryptedCredential;

type
  ISecurityLib = interface
    ['{CBB1F8FB-7B97-4BD9-9259-5639271F8D96}']
    function Version: IVersion;
    function NewCredential(const Login, Password: WideString): ICredential;
    function NewEncryptedCredential(const Login, Password: WideString; const Cipher: IKeyCipher;
      const PasswordCrypted: Boolean): ICryptedCredential;
  end;

  TSecurityLib = class sealed(TInterfacedObject, ISecurityLib)
  strict private
  type
    TNewCredential = function(const Login, Password: WideString): ICredential; stdcall;
    TNewEncryptedCredential = function(const Login, Password: WideString; const Cipher: IKeyCipher;
      const PasswordCrypted: Boolean): ICryptedCredential; stdcall;
  strict private
    _LibraryCore: ILibraryCore;
    _NewCredential: TNewCredential;
    _NewEncryptedCredential: TNewEncryptedCredential;
  public
    function Version: IVersion;
    function NewCredential(const Login, Password: WideString): ICredential;
    function NewEncryptedCredential(const Login, Password: WideString; const Cipher: IKeyCipher;
      const PasswordCrypted: Boolean): ICryptedCredential;
    constructor Create(const LibraryPath: String);
    class function New(const LibraryPath: String): ISecurityLib;
  end;

implementation

function TSecurityLib.Version: IVersion;
begin
  Result := _LibraryCore.Version;
end;

function TSecurityLib.NewCredential(const Login, Password: WideString): ICredential;
begin
  if Assigned(@_NewCredential) then
    Result := _NewCredential(Login, Password);
end;

function TSecurityLib.NewEncryptedCredential(const Login, Password: WideString; const Cipher: IKeyCipher;
  const PasswordCrypted: Boolean): ICryptedCredential;
begin
  if Assigned(@_NewEncryptedCredential) then
    Result := _NewEncryptedCredential(Login, Password, Cipher, PasswordCrypted);
end;

constructor TSecurityLib.Create(const LibraryPath: String);
begin
  _LibraryCore := TLibraryCore.New(LibraryPath, 'SecurityLib');
  @_NewCredential := _LibraryCore.GetMethodAddress('NewCredential');
  @_NewEncryptedCredential := _LibraryCore.GetMethodAddress('NewEncryptedCredential');
end;

class function TSecurityLib.New(const LibraryPath: String): ISecurityLib;
begin
  Result := TSecurityLib.Create(LibraryPath);
end;

end.
