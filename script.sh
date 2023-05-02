#!/bin/bash

# Install Husky if it's not already installed
if ! command -v husky &> /dev/null
then
    npm install husky --save-dev
fi

# Configure Husky to run pre-commit tests
npm install eslint
npx husky-init
mkdir -p .husky
cat << 'EOF' > .husky/pre-commit
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

tsc
npx lint-staged
EOF
chmod +x .husky/pre-commit

# Configure lint-staged to run pre-commit tests
npm install lint-staged --save-dev
npx json -I -f package.json -e 'this["lint-staged"]={"*.{js,jsx,ts,tsx,json,css,scss,md}":["npx prettier --write",
      "npm test -- --watchAll=false --findRelatedTests --bail",
      "npx eslint"]}'

# Run pre-commit tests for the first time
npm run pre-commit