# Salesforce Tools

Create a scratch org and set a password to your user
```sh
sf org create scratch --definition-file config/project-scratch-def.json --alias salesforce-tools --duration-days 30 --set-default
sf org generate password --complexity 3 --length 16
```

Deploy project to scratch org
```sh
sf project deploy start --source-dir force-app
```

Assign permission sets
```sh
sf org assign permset -n LogManage -n ToolsAdmin
```

Create a new package version
```sh
sf package version create --package "Salesforce Tools" --wait 10 --installation-key-bypass
```

Install your new package version
```sh
sf package install --package "Salesforce Tools@VERSIONNUMBER" --wait 10 --publish-wait 10 --target-org ORG_NAME
```

Maintain fflib
```sh
git subtree pull --prefix=fflib-apex-mocks git@github.com:apex-enterprise-patterns/fflib-apex-mocks.git master
git subtree pull --prefix=fflib-apex-common git@github.com:apex-enterprise-patterns/fflib-apex-common.git master
```

Then copy fflib content to project
```sh
cp -r fflib-apex-mocks/sfdx-source/apex-mocks/main/* force-app/fflib/
cp -r fflib-apex-mocks/sfdx-source/apex-mocks/test/* force-app/fflib/
cp -r fflib-apex-common/sfdx-source/apex-common/main/* force-app/fflib/
cp -r fflib-apex-common/sfdx-source/apex-common/test/* force-app/fflib/
```

## Acknowledgements

This project includes code from the salesforce.com, Inc. repository which is licensed under the BSD-3-Clause license. The full license text is included in the LICENSE file.