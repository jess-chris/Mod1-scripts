#!/usr/bin/env bash

# NVM setup
exec curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash & 
wait

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

eval `nvm install 16`

eval `ssh-agent -s`

eval `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""`


# WSL or Linux
if [[ $(uname) == "Linux" ]]; then

  if ! grep -Fq "ssh-agent" ~/.bashrc; then
    printf "eval \`ssh-agent -s\`\n" >> ~/.bashrc
  fi

  printf "Host github.com\n    UpdateHostKeys yes\n    IdentityFile /home/$USER/.ssh/id_ed25519\n" >> ~/.ssh/config

#MAC OSX
elif [[ $(uname) == "Darwin" ]]; then

  if ! grep -Fq "ssh-agent" ~/.zshrc; then
    printf "eval \`ssh-agent -s\`\n" >> ~/.zshrc
  fi

  printf "Host github.com\n    UpdateHostKeys yes\n    IdentityFile /Users/$USER/.ssh/id_ed25519\n" >> ~/.ssh/config

fi

source ~/.bashrc

pubkey=$(cat ~/.ssh/id_ed25519.pub)

printf "***\n\n SSH_KEY: $pubkey \n***\n\n"

