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

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgements

This project includes code from the salesforce.com, Inc. repository which is licensed under the BSD-3-Clause license. The full license text is included in the LICENSE file.

This project includes code from FinancialForce.com, Inc., which is licensed under terms similar to the BSD-3-Clause license. The full license text is included in the LICENSE file.

This project includes code from various sources, including Stack Overflow. Code copied from Stack Overflow is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0).

## Attribution for Stack Overflow Code

Some code snippets in this project were copied from Stack Overflow and are used under the terms of the CC BY-SA 4.0 license. While the exact posts are not identifiable, we acknowledge the contributions of the Stack Overflow community.
