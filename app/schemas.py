from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class EmployeeCreate(BaseModel):
    name: str
    email: str
    position: Optional[str] = None

class EmployeeRead(EmployeeCreate):
    id: int

class RoomCreate(BaseModel):
    name: str
    location: Optional[str] = None
    capacity: Optional[int] = None

class RoomRead(RoomCreate):
    id: int

class BookingCreate(BaseModel):
    title: str
    start: datetime
    end: datetime
    employee_id: Optional[int]
    room_id: Optional[int]

class BookingRead(BookingCreate):
    id: int
