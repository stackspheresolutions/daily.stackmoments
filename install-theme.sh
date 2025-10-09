#!/bin/bash

# Theme Installation Script for Stack Moments - Daily

echo "Installing PaperMod theme..."

# Method 1: Using Git Submodule (Recommended)
if [ -d ".git" ]; then
    echo "Installing theme as git submodule..."
    git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
    git submodule update --init --recursive
    echo "Theme installed successfully!"
else
    # Method 2: Direct clone
    echo "Cloning theme directly..."
    git clone https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod --depth=1
    echo "Theme cloned successfully!"
fi

echo ""
echo "Next steps:"
echo "1. Run 'hugo server -D' to start the development server"
echo "2. Visit http://localhost:1313 to view your site"
echo "3. Edit content in the 'content' directory"
echo ""
echo "Happy blogging!"
