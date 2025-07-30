# Install Azure CLI
az login

# Create resource group
az group create --name portfolio-chatbot-rg --location eastus

# Create App Service plan
az appservice plan create --name portfolio-plan --resource-group portfolio-chatbot-rg --sku B1

# Create Web App
az webapp create --resource-group portfolio-chatbot-rg --plan portfolio-plan --name your-portfolio-chatbot --runtime "NODE|18-lts"

# Configure app settings
az webapp config appsettings set --resource-group portfolio-chatbot-rg --name your-portfolio-chatbot --settings @appsettings.json

# Deploy application
az webapp deployment source config --resource-group portfolio-chatbot-rg --name your-portfolio-chatbot --repo-url https://github.com/MoreVijayP/ai-assistant-portfolio --branch main --manual-integration