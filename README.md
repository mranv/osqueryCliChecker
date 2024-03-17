# osqueryCliChecker

## Overview
osqueryCliChecker is a utility tool written in Swift for macOS systems. It checks for the presence of the `osqueryi` and `osqueryctl` command-line interfaces (CLI) and installs them if necessary. Additionally, it performs post-installation steps required for setting up osquery.

## Components
The project consists of the following components:

1. **main.swift**: This file contains the main logic of the utility tool. It checks for the presence of `osqueryi` and `osqueryctl` using pkg-config, installs them if not found, and executes post-installation steps.

2. **Installation functions**: These functions are responsible for downloading and installing osquery if it's not already present on the system. This includes downloading the package from a specified URL, installing it using the macOS installer (`/usr/sbin/installer`), and cleaning up temporary files.

3. **Post-installation steps**: These steps include copying configuration files and plist files to appropriate directories and loading the launch daemon for osquery.

4. **Utility functions**: These functions handle the execution of shell commands (`executeCommand`) and finding the paths of osquery executables (`findAndRunOsqueryCommands`).

## How to Use

1. Clone the `osqueryCliChecker` repository to your local machine:

    ```bash
    git clone https://github.com/yourusername/osqueryCliChecker.git
    ```

2. Navigate to the cloned directory:

    ```bash
    cd osqueryCliChecker
    ```

3. Execute the main script:

    ```bash
    swift main.swift 
    ```

    This will check for the presence of `osqueryi` and `osqueryctl` on your system. If they are not found, the script will download and install osquery, and then execute the post-installation steps.

## Dependencies

The project uses the following dependencies:

- **Foundation**: The Foundation framework provides a base layer of functionality for apps and frameworks, including data storage and persistence, text processing, date and time calculations, and networking.

## Compatibility

The utility tool is compatible with macOS systems.

## License

This project is licensed under the [MIT License](LICENSE).

## Contribution

Contributions are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or create a pull request on the [GitHub repository](https://github.com/yourusername/osqueryCliChecker).

---
Feel free to modify the placeholders (such as `yourusername`) with the appropriate information for your project. Let me know if you need further assistance!
