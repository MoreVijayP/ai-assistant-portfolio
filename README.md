# AI Portfolio Chatbot 🤖

A sophisticated AI-powered chatbot system that provides intelligent responses about a software developer's portfolio using RAG (Retrieval-Augmented Generation) architecture. The system combines a modern web application with advanced AI automation workflows to deliver personalized interactions.

## 🌟 Features

- **Intelligent Portfolio Assistant**: AI chatbot trained on portfolio data including skills, projects, experience, and contact details
- **RAG Architecture**: Uses vector embeddings for accurate, context-aware responses
- **Real-time Conversations**: WebSocket-enabled chat interface with session management
- **Document Processing**: Automated PDF to vector embedding pipeline
- **Azure Cloud Deployment**: Scalable cloud infrastructure
- **Conversation Logging**: All interactions stored in Airtable for analytics

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Web Frontend  │───▶│   Azure Web App  │───▶│  n8n Workflows  │
│   (.NET core)   │    │   (Backend API)  │    │ (Container App) │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │    Airtable     │    │  Pinecone DB    │
                       │  (Logging)      │    │  (Vector Store) │
                       └─────────────────┘    └─────────────────┘
                                                        │
                                                        ▼
                                               ┌─────────────────┐
                                               │ Google Gemini   │
                                               │ (LLM & Embedding)│
                                               └─────────────────┘
```

## 🚀 Technology Stack

### Frontend & Backend
- **Frontend**: Modern web application (.NET Core/HTML/CSS/JavaScript)
- **Backend**: n8n webhook url with aichatbot endpoint
- **Deployment**: Azure App Service with continuous deployment

### AI & Automation
- **Workflow Engine**: n8n (deployed on Azure Container Apps)
- **LLM**: Google Gemini Chat Model
- **Embeddings**: Google Gemini Embedding Model
- **Vector Database**: Pinecone
- **Memory**: Buffer Window Memory (15 context length)

### Data & Storage
- **Logging**: Airtable
- **Document Storage**: Local file system with auto-processing
- **Session Management**: Custom session handling

## 📋 Prerequisites

- Azure subscription
- n8n instance (self-hosted or cloud)
- Google AI Studio API key
- Pinecone account and API key
- Airtable account and API token

## 🛠️ Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/MoreVijayP/ai-assistant-portfolio.git
cd ai-portfolio-chatbot
```

### 2. Environment Configuration

Create `.env` file in the root directory:

```env
# Google AI Studio
GOOGLE_AI_API_KEY=your_google_ai_api_key

# Pinecone Configuration
PINECONE_API_KEY=your_pinecone_api_key
PINECONE_INDEX_NAME=portfolio

# Airtable Configuration
AIRTABLE_API_TOKEN=your_airtable_token
AIRTABLE_BASE_ID=your_base_id
AIRTABLE_TABLE_ID=your_table_id

# Azure Configuration
AZURE_SUBSCRIPTION_ID=your_subscription_id
AZURE_RESOURCE_GROUP=your_resource_group
AZURE_WEB_APP_NAME=your_web_app_name

# n8n Configuration
N8N_WEBHOOK_URL=your_n8n_webhook_url
```

### 3. Deploy to Azure

#### Web Application Deployment

```bash
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
```

#### n8n Workflow Deployment

```bash
# Create Container App Environment
az containerapp env create --name n8n-env --resource-group portfolio-chatbot-rg --location eastus

# Deploy n8n container
az containerapp create \
  --name n8n-workflows \
  --resource-group portfolio-chatbot-rg \
  --environment n8n-env \
  --image n8nio/n8n:latest \
  --env-vars N8N_HOST=0.0.0.0 N8N_PORT=5678 \
  --ingress external \
  --target-port 5678
```

### 4. Import n8n Workflows

1. Access your n8n instance
2. Import the workflow files:
   - `workflows/vij-ai-chatbot.json` - Main chatbot workflow
   - `workflows/EmbeddingPDFtoVector.json` - Document processing workflow

### 5. Configure Workflow Credentials

Set up the following credentials in n8n:
- Google Gemini API
- Pinecone API
- Airtable Token API

## 📁 Project Structure

```
ai-assistant-portfolio/

├── 📁 workflows/
│   ├── vij-ai-chatbot.json
│   └── EmbeddingPDFtoVector.json
├── 📁 data/
│   └── portfolio-documents/
├── 📁 docs/
│   ├── API.md
│   └── DEPLOYMENT.md
├── 📁 scripts/
│   └── deploy.sh
├── .env.example
├── package.json
├── README.md
└── azure-pipelines.yml
```

## 🔄 Workflow Details

### Main Chatbot Workflow (`vij-ai-chatbot.json`)

**Components:**
1. **Webhook Trigger**: Receives POST/GET requests
2. **AI Agent**: Core conversation handler with custom prompt
3. **Google Gemini Chat Model**: Language model for responses
4. **Simple Memory**: Maintains conversation context (15 messages)
5. **Pinecone Vector Store**: Retrieves relevant portfolio information
6. **Response Processing**: Formats output as JSON with HTML
7. **Airtable Logging**: Records all interactions

**Prompt Engineering:**
- Professional AI assistant specialized in portfolio information
- Uses retrieved context from Pinecone vector database
- Responds in structured HTML format with bullet points
- Maintains recruiter-friendly tone
- Limits responses to 3 short paragraphs

### Document Processing Workflow (`EmbeddingPDFtoVector.json`)

**Components:**
1. **Local File Trigger**: Monitors `C:\portfoliodata` folder
2. **File Reader**: Processes new PDF/DOCX files
3. **Document Loader**: Extracts and chunks text content
4. **Google Gemini Embeddings**: Converts text to vector embeddings
5. **Pinecone Storage**: Stores embeddings for retrieval

## 💬 API Usage

### Chat Endpoint

```javascript
POST /aichatbot
Content-Type: application/json

{
  "sessionId": "unique-session-id",
  "message": "Tell me about your projects"
}
```

### Response Format

```json
{
  "reply": "<p>Here's an overview of my key projects:</p><ul><li>Real Estate Lead Manager - Automated lead processing</li><li>AI Portfolio Chatbot - This current project</li></ul><p>Would you like to know more about any specific project?</p>"
}
```

## 🔧 Customization

### Adding New Portfolio Data

1. Place PDF/DOCX files in the monitored folder
2. The embedding workflow automatically processes new files
3. Files are chunked and stored in Pinecone vector database

### Modifying AI Behavior

Edit the prompt in the AI Agent node:
- Adjust tone and personality
- Modify response format
- Change conversation limits
- Update context usage instructions


## 📊 Analytics & Monitoring

### Conversation Analytics
- All interactions logged in Airtable
- Session tracking and user journey analysis
- Popular question identification

### Performance Monitoring
- Azure Application Insights integration
- Vector search performance metrics
- API response time tracking
- Error rate monitoring

## 🔒 Security Features

- Session-based conversation management
- API rate limiting
- Secure credential management
- CORS protection

## 🚀 Deployment Options

### Azure (Recommended)
- Web App + Container Apps architecture
- Auto-scaling capabilities
- Integrated monitoring
- CI/CD pipeline support

### Alternative Deployments
- Docker containers
- Kubernetes clusters
- Serverless functions
- Self-hosted solutions

## 📈 Scaling Considerations

- **Vector Database**: Pinecone handles large-scale embeddings
- **Memory Management**: Buffer window prevents context overflow
- **API Limits**: Configure rate limiting based on usage
- **Storage**: Monitor Airtable record limits

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📧 Email: morevijay.1990@gmail.com
- 💼 LinkedIn: [[Your LinkedIn Profile]](https://www.linkedin.com/in/morevijay/)

## 🙏 Acknowledgments

- n8n community for workflow automation
- Google AI for Gemini models
- Pinecone for vector database
- Airtable for data logging
- Azure for cloud infrastructure

---

**Made by Vijay More - Showcasing the power of AI automation and modern web development**
