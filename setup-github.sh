#!/bin/bash
set -e

echo "Setting up GitHub repository for Cadenza..."

# Navigate to the project root
cd /Users/fernando/work/cadenza

# Check if we need to move files from cadenza subdirectory
if [ -d "cadenza-temp" ]; then
  echo "Found cadenza-temp directory, moving files..."
  # Move all files from cadenza-temp to root
  for item in cadenza-temp/*; do
    if [ -e "$item" ]; then
      mv "$item" .
    fi
  done

  # Move hidden files
  shopt -s dotglob
  for item in cadenza-temp/.[^.]*; do
    if [ -e "$item" ] && [ "$item" != "cadenza-temp/." ] && [ "$item" != "cadenza-temp/.." ]; then
      mv "$item" .
    fi
  done
  shopt -u dotglob

  # Remove empty directory
  rmdir cadenza-temp
  echo "Files moved successfully!"
elif [ -d "cadenza" ]; then
  echo "Found cadenza subdirectory, renaming and moving..."
  mv cadenza cadenza-temp

  # Move all files from cadenza-temp to root
  for item in cadenza-temp/*; do
    if [ -e "$item" ]; then
      mv "$item" .
    fi
  done

  # Move hidden files
  shopt -s dotglob
  for item in cadenza-temp/.[^.]*; do
    if [ -e "$item" ] && [ "$item" != "cadenza-temp/." ] && [ "$item" != "cadenza-temp/.." ]; then
      mv "$item" .
    fi
  done
  shopt -u dotglob

  # Remove empty directory
  rmdir cadenza-temp
  echo "Files moved successfully!"
fi

# Check if git repo exists, if not initialize it
if [ ! -d ".git" ]; then
  echo "Initializing git repository..."
  git init
fi

# Create .gitignore if it doesn't exist or update it
cat > .gitignore << 'EOF'
# Devbox
.devbox/

# Dependencies
node_modules/
.pnp/
.pnp.js
.yarn/cache
.yarn/unplugged
.yarn/build-state.yml
.yarn/install-state.gz

# Build outputs
dist/
dist-types/
build/
*.tsbuildinfo

# Temporary files
create-backstage.sh
move-files.sh

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment
.env
.env.local
.env.*.local

# Test coverage
coverage/

# Misc
.cache/
EOF

echo "Created/updated .gitignore"

# Stage all files
echo "Staging files for commit..."
git add .

# Create initial commit
echo "Creating initial commit..."
git commit -m "$(cat <<'COMMITMSG'
feat: initialize Cadenza project with Backstage

- Set up Backstage.io application
- Configure devbox environment with Node.js, Yarn, Git, Python3, GCC, and GitHub CLI
- Add project documentation (CLAUDE.md and README.md)
- Configure Cursor AI rules for PRD and task management workflow

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
COMMITMSG
)"

echo "Initial commit created!"

# Create GitHub repository
echo "Creating GitHub repository 'cadenza' for user fernando1973..."
gh repo create fernando1973/cadenza --public --source=. --description="Cadenza: AI-assisted development workflow system built on Backstage.io" --push

echo ""
echo "✅ GitHub repository created successfully!"
echo "🔗 Repository URL: https://github.com/fernando1973/cadenza"
echo ""
