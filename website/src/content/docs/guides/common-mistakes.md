---
title: Common Mistakes
description: Pitfalls when transitioning from Git or Graphite to JJ
---

Transitioning to JJ from Git or Graphite means unlearning old habits. Here are the most common mistakes and how to avoid them.

## Mistake 1: Using Git Commands on JJ-Managed Code

Running `git rebase`, `git merge`, or `git pull` in a JJ-managed repo. Git doesn't understand JJ's change IDs or [operation log](/guides/operation-log/), so these operations can't be undone with `jj undo`.

### The Right Way

```bash
jj rebase -s @ -d main          # Instead of git rebase main
jj new @- main                  # Instead of git merge
jj git fetch && jj stack-sync   # Instead of git pull
```

**If you already did it**: Run `jj git import` to sync state, or `jj undo` / `jj op restore` to roll back.

---

## Mistake 2: Expecting Bookmarks to Auto-Follow

In Git, the current branch moves forward when you commit. JJ bookmarks **don't auto-follow**—they stay where you set them.

```bash
jj create my-feature
jj new -m "More work"
jj log
# 😱 my-feature is still at the old commit!
```

### The Right Way

```bash
# Move an existing bookmark
jj bookmark set my-feature -r @

# Or use LazyJJ's tug alias
jj tug  # Moves the current bookmark to parent
```

Bookmarks are optional in JJ—you can work entirely with change IDs. You only need bookmarks when pushing to GitHub.

---

## Mistake 3: Avoiding Empty Commits (Graphite Habit)

Graphite requires "one commit per branch" discipline. In JJ, it's fine to create a commit first, then add changes:

```bash
# ✅ JJ workflow - create commit, then edit
jj new -m "Add feature"
vim file.txt  # Changes go into "Add feature" commit
```

Use `jj stack-gc` to clean up empty commits if needed.

---

## Mistake 4: Looking for `git add`

JJ has no staging area. Your working directory **is** the commit. See the [Mental Model guide](/guides/mental-model/) for why this is better.

### The Right Way

```bash
vim src/auth.js
vim src/login.js
jj diff                         # Shows changes in current commit
jj describe -m "Add authentication"
jj new                          # Start next commit
```

**Need to split changes?** Use `jj split` — an interactive UI lets you choose what stays in the current commit.

---

## Mistake 5: Forgetting `jj new` After Describing a Commit

`jj describe` just sets the message—you're still working inside that commit. Every file edit continues to amend it. This is a common Git habit that doesn't transfer.

### The Right Way

```bash
jj new -m "Add database schema"
vim schema.sql
# Commit is ready, start next one:
jj new -m "Add models"
vim models.js
# Now models.js is in its own commit
```

Think: **`jj new` = finalize current commit and start next**.

**If you already mixed changes**: Use `jj split` to separate them.

---

## Mistake 6: Not Trusting the Operation Log

Being afraid to experiment because "what if I break something?" JJ's [operation log](/guides/operation-log/) makes almost everything reversible.

### The Right Way

**Experiment fearlessly**:

```bash
jj rebase -s my-stack -d new-base   # Try a complex rebase
jj undo                             # Didn't work? No problem

jj squash -r xyz --into abc         # Try squashing
jj undo                             # Not what you wanted? Reversed

jj resolve                          # Try conflict resolution
jj undo                             # Wrong choices? Try again
```

The operation log records everything. `jj op log` shows your history, `jj op restore` jumps to any point.

---

## Quick Reference

| ❌ Don't | ✅ Do Instead |
|----------|---------------|
| `git rebase` / `git merge` | `jj rebase` / `jj new @- other-commit` |
| Assume bookmarks auto-move | Manually `jj bookmark set` when needed |
| Fear empty commits | Create freely, clean with `jj stack-gc` |
| Look for `jj add` | Just edit files (automatic) |
| Use `jj describe` to seal commit | Use `jj new` to start next commit |
| Fear breaking things | Experiment! `jj undo` fixes mistakes |

## Next Steps

- Understand the [Mental Model](/guides/mental-model/) to prevent these mistakes
- Learn about the [Operation Log](/guides/operation-log/) to trust experimentation
- Review the [Git → JJ Quick Reference](/guides/git-differences/) for command mappings
- See [LazyJJ vs Graphite](/guides/from-graphite/) if transitioning from Graphite
