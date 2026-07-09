import uuid
from fastapi import APIRouter, HTTPException, status
from app.core.database import users_db
from app.schemas.auth import UserModel, LoginRequest, SignupRequest

router = APIRouter()

@router.post("/login", response_model=UserModel)
def login(payload: LoginRequest):
    email = payload.email.lower()
    
    # Simulate matching logic from Flutter's ApiService
    if "admin" in email:
        user_id = "usr_admin"
    else:
        user_id = "usr_1"
        
    if user_id not in users_db:
        # Create user on the fly if not exists (to match Flutter test behaviour)
        users_db[user_id] = {
            "id": user_id,
            "name": "John Doe",
            "email": payload.email,
            "role": "client",
            "avatarUrl": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=256&auto=format&fit=crop",
            "companyId": "comp_1"
        }
    
    return UserModel(**users_db[user_id])

@router.post("/signup", response_model=UserModel)
def signup(payload: SignupRequest):
    # Check if user already exists in db
    for user in users_db.values():
        if user["email"].lower() == payload.email.lower():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="User with this email already exists"
            )
            
    new_id = f"usr_{uuid.uuid4().hex[:6]}"
    new_user = {
        "id": new_id,
        "name": payload.name,
        "email": payload.email,
        "role": "client",
        "avatarUrl": None,
        "companyId": None
    }
    users_db[new_id] = new_user
    return UserModel(**new_user)

@router.post("/logout")
def logout():
    return {"message": "Logged out successfully"}
