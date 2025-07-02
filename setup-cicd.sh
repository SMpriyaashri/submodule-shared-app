#!/bin/bash

# CI/CD Pipeline Setup Script for Submodule Auto-Updates
# This script helps set up the automatic submodule update pipeline

echo "🚀 Setting up CI/CD Pipeline for Submodule Auto-Updates"
echo "=================================================="

# Check if we're in the right directory
if [ ! -f ".gitmodules" ]; then
    echo "❌ Error: .gitmodules file not found. Please run this script from the submodule-shared-app directory."
    exit 1
fi

echo "✅ Found .gitmodules file"

# Check if GitHub Actions directory exists
if [ ! -d ".github/workflows" ]; then
    echo "📁 Creating .github/workflows directory..."
    mkdir -p .github/workflows
fi

echo "✅ GitHub Actions directory ready"

# Check if workflow files exist
if [ ! -f ".github/workflows/update-submodule.yml" ]; then
    echo "❌ Error: update-submodule.yml workflow not found."
    echo "Please ensure the workflow files are in place."
    exit 1
fi

if [ ! -f ".github/workflows/webhook-update.yml" ]; then
    echo "❌ Error: webhook-update.yml workflow not found."
    echo "Please ensure the workflow files are in place."
    exit 1
fi

echo "✅ Workflow files found"

# Check submodule configuration
echo "📋 Checking submodule configuration..."
if grep -q "main-app" .gitmodules; then
    echo "✅ main-app submodule configured"
else
    echo "❌ Error: main-app submodule not found in .gitmodules"
    exit 1
fi

# Display setup instructions
echo ""
echo "🎯 Next Steps:"
echo "=============="
echo ""
echo "1. Create a GitHub Personal Access Token:"
echo "   - Go to GitHub Settings → Developer settings → Personal access tokens"
echo "   - Generate new token with 'repo' and 'workflow' permissions"
echo ""
echo "2. Add Repository Secrets:"
echo "   In main-app repository:"
echo "   - Settings → Secrets and variables → Actions"
echo "   - Add secret: SUBMODULE_UPDATE_TOKEN = your_token"
echo ""
echo "3. Enable Repository Dispatch Events:"
echo "   In submodule-shared-app repository:"
echo "   - Settings → Actions → General"
echo "   - Enable 'Allow GitHub Actions to create and approve pull requests'"
echo ""
echo "4. Test the Pipeline:"
echo "   - Make a change in main-app and push to main branch"
echo "   - Check Actions tab in both repositories"
echo ""
echo "📚 For detailed instructions, see SETUP-CICD.md"
echo ""
echo "🎉 Setup script completed!" 