# Create new repository # 

Make sure you create a [Personal Access Token](https://github.com/settings/tokens) with `Full control of private repositories`.   
Save the token in `~/.gitPAT`

Create a new repository using Github's API: 
```
REPO=set-repo-name
curl -u "$(git config --global --get user.name):$(cat ~/.gitPAT)" https://api.github.com/user/repos -d "{\"name\":\"$REPO\"}"
```
Initialize your local repo:
```
mkdir $REPO ; cd $REPO 
git init
```
Set the remote repo you just created on Github:
```
git remote add origin "git@github.com:$(git config --global --get user.name)/${REPO}.git"
```
Send tour first commit (readme.md)
```
echo "#${REPO}#" > README.md
git add README.md
git commit -m "First commit"
git push --set-upstream origin main
```
