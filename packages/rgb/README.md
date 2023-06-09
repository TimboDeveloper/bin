# RGB Command
The rgb command is a command-line utility that allows you to display colored text in the terminal. It provides a simple way to customize the appearance of the text by specifying the RGB values of the desired color. This readme file explains the usage and options of the rgb command.

## Syntax

```sh
rgb [options] <message> <R> <G> <B>
```

* \<message\>: Optional parameter. The text message to be displayed in the specified color. If not provided, the command will color the current terminal.

* \<R\>, \<G\>, \<B\>: Required parameters. They represent the red, green, and blue values, respectively, ranging from 0 to 255.

## Options
The rgb command supports the following options:

* -h: Displays the help information for the rgb command, including usage and available options.
* -b: Renders the text message in bold. This option enhances the visual impact of the colored text.

## Examples
To color the current terminal in a specific RGB color:

```sh
rgb 128 0 255
```

To display a message in a specific RGB color:

```sh
rgb "Hello, world!" 255 0 0
```

To display a message in a bold and specific RGB color:

```sh
rgb -b "Important message" 0 128 0
```

## Compatibility
The rgb command is compatible with most Unix-like systems, including Linux and macOS. It can be executed from the terminal or incorporated into shell scripts to add color and emphasis to your text-based applications.
