#!/usr/bin/env bash



if [ -f "~/.ssh/id_ed25519" ]; then
  printf "SSH key already exists!"
  exit 0
fi

if ! [ $(ps ax | grep [s]sh-agent | wc -l) -gt 0 ] ; then
  eval `ssh-agent -s &>/dev/null`
fi

eval `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""`


# WSL or Linux
if [[ $(uname) == "Linux" ]]; then

  if ! grep -Fq "ssh-agent" ~/.bashrc; then
    printf "if ! [ \$(ps ax | grep [s]sh-agent | wc -l) -gt 0 ] ; then\n  eval \`ssh-agent -s &>/dev/null\`\nfi" >> ~/.bashrc
  fi

  printf "Host github.com\n    UpdateHostKeys yes\n    IdentityFile /home/$USER/.ssh/id_ed25519\n" >> ~/.ssh/config

#MAC OSX
elif [[ $(uname) == "Darwin" ]]; then

  # if ! grep -Fq "ssh-agent" ~/.zshrc; then
  #   printf "if ! [ \$(ps ax | grep [s]sh-agent | wc -l) -gt 0 ] ; then\n  eval \`ssh-agent -s &>/dev/null\`\nfi" >> ~/.zshrc
  # fi

  printf "Host github.com\n    UpdateHostKeys yes\n    IdentityFile /Users/$USER/.ssh/id_ed25519\n" >> ~/.ssh/config

fi

source ~/.bashrc

pubkey=$(cat ~/.ssh/id_ed25519.pub)

printf "\n\n\n $pubkey \n\n\n"

