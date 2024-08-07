# Salesforce Tools

This project is an unlocked package containing fflib files, utility classes, and service Apex classes. It also includes best practices used in conjunction with fflib. The repository features a `scripts` folder to manage deployments and keep the repository up-to-date.

## Usage

To deploy the latest version of the unlocked package in your org, use the following command. Replace `VERSIONNUMBER` with the specific version you wish to install and `YOUR_ORG_NAME` with the alias of your Salesforce org.

 ```sh
  sf package install --package "Salesforce Tools@VERSIONNUMBER" --wait 10 --publish-wait 10 --target-org YOUR_ORG_NAME
  ```

* `VERSIONNUMBER`: The version of the package (e.g., 1.0.0).
* `YOUR_ORG_NAME`: The alias of your Salesforce org.

After deployment, you can add this repository as a subtree of your project to reference the components and Apex classes.

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

To initialize a new scratch org, use the following script. Add the `-s` flag to set this org as the default.

  ```sh
  sh scripts/initScratchOrg.sh test -s
  ```

* `test`: Replace with your desired scratch org alias.
* `-s`: Optional flag to set this org as the default.

### Maintaining fflib Libraries

To update the fflib libraries, use the following commands :

  ```sh
  # Update fflib-apex-mocks
  git subtree pull --prefix=fflib-apex-mocks git@github.com:apex-enterprise-patterns/fflib-apex-mocks.git master

  # Update fflib-apex-common
  git subtree pull --prefix=fflib-apex-common git@github.com:apex-enterprise-patterns/fflib-apex-common.git master
  ```

### Managing Package Versions

To create a new version of the package, use :

  ```sh
  sf package version create --package "Salesforce Tools" --wait 10 --installation-key-bypass
  ```

* `--package "Salesforce Tools"`: Replace with the name of your package.
* `--wait 10`: Adjust the wait time if needed; this specifies the number of minutes to wait for the process to complete.
* `--installation-key-bypass`: Bypass the installation key prompt.

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

- **RollupHelper**: Adapted from a gist by Thibault WEBER. See the [original source](https://gist.github.com/grotib/838a40928d17d241f974319f04336bc3/edit).

### Attribution for Stack Overflow Code

Code snippets from Stack Overflow are used under the terms of the CC BY-SA 4.0 license. We acknowledge the Stack Overflow community for their contributions.
