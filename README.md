# k9x.sh
interactively asks for kubeconfig file and context before opening k9s (using fzf and kubectx)



## Installation

To add the `k9x` function to your shell, append the following code to your shell's configuration file ( `~/.bashrc`  or `~/.zshrc`):

1. Append to your `~/.bashrc` or `~/.zshrc` 

```bash
k9x() {
    local kubeconfig
    local context
    # list kubeconfig files and select one with fzf
    kubeconfig=$(ls -p ~/.kube | grep -v / | fzf --prompt="Select kubeconfig > ")
    [[ -z "$kubeconfig" ]] && return 1

    # for the selected config, choose a context
    context=$(KUBECONFIG="$HOME/.kube/$kubeconfig" kubectx | fzf)

    # open k9s 
    k9s --splashless -A -c pod --kubeconfig "$HOME/.kube/$kubeconfig" --context "$context"
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

- **[kubectx](https://github.com/ahmetb/kubectx)**  Faster way to switch between clusters and namespaces in kubectl 
- **[fzf](https://github.com/junegunn/fzf?tab=readme-ov-file#using-homebrew)**  🌸 A command-line fuzzy finder 



## Tips

- If you use `:q` for exiting, k9s saves your session state, and you can go back to where you were. `Ctrl+C` will not do this.