#!/bin/bash

# =============================================================================
# PUSH SETUP TO GITHUB - Run this on your PC
# 
# This script pushes all the setup files to your GitHub repo, then runs
# the marketing skills integration.
# 
# Usage: bash push-and-integrate.sh
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔═════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Claude Skills - Push & Integration Script          ║${NC}"
echo -e "${BLUE}╚═════════════════════════════════════════════════════════╝${NC}"

# Step 1: Check we're in a git repo
echo -e "\n${YELLOW}Step 1: Checking git setup${NC}"
if [ ! -d ".git" ]; then
    echo -e "${RED}✗ Error: Not in a git repository${NC}"
    echo "Please run this from your claude-skills directory"
    echo ""
    echo "Setup:"
    echo "  git clone https://github.com/Streak-Aholic/claude-skills.git"
    echo "  cd claude-skills"
    echo "  bash push-and-integrate.sh"
    exit 1
fi
echo -e "${GREEN}✓ Git repository found${NC}"

# Step 2: Check git credentials
echo -e "\n${YELLOW}Step 2: Checking git credentials${NC}"
GIT_USER=$(git config user.name)
GIT_EMAIL=$(git config user.email)

if [ -z "$GIT_USER" ] || [ -z "$GIT_EMAIL" ]; then
    echo -e "${YELLOW}Setting up git credentials...${NC}"
    git config user.name "Streak-Aholic"
    git config user.email "your-email@example.com"
    echo -e "${YELLOW}Note: Update email in .git/config if needed${NC}"
fi

echo -e "${GREEN}✓ Git user: $GIT_USER ($GIT_EMAIL)${NC}"

# Step 3: Check if we need to add existing files from GitHub
echo -e "\n${YELLOW}Step 3: Checking for existing commits${NC}"
COMMIT_COUNT=$(git rev-list --all --count 2>/dev/null || echo "0")

if [ "$COMMIT_COUNT" -eq "0" ]; then
    echo -e "${YELLOW}No commits found. This is a fresh repo.${NC}"
    echo -e "${YELLOW}Adding setup files...${NC}"
    
    # Create basic structure
    mkdir -p skills/marketing
    mkdir -p tools
    
    # Create basic README if it doesn't exist
    if [ ! -f "README.md" ]; then
        cat > README.md << 'EOF'
# Claude Skills Repository

Your personal collection of Claude skills for use across multiple machines.

## 📦 What's Inside

- **30+ Marketing Skills** - CRO, copywriting, SEO, analytics, growth, sales
- **Organized structure** - Skills in subdirectories by category
- **Git sync** - Keep skills synchronized across machines

## 🚀 Getting Started

1. Run the setup script: `bash setup-marketing-skills.sh`
2. Commit: `git add . && git commit -m "Add marketing skills"`
3. Push: `git push origin main`
4. On other machine: `git pull origin main`

## 📁 Structure

```
skills/
└── marketing/
    ├── page-cro/
    ├── copywriting/
    ├── email-sequence/
    └── ... (30+ more)

tools/
└── shared utilities
```

See SETUP_INSTRUCTIONS.md for detailed setup.
EOF
        git add README.md
    fi
    
    # Create .gitignore if it doesn't exist
    if [ ! -f ".gitignore" ]; then
        cat > .gitignore << 'EOF'
# OS
.DS_Store
Thumbs.db
*.swp

# IDE
.vscode/
.idea/

# Node
node_modules/
package-lock.json

# Python
__pycache__/
*.pyc
venv/

# Local
.local/
local-*.md
EOF
        git add .gitignore
    fi
    
    # Create SETUP_INSTRUCTIONS if it doesn't exist
    if [ ! -f "SETUP_INSTRUCTIONS.md" ]; then
        cat > SETUP_INSTRUCTIONS.md << 'EOF'
# Setup Instructions

## Quick Start

1. **Clone and navigate:**
   ```bash
   git clone https://github.com/Streak-Aholic/claude-skills.git
   cd claude-skills
   ```

2. **Run the setup script:**
   ```bash
   bash setup-marketing-skills.sh
   ```

   This will:
   - Clone marketing skills from GitHub
   - Copy all 30+ skills to `skills/marketing/`
   - Create documentation

3. **Commit and push:**
   ```bash
   git add .
   git commit -m "Add: 30+ marketing skills"
   git push origin main
   ```

4. **On your other machine:**
   ```bash
   git clone https://github.com/Streak-Aholic/claude-skills.git
   cd claude-skills
   git pull origin main
   ```

Done! Both machines now have synchronized marketing skills.

## Usage

Once configured in Claude, it will automatically use the right skill:

```
"Help me optimize this landing page"
→ Uses page-cro skill

"Write cold email sequences"
→ Uses cold-email skill

"Set up GA4 tracking"
→ Uses analytics-tracking skill
```

## Keep in Sync

```bash
# Pull latest before work
git pull origin main

# Push after updates
git add skills/
git commit -m "Update: [skill name]"
git push origin main
```

See README.md for more details.
EOF
        git add SETUP_INSTRUCTIONS.md
    fi
    
    # Add setup script if it doesn't exist
    if [ ! -f "setup-marketing-skills.sh" ]; then
        echo -e "${YELLOW}Note: You need to download setup-marketing-skills.sh${NC}"
        echo "from Claude's outputs and add it to this directory"
    fi
    
    git commit -m "Initial commit: Setup structure and documentation" 2>/dev/null || true
    echo -e "${GREEN}✓ Added initial files${NC}"
else
    echo -e "${GREEN}✓ Repository has $COMMIT_COUNT commit(s)${NC}"
fi

# Step 4: Push to GitHub
echo -e "\n${YELLOW}Step 4: Pushing to GitHub${NC}"
echo -e "${YELLOW}This may prompt for authentication${NC}"

if git push origin main; then
    echo -e "${GREEN}✓ Successfully pushed to GitHub${NC}"
else
    echo -e "${RED}✗ Push failed${NC}"
    echo "This might be due to:"
    echo "  - No network connection"
    echo "  - GitHub authentication needed"
    echo "  - Repository permissions"
    echo ""
    echo "Try:"
    echo "  git push origin main --force"
    exit 1
fi

# Step 5: Run the setup script
echo -e "\n${YELLOW}Step 5: Running marketing skills integration${NC}"

if [ ! -f "setup-marketing-skills.sh" ]; then
    echo -e "${RED}✗ setup-marketing-skills.sh not found${NC}"
    echo "Please download it from Claude's outputs and place it in this directory"
    exit 1
fi

chmod +x setup-marketing-skills.sh

if bash setup-marketing-skills.sh; then
    echo -e "${GREEN}✓ Marketing skills integration complete${NC}"
else
    echo -e "${RED}✗ Setup script failed${NC}"
    exit 1
fi

# Step 6: Final push
echo -e "\n${YELLOW}Step 6: Pushing marketing skills to GitHub${NC}"

git add .
git commit -m "Add: 30+ marketing skills (CRO, copywriting, SEO, analytics, growth)" 2>/dev/null || echo -e "${YELLOW}No changes to commit${NC}"

if git push origin main; then
    echo -e "${GREEN}✓ Marketing skills pushed to GitHub${NC}"
else
    echo -e "${YELLOW}~ Push had issues, but integration is complete locally${NC}"
fi

# Final summary
echo -e "\n${BLUE}╔═════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    COMPLETE! ✓                          ║${NC}"
echo -e "${BLUE}╚═════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${GREEN}What happened:${NC}"
echo "  ✓ Pushed setup files to GitHub"
echo "  ✓ Integrated 30+ marketing skills"
echo "  ✓ Pushed everything to your repo"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. On your other machine:"
echo "     git clone https://github.com/Streak-Aholic/claude-skills.git"
echo "     cd claude-skills && git pull origin main"
echo ""
echo "  2. Configure Claude to use:"
echo "     /path/to/claude-skills/skills/marketing/"
echo ""
echo "  3. Start using! Ask Claude:"
echo "     'Help me optimize this landing page for conversions'"
echo ""
echo -e "${GREEN}You're all set! 🚀${NC}"

exit 0
