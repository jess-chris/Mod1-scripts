#!/usr/bin/env bash

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

