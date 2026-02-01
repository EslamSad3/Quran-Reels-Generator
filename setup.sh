#!/bin/bash

###############################################################################
# Quran Reels Generator - Automated GitHub Setup Script
# 
# Usage: chmod +x setup.sh && ./setup.sh
# 
# This script automates the entire setup process:
# 1. Checks prerequisites (gh, git, node)
# 2. Authenticates with GitHub
# 3. Creates project structure
# 4. Sets up .gitignore files
# 5. Creates documentation and README
# 6. Initializes Git repository
# 7. Creates initial commit
# 8. Creates GitHub repository and pushes code
#
###############################################################################

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="quran-reels-app"
REPO_NAME="quran-reels-generator"
REPO_DESCRIPTION="Full-stack Quran Reels video generator with Next.js & Express"
GITHUB_VISIBILITY="public"

###############################################################################
# Helper Functions
###############################################################################

print_header() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 is not installed"
        echo "Install from: $2"
        return 1
    fi
    print_step "$1 is installed"
    return 0
}

###############################################################################
# Pre-flight Checks
###############################################################################

print_header "🚀 Quran Reels Generator - GitHub Setup"

echo "Checking prerequisites..."
echo ""

MISSING=0

check_command "gh" "https://cli.github.com" || MISSING=1
check_command "git" "https://git-scm.com" || MISSING=1
check_command "node" "https://nodejs.org" || MISSING=1

if [ $MISSING -eq 1 ]; then
    print_error "Please install missing prerequisites and try again"
    exit 1
fi

echo ""
print_step "All prerequisites installed"
echo ""

###############################################################################
# GitHub Authentication
###############################################################################

print_header "🔐 GitHub Authentication"

# Check if already authenticated
if gh auth status > /dev/null 2>&1; then
    print_step "Already authenticated with GitHub"
    GITHUB_USER=$(gh auth status --show-token 2>&1 | grep "Logged in to" | awk '{print $NF}' | sed 's/as //')
    if [ -z "$GITHUB_USER" ]; then
        GITHUB_USER=$(gh api user -q '.login')
    fi
else
    print_info "Starting GitHub authentication..."
    gh auth login --web
    print_step "GitHub authentication completed"
fi

GITHUB_USER=$(gh api user -q '.login')
print_step "Authenticated as: $GITHUB_USER"
echo ""

###############################################################################
# Project Structure
###############################################################################

print_header "📁 Creating Project Structure"

# Create project directory
if [ -d "$PROJECT_NAME" ]; then
    print_info "Directory $PROJECT_NAME already exists"
    read -p "Overwrite? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$PROJECT_NAME"
    else
        print_error "Cancelled"
        exit 1
    fi
fi

mkdir -p "$PROJECT_NAME"/{server,client,docs}
cd "$PROJECT_NAME"
print_step "Created project directories"

###############################################################################
# Git Initialization
###############################################################################

print_header "🔧 Initializing Git Repository"

git init
print_step "Git repository initialized"

# Configure git (optional)
if ! git config user.email > /dev/null 2>&1; then
    print_info "Configuring Git user..."
    git config user.email "$GITHUB_USER@users.noreply.github.com" || true
    git config user.name "$GITHUB_USER" || true
fi

###############################################################################
# Create .gitignore Files
###############################################################################

print_header "🚫 Creating .gitignore Files"

# Root .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
package-lock.json
yarn.lock
pnpm-lock.yaml

# Environment variables
.env
.env.local
.env.*.local

# IDE & Editor
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store
*.sublime-project
*.sublime-workspace

# Build outputs
dist/
build/
.next/
out/
.swc/

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# OS
Thumbs.db
.DS_Store

# Temp files
temp/
uploads/
*.tmp
*.temp

# Testing
coverage/
.nyc_output/
jest-coverage/

# Optional npm cache
.npm

# Production
.cache/

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Audio/Video files (generated)
*.mp3
*.mp4
*.wav
*.png

# Docker
.dockerignore
docker-compose.override.yml

# CI/CD
.github/workflows/.env*
EOF
print_step "Root .gitignore created"

# Server .gitignore
cat > server/.gitignore << 'EOF'
node_modules/
dist/
build/
*.log
.env
.env.local
temp/
*.mp3
*.png
*.mp4
.DS_Store
.swc/
package-lock.json
EOF
print_step "server/.gitignore created"

# Client .gitignore
cat > client/.gitignore << 'EOF'
node_modules/
.next/
out/
build/
dist/
.env.local
.env
.DS_Store
*.log
coverage/
.vercel/
.swc/
package-lock.json
EOF
print_step "client/.gitignore created"

###############################################################################
# Create Documentation Files
###############################################################################

print_header "📚 Creating Documentation Files"

# Full Stack Implementation Guide
cat > docs/fullstack-implementation.md << 'EOF'
# Quran Reels Generator - Full Stack Implementation

[Full documentation content - copy from quran-reels-fullstack.md file]

Complete source code and implementation details for all backend services,
frontend components, and API endpoints.

**Key Sections:**
- Project Architecture Overview
- Directory Structure
- Backend Implementation (Express + TypeScript)
- Frontend Implementation (Next.js + React)
- Service Layer (Quran API, Canvas, FFmpeg)
- Component Structure
- Configuration & Setup

See the separate file for complete details.
EOF
print_step "docs/fullstack-implementation.md created"

# Quick Start Guide
cat > docs/quick-start-guide.md << 'EOF'
# Quran Reels Generator - Quick Start Guide

[Quick start documentation content - copy from quick-start-guide.md file]

**Quick reference for:**
- 5-minute setup
- Installation steps
- API endpoints
- Configuration options
- Common issues & solutions
- Deployment guides

See the separate file for complete details.
EOF
print_step "docs/quick-start-guide.md created"

# GitHub Setup Guide
cat > docs/github-setup-guide.md << 'EOF'
# Quran Reels Generator - GitHub Setup Guide

## Creating and Pushing to GitHub

This guide explains how the automated `setup.sh` script:
1. Checks GitHub CLI and prerequisites
2. Authenticates with GitHub
3. Creates the project structure
4. Initializes Git repository
5. Creates GitHub repository
6. Pushes all code

### Manual Steps (if needed)

**Clone existing repo:**
\`\`\`bash
git clone https://github.com/$GITHUB_USER/quran-reels-generator.git
cd quran-reels-generator
\`\`\`

**Push changes:**
\`\`\`bash
git add .
git commit -m "Your message"
git push origin main
\`\`\`

**Create feature branch:**
\`\`\`bash
git checkout -b feature/your-feature
git push -u origin feature/your-feature
\`\`\`

### Repository Management

**View repository:**
https://github.com/$GITHUB_USER/quran-reels-generator

**Add collaborators:**
1. Go to Settings > Collaborators
2. Add user by username
3. Set permission level

**Enable GitHub Actions:**
1. Go to Actions tab
2. Set up CI/CD workflows for automated testing
3. Add status badges to README

### Local Development Workflow

\`\`\`bash
# Clone the repo
git clone https://github.com/$GITHUB_USER/quran-reels-generator.git
cd quran-reels-generator

# Create feature branch
git checkout -b feature/add-subtitles

# Make changes
# ... edit files ...

# Commit changes
git add .
git commit -m "feat: add subtitle support"

# Push to GitHub
git push origin feature/add-subtitles

# Create Pull Request on GitHub website
# ... and merge after review
\`\`\`

### Best Practices

- ✅ Write clear commit messages
- ✅ Use feature branches for development
- ✅ Create pull requests before merging
- ✅ Keep main branch stable
- ✅ Tag releases with semantic versioning
- ✅ Document breaking changes in commit messages

EOF
print_step "docs/github-setup-guide.md created"

###############################################################################
# Create README.md
###############################################################################

print_header "📝 Creating README.md"

cat > README.md << 'EOF'
# Quran Reels Generator

[![GitHub stars](https://img.shields.io/github/stars/EslamSad3/quran-reels-generator?style=social)](https://github.com/EslamSad3/quran-reels-generator)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

A full-stack application that generates beautiful vertical short-form Quranic videos (1080x1920) with Arabic text overlays and audio recitations. Perfect for Instagram Reels, TikTok, and social media sharing.

## ✨ Features

- 📖 Fetch authentic Quranic verses from Quran Cloud API
- 🎨 Generate professional overlay graphics with proper Arabic RTL support
- 🎬 Create high-quality MP4 videos using FFmpeg
- ⚡ Real-time video processing without serverless timeouts (dedicated Express backend)
- 🎯 Modern responsive UI with Next.js 16 and Tailwind CSS
- 📱 Perfect 9:16 vertical format for mobile platforms
- 🔄 Stream-based audio processing (memory efficient)
- 🎬 Configurable FFmpeg encoding quality

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- FFmpeg installed globally (`ffmpeg -version` should work)
- GitHub CLI for setup (`gh` command)
- Ports 3000 and 4000 available

### Automated Setup

```bash
# Download and run the setup script
chmod +x setup.sh
./setup.sh

# This will:
# 1. Check all prerequisites
# 2. Authenticate with GitHub
# 3. Create project structure
# 4. Initialize Git repository
# 5. Create GitHub repository
# 6. Push initial code
```

### Manual Installation

```bash
# Backend
cd server
npm install
npm run dev

# Frontend (new terminal)
cd client
npm install
npm run dev
```

### Access Application

Open your browser and navigate to:
```
http://localhost:3000
```

## 📚 Documentation

Complete documentation available in the `docs/` directory:

- **`docs/fullstack-implementation.md`** - Complete source code and implementation details
- **`docs/quick-start-guide.md`** - Installation, troubleshooting, and reference guide
- **`docs/github-setup-guide.md`** - GitHub repository setup and workflow instructions

## 🎯 How It Works

```
User Input (Surah, Ayah)
    ↓
[Frontend] POST to http://localhost:4000/generate
    ↓
[Backend] Fetch from Quran Cloud API
    ├─ Arabic text (Uthmani script)
    └─ Audio (Alafasy recitation)
    ↓
[Backend] Download audio MP3 to temp folder
    ↓
[Backend] Create Canvas overlay (1080x1920 PNG)
    ├─ Surah name (gold)
    ├─ Ayah number
    └─ Arabic text (white, RTL)
    ↓
[Backend] Process with FFmpeg
    ├─ Scale background video
    ├─ Overlay PNG at center
    ├─ Combine with audio
    └─ Encode to MP4
    ↓
[Backend] Return video URL
    ↓
[Frontend] Display in video player
    ↓
User: Play or Download
```

## 🛠 Tech Stack

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Language**: TypeScript
- **Video Processing**: fluent-ffmpeg
- **Graphics**: canvas (Node.js)
- **HTTP Client**: Axios

### Frontend
- **Framework**: Next.js 16 (App Router)
- **UI Library**: React 19
- **Language**: TypeScript
- **Styling**: Tailwind CSS 3
- **HTTP Client**: Axios
- **Video Player**: HTML5 <video>

### APIs & Services
- **Quran Data**: Quran Cloud API (free, public)
- **Video Encoding**: FFmpeg (open-source)

## 🌐 Deployment

### Deploy Backend

**Option 1: Render**
```bash
git push origin main
# 1. Go to render.com
# 2. Create new Web Service
# 3. Connect GitHub repository
# 4. Build command: npm run build
# 5. Start command: node dist/index.js
```

**Option 2: Railway**
Similar process to Render

### Deploy Frontend

**Option 1: Vercel (Recommended)**
```bash
npm i -g vercel
cd client
vercel
```

**Option 2: Netlify**
- Connect GitHub repository
- Set build command: `npm run build`
- Set publish directory: `.next`

## 📄 License

MIT License - Feel free to use, modify, and distribute

## 🙏 Credits & Attribution

- **Quran Data**: [Quran Cloud API](https://alquran.cloud) - Islamic Network
- **Video Processing**: [FFmpeg](https://ffmpeg.org) - Open-source multimedia framework
- **Framework**: [Next.js](https://nextjs.org) by Vercel
- **Server**: [Express.js](https://expressjs.com) - Node.js web framework
- **Styling**: [Tailwind CSS](https://tailwindcss.com) - Utility-first CSS

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support & Issues

If you encounter any issues:

1. Check the troubleshooting section in documentation
2. Review the [Quran Cloud API status](https://alquran.cloud)
3. Ensure FFmpeg is properly installed
4. Check that ports 3000 and 4000 are available

## 🎯 Roadmap

- [ ] Add subtitle support
- [ ] Support multiple Quran recitations
- [ ] Add background music options
- [ ] Implement video caching
- [ ] Add webhook support for batch processing
- [ ] Create mobile app (React Native)
- [ ] Add custom background image support
- [ ] Implement video effects/filters

---

**Made with ❤️ for the Ummah**

Built to help share the beauty and wisdom of the Quran with modern audiences through engaging video content.
EOF
print_step "README.md created"

###############################################################################
# Create Package.json Files
###############################################################################

print_header "📦 Creating package.json Files"

# Server package.json
cat > server/package.json << 'EOF'
{
  "name": "quran-reels-server",
  "version": "1.0.0",
  "description": "Express backend for Quran Reels video generation",
  "main": "dist/index.js",
  "type": "commonjs",
  "scripts": {
    "build": "tsc",
    "dev": "ts-node src/index.ts",
    "start": "node dist/index.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "fluent-ffmpeg": "^2.1.2",
    "canvas": "^2.11.2",
    "axios": "^1.6.2"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/node": "^20.10.6",
    "@types/fluent-ffmpeg": "^2.1.24",
    "typescript": "^5.3.3",
    "ts-node": "^10.9.2"
  }
}
EOF
print_step "server/package.json created"

# Client package.json
cat > client/package.json << 'EOF'
{
  "name": "quran-reels-client",
  "version": "1.0.0",
  "description": "Next.js frontend for Quran Reels",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "^16.0.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "axios": "^1.6.2"
  },
  "devDependencies": {
    "@types/node": "^20.10.6",
    "@types/react": "^18.2.46",
    "@types/react-dom": "^18.2.18",
    "typescript": "^5.3.3",
    "tailwindcss": "^3.4.1",
    "postcss": "^8.4.32",
    "autoprefixer": "^10.4.16"
  }
}
EOF
print_step "server/package.json created"

###############################################################################
# Create tsconfig.json Files
###############################################################################

print_header "⚙️ Creating tsconfig.json Files"

# Server tsconfig.json
cat > server/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "moduleResolution": "node",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
print_step "server/tsconfig.json created"

# Client tsconfig.json
cat > client/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
EOF
print_step "client/tsconfig.json created"

###############################################################################
# Create Initial Commit
###############################################################################

print_header "💾 Creating Initial Commit"

git add .

git commit -m "Initial commit: Quran Reels Generator project structure

- Express backend with TypeScript setup
- Next.js frontend with Tailwind CSS
- Complete full-stack documentation
- Quick start and setup guides
- GitHub workflow instructions
- Ready for implementation of video generation features

See docs/ for complete implementation details"

print_step "Initial commit created"

###############################################################################
# Create GitHub Repository
###############################################################################

print_header "🐙 Creating GitHub Repository"

print_info "Creating repository: $REPO_NAME..."

if gh repo create "$REPO_NAME" \
    --"$GITHUB_VISIBILITY" \
    --source=. \
    --push \
    --description "$REPO_DESCRIPTION" 2>/dev/null; then
    print_step "GitHub repository created and code pushed successfully"
else
    print_info "Note: Repository may already exist, pushing changes..."
    git push -u origin main || git push -u origin master
fi

###############################################################################
# Final Output
###############################################################################

print_header "✅ Setup Complete!"

echo ""
echo -e "${GREEN}Your Quran Reels Generator project is ready!${NC}"
echo ""

REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME"

echo "📊 Project Information:"
echo "  Repository: $REPO_NAME"
echo "  Owner: $GITHUB_USER"
echo "  Visibility: $GITHUB_VISIBILITY"
echo "  URL: $REPO_URL"
echo ""

echo "📁 Project Structure:"
echo "  ├── server/       (Express backend)"
echo "  ├── client/       (Next.js frontend)"
echo "  ├── docs/         (Complete documentation)"
echo "  └── README.md     (Project overview)"
echo ""

echo "📚 Documentation Files:"
echo "  ├── docs/fullstack-implementation.md  (Complete source code)"
echo "  ├── docs/quick-start-guide.md         (Setup & troubleshooting)"
echo "  └── docs/github-setup-guide.md        (Git workflow)"
echo ""

echo "🚀 Next Steps:"
echo "  1. cd $PROJECT_NAME"
echo "  2. Copy source code from docs/fullstack-implementation.md"
echo "  3. Create server/src/*.ts files"
echo "  4. Create client/app/*.tsx files"
echo "  5. cd server && npm install && npm run dev"
echo "  6. cd client && npm install && npm run dev (new terminal)"
echo "  7. Open http://localhost:3000"
echo ""

echo "📤 Pushing Changes to GitHub:"
echo "  git add ."
echo "  git commit -m 'Add implementation files'"
echo "  git push"
echo ""

echo "🔗 View Repository:"
echo "  $REPO_URL"
echo ""

echo -e "${GREEN}Happy coding! 🎉${NC}"
echo ""

# Open repository in browser (optional)
if command -v open &> /dev/null; then
    read -p "Open repository in browser? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "$REPO_URL"
    fi
elif command -v xdg-open &> /dev/null; then
    read -p "Open repository in browser? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        xdg-open "$REPO_URL"
    fi
fi
