from sqlmodel import SQLModel, create_engine, Session
import os

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./hr_app.db")

engine = create_engine(DATABASE_URL, echo=True)

def init_db():
    """Create all database tables on startup."""
    SQLModel.metadata.create_all(engine)

def get_session():
    """Dependency for FastAPI routes to get a DB session."""
    with Session(engine) as session:
        yield session
