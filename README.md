# cmdlatex
Convert LaTeX input into a png, which is copied to the clipboard.

## Requirements
This script uses `pdflatex`, `convert`, `xclip` and `feh`. Make sure that these programs are already installed for the correct execution of the script.

## Getting started
To get things running, clone the repository either with HTTPS or SSH; or download a zip file of the repository:
### HTTPS

```bash
git clone https://github.com/nilsmo1/cmdlatex.git
```
### SSH

```bash
git clone git@github.com:nilsmo1/cmdlatex.git
```
From here, go to the newly downloaded or cloned instance of the repository and run the `INSTALL` script:
```
cd cmdlatex
./INSTALL
```
This will copy the executable `cmdlatex.sh` to `~/.local/bin/` as `cmdlatex` and the default config file will be created under `~/.config/cmdlatex/config.tex`.
> Make sure that your `$PATH` variable includes `~/.local/bin/` for this to work.

## Usage
Either run
```bash
cmdlatex [-optional flags] -e '<latex expression>'
```
> If the `-e` flag is used, make sure to surround the expression with single quotes.

Or
```bash
cmdlatex [-optional flags]
```

## Additional help
For additional information about the different flags that this program supports, run `cmdlatex -h`.
