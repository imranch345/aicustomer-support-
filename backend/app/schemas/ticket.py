from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel
from app.schemas.message import MessageModel

class TicketModel(BaseModel):
    id: str
    title: str
    description: str
    status: str  # open, inProgress, resolved
    priority: str  # low, medium, high, urgent
    createdAt: datetime
    updatedAt: datetime
    userId: str
    assignedAgentId: Optional[str] = None
    messages: List[MessageModel] = []

class TicketCreate(BaseModel):
    title: str
    description: str
    priority: str
