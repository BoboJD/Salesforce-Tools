# Salesforce Tools

This project is an unlocked package containing fflib apex files, utility classes, and service Apex classes. It also includes best practices used in conjunction with fflib apex files. The repository features a `scripts` folder to manage deployments and keep the repository up-to-date.

## Documentation

For more detailed documentation, check out the [docs](./docs).

## Prerequisites for using bash scripts

* Install "Chocolatey" which allows "choco" command line on windows (https://chocolatey.org/install)

* Install "make" command line

  ```sh
  choco install -y make
  ```

* Install "jq" command line, used to parse JSON from scripts

  ```sh
  choco install -y jq
  ```

* Install "yq" command line, used to parse YAML from scripts

  ```sh
  choco install -y yq
  ```

* Install "XMLStarlet" command line, used to changes XML Files from scripts

  ```sh
  choco install -y xmlstarlet
  ```

* Node.js installed for npm (https://nodejs.org/en/download)

  ```sh
  npm install npm@latest -g
  ```

* To facilitate updates for global npm packages, install "npm-check-updates" (https://www.npmjs.com/package/npm-check-updates)

  ```sh
  npm install -g npm-check-updates
  ```

* Salesforce CLI installed with npm (https://github.com/salesforcecli/cli)

  ```sh
  npm install -g @salesforce/cli
  ```

## Usage

To deploy the latest version of the unlocked package in your org, use the following command. Replace `VERSIONNUMBER` with the specific version you wish to install and `YOUR_ORG_NAME` with the alias of your Salesforce org.

 ```sh
  sf package install --package "Salesforce Tools@VERSIONNUMBER" --wait 10 --publish-wait 10 --target-org YOUR_ORG_NAME
  ```

* `VERSIONNUMBER`: The version of the package (e.g., 1.0.0).
* `YOUR_ORG_NAME`: The alias of your Salesforce org.

After deployment, you have to remove every "tlz" custom permissions of Salesforce Tools package which were assigned on Admin profile.

Also, you can add this repository as a subtree of your project to see the components and Apex classes. It will allows you to use the bash scripts to manage org files.

  ```sh
  git subtree add --prefix=tlz git@github.com:BoboJD/Salesforce-Tools.git master
  ```

To use the package's components and Apex classes, reference them with the "tlz" namespace.

## Contributing to the Project

We welcome contributions! To get started :

1. **Fork the Repository**: Create a fork of the repository to work on your changes.
2. **Create a Branch**: Create a new branch for each feature or bug fix.
3. **Make Changes**: Implement your changes and ensure that they adhere to the project’s coding standards.
4. **Test Your Changes**: Run tests to ensure that your changes do not introduce any issues.
5. **Submit a Pull Request**: Once you’re satisfied with your changes, submit a pull request for review.

### Create a scratch org

To initialize a new scratch org, use the following `make` command. Add the `-s` flag to set this org as the default.

  ```sh
  make org p="test -s"
  ```

* `test`: Replace with your desired scratch org alias.
* `-s`: Optional flag to set this org as the default.

### Maintaining fflib Libraries

To update the fflib libraries, use the following commands :

  ```sh
  # Update fflib-apex-mocks
  git subtree pull --prefix=force-app/fflib-apex-mocks git@github.com:apex-enterprise-patterns/fflib-apex-mocks.git master

  # Update fflib-apex-common
  git subtree pull --prefix=force-app/fflib-apex-common git@github.com:apex-enterprise-patterns/fflib-apex-common.git master
  ```

### Managing Package Versions

To create a new version of the package, use :

  ```sh
  sf package version create --definition-file config/project-scratch-def.json --package "Salesforce Tools" --wait 30 --installation-key-bypass --code-coverage
  ```

* `--package "Salesforce Tools"`: Replace with the name of your package.
* `--wait 10`: Adjust the wait time if needed; this specifies the number of minutes to wait for the process to complete.
* `--installation-key-bypass`: Bypass the installation key prompt.

Then to promote the new version, use :

  ```sh
  sf package version promote --package "Salesforce Tools@VERSIONNUMBER"
  ```

* `VERSIONNUMBER`: The version of the package (e.g., 1.0.0).

### Reporting Issues

For issues or suggestions, please open an issue on the [GitHub Issues](https://github.com/BoboJD/Salesforce-Tools/issues) page.

Thank you for contributing!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

This project includes code from:

* Salesforce.com, Inc., licensed under the BSD-3-Clause license.
* FinancialForce.com, Inc., with a license similar to the BSD-3-Clause license.
* Various sources, including Stack Overflow, under the Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0).

### Specific Acknowledgments

* **RollupHelper**: Adapted from a gist by Thibault WEBER. See the [original source](https://gist.github.com/grotib/838a40928d17d241f974319f04336bc3/edit).

### Attribution for Stack Overflow Code

Code snippets from Stack Overflow are used under the terms of the CC BY-SA 4.0 license. We acknowledge the Stack Overflow community for their contributions.
