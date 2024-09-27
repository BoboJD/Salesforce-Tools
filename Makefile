.PHONY: archive clean crypt delete deploy key org release retrieve tests version

p=

# Archive Log__c from DevHub into specified folder in salesforce-tools-config.yml
archive:
	@bash scripts/archive_logs.sh

# Fetch and pull remote branches "master" "prod-release" "preprod", then delete stale local branches
clean:
	@bash scripts/clean.sh

# Crypt a password to be stored in OrgSettings__mdt
crypt:
	@bash scripts/crypt_password.sh $(p)

# Delete metadata files specified in 'manifest/destructiveChanges.xml'
delete:
	@bash scripts/deleteMetadata.sh

# Deploy project metadata files into current org
deploy:
	@bash scripts/deploy.sh $(p)

# Generate the encryption key to be stored in EncryptionKey__c custom setting
key:
	@bash scripts/generate_key.sh

# Create a scratch org
org:
	@bash scripts/initScratchOrg.sh $(p)

# Create a release branch from your current feature or project branch
release:
	@bash scripts/release.sh $(p)

# Retrieve files changes in current org
retrieve:
	@bash scripts/retrieveManualChanges.sh $(p)

# Run all tests in your current org, then summarize tests result
tests:
	@bash scripts/runTests.sh $(p)

# Upload new version of the package
version:
	@bash scripts/update_version_and_create_package.sh
