#!/bin/bash
# Complete setup script to configure Git and GitHub CLI for iamvikshan
#
# This script sets up:
# 1. Git global config (user.name and user.email)
# 2. GitHub CLI authentication as iamvikshan
# 3. SSH signing keys for commit verification
# 4. Updates ~/.bashrc to clear GITHUB_TOKEN and add verification function
# 5. Ensures all commits and pushes are attributed to iamvikshan
#
# Run this once to set up your development environment permanently.
# Safe to run multiple times (idempotent).
#
# Usage:
#   ./iamvikshan.sh [--repo <repository-url>]
#
# Options:
#   --repo <url>   Override the target repository URL (default: https://github.com/iamvikshan/linktree.git)
#
# Environment variables:
#   TARGET_REPO    Set this to override the default target repository URL
#
# Examples:
#   ./iamvikshan.sh
#   ./iamvikshan.sh --repo https://github.com/myorg/myrepo.git
#   TARGET_REPO=https://github.com/myorg/myrepo.git ./iamvikshan.sh

set -euo pipefail

# Detect non-interactive/non-TTY environment
# In non-interactive mode, skip interactive prompts and use defaults
IS_INTERACTIVE=true
if [[ ! -t 0 ]] || [[ ! -t 1 ]]; then
    IS_INTERACTIVE=false
    echo "⚠️  Running in non-interactive mode (no TTY detected)"
    echo "   Authentication steps requiring user input will be skipped."
    echo "   Set environment variables or run interactively for full setup."
    echo ""
fi

# Read timeout in seconds for interactive prompts
READ_TIMEOUT=60

GIT_USER="iamvikshan"
GIT_EMAIL="103361575+iamvikshan@users.noreply.github.com"
BASHRC_FILE="$HOME/.bashrc"
MARKER_START="# iamvikshan development setup"
MARKER_END="# End iamvikshan development setup"

# Default target repository (can be overridden by TARGET_REPO env var or --repo argument)
DEFAULT_TARGET_REPO="https://github.com/iamvikshan/linktree.git"
TARGET_REPO="${TARGET_REPO:-$DEFAULT_TARGET_REPO}"

# Initialize optional variables with defaults to satisfy 'set -u'
: "${GITHUB_TOKEN:=}"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --repo)
            if [ $# -lt 2 ] || [ -z "${2-}" ] || [[ "${2-}" == -* ]]; then
                echo "Error: --repo requires a repository URL argument."
                echo "Run '$0 --help' for usage information."
                exit 1
            fi
            TARGET_REPO="${2-}"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [--repo <repository-url>]"
            echo ""
            echo "Options:"
            echo "  --repo <url>   Override the target repository URL"
            echo "                 (default: $DEFAULT_TARGET_REPO)"
            echo ""
            echo "Environment variables:"
            echo "  TARGET_REPO    Set this to override the default target repository URL"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Run '$0 --help' for usage information."
            exit 1
            ;;
    esac
done

# Define the canonical check_dev_setup function body using a here-doc
# This ensures both code paths (insert after setup.sh and fallback append) use identical content
read -r -d '' FUNCTION_DEF << 'FUNCTION_EOF' || true
# Clear GITHUB_TOKEN to use stored gh CLI credentials (GIT_USER_PLACEHOLDER) instead of existing GITHUB_TOKEN
# This ensures all Git operations and GitHub CLI commands use GIT_USER_PLACEHOLDER credentials
# Must be after setup.sh is sourced, as Codespace may set GITHUB_TOKEN
# Setting to empty string works better than unset for some environments
export GITHUB_TOKEN=""

# GIT_USER_PLACEHOLDER development setup verification
check_dev_setup() {
    local git_user=$(git config --global user.name 2>/dev/null)
    local git_email=$(git config --global user.email 2>/dev/null)
    local gh_user=""
    
    if command -v gh &> /dev/null; then
        gh_user=$(gh api user --jq .login 2>/dev/null || echo "")
    fi
    
    if [ "$git_user" != "GIT_USER_PLACEHOLDER" ] || [ "$git_email" != "GIT_EMAIL_PLACEHOLDER" ]; then
        echo "⚠️  Git is not configured for GIT_USER_PLACEHOLDER"
        echo "   Run: git config --global user.name 'GIT_USER_PLACEHOLDER'"
        echo "   Run: git config --global user.email 'GIT_EMAIL_PLACEHOLDER'"
        return 1
    fi
    
    if [ -z "$gh_user" ] || [ "$gh_user" != "GIT_USER_PLACEHOLDER" ]; then
        if [ -n "$GITHUB_TOKEN" ]; then
            echo "⚠️  GitHub CLI is using existing GITHUB_TOKEN, not GIT_USER_PLACEHOLDER"
            echo "   Run: ./iamvikshan.sh to authenticate as GIT_USER_PLACEHOLDER"
        else
            echo "⚠️  GitHub CLI is not authenticated as GIT_USER_PLACEHOLDER"
            echo "   Run: ./iamvikshan.sh to authenticate"
        fi
        return 1
    fi
    
    echo "✓ Development setup verified: working as GIT_USER_PLACEHOLDER"
    return 0
}

# Uncomment the line below to auto-check on shell startup
# check_dev_setup
FUNCTION_EOF

# Replace placeholders with actual values
FUNCTION_DEF="${FUNCTION_DEF//GIT_USER_PLACEHOLDER/$GIT_USER}"
FUNCTION_DEF="${FUNCTION_DEF//GIT_EMAIL_PLACEHOLDER/$GIT_EMAIL}"

# Check for required dependencies
if ! command -v ssh-keygen &> /dev/null; then
    echo "Checking dependencies..."
    echo "⚠️  ssh-keygen command not found."
    if command -v apt-get &> /dev/null; then
        echo "   Installing openssh-client..."
        if [ "$EUID" -ne 0 ] && command -v sudo &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y openssh-client
        else
            apt-get update && apt-get install -y openssh-client
        fi
        echo "✓ openssh-client installed"
    else
        echo "❌ Error: ssh-keygen is required but cannot be installed automatically."
        echo "   Please install openssh-client manually."
        exit 1
    fi
    echo ""
fi

echo "=========================================="
echo "Complete Setup for iamvikshan"
echo "=========================================="
echo ""

# Step 1: Configure Git
echo "Step 1: Configuring Git..."
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"
echo "✓ Git user configured as $GIT_USER"
echo "  Name: $(git config --global user.name)"
echo "  Email: $(git config --global user.email)"
echo ""

# Step 2: Check GitHub CLI authentication
echo "Step 2: Checking GitHub CLI authentication..."
# Temporarily clear GITHUB_TOKEN to check actual authenticated user
OLD_TOKEN="$GITHUB_TOKEN"
export GITHUB_TOKEN=""
CURRENT_USER=$(gh api user --jq .login 2>/dev/null || echo "")
export GITHUB_TOKEN="$OLD_TOKEN"

if [ "$CURRENT_USER" = "$GIT_USER" ]; then
    echo "✓ GitHub CLI already authenticated as $GIT_USER"
    NEEDS_AUTH=false
else
    echo "⚠️  GitHub CLI needs to be authenticated as $GIT_USER"
    echo "   Current: ${CURRENT_USER:-Not authenticated}"
    NEEDS_AUTH=true
fi
echo ""

# Step 3: Authenticate GitHub CLI if needed
if [ "$NEEDS_AUTH" = true ]; then
    echo "Step 3: Authenticating GitHub CLI..."
    echo "The Codespace's existing GITHUB_TOKEN will be temporarily disabled"
    echo ""
    
    # Handle non-interactive mode: skip authentication
    if [ "$IS_INTERACTIVE" != "true" ]; then
        echo "⚠️  Skipping GitHub CLI authentication (non-interactive mode)"
        echo "   To authenticate, either:"
        echo "   - Run this script in an interactive terminal"
        echo "   - Pre-authenticate with 'gh auth login' before running"
        echo ""
        choice="s"
    else
        echo "You have two options:"
        echo ""
        echo "Option 1: Interactive web login (recommended)"
        echo "  This will open a browser window for you to authenticate"
        echo ""
        echo "Option 2: Use a Personal Access Token"
        echo "  If you have a PAT for $GIT_USER, you can paste it here"
        echo ""
        
        # Use timed read to prevent hanging; default to skip on timeout
        choice=""
        if ! read -t "$READ_TIMEOUT" -p "Choose option (1 or 2, or 's' to skip) [timeout=${READ_TIMEOUT}s -> skip]: " choice; then
            echo ""
            echo "⚠️  Input timed out after ${READ_TIMEOUT}s. Skipping authentication."
            choice="s"
        fi
        # Handle empty input (user just pressed Enter)
        choice="${choice:-s}"
    fi

    case $choice in
        1)
            echo "Starting web-based authentication..."
            echo "  Requesting scopes: repo, workflow, write:packages, read:packages, admin:ssh_signing_key"
            unset GITHUB_TOKEN
            gh auth login --hostname github.com --web --git-protocol https --scopes "repo,workflow,write:packages,read:packages,admin:ssh_signing_key"
            echo "✓ Authentication complete"
            ;;
        2)
            echo "Please provide your Personal Access Token for $GIT_USER"
            echo "You can create one at: https://github.com/settings/tokens"
            echo "Required scopes: repo, workflow, write:packages, read:packages, admin:ssh_signing_key"
            
            # Use timed read for token input; skip on timeout
            token=""
            if ! read -t "$READ_TIMEOUT" -sp "Enter token [timeout=${READ_TIMEOUT}s -> skip]: " token; then
                echo ""
                echo "⚠️  Token input timed out. Skipping authentication."
            elif [ -n "$token" ]; then
                echo ""
                unset GITHUB_TOKEN
                # Authenticate with the token
                echo "$token" | gh auth login --with-token
                echo "✓ Authentication complete"
            else
                echo ""
                echo "⚠️  Empty token provided. Skipping authentication."
            fi
            
            # SECURITY: Clear the token from memory immediately after use
            # Overwrite with fixed-length string before unsetting to reduce exposure
            token="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            unset token
            ;;
        s|S)
            echo "⚠️  Skipping GitHub CLI authentication"
            echo "   You may need to authenticate manually later"
            ;;
        *)
            echo "⚠️  Invalid choice. Skipping authentication."
            ;;
    esac
    echo ""
else
    echo "Step 3: GitHub CLI authentication - skipped (already configured)"
    echo ""
fi

# Step 3.5: Setup SSH Signing Keys (mandatory for commit verification)
echo "Step 3.5: Setting up SSH signing keys for commit verification..."
export GITHUB_TOKEN=""

# Check if admin:ssh_signing_key scope is available
HAS_SIGNING_SCOPE=true
SCOPE_CHECK_OUTPUT=$(gh api /user/ssh_signing_keys 2>&1)
SCOPE_CHECK_EXIT=$?
if [ $SCOPE_CHECK_EXIT -ne 0 ]; then
    # Check if it's a scope/authorization issue vs other errors
    if echo "$SCOPE_CHECK_OUTPUT" | grep -qiE "scope|admin:ssh_signing_key|requires the|403|insufficient"; then
        HAS_SIGNING_SCOPE=false
    elif echo "$SCOPE_CHECK_OUTPUT" | grep -qiE "rate limit|network|timeout|connection"; then
        echo "⚠️  Warning: Could not verify SSH signing scope due to network/API issue"
        echo "   Error: $SCOPE_CHECK_OUTPUT"
        echo "   Assuming scope is available; if commit signing fails, run: gh auth refresh -h github.com -s admin:ssh_signing_key"
    elif echo "$SCOPE_CHECK_OUTPUT" | grep -qiE "not logged in|authentication|unauthorized|401"; then
        echo "❌ Error: GitHub CLI is not authenticated"
        echo "   Error: $SCOPE_CHECK_OUTPUT"
        echo "   Please run 'gh auth login' first"
        exit 1
    else
        # Unknown error - assume scope issue to be safe
        HAS_SIGNING_SCOPE=false
    fi
fi

if [ "$HAS_SIGNING_SCOPE" != "true" ]; then
    echo "⚠️  Need 'admin:ssh_signing_key' scope for commit signing"
    
    if [ "$IS_INTERACTIVE" != "true" ]; then
        echo "   Skipping scope refresh (non-interactive mode)"
        echo "   Run interactively or pre-authorize with: gh auth refresh -h github.com -s admin:ssh_signing_key"
    else
        echo "   This will open a browser for authorization..."
        confirm=""
        if ! read -t "$READ_TIMEOUT" -p "Press Enter to continue (or wait ${READ_TIMEOUT}s to skip): " confirm; then
            echo ""
            echo "   Timed out. Skipping scope refresh."
        else
            gh auth refresh -h github.com -s admin:ssh_signing_key
            echo "✓ Scope granted"
        fi
    fi
fi

# Use consistent key name for reuse across environments
SIGNING_KEY_PATH="$HOME/.ssh/id_ed25519_signing"
SIGNING_KEY_PUB="$SIGNING_KEY_PATH.pub"

# Check if key already exists locally
if [ -f "$SIGNING_KEY_PATH" ] && [ -f "$SIGNING_KEY_PUB" ]; then
    echo "✓ Found existing SSH signing key: $SIGNING_KEY_PATH"
    KEY_EXISTS=true
else
    echo "Generating new SSH signing key..."
    mkdir -p "$HOME/.ssh"
    
    # SECURITY NOTE: Empty passphrase (-N "") is used intentionally here.
    # Reason: This key is for automated commit signing in CI/dev environments
    #         where interactive passphrase entry is not practical.
    # Implications:
    #   - The private key is protected only by filesystem permissions
    #   - Anyone with read access to ~/.ssh/id_ed25519_signing can use it
    # For production/high-security environments:
    #   - Consider using a passphrase and ssh-agent for key caching
    #   - Or use hardware security keys (e.g., YubiKey)
    #   - Set SSH_SIGNING_PASSPHRASE env var and modify this script to use it
    echo "  Note: Generating key with empty passphrase for automated signing."
    echo "        For production use, consider adding a passphrase manually."
    
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SIGNING_KEY_PATH" -N "" -q
    echo "✓ SSH signing key generated: $SIGNING_KEY_PATH"
    KEY_EXISTS=false
fi

# Check if this key is already on GitHub and add if needed
echo "Ensuring SSH signing key is added to GitHub..."
KEY_FINGERPRINT=$(ssh-keygen -lf "$SIGNING_KEY_PUB" 2>/dev/null | awk '{print $2}' || echo "")

# Try to add the key (will fail gracefully if already exists)
ADD_OUTPUT=$(gh ssh-key add "$SIGNING_KEY_PUB" --type signing --title "iamvikshan signing key" 2>&1)
ADD_EXIT_CODE=$?

if [ $ADD_EXIT_CODE -eq 0 ]; then
    echo "✓ SSH signing key added to GitHub"
elif echo "$ADD_OUTPUT" | grep -qi "already exists\|duplicate"; then
    echo "✓ SSH signing key already exists on GitHub"
else
    # Verify by checking the list
    if [ -n "$KEY_FINGERPRINT" ] && gh ssh-key list --type signing 2>/dev/null | grep -q "$KEY_FINGERPRINT"; then
        echo "✓ SSH signing key is on GitHub"
    else
        echo "⚠️  Failed to add SSH signing key to GitHub"
        echo "   Error: $ADD_OUTPUT"
        echo "   You may need to add it manually at: https://github.com/settings/keys"
        echo "   Public key location: $SIGNING_KEY_PUB"
    fi
fi

# Configure Git for SSH signing
git config --global gpg.format ssh
git config --global user.signingkey "$SIGNING_KEY_PUB"
git config --global commit.gpgsign true
echo "✓ Git configured for SSH signing"
echo ""

# Step 3.6: Configure Git Remote and Credentials
echo "Step 3.6: Configuring Git Remote and Credentials..."

# Configure git to use GitHub CLI as credential helper
echo "Configuring git credential helper to use gh CLI..."
gh auth setup-git

# Ensure remote is set correctly
echo "Ensuring git remote 'origin' is configured..."
# Check if we are in a git repo
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # Set remote to HTTPS URL (TARGET_REPO configured at script start)
    # We use HTTPS because we just set up the credential helper
    
    if git remote | grep -q "^origin$"; then
        CURRENT_URL=$(git remote get-url origin)
        if [ "$CURRENT_URL" != "$TARGET_REPO" ]; then
            echo "Updating existing 'origin' remote from $CURRENT_URL to $TARGET_REPO..."
            git remote set-url origin "$TARGET_REPO"
        else
            echo "Remote 'origin' is already set to $TARGET_REPO"
        fi
    else
        echo "Adding 'origin' remote..."
        git remote add origin "$TARGET_REPO"
    fi
    echo "✓ Remote 'origin' configured"
else
    echo "⚠️  Not inside a git repository. Skipping remote configuration."
fi
echo ""

# Step 4: Update ~/.bashrc
echo "Step 4: Updating ~/.bashrc..."

# Atomic update of ~/.bashrc:
# 1. Read the original file
# 2. Build complete new content in a temp file (skip old marker block, insert new block)
# 3. Only after temp file is fully written, atomically replace original via mv
# This prevents data loss if the script is interrupted mid-write.

BASHRC_TMP="${BASHRC_FILE}.tmp.$$"

# Ensure temp file is cleaned up on exit/error
trap 'rm -f "$BASHRC_TMP"' EXIT

# Find the line number where setup.sh is sourced (to insert after it)
# Use '|| true' to handle case where file doesn't exist or pattern not found
SETUP_LINE=""
if [ -f "$BASHRC_FILE" ]; then
    SETUP_LINE=$(grep -n "source /usr/local/bin/setup.sh" "$BASHRC_FILE" 2>/dev/null | tail -1 | cut -d: -f1 || true)
fi

# Build the complete new ~/.bashrc content atomically
{
    if [ -f "$BASHRC_FILE" ]; then
        # Read original file, skipping any existing marker block
        # Track line numbers to insert the new block at the right position
        line_num=0
        in_old_block=false
        block_inserted=false
        
        while IFS= read -r line || [ -n "$line" ]; do
            line_num=$((line_num + 1))
            
            # Check for start of old block
            if [ "$line" = "$MARKER_START" ]; then
                in_old_block=true
                continue
            fi
            
            # Check for end of old block
            if [ "$line" = "$MARKER_END" ]; then
                in_old_block=false
                continue
            fi
            
            # Skip lines inside the old block
            if [ "$in_old_block" = "true" ]; then
                continue
            fi
            
            # Output the current line
            printf '%s\n' "$line"
            
            # Insert new block after the setup.sh line if applicable
            if [ -n "$SETUP_LINE" ] && [ "$line_num" = "$SETUP_LINE" ] && [ "$block_inserted" = "false" ]; then
                echo ""
                echo "$MARKER_START"
                echo "$FUNCTION_DEF"
                echo "$MARKER_END"
                block_inserted=true
            fi
        done < "$BASHRC_FILE"
        
        # If no SETUP_LINE or block wasn't inserted yet, append at EOF
        if [ "$block_inserted" = "false" ]; then
            echo ""
            echo "$MARKER_START"
            echo "$FUNCTION_DEF"
            echo "$MARKER_END"
        fi
    else
        # No existing ~/.bashrc, create fresh with just the block
        echo "$MARKER_START"
        echo "$FUNCTION_DEF"
        echo "$MARKER_END"
    fi
} > "$BASHRC_TMP"

# Atomically replace the original file
mv "$BASHRC_TMP" "$BASHRC_FILE"

# Clear the trap since we successfully moved the file
trap - EXIT

if [ -n "$SETUP_LINE" ]; then
    echo "✓ Updated ~/.bashrc with GITHUB_TOKEN clearing and verification function"
else
    echo "✓ Appended setup to ~/.bashrc"
fi
echo ""

# Step 5: Verify final setup
echo "Step 5: Verifying final setup..."
echo ""

# Source bashrc to test the new configuration
export GITHUB_TOKEN=""
FINAL_GIT_USER=$(git config --global user.name)
FINAL_GIT_EMAIL=$(git config --global user.email)
FINAL_GH_USER=$(gh api user --jq .login 2>/dev/null || echo "")
FINAL_SIGNING_KEY=$(git config --global user.signingkey || echo "")
FINAL_GPGSIGN=$(git config --global commit.gpgsign || echo "false")

echo "Current configuration:"
echo "  ✓ Git user.name: $FINAL_GIT_USER"
echo "  ✓ Git user.email: $FINAL_GIT_EMAIL"
if [ -n "$FINAL_GH_USER" ]; then
    echo "  ✓ GitHub CLI user: $FINAL_GH_USER"
else
    echo "  ⚠️  GitHub CLI: Not authenticated"
fi
if [ -n "$FINAL_SIGNING_KEY" ] && [ "$FINAL_GPGSIGN" = "true" ]; then
    echo "  ✓ Commit signing: Enabled ($FINAL_SIGNING_KEY)"
else
    echo "  ⚠️  Commit signing: Not configured"
fi
echo ""

# Final status
SETUP_COMPLETE=true
if [ "$FINAL_GIT_USER" != "$GIT_USER" ] || [ "$FINAL_GIT_EMAIL" != "$GIT_EMAIL" ]; then
    SETUP_COMPLETE=false
fi
if [ "$FINAL_GH_USER" != "$GIT_USER" ]; then
    SETUP_COMPLETE=false
fi
if [ -z "$FINAL_SIGNING_KEY" ] || [ "$FINAL_GPGSIGN" != "true" ]; then
    SETUP_COMPLETE=false
fi

if [ "$SETUP_COMPLETE" = "true" ]; then
    echo "=========================================="
    echo "✓ Setup Complete!"
    echo "=========================================="
    echo ""
    echo "All operations will be attributed to $GIT_USER"
    echo "All commits will be signed with SSH key: $FINAL_SIGNING_KEY"
    echo ""
    echo "To verify your setup in a new shell, run:"
    echo "  source ~/.bashrc"
    echo "  check_dev_setup"
    echo ""
    exit 0
else
    echo "=========================================="
    echo "⚠️  Setup Incomplete"
    echo "=========================================="
    echo ""
    if [ "$FINAL_GIT_USER" != "$GIT_USER" ] || [ "$FINAL_GIT_EMAIL" != "$GIT_EMAIL" ]; then
        echo "Git configuration needs attention"
    fi
    if [ "$FINAL_GH_USER" != "$GIT_USER" ]; then
        echo "GitHub CLI authentication needs attention"
        echo "Run this script again and choose option 1 or 2 for authentication"
    fi
    if [ -z "$FINAL_SIGNING_KEY" ] || [ "$FINAL_GPGSIGN" != "true" ]; then
        echo "SSH signing key setup needs attention"
        echo "Run this script again to complete SSH signing setup"
    fi
    echo ""
    exit 1
fi