# Customer Support Backend (FastAPI)

A lightweight FastAPI project that provides a backend for the Customer Support Application. It features in-memory mock data, input validation via Pydantic, and REST API endpoints.

## Directory Structure

```
backend/
├── app/
│   ├── main.py                     # Entry point (CORS, app creation)
│   ├── core/
│   │   ├── config.py               # Application settings
│   │   └── database.py             # Mock in-memory state
│   ├── schemas/                    # Pydantic validation schemas
│   │   ├── auth.py
│   │   ├── company.py
│   │   ├── message.py
│   │   └── ticket.py
│   └── api/
│       └── v1/                     # Versioned API routes
│           ├── auth.py             # Login, signup, logout
│           ├── tickets.py          # View/create tickets & messages
│           └── chatbot.py          # Bot responses
├── requirements.txt                # Dependencies
└── README.md                       # Setup instructions
```

## Setup & Running

1. **Navigate to the backend directory:**
   ```bash
   cd backend
   ```

2. **Create a virtual environment (optional but recommended):**
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the development server:**
   ```bash
   python -m uvicorn app.main:app --reload --port 8000
   ```

## Interactive API Docs

Once running, navigate to:
- Swagger UI docs: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
- ReDoc: [http://127.0.0.1:8000/redoc](http://127.0.0.1:8000/redoc)
