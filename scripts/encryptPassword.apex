// Encrypting the password

// Generate and display an encryption key
// Blob encryptionKey = Crypto.generateAesKey(256);
// String encryptionKeyString = EncodingUtil.base64Encode(encryptionKey);
// System.debug('Encryption Key: ' + encryptionKeyString);

// Avoid character ' in the password because the decryption replaces it with &apos;
String password = 'myPassword'; // Replace this with the password you want to encrypt

Blob encryptionKey = EncodingUtil.base64Decode(EncryptionKey__c.getOrgDefaults().Value__c);

Blob encryptedPassword = Crypto.encryptWithManagedIV('AES256', encryptionKey, Blob.valueOf(password));

// Convert encrypted password to strings for storage
String encryptedPasswordString = EncodingUtil.base64Encode(encryptedPassword);

System.debug('Encrypted Password: ' + encryptedPasswordString);