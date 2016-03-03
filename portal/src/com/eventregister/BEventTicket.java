package com.eventregister;
public class BEventTicket{
private String m_TicketName=null;
private String m_TickId=null;
private double m_TicketPrice=0.0;
private double m_ProcessFee=0.0;
private double m_TicketDisplayPrice=0.0;
private int m_MinQty=0;
private int m_MaxQty=0;
private int m_Capacity=0;
private int m_SoldQty=0;
private String m_StartDate=null;
private String m_StartTime=null;
private String m_EndTime=null;
private String m_EndDate=null;
private String m_Start_Status=null;
private String m_End_Status=null;
private String m_Sold_Status=null;
private String m_ticketDescription=null;
private boolean isMemberTicket=false;
private String TicketStatus=null;
private String m_tickettype=null;

public void setTicketStatus(String p_ticketStatus){
TicketStatus=p_ticketStatus;
}

public String getTicketStatus(){
return TicketStatus;
}


public String getTicketName(){
return m_TicketName;
}
public void setTicketName(String p_TicketName){

 m_TicketName=p_TicketName;

}


public String getTicketId(){

return m_TickId;

}

public void setTicketId(String p_TickId){

 m_TickId=p_TickId;

}
public double getTicketPrice(){

return m_TicketPrice;

}

public void setTicketPrice(double p_TicketPrice){

 m_TicketPrice=p_TicketPrice;

}

public double getTicketProcessFee(){

return m_ProcessFee;

}

public void setTicketProcessFee(double p_ProcessFee){

 m_ProcessFee=p_ProcessFee;

}

public int getTicketMinQty(){

return m_MinQty;

}

public void setTicketMinQty(int p_MinQty){

 m_MinQty=p_MinQty;

}

public int getTicketMaxQty(){

return m_MaxQty;

}

public void setTicketMaxQty(int p_MaxQty){
 m_MaxQty=p_MaxQty;
}


public int getTicketCapacity(){
return m_Capacity;
}

public void setTicketCapacity(int p_Capacity){
 m_Capacity=p_Capacity;
}

public int getTicketSoldQty(){
return m_SoldQty;
}

public void setTicketSoldQty(int p_SoldQty){
 m_SoldQty=p_SoldQty;
}

public String getTicketStartDate(){
return m_StartDate;
}

public void setTicketStartDate(String p_StartDate){
 m_StartDate=p_StartDate;
}

public String getTicketEndDate(){
return m_EndDate;
}

public void setTicketEndDate(String p_EndDate){
 m_EndDate=p_EndDate;
}


public void setTicketStartTime(String p_StartTime){
 m_StartTime=p_StartTime;
}

public String getTicketStartTime(){
return m_StartTime;
}

public String getTicketEndTime(){
return m_EndTime;
}

public void setTicketEndTime(String p_EndTime){
 m_EndTime=p_EndTime;
}

public String getStartStatus(){
return m_Start_Status;
}

public void setStartStatus(String p_Start_Status){
 m_Start_Status=p_Start_Status;
}

public String getEndStatus(){
return m_End_Status;
}

public void setEndStatus(String p_End_Status){
 m_End_Status=p_End_Status;
}

public String getSoldStatus(){
return m_Sold_Status;
}

public void setSoldStatus(String p_Sold_Status){
 m_End_Status=p_Sold_Status;
}


public String getTicketType(){
return m_tickettype;
}

public void setTicketType(String type){
 m_tickettype=type;
}



public void setTicketDisplayPrice(double price){
m_TicketDisplayPrice=price;
}

public double getTicketDisplayPrice(){
return m_TicketDisplayPrice;
}

public void setTicketDescription(String p_ticketDescription){
m_ticketDescription=p_ticketDescription;
}

public String getTicketDescription(){
return m_ticketDescription;
}

public boolean isMemberTicket(){

return isMemberTicket;
}

public void setMemberTicketFlag(boolean isMemberTicket){
this.isMemberTicket=isMemberTicket;
}

}