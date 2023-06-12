# Generics

[group-start]: <> (force)
--force

The --force flag allows the command to be executed forcefully, overriding any restrictions or safety measures that may be in place.

Usage:
    command [options] --force

Examples:
    1. Run a command forcefully:
            command --force

    2. Replace an existing file without confirmation:
            command replace file.txt --force

    3. Delete a directory and its contents forcefully:
            command delete directory --force

Notes:
    - Exercise caution when using the --force flag as it can lead to irreversible actions or data loss.
    - Always double-check the consequences before proceeding.
    - It is recommended to make backup copies or take necessary precautions before using --force.
    - Some commands or utilities may provide additional warnings or prompts when the --force flag is used.
    - To skip the confirmation prompt and automatically answer "yes" when using --force, you can consider using the --yes or --assume-yes flag.

Confirmation Prompt:
    When --force is used, a confirmation prompt is typically displayed to ensure user intention. The prompt may ask for a "yes" or "no" response to proceed with the potentially risky action.

Example with Confirmation Prompt:
    command delete directory --force
    Are you sure you want to delete the directory 'directory'? (yes/no):

Skipping Confirmation Prompt:
    Some commands or utilities provide an alternative flag, such as --yes or --assume-yes, which allows skipping the confirmation prompt and automatically answering "yes" to proceed with the action.

Example with Skipping Confirmation Prompt:
    command delete directory --force --yes
    The action will proceed without displaying the confirmation prompt.
[group-end]: <> (force)

# Bin - Command

[group-start]: <> (default)
Usage: bin [options] [command]
[group-end]: <> (default)

[group-start]: <> (create)
bin create - Create a package

Syntax:
    bin create <package-name> [options]

Description:
    This command creates a package within the "packages" folder. If the "packages" folder does not exist, it will be created automatically. The package name should be specified as an argument.

    Options:
    --force      Force the creation of the package folder even if it already exists.
    --yes        Skip the confirmation prompt when using the --force option.

Usage examples:
    1. Create a package named "mypackage":
        bin create mypackage

    2. Create a package named "mypackage" and force the recreation of the package folder if it already exists:
        bin create mypackage --force

    3. Create a package named "mypackage" and skip the confirmation prompt when forcing the recreation of the package folder:
        bin create mypackage --force --yes

Note:
    - The package name should be a valid string without spaces or special characters.
    - The package will be created within the "packages" folder in the current directory.
[group-end]: <> (create)
