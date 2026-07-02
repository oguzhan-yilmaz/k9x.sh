#!/usr/bin/env bash

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
