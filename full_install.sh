#!/usr/bin/env bash

# Install node and check versions
if [ -z $(which node) ] ; then

  # NVM setup
  exec curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash &>/dev/null
  wait $!

  export NVM_DIR="$HOME/.nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"\n[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

  eval `nvm install 16 &>/dev/null`
  wait $!
else
  if [ -z $(node --version | grep v16) ] ; then
    eval `nvm install 16 &>/dev/null`
    wait $!
    eval `nvm use 16 &>/dev/null`
    wait $!
  fi
fi

# Install mocha globally 
if [ -z $(which mocha) ] ; then
  eval `npm i -g mocha &>/dev/null`
  wait $!
fi

# Check for ssh-agent process
if ! [ $(ps ax | grep [s]sh-agent | wc -l) -gt 0 ] ; then
  eval `ssh-agent -s &>/dev/null`
  wait $!
fi

# Check if key exists otherwise create a new one
if [ -f "~/.ssh/id_ed25519" ]; then
  printf "SSH key already exists!"
else
  eval `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""`
fi

# WSL or Linux
if [[ $(uname) == "Linux" ]]; then

  if ! grep -Fq "ssh-agent" ~/.bashrc; then
    printf "if ! [ \$(ps ax | grep [s]sh-agent | wc -l) -gt 0 ] ; then\n  eval \`ssh-agent -s &>/dev/null\`\nfi" >> ~/.bashrc
  fi

  printf "Host github.com\n    UpdateHostKeys yes\n    IdentityFile /home/$USER/.ssh/id_ed25519\n" >> ~/.ssh/config

#MAC OSX
elif [[ $(uname) == "Darwin" ]]; then

  if ! grep -Fq "ssh-agent" ~/.zshrc; then
    printf "if ! [ \$(ps ax | grep [s]sh-agent | wc -l) -gt 0 ] ; then\n  eval \`ssh-agent -s &>/dev/null\`\nfi" >> ~/.zshrc
  fi

  printf "Host github.com\n    UpdateHostKeys yes\n    IdentityFile /Users/$USER/.ssh/id_ed25519\n" >> ~/.ssh/config

fi


pubkey=$(cat ~/.ssh/id_ed25519.pub)

printf "***\n\n SSH_KEY: $pubkey \n***\n\n"

