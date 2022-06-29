# Git trees
> https://www.atlassian.com/git/tutorials/undoing-changes/git-reset

In order to understand how reset works, need to first understand the different between 3 trees:   
- working directory (actual files)
- staging index  (`git ls-files -s`)
- commit hisory 

Example, new project:    
```
$ git init 
Initialized empty Git repository in /home/ptosiani/test/.git/
✔ ~/test [master L|✔] 
18:38 $ date > f1.txt ; date > f2.txt ; date > f3.txt

# working directory now has 3 files 
# staging index is empty 
# commit history is empty 
```
We add the 3 files to the staging index: 
```
18:40 $ git add . 
18:40 $ git ls-files -s 
100644 226b30bcecf530022d89af692fc2a402e7a4d90f 0	f1.txt
100644 226b30bcecf530022d89af692fc2a402e7a4d90f 0	f2.txt
100644 226b30bcecf530022d89af692fc2a402e7a4d90f 0	f3.txt

# working dir has 3 files
# staging index has 3 files 
# commit history is empty 
```
We commit the changes: 
```
8:41 $ git commit -m 'first commit' 
[master (root-commit) 99818f3] first commit
 3 files changed, 3 insertions(+)
 create mode 100644 f1.txt
 create mode 100644 f2.txt
 create mode 100644 f3.txt
```
Now we add a couple extra files and commits to increase the commit history.   
```
8:47 $ git log  --oneline 
8f539dd (HEAD -> master) fourth commit
ae174fa third commit
3bcdc49 second commit
99818f3 first commit
```

> At a surface level, git reset is similar in behavior to git checkout. Where git checkout solely operates on the HEAD ref pointer, git reset will move the HEAD ref pointer and the current branch ref pointer.

## Checkout vs Reset 

### Checkout 
With checkout we move the HEAD in the commit index, but we leave the branch pointer. Creating a detached head scenario: 

```
18:49 $ ls
f1.txt  f2.txt  f3.txt  f4.txt  f5.txt  f6.txt
18:55 $ git co 99818f3
8:55 $ git log --oneline 
99818f3 (HEAD) first commit
18:56 $ ls
f1.txt  f2.txt  f3.txt      <--- files are gone, we're back at fisr commit. But can switch back. 

18:57 $ git reflog
99818f3 (HEAD) HEAD@{0}: checkout: moving from master to 99818f3
8f539dd (master) HEAD@{1}: commit: fourth commit
ae174fa HEAD@{4}: commit: third commit
3bcdc49 HEAD@{5}: commit: second commit
99818f3 (HEAD) HEAD@{2}: commit (initial): first commit
```

### Reset 

By default reset uses `--mixed` option (commit index + staging index) 

```
19:03 $ git log --oneline 
1dc09a3 (HEAD -> master) fourth commit
51e9fde third commit
6366bc2 second commit
40c03aa first commit

19:03 $ git reset 6366bc2

19:04 $ git log --oneline 
6366bc2 (HEAD -> master) second commit
40c03aa first commit

19:04 $ ls
f1.txt  f2.txt  f3.txt  f4.txt  f5.txt  f6.txt

19:04 $ git status 
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	f5.txt
	f6.txt

```

Now the staging index says that there are **2 untracked** files.   

Using `--soft` only moves the commit index. It can be used to fix commit messages.    
To merge multiple commits in one.  

```
19:13 $ git reset --soft 6366bc2

19:14 $ git log --oneline 
6366bc2 (HEAD -> master) second commit
40c03aa first commit

19:14 $ ls
f1.txt  f2.txt  f3.txt  f4.txt  f5.txt  f6.txt

19:15 $ git status 
On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   f5.txt
	new file:   f6.txt
```
Now the staging index says that there are **2 new** files.   

Finally, the most dangerous option `--hard` takes you all the way back in time, including removing files form the working directory.  

```
19:18 $ git reset --hard 6366bc2
HEAD is now at 6366bc2 second commit

19:19 $ ls 
f1.txt  f2.txt  f3.txt  f4.txt

19:19 $ git log --oneline 
6366bc2 (HEAD -> master) second commit
40c03aa first commit

19:19 $ git reflog 
6366bc2 (HEAD -> master) HEAD@{0}: reset: moving to 6366bc2
1dc09a3 HEAD@{1}: commit: fourth commit
51e9fde HEAD@{2}: commit: third commit
6366bc2 (HEAD -> master) HEAD@{3}: commit: second commit
40c03aa HEAD@{4}: commit (initial): first commit

# Recover by doing another rest 

19:29 $ git reset --hard 1dc09a3
19:30 $ git log --oneline 
1dc09a3 (HEAD -> master) fourth commit
51e9fde third commit
6366bc2 second commit
40c03aa first commit

19:30 $ ls
f1.txt  f2.txt  f3.txt  f4.txt  f5.txt  f6.txt
```








