#!/usr/bin/env bash

set -eE

export DEBIAN_FRONTEND=noninteractive
LOG_FILE=$HOME/setup.log
touch "$LOG_FILE"

# Trap non-zero exit
trap '[[ "$?" == 0 ]] || (echo "==========" &&
echo "Last 10 lines of log:" &&
tail -n 10 $LOG_FILE &&
echo "==========" &&
echo "Problem encountered; check detailed log: $LOG_FILE")' EXIT

install_essentials() {
    echo 'Updating Apt sources...'
    sudo -E apt-get update | sudo tee -a "$LOG_FILE" &> /dev/null
    echo 'Updating Apt sources... [DONE]'

    echo 'Installing essential tools...'
    sudo -E apt-get install -qqy apt-utils \
                                 git \
                                 curl \
                                 zsh \
                                 vim | sudo tee -a "$LOG_FILE" &> /dev/null
    echo 'Installing essential tools... [DONE]'

    echo 'Installing libs for building...'
    sudo -E apt-get install -qqy build-essential \
                                 zlib1g-dev \
                                 liblzma-dev \
                                 libncursesw5-dev \
                                 libreadline-dev \
                                 libssl-dev \
                                 libgdbm-dev \
                                 libc6-dev \
                                 libsqlite3-dev \
                                 libbz2-dev \
                                 libffi-dev | sudo tee -a "$LOG_FILE" &> /dev/null
    echo 'Installing libs for building... [DONE]'
}

install_python() {
    echo 'Installing Pyenv...'
    curl -fsSL https://pyenv.run | bash - &>> "$LOG_FILE"

    # shellcheck disable=SC2016,SC2089
    PYENV_PATH='
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
'

    for i in ~/.bashrc ~/.zshrc
    do
        echo "$PYENV_PATH" >> $i
    done

    eval "$PYENV_PATH"
    echo 'Installing Pyenv... [DONE]'

    echo 'Installing Python 3.11 using Pyenv...'
    pyenv install 3.11 &>> "$LOG_FILE"
    pyenv global 3.11 &>> "$LOG_FILE"
    echo 'Installing Python 3.11 using Pyenv... [DONE]'
}

install_nodejs() {
    echo 'Installing nvm...'
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash &>> "$LOG_FILE"
    
    # shellcheck disable=SC2016,SC2089
    NVM_PATH='
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
'
    eval "$NVM_PATH"
    echo 'Installing nvm... [DONE]'

    echo 'Installing Node.js LTS using nvm...'
    nvm install --lts &>> "$LOG_FILE"
    nvm use --lts &>> "$LOG_FILE"
    echo 'Installing Node.js LTS using nvm... [DONE]'

    echo 'Install pnpm...'
    npm install --global pnpm &>> "$LOG_FILE"
    echo 'Install pnpm... [DONE'
}

install_go() {
    echo 'Installing GoLang...'
    arch=$(uname -m)
    if [[ $arch == aarch64 ]] || [[ $arch == amd64 ]]; then
        curl -fsSL "https://dl.google.com/go/$(curl https://go.dev/VERSION?m=text | head -n1).linux-amd64.tar.gz" | sudo tar -C /usr/local -xz
    elif [[ $arch == x86_64 ]]; then
        curl -fsSL "https://dl.google.com/go/$(curl https://go.dev/VERSION?m=text | head -n1).linux-amd64.tar.gz" | sudo tar -C /usr/local -xz
    else
        echo "Unsupported architecture: $arch; skipping GoLang installation"
        return
    fi
    GO_ENVS='
export PATH=$PATH:/usr/local/go/bin
'
    for i in ~/.bashrc ~/.zshrc
    do
        echo "$GO_ENVS" >> $i
    done

    eval "$GO_ENVS"
    echo 'Installing GoLang... [DONE]'
}

setup_shell() {
    echo 'Installing Oh My Zsh...'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &>> "$LOG_FILE"
    echo 'Installing Oh My Zsh... [DONE]'

    echo '
code() { code-server "$@" }
' >> ~/.zshrc

    echo 'Switching default shell to Zsh...'
    sudo chsh -s /bin/zsh "$USER"
    echo 'Switching default shell to Zsh... [DONE]'
}

install_essentials
setup_shell
install_python
install_nodejs
install_go

echo 'All set! Restart your shell to try it out!'
