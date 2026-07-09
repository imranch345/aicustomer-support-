from typing import Optional
from pydantic import BaseModel, EmailStr

class UserModel(BaseModel):
    id: str
    name: str
    email: EmailStr
    role: str  # client, admin, agent, etc.
    avatarUrl: Optional[str] = None
    companyId: Optional[str] = None

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class SignupRequest(BaseModel):
    name: str
    email: EmailStr
    password: str
