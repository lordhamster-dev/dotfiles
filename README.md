# dotfiles

# fish shell

## Install

```shell
brew install fish
```

## Add to /etc/shells

```shell
/usr/local/bin/fish
```

## Set default shell

```shell
chsh -s /usr/local/bin/fish
```

## Install fisher

```shell
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

## Install nvm

```shell
fisher install jorgebucaran/nvm.fish
```
