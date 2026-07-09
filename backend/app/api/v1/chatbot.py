import datetime
import uuid
from pydantic import BaseModel
from fastapi import APIRouter
from app.schemas.message import MessageModel

router = APIRouter()

class ChatbotRequest(BaseModel):
    message: str

@router.post("/message", response_model=MessageModel)
def get_chatbot_response(payload: ChatbotRequest):
    clean_msg = payload.message.lower()
    
    if "billing" in clean_msg or "invoice" in clean_msg or "payment" in clean_msg:
        bot_reply = 'For billing concerns, invoices, or subscription refunds, you can check the "Billing" section in Settings. Alternatively, would you like me to open a Billing support ticket for you?'
    elif "ticket" in clean_msg or "open support" in clean_msg:
        bot_reply = 'You can easily open a ticket by navigating to the "Tickets" screen from the home dashboard and tapping the "+" button. I can also collect some details and open one right here if you prefer!'
    elif "human" in clean_msg or "live chat" in clean_msg or "agent" in clean_msg:
        bot_reply = 'Sure! I can connect you to a live support agent. Please head over to the "Live Chat" section from the Home screen to start a real-time messaging session with a support engineer.'
    elif "hello" in clean_msg or "hi" in clean_msg:
        bot_reply = 'Hello! I am your SupportSync Assistant. How can I help you today? You can ask me about billing, opening tickets, or connecting to a live representative.'
    else:
        bot_reply = f'I understand you have a question about "{payload.message}". You can browse our FAQs in the Help Center, open a ticket in the Tickets tab, or request to chat with a live agent.'

    return MessageModel(
        id=f"msg_{uuid.uuid4().hex[:8]}",
        content=bot_reply,
        timestamp=datetime.datetime.now(),
        sender="bot",
        senderName="Support Bot"
    )
