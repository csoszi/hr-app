from typing import Optional, List
from sqlmodel import SQLModel, Field, Relationship
from datetime import datetime

class Employee(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    email: str
    position: Optional[str] = None

    bookings: List["Booking"] = Relationship(back_populates="employee")

class MeetingRoom(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    location: Optional[str] = None
    capacity: Optional[int] = None

    bookings: List["Booking"] = Relationship(back_populates="room")

class Booking(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    title: str
    start: datetime
    end: datetime
    employee_id: Optional[int] = Field(foreign_key="employee.id")
    room_id: Optional[int] = Field(foreign_key="meetingroom.id")

    employee: Optional[Employee] = Relationship(back_populates="bookings")
    room: Optional[MeetingRoom] = Relationship(back_populates="bookings")
