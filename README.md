# Email Parsing & Company Research App

A full-stack application to fetch unread emails, extract company names, and perform automated research and credibility scoring using OpenAI and Serper APIs. Includes a FastAPI backend and a Streamlit dashboard for interactive analysis.

---

## 🚀 Features
- Fetch unread emails from your inbox (Gmail supported)
- Extract company names from emails
- Research companies using OpenAI and Serper
- Compute credibility scores and display key insights
- Interactive Streamlit dashboard for visualization
- SQLite database for persistent storage

---

## 🗂️ Project Structure
```
email-parsing/
│
├── app/                    # Backend code (API, models, services, utils, core)
├── streamlit_dashboard/    # Streamlit dashboard (dashboard.py)
├── requirements.txt        # Python dependencies
├── run_project.bat         # Batch script to set up and run everything
├── main.py                 # FastAPI entry point
├── .gitignore              # Git ignore rules
├── app.db                  # SQLite database (auto-created)
├── venv/                   # Python virtual environment (not in git)
```

---

## ⚡ Quickstart

### 1. Clone the repository
```
git clone <your-repo-url>
cd email-parsing
```

### 2. Set up your environment
- **Create a `.env` file** in the root with your credentials:
  ```
  EMAIL_ADDRESS=your@email.com
  APP_PASSWORD=your_app_password
  openai_api_key=sk-...
  serper_api_key=...
  ```
- **(Optional)**: Edit `requirements.txt` if you need extra packages.

### 3. Run the project (Windows)
```
run_project.bat
```
- This will create a virtual environment, install dependencies, start FastAPI, and prompt to launch Streamlit.

### 4. Access the app
- **FastAPI docs:** [http://127.0.0.1:9000/docs](http://127.0.0.1:9000/docs)
- **Streamlit dashboard:** [http://localhost:8501](http://localhost:8501)

---

## 🛠️ Manual Commands

**Activate venv:**
```
.\venv\Scripts\activate
```
**Install dependencies:**
```
pip install -r requirements.txt
```
**Run FastAPI:**
```
uvicorn main:app --reload --port 9000
```
**Run Streamlit:**
```
streamlit run streamlit_dashboard/dashboard.py
```

---

## 📝 Notes
- Only the first unread email is processed per request (configurable in code).
- All sensitive info should be kept in `.env` (never commit to git).
- The `venv/` and `app.db` files are ignored by git via `.gitignore`.

---

## 📄 License
MIT License (add your own if needed) 

---

## 🐳 Docker Usage

### 1. Build the Docker image
```
docker build -t agentic-email-intel .
```

### 2. Run the container (with .env file)
```
docker run --env-file .env -p 9000:9000 -p 8501:8501 agentic-email-intel
```

- FastAPI docs: [http://localhost:9000/docs](http://localhost:9000/docs)
- Streamlit dashboard: [http://localhost:8501](http://localhost:8501)

--- 