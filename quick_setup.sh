#!/bin/bash
#
# Quick setup script for creating PR and applying branch protection
# Requires: gh CLI installed and authenticated
#
# Usage: ./quick_setup.sh
#

set -e

OWNER="tonythefreelancer"
REPO="djhaitianmike"
BASE_BRANCH="main"
HEAD_BRANCH="add-readme-license"
PR_TITLE="Add README and MIT license"
PR_BODY="Adds a starter README.md and MIT LICENSE file for the DJ Haitian Mike Booking System."

echo "=================================================="
echo "PR Creation and Branch Protection Setup"
echo "Repository: ${OWNER}/${REPO}"
echo "=================================================="
echo

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "ERROR: gh CLI is not installed."
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if gh is authenticated
if ! gh auth status &> /dev/null; then
    echo "ERROR: gh CLI is not authenticated."
    echo "Please run: gh auth login"
    exit 1
fi

echo "✓ gh CLI is installed and authenticated"
echo

# Step 1: Create Pull Request
echo "Step 1: Creating Pull Request..."
echo "  From: ${HEAD_BRANCH}"
echo "  To: ${BASE_BRANCH}"
echo

PR_URL=$(gh pr create \
    --repo "${OWNER}/${REPO}" \
    --base "${BASE_BRANCH}" \
    --head "${HEAD_BRANCH}" \
    --title "${PR_TITLE}" \
    --body "${PR_BODY}" \
    2>&1)

if [ $? -eq 0 ]; then
    echo "✓ Pull Request created successfully!"
    echo "  ${PR_URL}"
else
    if echo "${PR_URL}" | grep -q "already exists"; then
        echo "Note: Pull request already exists"
        # Try to find the existing PR
        EXISTING_PR=$(gh pr list --repo "${OWNER}/${REPO}" --base "${BASE_BRANCH}" --head "${HEAD_BRANCH}" --json url --jq '.[0].url' 2>/dev/null)
        if [ -n "${EXISTING_PR}" ]; then
            PR_URL="${EXISTING_PR}"
            echo "  ${PR_URL}"
        fi
    else
        echo "ERROR: Failed to create pull request"
        echo "${PR_URL}"
        exit 1
    fi
fi

echo

# Step 2: Apply Branch Protection
echo "Step 2: Applying branch protection to '${BASE_BRANCH}'..."
echo

# Check if GITHUB_TOKEN or GH_TOKEN is set
TOKEN="${GITHUB_TOKEN:-${GH_TOKEN}}"
if [ -z "${TOKEN}" ]; then
    # Try to get token from gh CLI
    TOKEN=$(gh auth token 2>/dev/null)
fi

if [ -z "${TOKEN}" ]; then
    echo "ERROR: No GitHub token found."
    echo "Please set GITHUB_TOKEN or GH_TOKEN environment variable."
    exit 1
fi

# Apply branch protection using GitHub API
RESPONSE=$(curl -s -w "\n%{http_code}" -X PUT \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/${OWNER}/${REPO}/branches/${BASE_BRANCH}/protection" \
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
    }')

HTTP_CODE=$(echo "${RESPONSE}" | tail -n1)
BODY=$(echo "${RESPONSE}" | sed '$d')

if [ "${HTTP_CODE}" = "200" ]; then
    echo "✓ Branch protection applied successfully!"
    echo
    echo "Protection settings:"
    echo "  - Require pull request reviews: 1 required reviewer"
    echo "  - Dismiss stale pull request approvals: enabled"
    echo "  - Enforce for administrators: disabled"
    echo "  - Require status checks: none (not configured)"
else
    echo "ERROR: Failed to apply branch protection (HTTP ${HTTP_CODE})"
    echo "${BODY}" | head -n 5
    exit 1
fi

echo
echo "=================================================="
echo "Setup Complete!"
echo "=================================================="
echo
echo "Pull Request: ${PR_URL}"
echo "Branch Protection: Applied to '${BASE_BRANCH}'"
echo
echo "The PR has been left open for review (not auto-merged)."
echo

exit 0
