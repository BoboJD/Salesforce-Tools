#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"

# Parameters
password=$1 # Mandatory

if [ -z "$password" ]; then
	error_exit "You need to provide a password."
fi

# Create a temporary file for the anonymous Apex code
apex_file=$(mktemp)

if [ ! -f "$apex_file" ]; then
    error_exit "Failed to create temporary Apex file"
fi

# Write the anonymous Apex code into the temporary file
cat <<EOF > "$apex_file"
String password = '$password';
Blob encryptionKey = EncodingUtil.base64Decode(tlz__EncryptionKey__c.getOrgDefaults().tlz__Value__c);
Blob encryptedPassword = Crypto.encryptWithManagedIV('AES256', encryptionKey, Blob.valueOf(password));
String encryptedPasswordString = EncodingUtil.base64Encode(encryptedPassword);
System.debug(encryptedPasswordString);
EOF

# Run the Anonymous Apex code using Salesforce CLI
output=$(sf apex run --file "$apex_file" 2>&1)

if [ $? -ne 0 ]; then
    rm "$apex_file"  # Clean up even if the command failed
    error_exit "Failed to run Apex code: $output"
fi

# Extract the encrypted password from the output using grep and sed
encrypted_password=$(echo "$output" | grep 'DEBUG|' | sed 's/.*DEBUG|//')

if [ -z "$encrypted_password" ]; then
    rm "$apex_file"
    error_exit "Failed to extract the encrypted password from output"
fi

# Display the encrypted password
echo "$encrypted_password"

# Delete the temporary file
rm "$apex_file"