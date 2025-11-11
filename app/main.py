from fastapi import FastAPI, Depends, HTTPException
from sqlmodel import Session
from . import models, crud
from .database import init_db, get_session
from .schemas import EmployeeCreate, EmployeeRead, BookingCreate, BookingRead, RoomCreate, RoomRead

app = FastAPI(title="HR App")

@app.on_event("startup")
def on_startup():
    """Initialize the database when app starts."""
    init_db()

@app.post("/employees", response_model=EmployeeRead)
def create_employee(payload: EmployeeCreate, session: Session = Depends(get_session)):
    emp = models.Employee.from_orm(payload)
    return crud.create_employee(session, emp)

@app.post("/rooms", response_model=RoomRead)
def create_room(payload: RoomCreate, session: Session = Depends(get_session)):
    room = models.MeetingRoom.from_orm(payload)
    return crud.create_room(session, room)

@app.post("/bookings", response_model=BookingRead)
def create_booking(payload: BookingCreate, session: Session = Depends(get_session)):
    booking = models.Booking.from_orm(payload)
    try:
        return crud.create_booking(session, booking)
    except ValueError as e:
        raise HTTPException(status_code=409, detail=str(e))

@app.get("/bookings", response_model=list[BookingRead])
def list_bookings(session: Session = Depends(get_session)):
    """List all bookings."""
    return session.exec(models.Booking.select()).all()
