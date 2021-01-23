# thock

[![Hackage](https://img.shields.io/hackage/v/thock.svg)](https://hackage.haskell.org/package/thock)

![An example of an online game](resources/demo.gif)

## Installation

### Binary

Right now there are only binaries for Ubuntu and macOS under [releases](https://github.com/rmehri01/thock/releases). Unfortunately there is no support for Windows but the Ubuntu binary will still work in [WSL](https://docs.microsoft.com/en-us/windows/wsl/about).

To use the binary you will have to put it on your PATH and may have to change permissions using `chmod` or allowing it in system preferences.

### From Source

```console
git clone https://github.com/rmehri01/thock.git
cd thock
stack install thock
```

## Usage
| `Esc / q` | return to previous menu, in the start menu - exit (`Note:` - `q` doesn't work during typing, use `^q` instead) |
| `^r`      | retry (during Practice)                                                                                        |
| `^n`      | next quote (during Practice)                                                                                   |

## Credit

The terminal UI is made using the amazing [brick](https://github.com/jtdaugherty/brick/) library and the online functionality was done using [websockets](https://github.com/jaspervdj/websockets). I also took a great amount of inspiration from other great projects such as [hascard](https://github.com/Yvee1/hascard), [monkeytype](https://github.com/Miodec/monkeytype), and [gotta-go-fast](https://github.com/callum-oakley/gotta-go-fast).
