
#                       Git Assessment-2 
 
1. How do you rename the current branch you are on to a new-branch-name? 
```
git branch -m oldname newname
```
2. What is the command to stash your changes and include untracked files?
```
git stash -u 
```
3. How would you merge changes from the branch feature-new into your current branch?
```
git merge feature-new  branchname
```
4. What command do you use to view the differences between your working directory and the last commit? 
```
git diff
```
5. Explain how to resolve a merge conflict that occurs during a git merge. What steps would you take? 
```
Switch to branch and open conflicted file and resolve the conflicts and conflicts resolved then merge it.
```
6. Explain the purpose and use case of git rebase with an example. How does it differ from git merge? 
```
- git rebase command is used to move sequence of commits to base commit.For example in have A—B--C in main branch and from B in created another branch named feature and I hane commit D—E.Now by using rebase command I am in feature branch and command git rebase main.and the result will be A—B—C--D--E.
- git merge command is used to merge two branches.
```  
7. What does the command git cherry-pick <commit hash> do? Provide a scenario where you might use it.
```
- git cherrypick<command hash>  use to copy specific commit to from one branch to another branch…
- scenario: I am working in a main branch and a feature branch.I made many commits in feature branch and if I want that last specific commit to my main branch I use cheerypick command.
```
8. Describe the differences between git reset --soft, git reset --mixed, and git reset --hard. When would you use each?
```
- git reset—soft : moves head point to the specifid commit.undoes all changes made between two commits and add the changes as staged and ready to commit.
- git rest--mixed : it is a default command and preserve your changes in the working directory.
- git reset—hard: it discards all changes between two commits.it is danger to use.
```
9. Describe how you would revert a commit that has already been pushed to a shared repository. What command would you use, and what should you consider before doing this? 
```
git revet<commit -hash>
```
10. What is the difference between git pull --rebase and git pull? When would you prefer one over the other? 
```
- git pull :It fetches changes from the remote repository and then merges them into current branch.
- git pull—rebase:It used to insteed of merging it rebase your local commits on top of fetched changes
```
11. How can you view the changes made by a specific commit? What command do you use?
```
git show 
```
12. What is branch protection in Git, and why is it important for a collaborative development environment? 
```
Branch protection is to protect important branches by setting branch protection rules,which define whether collaborators can delete or force push to the branch and set requirements for any pushes to the branch.
```  
13. Explain how to set up branch protection rules in GitHub.
```
1. Go to the repository’s main page on github.

2. click settings under repository name

3. click branches in the code and automation section of the sidebar.

4. click add rule next to branch protection rule.
   
5. Type the branch name or pattern you want to protect under branch name pattern.

6.click create or save changes to confirm the rule.  
```
14. What happens if a user tries to push changes directly to a protected branch? 
```
The user will receive an erroe message that the branch is protected and direct pushes are not allowed.this prevents unauthorized changes and enforce the workflow rules set for the branch,such as requiring pull request or specific approvals before merging.
```
15. What is the purpose of a .gitignore file, and how do you create one? Provide an example of what you might include in it.
```
- The .gitignore file is used to specify files and directories that git should ignore in a repository and not track.This is used to excluding files that are not needed for version control such as temporary files..
- To crete a file in root repository create a file named .gitignore
- I can include system-specific files,vs code workspaces,the security keyfiles get added to the gitignore.
```
