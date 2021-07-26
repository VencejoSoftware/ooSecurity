{
  Copyright (c) 2021, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program SecurityTest;

uses
  RunTest,
  CredentialSerialization_test in '..\code\entity\serialization\CredentialSerialization_test.pas',
  CredentialService_mock in '..\code\service\CredentialService_mock.pas',
  CredentialServiceSQL_test in '..\code\service\sql\CredentialServiceSQL_test.pas',
  DBEngineMock in '..\code\DBEngineMock.pas',
  ServerSerialization_test in '..\code\entity\serialization\ServerSerialization_test.pas',
  Credential in '..\..\code\entity\Credential.pas',
  CredentialFactory in '..\..\code\entity\CredentialFactory.pas',
  CryptedCredential in '..\..\code\entity\CryptedCredential.pas',
  Server in '..\..\code\entity\Server.pas',
  ServerFactory in '..\..\code\entity\ServerFactory.pas',
  CredentialSerialization in '..\..\code\entity\serialization\CredentialSerialization.pas',
  ServerSerialization in '..\..\code\entity\serialization\ServerSerialization.pas',
  CredentialService in '..\..\code\service\CredentialService.pas',
  CredentialServiceSQL in '..\..\code\service\sql\CredentialServiceSQL.pas',
  Credential_Test in '..\code\entity\Credential_Test.pas',
  CredentialFactory_test in '..\code\entity\CredentialFactory_test.pas',
  CryptedCredential_test in '..\code\entity\CryptedCredential_test.pas',
  Server_test in '..\code\entity\Server_test.pas',
  ServerFactory_test in '..\code\entity\ServerFactory_test.pas';

{$R *.res}

begin
  Run;

end.
