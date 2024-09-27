#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"

# Create a temporary file for the anonymous Apex code
apex_file=$(mktemp)

if [ ! -f "$apex_file" ]; then
    error_exit "Failed to create temporary Apex file"
fi

# Write the anonymous Apex code into the temporary file
cat <<EOF > "$apex_file"
Blob encryptionKey = Crypto.generateAesKey(256);
String encryptionKeyString = EncodingUtil.base64Encode(encryptionKey);
System.debug(encryptionKeyString);
EOF

# Run the Anonymous Apex code using Salesforce CLI
output=$(sf apex run --file "$apex_file" 2>&1)

if [ $? -ne 0 ]; then
    rm "$apex_file"  # Clean up even if the command failed
    error_exit "Failed to run Apex code: $output"
fi

# Extract the encryption key from the output using grep and sed
encryption_key=$(echo "$output" | grep 'DEBUG|' | sed 's/.*DEBUG|//')

if [ -z "$encryption_key" ]; then
    rm "$apex_file"
    error_exit "Failed to extract the encryption key from output"
fi

# Display the encryption key
echo "$encryption_key"

# Delete the temporary file
rm "$apex_file"