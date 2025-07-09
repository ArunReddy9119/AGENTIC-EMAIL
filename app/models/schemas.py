from pydantic import BaseModel, EmailStr
from typing import List, Optional, Any, Dict
from datetime import datetime
from sqlalchemy import Column, Integer, String, DateTime
from app.core.database import Base


class ConnectResponse(BaseModel):
    success: bool
    message: str


class Email(Base):
    __tablename__ = "emails"
    id = Column(Integer, primary_key=True, index=True)
    sender = Column(String, index=True)
    recipient = Column(String, index=True)
    subject = Column(String)
    body = Column(String)
    timestamp = Column(DateTime, default=datetime.utcnow)


class EmailResponse(BaseModel):
    id: int
    sender: str
    recipient: str
    subject: str
    body: str
    timestamp: datetime

    class Config:
        from_attributes = True


class FetchEmailsResponse(BaseModel):
    emails: List[EmailResponse]


class CompanyProfile(BaseModel):
    name: str
    description: Optional[str]
    website: Optional[str]


class CredibilityScore(BaseModel):
    score: float  # 🔁 Changed from int to float
    raw_metrics: Dict[str, Any]  # e.g., {"age_years": 5, "market_cap": 1e9}
    score_breakdown: Dict[str, float]  # e.g., {"age": 7.5, "market_cap": 10.0}


class ResearchReport(BaseModel):
    report_id: str
    company_name: str
    research_date: datetime
    overall_status: str
    completion_percentage: float
    company_profile: CompanyProfile
    products_services: Optional[List[Any]]
    market_analysis: Optional[Any]
    financial_metrics: Optional[List[Any]]
    key_insights: Optional[List[str]]
    recommendations: Optional[List[str]]
    credibility: Optional[CredibilityScore]
