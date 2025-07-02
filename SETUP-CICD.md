# CI/CD Pipeline Setup for Auto Submodule Updates

This guide explains how to set up automatic submodule updates when changes are pushed to the main-app repository.

## Overview

The pipeline consists of two main components:
1. **Trigger Workflow** (in `main-app`): Notifies when changes are pushed
2. **Update Workflow** (in `submodule-shared-app`): Automatically updates the submodule

## Setup Steps

### 1. Create GitHub Personal Access Token

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate a new token with the following permissions:
   - `repo` (Full control of private repositories)
   - `workflow` (Update GitHub Action workflows)
3. Copy the token (you'll need it for the next step)

### 2. Add Repository Secrets

#### In `main-app` repository:
1. Go to Settings → Secrets and variables → Actions
2. Add a new repository secret:
   - **Name:** `SUBMODULE_UPDATE_TOKEN`
   - **Value:** Your GitHub Personal Access Token

#### In `submodule-shared-app` repository:
1. Go to Settings → Secrets and variables → Actions
2. Add a new repository secret:
   - **Name:** `GITHUB_TOKEN` (usually already exists)
   - **Value:** Your GitHub Personal Access Token (if you need to override the default)

### 3. Enable Repository Dispatch Events

In the `submodule-shared-app` repository:
1. Go to Settings → Actions → General
2. Ensure "Allow GitHub Actions to create and approve pull requests" is enabled
3. Ensure "Allow GitHub Actions to create and approve pull requests" is enabled

### 4. Test the Pipeline

#### Option A: Test with Manual Trigger
1. Go to the `submodule-shared-app` repository
2. Navigate to Actions → "Auto Update Submodule"
3. Click "Run workflow" → "Run workflow"

#### Option B: Test with Push to main-app
1. Make a change in `main-app`
2. Commit and push to the `main` branch
3. Check the Actions tab in both repositories

## How It Works

### Trigger Flow:
1. **Push to main-app** → Triggers `notify-submodule.yml`
2. **Repository Dispatch** → Sends event to `submodule-shared-app`
3. **Auto Update** → Triggers `update-submodule.yml`
4. **Submodule Update** → Updates `main-app` submodule to latest commit
5. **Commit & Push** → Commits the submodule pointer update

### Alternative Flow (Scheduled):
1. **Scheduled Job** → Runs every hour via `webhook-update.yml`
2. **Check for Updates** → Checks if submodule needs updating
3. **Update if Needed** → Updates submodule and commits changes

## Configuration Options

### Change Update Frequency
Edit the cron schedule in `webhook-update.yml`:
```yaml
schedule:
  # Run every 30 minutes
  - cron: '*/30 * * * *'
  # Run daily at 2 AM
  - cron: '0 2 * * *'
```

### Change Trigger Branches
Edit the branches in `notify-submodule.yml`:
```yaml
on:
  push:
    branches: [ main, develop, feature/* ]
```

### Add More Submodules
Update the workflow to handle multiple submodules:
```yaml
- name: Update all submodules
  run: |
    git submodule update --init --recursive --remote
```

## Troubleshooting

### Common Issues:

1. **Permission Denied**
   - Ensure the GitHub token has the correct permissions
   - Check repository settings for Actions permissions

2. **Submodule Not Updating**
   - Verify the submodule URL in `.gitmodules`
   - Check if the submodule is properly initialized

3. **Workflow Not Triggering**
   - Ensure the repository names match in the workflow files
   - Check if the event types are correctly configured

### Debug Steps:

1. Check the Actions tab in both repositories
2. Look at the workflow logs for error messages
3. Verify the repository dispatch event is being sent
4. Check if the submodule is properly configured

## Monitoring

### Check Pipeline Status:
- **main-app**: Actions → "Notify Submodule Update"
- **submodule-shared-app**: Actions → "Auto Update Submodule"

### View Update History:
- Check commit history in `submodule-shared-app`
- Look for commits with "🤖 Auto-update" messages

## Security Considerations

1. **Token Security**: Keep your GitHub token secure and rotate it regularly
2. **Repository Access**: Ensure the token only has access to necessary repositories
3. **Workflow Permissions**: Review and restrict workflow permissions as needed

## Support

If you encounter issues:
1. Check the GitHub Actions documentation
2. Review the workflow logs for specific error messages
3. Verify all setup steps have been completed correctly 