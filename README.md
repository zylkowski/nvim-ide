# nvim-container

neovim in a container with coc all setup to work with rust and python.

## Usage

- Recommended font [JetBrains mono](https://www.jetbrains.com/lp/mono/)

### Build

```bash
docker build -t nvim-ide:latest .
```

### Run in bash

```bash
docker run --rm -v $(pwd):/p:z -it nvim-ide:latest bash
```
### Navigation

- These are the few I use all the time there are others look at the `init.vim` file

| Keys      | Command          |
| ----      | -------          |
| gd        | Go to def        |
| gr        | Show usages      |
| SPACE rn  | Rename           |
| SPACE e   | Show diag        |
| gcc       | Toggle comment   |
| Shift + K | Show Hover       |
| g[        | Buffer previous  |
| g]        | Buffer next      |
| d[        | Diag previous    |
| d]        | Diag next        |
