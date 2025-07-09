#!/bin/bash

# Start FastAPI (Uvicorn) in the background
uvicorn main:app --host 0.0.0.0 --port 9000 &

# Start Streamlit dashboard
streamlit run streamlit_dashboard/dashboard.py --server.port 8501 --server.address 0.0.0.0 