## Branches 

> branches are just names for commits
> https://www.cloudbees.com/blog/git-detached-head

A branch is like a pointer to a specific commit.   

## Head 

> The purpose of HEAD is to keep track of the current point in a Git repo. In other words, HEAD answers the question, “Where am I right now?”
> For instance, when you use the log command, how does Git know which commit it should start displaying results from? HEAD provides the answer. When you create a new commit, its parent is indicated by where HEAD currently points to.

Simple project: 

```
$ touch file.txt ; git add . ; git commit -m 'first file'; date > file.txt ; git commit -am 'add date' ; date > file2.txt ; git add . ; git commit -m 'second file'
[master (root-commit) 3cbf359] first file
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 file.txt
[master 7276626] add date
 1 file changed, 1 insertion(+)
[master d991de1] second file
 1 file changed, 1 insertion(+)
 create mode 100644 file2.txt
 ```
 Commit log looks like: 
 ```
$ git log --oneline 
d991de1 (HEAD -> master) second file
7276626 add date
3cbf359 first file
```

To get to a **detached head state** you just need to try to check out a commit from the current brach: 

```
$ ls
file2.txt  file.txt
$ git checkout 3cbf359
HEAD is now at 3cbf359 first file
$ ls
file.txt
$ git log --oneline 
3cbf359 (HEAD) first file
```

> Most of the time, HEAD points to a branch name. When you add a new commit, your branch reference is updated to point to it, but HEAD remains the same. When you change branches, HEAD is updated to point to the branch you’ve switched to. All of that means that, in these scenarios, HEAD is synonymous with “the last commit in the current branch.” This is the normal state, in which HEAD is attached to a branch.

Adding changes while on **detached head state** links the new commits to where the head is currently pointing. For example: 

```
$ date > file3.txt ; git add . ; git commit -m 'third file in d-h'
[detached HEAD a911559] third file in d-h
 1 file changed, 1 insertion(+)
 create mode 100644 file3.txt
$ git log --oneline 
a911559 (HEAD) third file in d-h
3cbf359 first file
```

The commit shows that the d-h now points to a911559, giving us: 
```
[master (root-commit) 3cbf359] -> [master 7276626] -> [master d991de1]      
                        \---> [detached HEAD a911559]
```

### Keep it or ditch it? 

Let's add a couple of changes to our dechated head branch: 

```
$ date > file3.txt ; date > file.txt ; git add . ; git commit -m 'new dates'
[detached HEAD 791ffc7] new dates
 2 files changed, 2 insertions(+), 1 deletion(-)
```
Our repo now looks like: 
```
[master (root-commit) 3cbf359] -> [master 7276626] -> [master d991de1]      
                        \---> [detached HEAD a911559] -> [detached HEAD 791ffc7]

$ git log master --oneline 
d991de1 (master) second file
7276626 add date
3cbf359 first file

$ git log HEAD --oneline 
791ffc7 (HEAD) new dates
a911559 third file in d-h
3cbf359 first file
```
If we want to **DISCARD** all the changes we did in our detached head branch, and go back to the master branch, we simply need to checkout master.   

```
$ git co master
$ git log --oneline 
d991de1 (HEAD -> master) second file
7276626 add date
3cbf359 first file
```

Git gave us a warning about the two commits we had in our detached head branch: 
```
Warning: you are leaving 2 commits behind, not connected to
any of your branches:

  791ffc7 new dates
  a911559 third file in d-h

If you want to keep them by creating a new branch, this may be a good time
to do so with:

 git branch <new-branch-name> 791ffc7
```
Instead, if we want to **KEEP** the changes we made, we can create a new branch: 

```
$ git branch new-files
$ git co new-files 
Switched to branch 'new-files'

$ git log --oneline 
791ffc7 (HEAD -> new-files) new dates
a911559 third file in d-h
3cbf359 first file

$ git log master --oneline 
d991de1 (master) second file
7276626 add date
3cbf359 first file
```

The detached head has disappeared now that we tagged the commit (by creating a branch): 

```
$ git branch
  master
* new-files
```
New files added to the branch: 
```
$ date > file4.txt ; git add . ; git commit -m '4th file'
[new-files cd9a134] 4th file
 1 file changed, 1 insertion(+)
 create mode 100644 file4.txt
```
Makes our repo look like:
```
[master (root-commit) 3cbf359] -> [master 7276626] -> [master d991de1]      
                        \---> [new-files a911559] -> [new-files 791ffc7] -> [new-files HEAD cd9a134]
```

## Merge 

Once we're happy with the changes, we can merge our new-files branch into master with: 

```
$ git co master 
Switched to branch 'master'
$ git merge new-files 
Auto-merging file.txt
CONFLICT (content): Merge conflict in file.txt
Automatic merge failed; fix conflicts and then commit the result.
```

Here git is telling us that `file.txt` was modified on both branches, so we need to decide which file we'll include in the merge: 

```
$ git status 
On branch master
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Changes to be committed:
	new file:   file3.txt
	new file:   file4.txt

Unmerged paths:
  (use "git add <file>..." to mark resolution)
	both modified:   file.txt
  
$ cat file.txt 
<<<<<<< HEAD
Fri 24 Jun 2022 11:43:06 AM BST
=======
Fri 24 Jun 2022 12:13:27 PM BST
>>>>>>> new-files
```

The original content of the file was modified in the `new-files` branch.   
Git expects manual intervention to get the final file that will be added to the commit.   
This can be done easily with tools like vimdiff. First configure with:  

```
$ git config --global merge.tool vimdiff
$ git config --global diff.tool vimdiff
```

Then launch with: `$ git mergetool`    
After editing the file, git will leave the orig file (the one that contains the differences) and your file: 

```
$ ls file*
file2.txt  file3.txt  file4.txt  file.txt  file.txt.orig
```

To complete the merge, we simply need to add the file we just edited:

```
$ git status 
On branch master
All conflicts fixed but you are still merging.
  (use "git commit" to conclude merge)

Changes to be committed:
	modified:   file.txt
	new file:   file3.txt
	new file:   file4.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	file.txt.orig
 
$ git commit 
[master 501e659] Merge branch 'new-files'
```

Finally, we have all files in one branch, with no conflicts: 

```
$ git log --oneline 
501e659 (HEAD -> master) Merge branch 'new-files'
cd9a134 (new-files) 4th file
791ffc7 new dates
a911559 third file in d-h
d991de1 second file
3cbf359 first file
7276626 add date
```

Clear out the orig file and the branch created from the detached head: 

```
$ rm file.txt.orig ; git branch --delete new-files 
Deleted branch new-files (was cd9a134).
```





     


