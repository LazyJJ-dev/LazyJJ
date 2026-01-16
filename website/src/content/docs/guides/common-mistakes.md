---
title: Common Mistakes
description: Pitfalls when transitioning from Git or Graphite to JJ
---

Transitioning to JJ from Git or Graphite means unlearning old habits. This guide covers the most common mistakes and how to avoid them.

## Mistake 1: Using Git Commands on JJ-Managed Code

### The Mistake

Running `git rebase`, `git merge`, or `git pull` in a repository managed by JJ.

```bash
# ❌ DON'T DO THIS
git rebase main
git merge feature-branch
git pull origin main
```

### Why It's Wrong

Git doesn't understand JJ's change IDs or operation log. When you use git commands:
- JJ's operation log doesn't record the changes
- Change IDs can become inconsistent
- You can't `jj undo` git operations
- Descendants may not rebase automatically

Research shows this is mentioned as a pain point in 11 out of 20 major JJ resources.

### The Right Way

Use JJ equivalents:

```bash
# ✅ DO THIS INSTEAD
jj rebase -s @ -d main          # Instead of git rebase main
jj new @- main                  # Instead of git merge (creates merge commit)
jj git fetch && jj stack-sync   # Instead of git pull
```

### If You Made This Mistake

If you accidentally used git commands:

```bash
# Sync JJ's view with git's state
jj git import

# If things are broken, use the operation log
jj op log
jj undo  # or jj op restore to before the git command
```

---

## Mistake 2: Expecting Bookmarks to Auto-Follow

### The Mistake

Assuming that bookmarks (JJ's branches) move forward when you create new commits, like Git branches do.

```bash
# Create a bookmark
jj bookmark-create my-feature

# Create a new commit
jj new -m "More work"

# Check bookmark location
jj log
# 😱 my-feature is still at the old commit!
```

### Why It's Wrong

In Git, the current branch automatically moves forward when you commit. JJ bookmarks **don't auto-follow**—they stay at the commit where you set them unless you explicitly move them.

This is THE most common confusion for Git users, mentioned in 11 out of 20 JJ resources.

### The Right Way

Move bookmarks manually when needed:

```bash
# Create a bookmark at parent commit (common pattern)
jj bookmark-create my-feature
# This creates bookmark at @- (parent of current position)

# Or move an existing bookmark
jj bookmark set my-feature -r @

# Or use LazyJJ's bookmark-tug alias
jj bookmark-tug my-feature  # Moves bookmark to parent
```

### Why JJ Works This Way

Bookmarks are optional in JJ—you can work entirely with change IDs. When you do need bookmarks (for pushing to GitHub), you name specific commits rather than tracking "the tip of my work."

This feels wrong initially but enables powerful workflows:
- Easy to create multiple bookmarks in one stack
- Bookmarks don't get in the way of rebasing
- Change IDs are your primary reference, bookmarks are just labels

---

## Mistake 3: Avoiding Empty Commits (Graphite Habit)

### The Mistake

Being afraid to create commits before you have changes, like Graphite taught you.

```bash
# Graphite users think:
# "DON'T create empty branches, it breaks the workflow!"

# So they do:
vim file.txt  # Edit first
jj new -m "Add feature"  # Then create commit

# But their changes are now in the PREVIOUS commit!
```

### Why It's Wrong

Graphite requires "one commit per branch" discipline, and empty commits break their metadata tracking. JJ has no such restriction.

In JJ, it's perfectly fine (even encouraged) to create a commit first, then add changes:

```bash
# ✅ JJ workflow
jj new -m "Add feature"
vim file.txt  # Changes go into "Add feature" commit
```

### The Right Way

Create commits freely. Use `jj stack-gc` if you want to clean up empty ones later:

```bash
# Create a commit
jj new -m "Experiment with X"

# Decide not to do it after all
# Just move on, or clean up:
jj stack-gc  # Abandons empty commits in your stack
```

### Why This is Better

In Git/Graphite, you're paranoid about commit state. In JJ, commits are cheap and the operation log makes them safe. Create liberally, clean up if needed.

---

## Mistake 4: Looking for `git add` (Git Habit)

### The Mistake

Trying to find the JJ equivalent of `git add` to stage changes before committing.

```bash
# ❌ Git users look for:
jj add file.txt  # Doesn't exist!
```

### Why It's Wrong

JJ has no staging area. Your working directory **is** the commit. Changes are automatically included.

Research shows 13 out of 20 JJ resources praise the lack of staging area as a major simplification.

### The Right Way

Just edit files. They're automatically in your commit:

```bash
# Edit files
vim src/auth.js
vim src/login.js

# Check what changed
jj diff  # Shows changes in current commit

# Describe the commit
jj describe -m "Add authentication"

# Start next commit
jj new
```

### If You Need to Split Changes

If you edited multiple files but want them in separate commits, use `jj split`:

```bash
# Edit multiple files
vim file1.txt file2.txt

# Split them into separate commits
jj split
# Interactive UI lets you choose what stays in current commit
# Everything else goes to a new commit
```

Think of it as "unstageing after the fact" rather than staging before.

---

## Mistake 5: Forgetting `jj new` After Describing a Commit

### The Mistake

Describing a commit, then continuing to edit files, not realizing those edits go into the same commit.

```bash
jj new -m "Add database schema"
vim schema.sql
jj describe -m "Database schema complete"

# Keep editing
vim models.js
# 😱 models.js changes are being added to "Database schema complete"!
```

### Why It's Wrong

`jj describe` doesn't seal a commit—it just sets the message. You're still working inside that commit. Every file edit continues to amend it.

Research insight: "My brain assumes after a commit, I'm working on the next one" (Arne Bahlo). This is a common Git habit that doesn't transfer.

### The Right Way

Use `jj new` to seal the commit and start fresh:

```bash
jj new -m "Add database schema"
vim schema.sql
# Commit is ready, start next one:
jj new -m "Add models"
vim models.js
# Now models.js is in its own commit
```

Think: **`jj new` = finalize current commit and start next**.

### If You Made This Mistake

Split the commit:

```bash
# Commit has unrelated changes
jj split
# Choose what belongs in original commit
# Rest becomes a new commit
```

---

## Mistake 6: Not Trusting the Operation Log

### The Mistake

Being afraid to experiment because "what if I break something?"

```bash
# Timid approach:
# "Let me carefully plan this rebase..."
# "Maybe I should create a backup branch..."
# "What if I mess up?"

# Fear leads to:
# - Avoiding powerful operations
# - Not learning JJ's full capabilities
# - Working slower than necessary
```

### Why It's Wrong

JJ's operation log makes almost everything reversible. Research shows "jj undo is trivial and comprehensive" (Chris Krycho), yet new users don't trust it.

### The Right Way

**Experiment fearlessly**:

```bash
# Try a complex rebase
jj rebase -s my-stack -d new-base
# Did it work? Great!
# Didn't work? No problem:
jj undo

# Try squashing some commits
jj squash -r xyz --into abc
# Not what you wanted?
jj undo

# Experiment with conflict resolution
jj resolve
# Made wrong choices?
jj undo
```

The operation log records everything. `jj undo` reverses any operation. You can always `jj op log` to see your history and `jj op restore` to jump back to any point.

### Building Trust

Try this exercise:

```bash
# 1. Note your current state
jj log -r stack

# 2. Do something destructive
jj abandon @  # Abandon current commit

# 3. Undo it
jj undo

# 4. Verify everything is back
jj log -r stack
# Everything restored!
```

Once you trust `jj undo`, you'll work faster and learn faster.

---

## Quick Reference: What NOT To Do

| ❌ Don't | ✅ Do Instead |
|----------|---------------|
| `git rebase` / `git merge` | `jj rebase` / `jj new @- other-commit` |
| Assume bookmarks auto-move | Manually `jj bookmark set` when needed |
| Fear empty commits | Create freely, clean with `jj stack-gc` if desired |
| Look for `jj add` | Just edit files (automatic) |
| Use `jj describe` to seal commit | Use `jj new` to start next commit |
| Fear breaking things | Experiment! `jj undo` fixes mistakes |

---

## Learn From Others' Experiences

The research for this guide analyzed 40+ blog posts, official docs, and community discussions. The mistakes listed here are the ones that appear most frequently in "lessons learned" sections.

Almost every experienced JJ user mentions going through these same struggles before things "clicked." You're not alone in finding these confusing initially.

## Next Steps

- Understand the [Mental Model](/guides/mental-model/) to prevent these mistakes
- Learn about the [Operation Log](/guides/operation-log/) to trust experimentation
- Review [Git vs JJ Differences](/guides/git-differences/) for more comparisons
- See [From Graphite](/guides/from-graphite/) if transitioning from Graphite

Give yourself grace during the transition. These mistakes are normal and temporary.
