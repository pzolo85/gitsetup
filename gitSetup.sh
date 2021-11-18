#!/bin/bash

git config --global user.name $NAME
git config --global user.email $MAIL
git config --global core.editor vim
# Default branch
git config --global init.defaultBranch main

# Get bash-git-prompt 
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
cat << EOF >> ~/.bashrc
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/.bash-git-prompt/gitprompt.sh
fi
EOF

# Set commit message template
# https://gist.github.com/lisawolderiksen/a7b99d94c92c6671181611be1641c733
git config --global commit.template ~/.gitmessage
cat << EOF > ~/.gitmessage
# Title: Summary, imperative, start upper case, don't end with a period
# No more than 50 chars. #### 50 chars is here: #

# Remember blank line between title and body.

# Body: Explain *what* and *why* (not *how*). Include task ID (Jira issue).
# Wrap at 72 chars. ################################## which is here: #

EOF
