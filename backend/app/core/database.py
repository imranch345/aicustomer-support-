import datetime
from typing import Dict, List, Any

# Mock Database State
users_db: Dict[str, Dict[str, Any]] = {
    "usr_1": {
        "id": "usr_1",
        "name": "John Doe",
        "email": "john.doe@example.com",
        "role": "client",
        "avatarUrl": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=256&auto=format&fit=crop",
        "companyId": "comp_1"
    },
    "usr_admin": {
        "id": "usr_admin",
        "name": "Administrator",
        "email": "admin@example.com",
        "role": "admin",
        "avatarUrl": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=256&auto=format&fit=crop",
        "companyId": None
    }
}

companies_db: Dict[str, Dict[str, Any]] = {
    "comp_1": {
        "id": "comp_1",
        "name": "Acme Corp",
        "domain": "acme.com",
        "plan": "premium",
        "createdAt": (datetime.datetime.now() - datetime.timedelta(days=30)).isoformat()
    }
}

tickets_db: List[Dict[str, Any]] = [
    {
        "id": "tkt_101",
        "title": "Billing issue on invoice #1042",
        "description": "I was charged twice for this month's subscription. Please refund the duplicate transaction.",
        "status": "open",
        "priority": "high",
        "createdAt": (datetime.datetime.now() - datetime.timedelta(hours=4)).isoformat(),
        "updatedAt": (datetime.datetime.now() - datetime.timedelta(hours=4)).isoformat(),
        "userId": "usr_1",
        "assignedAgentId": "agent_1",
        "messages": [
            {
                "id": "msg_1",
                "content": "Hello, I noticed a double charge on my account.",
                "timestamp": (datetime.datetime.now() - datetime.timedelta(hours=4)).isoformat(),
                "sender": "user",
                "senderName": "John Doe"
            },
            {
                "id": "msg_2",
                "content": "Thank you for reaching out John. We have assigned this to our billing specialist.",
                "timestamp": (datetime.datetime.now() - datetime.timedelta(hours=3, minutes=45)).isoformat(),
                "sender": "system",
                "senderName": "System"
            }
        ]
    },
    {
        "id": "tkt_102",
        "title": "API integration returning 500 error",
        "description": "When calling the webhook endpoint /v1/events, we are getting a 500 internal server error.",
        "status": "inProgress",
        "priority": "urgent",
        "createdAt": (datetime.datetime.now() - datetime.timedelta(days=1)).isoformat(),
        "updatedAt": (datetime.datetime.now() - datetime.timedelta(hours=2)).isoformat(),
        "userId": "usr_1",
        "assignedAgentId": "agent_2",
        "messages": [
            {
                "id": "msg_3",
                "content": "The endpoint /v1/events crashes under load.",
                "timestamp": (datetime.datetime.now() - datetime.timedelta(days=1)).isoformat(),
                "sender": "user",
                "senderName": "John Doe"
            },
            {
                "id": "msg_4",
                "content": "Hey John, I am looking into the stack trace right now. It seems to be a database deadlock issue.",
                "timestamp": (datetime.datetime.now() - datetime.timedelta(hours=2)).isoformat(),
                "sender": "agent",
                "senderName": "Sarah Jenkins (Support Agent)"
            }
        ]
    },
    {
        "id": "tkt_103",
        "title": "How to update billing email?",
        "description": "Can I add multiple email recipients for monthly invoices?",
        "status": "resolved",
        "priority": "low",
        "createdAt": (datetime.datetime.now() - datetime.timedelta(days=5)).isoformat(),
        "updatedAt": (datetime.datetime.now() - datetime.timedelta(days=4)).isoformat(),
        "userId": "usr_1",
        "assignedAgentId": "agent_1",
        "messages": [
            {
                "id": "msg_5",
                "content": "I want to add my accounting team to invoice notifications.",
                "timestamp": (datetime.datetime.now() - datetime.timedelta(days=5)).isoformat(),
                "sender": "user",
                "senderName": "John Doe"
            },
            {
                "id": "msg_6",
                "content": "You can configure billing recipients under Settings > Billing > Email Notifications. I have resolved this ticket, let me know if you need anything else.",
                "timestamp": (datetime.datetime.now() - datetime.timedelta(days=4)).isoformat(),
                "sender": "agent",
                "senderName": "Sarah Jenkins (Support Agent)"
            }
        ]
    }
]
