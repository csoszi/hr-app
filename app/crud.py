from sqlmodel import select, Session
from .models import Employee, MeetingRoom, Booking
from datetime import datetime

def create_employee(session: Session, employee: Employee) -> Employee:
    session.add(employee)
    session.commit()
    session.refresh(employee)
    return employee

def create_room(session: Session, room: MeetingRoom) -> MeetingRoom:
    session.add(room)
    session.commit()
    session.refresh(room)
    return room

def is_conflict(session: Session, room_id: int, start: datetime, end: datetime) -> bool:
    q = select(Booking).where(Booking.room_id == room_id, Booking.end > start, Booking.start < end)
    return session.exec(q).first() is not None

def create_booking(session: Session, booking: Booking) -> Booking:
    if booking.room_id and is_conflict(session, booking.room_id, booking.start, booking.end):
        raise ValueError("Time conflict for room")
    session.add(booking)
    session.commit()
    session.refresh(booking)
    return booking
