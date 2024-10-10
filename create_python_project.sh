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

# Check if Poetry is installed
if ! command -v poetry &> /dev/null
then
    echo -e "${RED}Poetry could not be found. Please install Poetry first: https://python-poetry.org/docs/#installation${NC}"
    exit 1
fi

# Get project name from user
read -p "Enter the name of your new Python project: " project_name

# Create a new Poetry project
print_step "Creating new Python project with Poetry..."
poetry new $project_name
cd $project_name

# Add Flask as a dependency
print_step "Adding Flask to the project..."
poetry add flask

# Add development tools (Pylint, Radon, Bandit, Pip-audit, pytest, etc.)
print_step "Adding development dependencies (Pylint, Radon, Bandit, Pip-audit, pytest, etc.)..."
poetry add --dev pylint radon bandit pip-audit pytest pytest-cov

# Optional: If you want Black (formatter) and isort (import sorter), you can add them too
# poetry add --dev black isort

# Set up the .pylintrc configuration file
print_step "Generating Pylint configuration..."
poetry run pylint --generate-rcfile > .pylintrc

# Create a simple Flask app as a starting point
print_step "Creating a basic Flask app..."
cat > app.py <<EOL
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, Flask!'

if __name__ == '__main__':
    app.run()
EOL

# Update the README.md file with usage instructions
print_step "Updating README.md with project instructions..."
cat > README.md <<EOL
# $project_name

This is a Python project using Flask, created with Poetry. It includes setup for linting, security checks, and testing.

## How to Run

1. **Install dependencies**: 
   \`\`\`bash
   poetry install
   \`\`\`

2. **Activate the virtual environment**:
   \`\`\`bash
   poetry shell
   \`\`\`

3. **Run the Flask app**:
   \`\`\`bash
   python app.py
   \`\`\`

## Development Tools

- **Pylint**: Run linting with:
  \`\`\`bash
  poetry run pylint app.py
  \`\`\`

- **Radon**: Check code complexity:
  \`\`\`bash
  poetry run radon cc .
  \`\`\`

- **Bandit**: Run security checks:
  \`\`\`bash
  poetry run bandit -r .
  \`\`\`

- **Pip-audit**: Check for vulnerable dependencies:
  \`\`\`bash
  poetry run pip-audit
  \`\`\`

- **pytest**: Run tests with:
  \`\`\`bash
  poetry run pytest
  \`\`\`
EOL

# Final message
echo -e "\n${GREEN}Python project setup complete!${NC}"
echo -e "${GREEN}Navigate to the project folder with:${NC} cd $project_name"
echo -e "${GREEN}To install dependencies and activate the virtual environment, run:${NC} poetry install && poetry shell"
