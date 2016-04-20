
# The headers are listed in chronological order.
By following these steps, you can reduce the amount of errors and merge conflicts that your group suffers.


## git pull origin master
  * Always pull master in, and do your own private merging before creating a new branch.
  * This will ensure that you are starting with the most recent code-base. This may even be an opportunity for your team to merge and push their changes, if they have large changes that may affect your own code.

## git checkout -b BRANCHNAMEHERE
  * This creates a new branch with the branch name that you give it.
  * You will make all of your changes within this branch.
  * Whenever you checkout -b it creates a new branch that is an identical clone of your current branch that you are leaving.

## git branch
  * The terminal will display a list of local branches on your machine.

## git status
  * This shows any differences that you may have between commits

## git commit -m"YOUR MEANINGFUL MESSAGE GOES HERE"
  * After making your changes, commit them to your current branch. Maybe run a `git branch` to ensure that you are in the correct branch. Be sure to write meaningful messages that your group will be able to understand, when they are looking for specific changes. Consider flagging files where heavy changes were made in the commit message. You have a list of them right above your last command, because you did a git status.
  eg. git commit -m"4-14, Auth feature completed. (re-factoring of login.scss, added to mainCtrl.js, app.js, dirOne.js, etc.)"

## git push origin --set-upstream BRANCHNAMEHERE
  * connects your new branch to the repository and sets up that branch there, uploading the files as well.

## git checkout master
  * switches to master. If you have uncommitted changes it will prompt you to commit them before you do.

## git pull origin master
  * Your commits should not have any changes on master, because nobody should be working out of master. For this reason, it should pull in relatively cleanly. There may be some conflicts, but since you are not making changes on master, they should be minimal.

## git checkout BRANCHNAMEHERE
  * Checks back into your regular branch

## git merge master
  * We will now merge the code from master into your branch. This is where we will likely see conflicts.
  * If there are conflicts, you might see a console message like this.
    ```github
    Auto-merging index.html
    CONFLICT (content): Merge conflict in index.html
    Automatic merge failed; fix conflicts and then commit the result.
    ```
  * Don't panic! You have a options:
    * git Status is your friend. It will help you determine which files have large conflicts.
    * Search your project(Ctrl + Shift + F) for HEAD tags, there may be several, once you fix one, see if you can find the others. You'll likely see something like this:
        <div class="page-break"></div>
    *HEAD is the current branch in which you have initiated a merge.
    *The SHA tag is the name of the commit that caused the conflict with HEAD.*

```JavaScript

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< HEAD
function forloop(arr){
  >>>>for (var i = 0; i < array.length; i++) {  <<<<
    array[i]
  }
}
===============================================
<<<<<<<<<<<<<<<<<<<SHA 98231bu234y7fdn890qwuqgd987gb
function forLoop(arr){
  >>>>for (var j = 0; j < array.length; j++) {  <<<<
    array[j]
  }
}
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
```

  * It's ugly, one of them has to go, and somebody’s got to decide which.
  * Usually the one in your commit is the one that needs to stay, you likely made the changes, there's a chance that your teammate has made changes or added things for a reason as well. Perhaps you could check with them if you are tempted to delete things whose purpose you are unaware of.
  * Comment one of those sections out for now.
  * Test it out, see what this change does to your code.
  * Test the other portions of code that this might affect.
  * Delete what you commented out along with the sha, the HEAD and all the fun little >>>>>guys.

## git add
  * You could git add -A to add all, or add the individual files that you have altered.
## git commit -m"(mainSvc[38:1]), changed forLoop function's var i, to var j"
  * Give a nice, human readable message, that will help debug.
  * These comments will even be helpful when adding projects to your portfolio. -That feature, or color palette, that you didn't like, well it's your portfolio piece, host the version that you have altered after the cohort was over.
  * These commit messages might help you to find the point in time where you got upset when the group rejected your awesome idea, and you became unhappy with the direction of the project.

## git merge
  * This will either tell you that you've already merged, or will merge your commit, depending on if you fixed any conflicts or not.

## git push --set-upstream origin BRANCHNAMEHERE
  * If everything is peachy, push it on up, and create a pull request on github.

## Slack your mentor
  * Let them know that there is a pending merge.
  * leave a nice comment, documenting your work-flow.
  * By using github in this way, we are creating a history of changes that have been made to the repository, we can use this history to go back in time, find where errors were introduced, and eliminate them. This is often easier, than debugging an entire project line-by-line.

# Resources
  * https://www.atlassian.com/git/tutorials/what-is-version-control --Atlassian has some fantastic documentation. It's a great place to search for help.
  * https://www.atlassian.com/git/tutorials/using-branches
  --Delve further into the nitty-gritty. --This site is great for the visually adept.
  * https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging --The basics, again, and slightly differing in opinion. Don't merge into master locally, but rather, the other way around. Merge master into your development branch instead. This gives control to your git master, allowing them to finalize changes to master.
  * https://www.youtube.com/watch?v=to6tIdy5rNc --Varying git branch usage strategies. It's useful if you are a visual person, or happen enjoy boxes with arrows pointing to them.
  * https://git-scm.com/docs/git-diff --git diff documentation
  * https://git-scm.com/docs/git-stash --git stash documentation. Don't bother using the search tool on this site, just google git-scm stash or whatever. Their docs are great, but poorly indexed.

----------------------------------------

# Extra Credit
## git log
  * It lists out all the commits within your current branch, with their author and Date.
## git diff
  * Show the changes between two branches, between two commits, or the difference between your working tree and your repo.
  * Further documentation is here: https://git-scm.com/docs/git-diff
## git stash
  * Dude, you can put your code in that!
  * Perhaps you are in the middle of a major module, and your group wants you to commit your previous changes so they can have the most current version. You can stash it, push your code, and request a master merge via a pull request on your own branch, then get back to what you were doing with your crazy changes.
  * There are a variety of options available to you. Those options can be found here: https://git-scm.com/docs/git-stash

## git fetch REMOTE_NAME_HERE BRANCH_NAME_HERE
  * Branch name is optional
  * Fetch, will retrieve all of the branches from the remote repository, and pull them into your local repository
  * This will allow you to see what everyone else has pushed within their working branches.
  * Safely spy on your co-collaborators.
  * Fetched content has no effect on your local work.
  * git branch -r **shows you the fetched branches, the -r stands for remote**
  * git log REMOTE_NAME_HERE/BRANCH_NAME_HERE **shows commit history**
  * git checkout -r REMOTE_NAME_HERE BRANCH_NAME_HERE
  * You will not be forced to merge this into your repository, but it is still an option.
  * git merge REMOTE_NAME_HERE/BRANCH_NAME_HERE --From the branch that you'd like to apply these changes to. This will pull in those changes into your current branch.
  ----------------------------
# The Dange® Z0ne··«««««
Many of these commands below re-write history. If you've ever seen the movie, 'Back to the Future', you will understand why this is dangerous. You don't want children being removed from existence by the invalidation of their parents.

## git checkout SHA_NUMBER_GOES_HERE
  * This will revert all of your changes back to this moment in time. Sometimes this will be a permanent reversion, but the choice is yours to make.   Always git commit -m"MSG" before checking out a different commit hash.   Alternatively you can git stash, but this is more nuanced.

## git commit --amend
  * --amend will open an editor, likely vi, vim or some variant with the last commit message, and allow you to edit it.
  * vim can be tricky, don't panic, use your arrow keys,
      * Esc will get you out of 'insert mode".
      * Shift+zz will save changes and exit.
  * But wait! There's more!: Perhaps you forgot to change something and had already committed. Perhaps you didn't actually want to send your api key that you had forgotten to remove previously. There's no need to make a new one with proper usage of amend
      * git add **will allow you to add files to the previous commit.**
      * git rm FILENAME **removes files from your commit.**
      * git commit --amend **save those changes**

## git revert SHA_NUMBER_GOES_HERE
  * This will revert to an old commit, while creating a new one that is a clone of said commit.
  * It does not change the project history, so it is much safer to use than reset or rebase.

## git rebase
  * Woah there, cowboy! This one's a tough cookie. I recommend really studying this one before you use it, especially within a group setting. It's likely that all you need is a git revert, which is safer in that you are not re-writing history, just skipping over a commit, into a new one containing the previous changes.
  * Never rebase things that you have already merged into master, or that you have already shared with co-collaborators.
  * Have a mentor walk you through rebasing, not so your group can have someone to blame besides yourself, but rather they'll be able to walk you through it.
  * It has the ability to re-apply commits chronologically from your current branch into another.
  * There are a ton of options that you can feed it. Read up elsewhere, or watch https://youtu.be/qh9KtjfjzCU?t=141  **Presfx**
  * This is useful to squash several small commits into one with a unified message.
  * It can be used to subvert entire commits that happened to break everything.
  * You are literally re-writing history, a very powerful tool, but in the wrong hands...
## git mergetool
  * You just might be fancy enough to have your own GUI mergetool installed on your machine(mac) and didn't even know it.
  * smoke em' if you've got em'

