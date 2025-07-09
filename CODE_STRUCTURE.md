# Code Structure & Developer Guide

This document explains the architecture, main components, and code flow of the **Email Parsing & Company Research App**. It is intended for developers who want to understand, maintain, or extend the project.

---

## 📁 Directory Overview

```
email-parsing/
│
├── app/                    # All backend (FastAPI) code
│   ├── api/                # API routers and endpoint logic
│   │   ├── api.py          # (Optional) API router setup
│   │   ├── deps.py         # Dependency injection for endpoints
│   │   └── endpoints/      # Individual API endpoint modules
│   │       ├── connect.py      # Gmail connection endpoint
│   │       ├── fetch.py        # Fetch unread emails endpoint
│   │       ├── orchestrate.py  # Orchestrate research workflow
│   │       ├── report.py       # Generate and return reports
│   │       ├── research.py     # Research a single company
│   │       └── __init__.py
│   │
│   ├── core/               # Core config, database, and logging
│   │   ├── config.py           # Loads settings from .env
│   │   ├── database.py         # SQLAlchemy setup (engine, session)
│   │   └── logging_config.py   # Custom logging setup
│   │
│   ├── models/             # Data models (Pydantic & SQLAlchemy)
│   │   └── schemas.py          # Email, Company, ResearchReport, etc.
│   │
│   ├── services/           # Business logic and integrations
│   │   ├── email_parser.py     # Parses raw emails
│   │   ├── email_reader.py     # Reads emails from IMAP
│   │   ├── gmail_service.py    # Gmail-specific IMAP logic
│   │   └── research_engine.py  # Orchestrates OpenAI/Serper research
│   │
│   └── utils/              # Helper utilities
│       ├── credibility.py      # Credibility scoring logic
│       ├── extract.py          # Company name extraction
│       ├── report_generator.py # Markdown report formatting
│       └── tools.py            # Miscellaneous tools
│
├── streamlit_dashboard/    # Streamlit UI
│   └── dashboard.py            # Main dashboard app
│
├── main.py                 # FastAPI app entry point
├── requirements.txt         # Python dependencies
├── run_project.bat          # Windows batch script for setup/run
├── .gitignore               # Git ignore rules
├── app.db                   # SQLite database (auto-created)
├── venv/                    # Python virtual environment (not in git)
```

---

## 🧩 Main Components & Flow

### 1. **FastAPI Backend (`app/` and `main.py`):**
- **`main.py`**: Initializes FastAPI, includes all routers, and creates DB tables.
- **`app/api/endpoints/`**: Each file is a REST endpoint (e.g., `/fetch/`, `/orchestrate/`).
- **`app/services/`**: Contains the logic for reading emails, parsing, and running research (OpenAI, Serper).
- **`app/models/schemas.py`**: Defines all data models (emails, companies, research reports) using Pydantic and SQLAlchemy.
- **`app/core/`**: Handles configuration, database connection, and logging.
- **`app/utils/`**: Helper functions for credibility scoring, extraction, and report formatting.

### 2. **Streamlit Dashboard (`streamlit_dashboard/dashboard.py`):**
- Connects to FastAPI endpoints to fetch emails and research results.
- Provides a user-friendly UI to trigger parsing, view company research, and see credibility scores.
- Handles errors and loading states for a smooth user experience.

### 3. **Database (`app.db`):**
- SQLite database for storing parsed emails and research results.
- Managed via SQLAlchemy (see `app/core/database.py`).

### 4. **Batch Script (`run_project.bat`):**
- Automates environment setup, dependency installation, and app launch.
- Prompts to start Streamlit after FastAPI is running.

---

## 🔄 **Typical Workflow**

1. **User launches the app** (via batch file or manually).
2. **User opens the Streamlit dashboard** and clicks a button to fetch emails or run research.
3. **Streamlit sends a request to FastAPI** (e.g., `/fetch/` or `/orchestrate/orchestrate/`).
4. **FastAPI endpoint**:
    - Reads unread emails (via Gmail IMAP)
    - Extracts company names
    - Runs research (OpenAI, Serper)
    - Computes credibility scores
    - Stores and returns results
5. **Streamlit displays results** (company profiles, scores, insights, recommendations).

---

## 📝 **Extending the Project**
- **Add new endpoints:** Create a new file in `app/api/endpoints/` and register it in `main.py`.
- **Add new models:** Define in `app/models/schemas.py`.
- **Add new services/integrations:** Place logic in `app/services/`.
- **Add new UI features:** Edit `streamlit_dashboard/dashboard.py`.

---

## 🛡️ **Security & Secrets**
- All sensitive info (API keys, email credentials) should be in `.env` (never commit to git).
- The app uses Pydantic settings to load secrets securely.

---

## 📚 **References**
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Streamlit Documentation](https://docs.streamlit.io/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [Pydantic Documentation](https://docs.pydantic.dev/)

---

For any questions, see the code comments or open an issue. Happy coding! 

---

## 🛠️ Detailed Explanation: `app/services/` Directory

This directory contains the core business logic and integrations for the application. Each file is responsible for a specific part of the email parsing and research workflow.

### 1. `email_reader.py`
- **Purpose:** Handles connecting to the email server (IMAP), authenticating, and fetching unread emails.
- **Key Logic:**
  - Uses credentials from settings to connect to Gmail (or other IMAP servers).
  - Fetches unread emails and returns them as raw email objects or dictionaries.
  - Handles connection errors and authentication failures gracefully.
- **Typical Usage:** Called by API endpoints to retrieve new emails for processing.

### 2. `gmail_service.py`
- **Purpose:** Provides Gmail-specific logic for IMAP operations.
- **Key Logic:**
  - Implements methods to connect, authenticate, and fetch emails using Gmail's IMAP server.
  - May include logic for handling Gmail-specific quirks (labels, threading, etc.).
  - Returns raw email data for further parsing.
- **Typical Usage:** Used by `email_reader.py` and API endpoints to interact with Gmail accounts.

### 3. `email_parser.py`
- **Purpose:** Parses raw email data into structured information.
- **Key Logic:**
  - Extracts sender, recipient, subject, body, and timestamp from raw email objects.
  - Cleans and normalizes email content for downstream processing.
  - Converts raw emails into Pydantic models for use in API responses and database storage.
- **Typical Usage:** Used after fetching emails to prepare them for company extraction and research.

### 4. `research_engine.py`
- **Purpose:** Orchestrates the research and credibility scoring process for extracted companies.
- **Key Logic:**
  - Integrates with OpenAI (for LLM-based research) and Serper (for web search).
  - For each company name:
    - Searches for company info using Serper.
    - Prompts OpenAI to generate a company profile and estimate metrics (market cap, employees, etc.).
    - Computes credibility scores using custom logic (see `utils/credibility.py`).
    - Assembles a `ResearchReport` with all findings, insights, and recommendations.
  - Handles errors and logs progress for each research step.
- **Typical Usage:** Called by the orchestration endpoint to process companies extracted from emails.

---

**In summary:**
- `email_reader.py` and `gmail_service.py` handle email fetching.
- `email_parser.py` turns raw emails into structured data.
- `research_engine.py` performs company research, scoring, and report generation using AI and web search.

For more details, see code comments in each file or the API endpoint logic that uses these services. 