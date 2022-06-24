# Files in your repo # 
> When you first clone a repository, all of your files will be tracked and unmodified because Git just checked them out and you haven’t edited anything.
```
✔ ~/randomjsongenerator [master|✔]
21:27 $ git status
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
```
A new file created is untracked 
```
✔ ~/randomjsongenerator [master|✔]
21:31 $ echo '.json' > .gitignore
✔ ~/randomjsongenerator [master|…1]
21:33 $ git status --short
?? .gitignore
```
To **stage** the file, we need to add it to the `staged` space: 
```
21:33 $ git add .gitignore
✔ ~/randomjsongenerator [master|●1]
21:35 $ git status --short
A  .gitignore
```
If a tracked file is modified it shows as: 
```
✔ ~/randomjsongenerator [master|●1✚ 1]
21:39 $ git status --short
A  .gitignore
 M template.temjson
```
> file appears under a section named “Changes not staged for commit” — which means that a file that is tracked has been modified in the working directory but not yet staged. To stage it, you run the git add command. git add is a multipurpose command — you use it to begin tracking new files, to stage files, and to do other things like marking merge-conflicted files as resolved. It may be helpful to think of it more as “add precisely this content to the next commit” rather than “add this file to the project”.     

We want to add the changes made to `template.temjson` to the project
```
✔ ~/randomjsongenerator [master|●1✚ 1]
21:39 $ git add template.temjson
✔ ~/randomjsongenerator [master|●2]
21:42 $ git status --short
A  .gitignore
M  template.temjson
```
If a file that was staged is modified, it needs to be staged again, because git assumes that the version we want to add to the project was the version we staged before. 
```
✔ ~/randomjsongenerator [master|●2]
21:42 $ echo "*.log" >> .gitignore
✔ ~/randomjsongenerator [master|●2✚ 1]
21:51 $ git status --short
AM .gitignore
M  template.temjson
```
## Differences between files ##
Diff is going to show us the differences between a file that was modified, but not `add`ed to the staging section yet. 
```
✔ ~/randomjsongenerator [master|●2✚ 1]
22:07 $ git status --short
AM .gitignore
M  template.temjson
✔ ~/randomjsongenerator [master|●2✚ 1]
22:08 $ git diff
diff --git a/.gitignore b/.gitignore
index 2057451..d1c82d5 100644            #<---- diff between index 20* and d1*
--- a/.gitignore
+++ b/.gitignore                           #<---- b is identified by "+"
@@ -1,2 +1,3 @@
 .json
 *.log
+*.tmp            #<----- only on b
```
We can use the `--staged` flag of `git diff` to look at changes that have been staged with `git add`
```
✔ ~/randomjsongenerator [master|●2✚ 1]
22:08 $ git diff --staged
diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..2057451   #<---- diff between index 00* and 20* 
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,2 @@
+.json
+*.log
diff --git a/template.temjson b/template.temjson
index 0678e0b..d355a86 100644          #<---- existing file, so index is not 00*
--- a/template.temjson
+++ b/template.temjson
@@ -2,6 +2,7 @@
   "title" : "XTITLE" ,
   "category" : "XCAT" ,
   "date" : "XDATE" ,
+  "id" : XID
```
## Removing files ##
If we want to move a staged file back to being untracked, we can use `git rm --cached` 
```
✔ ~/randomjsongenerator [master|●2]
22:27 $ git rm --cached .gitignore
rm '.gitignore'
✔ ~/randomjsongenerator [master|●1…1]
```
