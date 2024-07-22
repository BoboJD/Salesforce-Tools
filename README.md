# Salesforce Tools

Create a scratch org
```sh
sf org create scratch --definition-file config/project-scratch-def.json --alias salesforce-tools --duration-days 30 -s
```

Create a new package version
```sh
sf package version create --package "Salesforce Tools" --wait 10 --installation-key-bypass
```

Install your new package version
```sh
sf package install --package "Salesforce Tools@VERSIONNUMBER" --wait 10 --publish-wait 10 --target-org ORG_NAME
```