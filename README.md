# k9x.sh
interactively asks for kubeconfig file and context before opening k9s (using fzf)



## Installation

To add the `k9x` function to your shell, append the following code to your shell's configuration file ( `~/.bashrc`  or `~/.zshrc`):

1. Append to your `~/.bashrc` or `~/.zshrc` 

```bash
k9x() {
    local kubeconfig
    local context
    local flags

    kubeconfig=$(ls -p ~/.kube | grep -v / | fzf --prompt="Select kubeconfig > ")
    [[ -z "$kubeconfig" ]] && return 1

    context=$(
        KUBECONFIG="$HOME/.kube/$kubeconfig" kubectl config get-contexts -o name |
            fzf --prompt="Select context > "
    )
    [[ -z "$context" ]] && return 1

    export K9S_KUBECONFIG="$HOME/.kube/$kubeconfig"
    export K9S_CONTEXT="$context"

    flags="${K9X_FLAGS:--A -c pod}"
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        command k9s --kubeconfig "$K9S_KUBECONFIG" --context "$K9S_CONTEXT" ${=flags}
    else
        command k9s --kubeconfig "$K9S_KUBECONFIG" --context "$K9S_CONTEXT" $flags
    fi
}
```

2. Reload your config

```bash
source ~/.zshrc
source ~/.bashrc
```

## Usage

Simply run `k9x` in your terminal:

```bash
k9x
```

The function will guide you through selecting your `kubeconfig` and context.

## Dependencies

- **kubectl**
- **[fzf](https://github.com/junegunn/fzf?tab=readme-ov-file#using-homebrew)**  🌸 A command-line fuzzy finder 

Use **kx/kubectx** separately when you want to change the global kubectl context. `k9x` only sets `K9S_CONTEXT` / `K9S_KUBECONFIG` in the current shell.

## Configuration

`K9X_FLAGS` sets extra flags passed to `k9s`. When unset, the defaults are used:

```bash
-A -c pod
```

Override in your shell config:

```bash
export K9X_FLAGS='--splashless -A -c deployments'
```

`--kubeconfig` and `--context` are always set by `k9x` from your fzf selection and are not part of `K9X_FLAGS`.



## Tips

- If you use `:q` for exiting, k9s saves your session state, and you can go back to where you were. `Ctrl+C` will not do this.