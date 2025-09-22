# My nvim config
Derived from kickstart and modified down the line. 

## LSPs
Using the 0.11+ native LSPs. You need to install the LSPs manually.
This should install them all:

### Emmet, HTML, JS, Typescript, Svelte
```
bun add -g vscode-langservers-extracted typescript-language-server emmet-ls svelte-language-server
```

### Rust
```
rustup component add rust-analyzer
```

### Lua
```
brew install lua-language-server
```

### Go
```
go install golang.org/x/tools/gopls@latest
```
