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

* To avoid line return warning with git, you can run this command

  ```sh
  git config --global core.safecrlf false
  ```

## Installation of package in your Salesforce org

To deploy the latest version of the unlocked package in your org, use the following command. Replace `VERSIONNUMBER` with the specific version you wish to install and `YOUR_ORG_NAME` with the alias of your Salesforce org.

 ```sh
  sf package install --package "Salesforce Tools@VERSIONNUMBER" --wait 10 --publish-wait 10 --target-org YOUR_ORG_NAME
  ```

* `VERSIONNUMBER`: The version of the package (e.g., 1.0.0).
* `YOUR_ORG_NAME`: The alias of your Salesforce org.

After deployment, you have to remove every "tlz" custom permissions of Salesforce Tools package which were assigned on Admin profile.

To use the package's components and Apex classes, reference them with the "tlz" namespace.

## A subtree for your project

You can add this repository as a subtree of your project to see the components and Apex classes. It will allows you to use the bash scripts to manage org files.

  ```sh
  git subtree add --prefix=tlz git@github.com:BoboJD/Salesforce-Tools.git master --squash
  ```

## Contributing to the Project

Want to contribute? Ask me for a **Scratch Org**, and I'll send you your credentials.  
This allows you to develop and test without accessing the production org.  

### Contribution Steps  

1. **Fork the Repository** – Create a fork of the repository to work on your changes.  
2. **Create a Branch** – Use a new branch for each feature or bug fix.  
3. **Make Changes** – Implement your changes while following the project’s coding standards.  
4. **Test Your Changes** – Run tests to ensure your changes don’t introduce issues.  
5. **Submit a Pull Request** – Once satisfied, open a pull request for review.

### Reporting Issues

For issues or suggestions, please open an issue on the [GitHub Issues](https://github.com/BoboJD/Salesforce-Tools/issues) page.

Looking forward to your contributions!

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
