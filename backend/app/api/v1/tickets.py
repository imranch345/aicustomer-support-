import datetime
import uuid
from typing import List
from fastapi import APIRouter, HTTPException, status
from app.core.database import tickets_db
from app.schemas.ticket import TicketModel, TicketCreate
from app.schemas.message import MessageModel, MessageCreate

router = APIRouter()

@router.get("", response_model=List[TicketModel])
def get_tickets():
    return tickets_db

@router.post("", response_model=TicketModel)
def create_ticket(payload: TicketCreate):
    ticket_id = f"tkt_{uuid.uuid4().hex[:6]}"
    now = datetime.datetime.now().isoformat()
    
    first_message = {
        "id": f"msg_{uuid.uuid4().hex[:8]}",
        "content": payload.description,
        "timestamp": now,
        "sender": "user",
        "senderName": "John Doe" # Mock current user
    }
    
    new_ticket = {
        "id": ticket_id,
        "title": payload.title,
        "description": payload.description,
        "status": "open",
        "priority": payload.priority,
        "createdAt": now,
        "updatedAt": now,
        "userId": "usr_1", # Mock current user ID
        "assignedAgentId": None,
        "messages": [first_message]
    }
    
    # Insert at the beginning of the list to match Flutter's insert(0, newTicket)
    tickets_db.insert(0, new_ticket)
    return TicketModel(**new_ticket)

@router.post("/{ticket_id}/messages", response_model=TicketModel)
def add_message(ticket_id: str, payload: MessageCreate):
    # Find ticket
    target_ticket = None
    for ticket in tickets_db:
        if ticket["id"] == ticket_id:
            target_ticket = ticket
            break
            
    if not target_ticket:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Ticket not found"
        )
        
    now = datetime.datetime.now().isoformat()
    sender_name = "User" if payload.sender == "user" else "Support Agent"
    
    new_message = {
        "id": f"msg_{uuid.uuid4().hex[:8]}",
        "content": payload.content,
        "timestamp": now,
        "sender": payload.sender,
        "senderName": sender_name
    }
    
    target_ticket["messages"].append(new_message)
    target_ticket["updatedAt"] = now
    target_ticket["status"] = "open" if payload.sender == "user" else "inProgress"
    
    return TicketModel(**target_ticket)
