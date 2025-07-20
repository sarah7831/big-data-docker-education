#!/bin/bash

echo "=== Setting up Git Repository for Big Data Docker Project ==="

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed or not available."
    echo "Please install Xcode command line tools first:"
    echo "  xcode-select --install"
    exit 1
fi

# Initialize git repository if not already done
if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
fi

# Add all files
echo "Adding files to Git..."
git add .

# Create initial commit
echo "Creating initial commit..."
git commit -m "Initial commit: Big Data Docker Images for Education

- Ubuntu + Java base image with comprehensive exercises
- Hadoop HDFS + YARN image with MapReduce examples
- Complete Docker Compose setup for all planned images
- Comprehensive documentation and quick start guides
- Progressive learning curriculum for big data technologies

Features:
- 5 progressive Docker images (ubuntu-java, hadoop-base, hadoop-ingestion, hadoop-hive, hadoop-spark)
- Comprehensive exercises and verification scripts
- Web UI access for all services
- Volume persistence for data
- Educational documentation for instructors and students"

echo
echo "=== Git repository setup complete! ==="
echo
echo "Next steps to push to GitHub:"
echo "1. Create a new repository on GitHub"
echo "2. Run the following commands:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo
echo "Or create and push to GitHub in one step:"
echo "   gh repo create big-data-docker-education --public --source=. --remote=origin --push"
echo "   (requires GitHub CLI: brew install gh)"
