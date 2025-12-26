# Create PR and Apply Branch Protection

This document provides instructions and scripts for creating a pull request from `add-readme-license` to `main` and applying branch protection rules to the `main` branch.

## Overview

**Repository:** tonythefreelancer/djhaitianmike  
**Source Branch:** add-readme-license  
**Target Branch:** main  
**PR Title:** "Add README and MIT license"  
**PR Body:** "Adds a starter README.md and MIT LICENSE file for the DJ Haitian Mike Booking System."

## Requirements

- GitHub account with admin/write access to the repository
- GitHub Personal Access Token (PAT) with `repo` scope
- GitHub CLI (`gh`) or Python with `requests` library

## Option 1: Using GitHub CLI (Recommended)

### Step 1: Authenticate with GitHub CLI

```bash
gh auth login
```

Or set the token directly:

```bash
export GH_TOKEN="your_github_token_here"
```

### Step 2: Create the Pull Request

```bash
cd /home/runner/work/djhaitianmike/djhaitianmike
gh pr create \
  --repo tonythefreelancer/djhaitianmike \
  --base main \
  --head add-readme-license \
  --title "Add README and MIT license" \
  --body "Adds a starter README.md and MIT LICENSE file for the DJ Haitian Mike Booking System."
```

### Step 3: Apply Branch Protection Rules

Unfortunately, `gh` CLI doesn't have a direct command for branch protection. You'll need to use the API or web interface.

#### Using curl with GitHub API:

```bash
curl -X PUT \
  -H "Authorization: Bearer ${GH_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/tonythefreelancer/djhaitianmike/branches/main/protection \
  -d '{
    "required_status_checks": null,
    "enforce_admins": false,
    "required_pull_request_reviews": {
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": false,
      "required_approving_review_count": 1,
      "require_last_push_approval": false
    },
    "restrictions": null,
    "required_linear_history": false,
    "allow_force_pushes": false,
    "allow_deletions": false,
    "block_creations": false,
    "required_conversation_resolution": false,
    "lock_branch": false,
    "allow_fork_syncing": false
  }'
```

## Option 2: Using Python Script

A Python script has been provided at `/tmp/create_pr_and_protect.py`. To use it:

### Step 1: Set the GitHub Token

```bash
export GITHUB_TOKEN="your_github_token_here"
```

### Step 2: Run the Script

```bash
python3 /tmp/create_pr_and_protect.py
```

## Option 3: Using GitHub Web Interface

### Create Pull Request

1. Go to https://github.com/tonythefreelancer/djhaitianmike
2. Click on "Pull requests" tab
3. Click "New pull request"
4. Set base branch to `main` and compare branch to `add-readme-license`
5. Click "Create pull request"
6. Enter title: "Add README and MIT license"
7. Enter description: "Adds a starter README.md and MIT LICENSE file for the DJ Haitian Mike Booking System."
8. Click "Create pull request"

### Apply Branch Protection

1. Go to https://github.com/tonythefreelancer/djhaitianmike/settings/branches
2. Under "Branch protection rules", click "Add rule"
3. Enter branch name pattern: `main`
4. Configure the following settings:
   - ☑ Require a pull request before merging
     - Required approvals: 1
     - ☑ Dismiss stale pull request approvals when new commits are pushed
   - ☐ Require status checks to pass before merging (leave unchecked - no status checks configured)
   - ☐ Do not allow bypassing the above settings (leave unchecked - allows admins to bypass)
   - ☐ Restrict who can push to matching branches (leave unchecked)
5. Click "Create" or "Save changes"

## Branch Protection Settings Summary

The following branch protection rules should be applied to the `main` branch:

- **Require pull request reviews before merging:** Enabled
  - Required approving review count: 1
  - Dismiss stale pull request approvals when new commits are pushed: Enabled
  - Require code owner reviews: Disabled
  
- **Require status checks to pass before merging:** Disabled (no status checks configured)
  
- **Require branches to be up-to-date before merging:** N/A (requires status checks to be enabled first)
  
- **Require conversation resolution before merging:** Disabled
  
- **Enforce admins:** Disabled (admins can bypass these rules)
  
- **Restrict who can push:** Disabled (no restrictions)
  
- **Allow force pushes:** Disabled
  
- **Allow deletions:** Disabled

## Verification

After completing the steps:

1. Verify the PR exists: https://github.com/tonythefreelancer/djhaitianmike/pulls
2. Verify branch protection: https://github.com/tonythefreelancer/djhaitianmike/settings/branches

## Files in the PR

The `add-readme-license` branch (commit `ba7e44b0ba674c73ed3da360da8bce5de1f281f3`) contains:

1. **README.md** - Starter documentation for the DJ Haitian Mike Booking System
2. **LICENSE** - MIT License file

## Notes

- The PR should be left open for review (do not auto-merge)
- The branch protection rules ensure code quality by requiring reviews
- Admins retain the ability to bypass these rules if necessary
- "Require branches to be up-to-date" setting requires status checks to be configured first, which is not applicable in this case as no CI/CD status checks are currently configured

## Note on "Require branches to be up-to-date"

The problem statement mentions "Require branches to be up-to-date before merging: enabled". However, this setting is only available when status checks are configured. Since the requirement also states "Do not require any status checks (none configured)", this specific setting cannot be enabled through the API.

In the GitHub UI, this option appears as "Require branches to be up to date before merging" under the "Require status checks to pass before merging" section, and it's only available when at least one status check is selected.

If you want to enable this feature, you would need to:
1. Set up at least one CI/CD status check (e.g., GitHub Actions workflow)
2. Add that status check to the required checks list
3. Then enable "Require branches to be up to date before merging"
