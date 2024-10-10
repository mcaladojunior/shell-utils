#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define colors for better output readability
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No color

# Function to print a step header
print_step() {
  echo -e "\n${GREEN}>>> $1${NC}\n"
}

# 1. Run Pylint for style, static analysis, and code quality checks
print_step "Running Pylint (style, static analysis, and code quality checks)..."
pylint $(find . -type f -name "*.py" | grep -v 'migrations')

# 2. Run cyclomatic complexity analysis (Radon)
print_step "Checking code complexity with Radon..."
radon cc . -a

# 3. Check for security issues (Bandit)
print_step "Running Bandit (security checker)..."
bandit -r .

# 4. Check for dependency vulnerabilities (Pip-audit)
print_step "Checking for dependency vulnerabilities with pip-audit..."
pip-audit

# 5. Run test coverage report (if pytest is configured)
if [ -f "pytest.ini" ] || [ -f "setup.cfg" ] || [ -f "pyproject.toml" ]; then
  print_step "Running pytest with coverage..."
  pytest --cov=.
else
  echo -e "${RED}Skipping pytest as configuration files are missing.${NC}"
fi

# Final message
echo -e "\n${GREEN}All checks completed successfully!${NC}\n"
