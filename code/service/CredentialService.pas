{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit CredentialService;

interface

uses
  Credential;

type
  ICredentialService = interface
    ['{1B87A375-F6C1-4DCE-A8D0-5D0E434A61E3}']
    function Add(const Credential: ICredential): Boolean;
    function Modify(const Credential: ICredential): Boolean;
    function Remove(const Credential: ICredential): Boolean;
    function Load(const Login: WideString): ICredential;
    function IsValid(const Credential: ICredential): Boolean;
  end;

implementation

end.
