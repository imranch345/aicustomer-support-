from datetime import datetime
from typing import Optional
from pydantic import BaseModel

class CompanyModel(BaseModel):
    id: str
    name: str
    domain: str
    plan: str
    createdAt: datetime
