# LSP SERVERS INSTALL INSTRUCTIONS

## Astro
~~~
npm install -g @astrojs/language-server
~~~

## TailwindCSS
~~~
npm install -g @tailwindcss/language-server
~~~

## Clangd + llbd debugger

### Windows
[clangd + llbd](https://github.com/llvm/llvm-project/releases/tag/llvmorg-15.0.2) -> LLVM-15.0.2-win64.exe

### Linux
~~~
sudo apt install clangd
~~~


## TypeScript
~~~
npm install -g typescript typescript-language-server
~~~

## Css - Html - JavaScript
~~~
npm i -g vscode-langservers-extracted
~~~

## Deno
[link](https://deno.land/#installation)


## Go
~~~
go install golang.org/x/tools/gopls@latest
~~~


## Haskell
[link](https://github.com/haskell/haskell-language-server)


## Markdown
[link](https://github.com/artempyanykh/marksman/releases)


## Python

### Pylsp
~~~
pipx install 'python-lsp-server[all]'
~~~

### Pyright
~~~
pip install pyright
~~~

## Rust
~~~
rustup add component rust-analyzer
~~~

With this command we find the installation path
~~~
rustup which --toolchain stable rust-analyzer
~~~

## Toml
~~~
cargo install taplo-cli --locked --features lsp
~~~

## Sumneko [Lua]

### Windows
[link](https://github.com/sumneko/lua-language-server/releases)

### Linux
* Install Lua
~~~
sudo apt install lua5.4
~~~
* Install language-server
~~~
wget https://github.com/sumneko/lua-language-server/releases/download/3.6.7/lua-language-server-3.6.7-linux-x64.tar.gz
~~~

# TOOLS

## cmake
[link](https://cmake.org/download/)

## make
~~~
choco install make
~~~

## ripgrep
~~~
cargo install ripgrep
~~~

## lazygit
~~~
go install github.com/jesseduffield/lazygit@latest
~~~

## fzf

### Mac - Linux
~~~
brew install fzf
~~~

### Windows
~~~
choco install fzf
~~~

## bat - cat replacement

### Mac
~~~
brew install bat
~~~

### Windows
~~~
choco install bat
~~~

### Linux
~~~
sudo apt install bat
~~~

## fd

### Linux
~~~
sudo apt install fd-find
ln -s $(which fdfind) ~/.local/bin/fd
~~~

### Mac
~~~
brew install fd
~~~

### Windows
~~~
choco install fd
~~~

## bottom

### Linux - Mac - Windows
~~~
cargo install bottom --locked
~~~

## gdu

### Linux - Mac - Windows
~~~
go install github.com/dundee/gdu/v5/cmd/gdu@latest
~~~

# NEOVIM

### Mac - Linux
~~~
-- Install
brew install --HEAD neovim
-- Update
brew upgrade neovim --fetch-HEAD
~~~
### Windows
~~~
choco install neovim --pre
~~~

## NEOVIM DEPENDENCIES
~~~
pip install neovim
npm install -g neovim
~~~

# HELIX
```toml
[[language]]
name = "javascript"
shebangs = ["deno", "node"]
roots = ["deno.json", "package.json", "tsconfig.json"]
config = { enable = true, lint = true, unstable = true }
language-server = { command = "deno", args = ["lsp"], language-id = "javascript" }

[[language]]
name = "jsx"
shebangs = ["deno", "node"]
roots = ["deno.json", "package.json", "tsconfig.json"]
config = { enable = true, lint = true, unstable = true }
language-server = { command = "deno", args = ["lsp"], language-id = "javascriptreact" }

[[language]]
name = "typescript"
shebangs = ["deno", "node"]
roots = ["deno.json", "package.json", "tsconfig.json"]
config = { enable = true, lint = true, unstable = true }
language-server = { command = "deno", args = ["lsp"], language-id = "typescript" }

[[language]]
name = "tsx"
shebangs = ["deno", "node"]
roots = ["deno.json", "package.json", "tsconfig.json"]
config = { enable = true, lint = true, unstable = true }
language-server = { command = "deno", args = ["lsp"], language-id = "typescriptreact" }

[[language]]
name = "python"
roots = ["pyrightconfig.json", "pyproject.toml", "setup.py", "Poetry.lock", "."]
language-server = { command = "pyright-langserver", args = ["--stdio"] }
config = {}
```
