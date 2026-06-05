#!/usr/bin/env bash

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