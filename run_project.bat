@echo off
REM === Ensure we are in the project root ===
cd /d %~dp0

REM === Create virtual environment if it doesn't exist ===
if not exist venv (
    echo Creating virtual environment...
    python -m venv venv
)

REM === Activate virtual environment ===
echo Activating virtual environment...
call venv\Scripts\activate

REM === Upgrade pip ===
echo Upgrading pip...
pip install --upgrade pip

REM === Install/upgrade compatible dependencies ===
echo Ensuring compatible versions of langchain, langchain-core, openai, and langchain-openai...
pip install "langchain>=0.3.26,<1.0.0" "langchain-core>=0.3.66,<1.0.0" "openai>=1.86.0,<2.0.0" "langchain-openai>=0.3.27,<1.0.0" --upgrade

REM === Install all requirements ===
echo Installing dependencies...
pip install -r requirements.txt

REM === Start FastAPI app on port 9000 in a new window ===
echo Starting FastAPI app on port 9000 in a new window...
start cmd /k "call venv\Scripts\activate && uvicorn main:app --reload --port 9000"

REM === Ask user if they want to start Streamlit dashboard ===
echo.
echo Would you like to start the Streamlit dashboard? (Y/N)
choice /C YN /M "Start Streamlit dashboard?"
if errorlevel 2 goto end
if errorlevel 1 goto streamlit

:streamlit
echo.
echo If you make code changes, please restart Streamlit to see updates.
echo Running: streamlit run streamlit_dashboard/dashboard.py
streamlit run streamlit_dashboard/dashboard.py

goto end

:end
pause 