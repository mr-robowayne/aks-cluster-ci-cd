#!/bin/bash
set -e

REPO_NAME="aks-cluster-ci-cd"
SP_NAME="github-actions-filipe"
GITHUB_USER=$(gh api user --jq '.login')
DEV_BRANCH="development"
PROD_BRANCH="main"


echo "🔑 Resetting Service Principal credentials..."

# -------------------------------------------------------
# Get SP credentials
# -------------------------------------------------------
SP_CREDENTIALS=$(az ad sp credential reset \
  --id $(az ad sp list --display-name "$SP_NAME" --query "[0].appId" -o tsv) \
  -o json)

ARM_CLIENT_ID=$(echo $SP_CREDENTIALS | jq -r '.appId')
ARM_CLIENT_SECRET=$(echo $SP_CREDENTIALS | jq -r '.password')
ARM_TENANT_ID=$(echo $SP_CREDENTIALS | jq -r '.tenant')
ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)

echo "✅ Credentials retrieved"

# -------------------------------------------------------
# Create GitHub Environments
# -------------------------------------------------------
echo "🌍 Creating GitHub Environments..."

gh api repos/$GITHUB_USER/$REPO_NAME/environments/development --method PUT
gh api repos/$GITHUB_USER/$REPO_NAME/environments/production --method PUT

echo "✅ Environments created"

# -------------------------------------------------------
# Bind GitHub Environments to branch
# -------------------------------------------------------

## Developtment branch
gh api repos/$GITHUB_USER/$REPO_NAME/environments/development \
  --method PUT \
  --input - << EOF
{
  "deployment_branch_policy": {
    "protected_branches": false,
    "custom_branch_policies": true
  }
}
EOF

gh api repos/$GITHUB_USER/$REPO_NAME/environments/development/deployment-branch-policies \
  --method POST \
  --field name="$DEV_BRANCH"

#  Main branch
gh api repos/$GITHUB_USER/$REPO_NAME/environments/production \
  --method PUT \
  --input - << EOF
{
  "deployment_branch_policy": {
    "protected_branches": false,
    "custom_branch_policies": true
  }
}
EOF

gh api repos/$GITHUB_USER/$REPO_NAME/environments/production/deployment-branch-policies \
  --method POST \
  --field name="$PROD_BRANCH"


# -------------------------------------------------------
# Set Secrets for development environment
# -------------------------------------------------------
echo "🔐 Setting secrets for development..."

gh secret set ARM_CLIENT_ID --env development --body "$ARM_CLIENT_ID" --repo $GITHUB_USER/$REPO_NAME
gh secret set ARM_CLIENT_SECRET --env development --body "$ARM_CLIENT_SECRET" --repo $GITHUB_USER/$REPO_NAME
gh secret set ARM_TENANT_ID --env development --body "$ARM_TENANT_ID" --repo $GITHUB_USER/$REPO_NAME
gh secret set ARM_SUBSCRIPTION_ID --env development --body "$ARM_SUBSCRIPTION_ID" --repo $GITHUB_USER/$REPO_NAME

echo "✅ Development secrets set"

# -------------------------------------------------------
# Set Secrets for production environment
# -------------------------------------------------------
echo "🔐 Setting secrets for production..."

gh secret set ARM_CLIENT_ID --env production --body "$ARM_CLIENT_ID" --repo $GITHUB_USER/$REPO_NAME
gh secret set ARM_CLIENT_SECRET --env production --body "$ARM_CLIENT_SECRET" --repo $GITHUB_USER/$REPO_NAME
gh secret set ARM_TENANT_ID --env production --body "$ARM_TENANT_ID" --repo $GITHUB_USER/$REPO_NAME
gh secret set ARM_SUBSCRIPTION_ID --env production --body "$ARM_SUBSCRIPTION_ID" --repo $GITHUB_USER/$REPO_NAME

echo "✅ Production secrets set"
echo ""
echo "✅ All done! Environments and secrets configured:"
echo "   https://github.com/$GITHUB_USER/$REPO_NAME/settings/environments"