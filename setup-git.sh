#!/bin/bash

# Git setup script for big data Docker project
echo "Setting up Git repository for big data Docker images..."

# Initialize git repository if not already done
if [ ! -d ".git" ]; then
    git init
    echo "Git repository initialized"
else
    echo "Git repository already exists"
fi

# Add all files
git add .

# Create initial commit if no commits exist
if ! git rev-parse HEAD >/dev/null 2>&1; then
    git commit -m "Initial commit: Big data Docker images for education"
    echo "Initial commit created"
else
    echo "Repository already has commits"
fi

# Check if remote origin exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "Please add a remote origin:"
    echo "git remote add origin <your-repository-url>"
else
    echo "Remote origin already configured:"
    git remote get-url origin
fi

echo "Git setup complete!"
