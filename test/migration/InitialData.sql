BEGIN TRANSACTION;
DELETE FROM CREDENTIAL;
SET GENERATOR CREDENTIAL_SQ TO 0;
COMMIT;