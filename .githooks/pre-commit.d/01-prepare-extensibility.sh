#!/bin/bash

environments=(dev stage prod)
echo "Running extensions pre-commit hook..."
(
  cd "$(git rev-parse --show-toplevel)" || exit 1
    for environment in "${environments[@]}"; do
      modified=$(git diff --staged --exit-code --name-only environments/${environment} extensions)
      if [ -n "$modified" ]; then
        echo "Changes detected in ${environment} environment. Rendering extensibility..."
        ENV=${environment} npm run prepare-extensions
        ENV=${environment} npm run pack-extensions
        ENV=${environment} npm run prepare-wizards
        ENV=${environment} npm run pack-wizards
        ENV=${environment} npm run prepare-statics
        ENV=${environment} npm run pack-statics
        git add environments/${environment}
        else
          echo "No changes in ${environment} environment. Skipping.."
      fi
    done
)
