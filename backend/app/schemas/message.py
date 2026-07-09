from datetime import datetime
from pydantic import BaseModel

class MessageModel(BaseModel):
    id: str
    content: str
    timestamp: datetime
    sender: str  # user, agent, system, bot
    senderName: str

class MessageCreate(BaseModel):
    content: str
    sender: str = "user"
