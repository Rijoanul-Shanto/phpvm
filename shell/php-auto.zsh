# PHP Switcher - Zsh auto-switch hook
# Add to ~/.zshrc:
#   source /etc/phpvm/php-auto.zsh

autoload -U add-zsh-hook

_php_switcher_auto() {
    command -v phpvm &>/dev/null || return
    if [[ -n "${PHPVM_DEBUG:-}" ]]; then
        phpvm --auto --quiet
    else
        phpvm --auto --quiet 2>/dev/null
    fi
}

add-zsh-hook chpwd _php_switcher_auto

_php_switcher_auto