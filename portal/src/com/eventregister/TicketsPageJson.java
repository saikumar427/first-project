package com.eventregister;
//import org.json.*;
import java.util.Arrays;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONObject;

//import com.eventbee.general.DBManager;
import com.event.dbhelpers.DisplayAttribsDB;
import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.general.formatting.CurrencyFormat;
//import com.event.dbhelpers.*;
public class TicketsPageJson{

TicketingInfo ticketInfo=new TicketingInfo();

public JSONObject getJsonTicketsData(String eid,String evtdate,String ticketurlcode){
	return getJsonTicketsData(eid,evtdate,ticketurlcode,null);
}

public JSONObject getJsonTicketsData(String eid,String evtdate,String ticketurlcode,HashMap<String, String> params){
	
	JSONObject tObject=new JSONObject();
	ArrayList ticketgroups=new ArrayList();
	boolean isLooseTicket=true;
	try{
		boolean flag=ticketInfo.getBlockedInfo(eid);
		if(flag){
			tObject.put("status","blockedbytraffic");
			tObject.put("msg","There are more people buying tickets than available. You are now put in the queue, Please wait you will be taken to event page once tickets become"+
			                 " available. We'll automatically try after few seconds.<br/><div style='height:14px'></div><b><span id='blockedtimer' style='align:center;font-size:16px'><img src='/main/images/home/trafficloader.gif'></span></b>");
			tObject.put("remaintime","30");
			return tObject;
		}
		HashMap<String,Integer> holdqtyMap=ticketInfo.getWaitListHoldQty(eid,evtdate);
		String isSeatingEvent=ticketInfo.isSeatingEvent(eid);
		ticketInfo.intialize(eid,ticketurlcode,evtdate,params);
		tObject.put("availibilitymsg",ticketInfo.avaiabiltyMsgMap);
		tObject.put("isDiscountExists",ticketInfo.isDiscountExists);
		tObject.put("currencyformat",ticketInfo.currencyformat);
		tObject.put("discnbuy",ticketInfo.discnbuy);
		if(ticketInfo.ticketSettingsMap.get("seatticketid") !=null)
			tObject.put("seatticketid",ticketInfo.ticketSettingsMap.get("seatticketid"));
		HashMap ticketDisplayOptionsMap=(HashMap)ticketInfo.ticketSettingsMap.get("TicketDisplayOptionsMap");
		
		
		HashMap configMap=(HashMap)ticketInfo.ticketSettingsMap.get("configmap");
		
		try{
		if(configMap.containsKey("tickets.increment.value")){
			String incVal=(String)configMap.get("tickets.increment.value");
			tObject.put("ticketsincrement", new JSONObject(incVal));
		}
		}catch(Exception e){
			System.out.println("Exception occured while getting tickets increment value:"+e.getMessage());
		}
		
		String descMode="",grpdescMode="";
		try{
		descMode=(String) ticketDisplayOptionsMap.get("event.general.tktDescMode");
		}catch(Exception e){
		descMode="collapse";
		}
		try{
		grpdescMode=(String) ticketDisplayOptionsMap.get("event.group.tktDescMode");
		}catch(Exception e){
		grpdescMode="collapse";
		}
		tObject.put("tktDescMode",descMode);
		tObject.put("tktgrpDescMode",grpdescMode);
		try{
			tObject.put("ticketstatus",(String) ticketDisplayOptionsMap.get("event.activetickets.status"));
		}catch(Exception e){
		}
		
		tObject.put("TicketDisplayOptions",ticketDisplayOptionsMap);
		tObject.put("RegFlowWordings",ticketInfo.ticketSettingsMap.get("RegFlowWordingsMap"));
		ArrayList ticketsArray=ticketInfo.requiredTicketGroups;	
		
		for(int i=0;i<ticketsArray.size();i++){
			TicketGroup evt_TicketGroups=(TicketGroup)ticketsArray.get(i);
			isLooseTicket=evt_TicketGroups.isAutoGroup();
			
			EventTicket eventTicketsArray[]=(EventTicket[])evt_TicketGroups.getGroupTicketsArray();
			for(int k=0;k<eventTicketsArray.length;k++){
				try{
					JSONObject ticketObject=new JSONObject();
					ticketObject.put("Id",eventTicketsArray[k].getTicketId());
					ticketObject.put("eventId",eid);
					if(isLooseTicket)
						ticketObject.put("isLooseTicket","Y");
					else
						ticketObject.put("isLooseTicket","N");
					try{
						JSONObject tktgrp=new JSONObject();
						tktgrp.put("grpid",evt_TicketGroups.getTicketGroupId());
						tktgrp.put("grpdesc",evt_TicketGroups.getTicketGroupDescription());
						tktgrp.put("grpname",evt_TicketGroups.getTicketGroupName());
						if(ticketgroups.size()>0){
							for(int tkti=0;tkti<ticketgroups.size();tkti++){
								JSONObject temptktgrp=new JSONObject();
								temptktgrp=(JSONObject) ticketgroups.get(tkti);
								if(tktgrp.get("grpid")==temptktgrp.get("grpid")){
									JSONArray grptickets= (JSONArray)temptktgrp.get("tickets");
									//grptickets.put(eventTicketsArray[k].getTicketId());
									//tktgrp.put("tickets",grptickets);
									//ticketgroups.remove(tkti);
									//ticketgroups.add(tktgrp);
									if("Closed".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.closedtickets.status","yes"))){
										grptickets.put(eventTicketsArray[k].getTicketId());
										tktgrp.put("tickets",grptickets);
										ticketgroups.remove(tkti);
										ticketgroups.add(tktgrp);
									}
									else if("Sold Out".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.soldouttickets.status","yes"))){
										grptickets.put(eventTicketsArray[k].getTicketId());
										tktgrp.put("tickets",grptickets);
										ticketgroups.remove(tkti);
										ticketgroups.add(tktgrp);
									}
									else if("NOT_STARTED".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.status","no"))){
										grptickets.put(eventTicketsArray[k].getTicketId());
										tktgrp.put("tickets",grptickets);
										ticketgroups.remove(tkti);
										ticketgroups.add(tktgrp);
									}
									else if("Active".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.status","yes"))){
										grptickets.put(eventTicketsArray[k].getTicketId());
										tktgrp.put("tickets",grptickets);
										ticketgroups.remove(tkti);
										ticketgroups.add(tktgrp);
									}
									break;
								}
								else if(tkti==ticketgroups.size()-1){
									JSONArray grptickets=new JSONArray();
									grptickets.put(eventTicketsArray[k].getTicketId());
									tktgrp.put("tickets",grptickets);
									//ticketgroups.add(tktgrp);
									if("Closed".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.closedtickets.status","yes"))){
										ticketgroups.add(tktgrp);
									}
									else if("Sold Out".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.soldouttickets.status","yes"))){
										ticketgroups.add(tktgrp);
									}
									else if("NOT_STARTED".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.status","no"))){
										ticketgroups.add(tktgrp);
									}
									else if("Active".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.status","yes"))){
										ticketgroups.add(tktgrp);
									}
									break;
								}
							}
						}
						else{
							JSONArray grptickets=new JSONArray();
							grptickets.put(eventTicketsArray[k].getTicketId());
							tktgrp.put("tickets",grptickets);
							//ticketgroups.add(tktgrp);
							if("Closed".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.closedtickets.status","yes"))){
								ticketgroups.add(tktgrp);
							}
							else if("Sold Out".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.soldouttickets.status","yes"))){
								ticketgroups.add(tktgrp);
							}
							else if("NOT_STARTED".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.status","no"))){
								ticketgroups.add(tktgrp);
							}
							else if("Active".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.status","yes"))){
								ticketgroups.add(tktgrp);
							}
						}
						/*
						 	if("Closed".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.closedtickets.status","yes"))){
								ticketgroups.add(tktgrp);
							}
							else if("Sold Out".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.soldouttickets.status","yes"))){
								ticketgroups.add(tktgrp);
							}
							else if("NOT_STARTED".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.status","no"))){
								ticketgroups.add(tktgrp);
							}
							else if("Active".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.activetickets.status","yes"))){
								ticketgroups.add(tktgrp);
							}
						 */
					}catch(Exception e){
						System.out.println("exception in ticketsgroup generation:"+e.getMessage());
					}
					ticketObject.put("Name",eventTicketsArray[k].getTicketName());
					ticketObject.put("ActualPrice",CurrencyFormat.getCurrencyFormat("",eventTicketsArray[k].getTicketPrice()+"",true));
					ticketObject.put("ActualFee",CurrencyFormat.getCurrencyFormat("",eventTicketsArray[k].getTicketProcessFee()+"",true));
					ticketObject.put("ChargingPrice",CurrencyFormat.getCurrencyFormat("",eventTicketsArray[k].getTicketPrice()+"",true));
					ticketObject.put("ChargingFee",CurrencyFormat.getCurrencyFormat("",eventTicketsArray[k].getTicketProcessFee()+"",true));
					
					if("Active".equals(eventTicketsArray[k].getTicketStatus())){
						ticketObject.put("Available","Y");
					}
					else
						ticketObject.put("Available","N");
					ticketObject.put("IsEnable","Y");
					if("donationType".equals(eventTicketsArray[k].getTicketType()))
						ticketObject.put("DonateType","Y");
					String shortmsg="";
					//String shortmsg=eventTicketsArray[k].getTicketStartDate()+" "+eventTicketsArray[k].getTicketStartTime()+" - "+eventTicketsArray[k].getTicketEndDate()+" "+eventTicketsArray[k].getTicketEndTime();
					ticketObject.put("smallDesc",shortmsg);
					ticketObject.put("Min",eventTicketsArray[k].getTicketMinQty()+"");
					ticketObject.put("Max",eventTicketsArray[k].getTicketMaxQty()+"");
					ticketObject.put("original_max",eventTicketsArray[k].getOriginalMax()+"");
					ticketObject.put("ticketType",eventTicketsArray[k].getTicketType());
					if("donationType".equals(eventTicketsArray[k].getTicketType()))
						ticketObject.put("DonateType","Y");
					ticketObject.put("GroupId",evt_TicketGroups.getTicketGroupId());
					if(!"".equals(eventTicketsArray[k].getTicketDescription()))
						ticketObject.put("Desc",eventTicketsArray[k].getTicketDescription());
					
					if(eventTicketsArray[k].isMemberTicket())
						ticketObject.put("IsMemberTicket","Y");
					ticketObject.put("tktSelected","0");
					
					ticketObject.put("remainQty",eventTicketsArray[k].getRemainQty());
					ticketObject.put("soldQty",eventTicketsArray[k].getTicketSoldQty());
					if("NO".equalsIgnoreCase(eventTicketsArray[k].getWaitListType()))
					ticketObject.put("waitListType","N");
					else{
						try{
						int waitListCapacity=0;
						try{
							waitListCapacity=eventTicketsArray[k].getWaitListLimit();
						}catch(Exception e){waitListCapacity=0;}
						 
						ticketObject.put("waitListGrandLimit",waitListCapacity);
						//System.out.println("the Remain Quantity::"+eventTicketsArray[k].getRemainQty());
						
						if(holdqtyMap.containsKey("inprocess_"+eventTicketsArray[k].getTicketId()))
							ticketObject.put("remainQty",eventTicketsArray[k].getRemainQty()-holdqtyMap.get("inprocess_"+eventTicketsArray[k].getTicketId()));
						
						/*if(holdqtyMap.containsKey(eventTicketsArray[k].getTicketId()))
							ticketObject.put("remainQty",eventTicketsArray[k].getRemainQty()-holdqtyMap.get(eventTicketsArray[k].getTicketId()));*/
						
						if(waitListCapacity==100000)
							ticketObject.put("waitListType","Y");
						else{
							int usedQty=0;
							if(holdqtyMap.containsKey(eventTicketsArray[k].getTicketId()))
								usedQty=holdqtyMap.get(eventTicketsArray[k].getTicketId());
							
							ticketObject.put("waitListType","N");
							eventTicketsArray[k].setWaitListLimit(0);
							if(waitListCapacity>usedQty){
								if(Integer.parseInt(ticketObject.get("remainQty")+"")<=0){
									ticketObject.put("waitListType","Y"); 
									eventTicketsArray[k].setWaitListLimit(waitListCapacity-usedQty);
								}
							}
						}
						
						
						if(Integer.parseInt(ticketObject.get("remainQty")+"")<=0){
							if(!"".equals(evtdate) && "YES".equals(isSeatingEvent)){
							}else
								eventTicketsArray[k].setTicketStatus("Sold Out");
						}						
						//ticketObject.put("remainQty","3");
						
						}catch(Exception e){
							System.out.println("exception occured::---------------------"+e.getMessage());
						}
					}
					ticketObject.put("waitListLimit",eventTicketsArray[k].getWaitListLimit());
					
					
					
					
					if("Closed".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.closedtickets.status","yes"))){
						ticketObject.put("Msg",GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.closedtickets.statusmessage","Closed"));
						tObject.put(eventTicketsArray[k].getTicketId(),ticketObject);
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.closedtickets.strikethrough","no")))
						ticketObject.put("Strike","Y");
						ticketObject.put("Available","N");
						ticketObject.put("UnavailableType","CLOSED");
					}
					else if("Sold Out".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.soldouttickets.status","yes"))){
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.soldouttickets.strikethrough","no")))
							ticketObject.put("Strike","Y");
						ticketObject.put("Msg",GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.soldouttickets.statusmessage","SOLD OUT"));
						tObject.put(eventTicketsArray[k].getTicketId(),ticketObject);
						ticketObject.put("Available","N");
						ticketObject.put("UnavailableType","SOLDOUT");
					}
					else if("NOT_STARTED".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.status","no"))){
						ticketObject.put("Msg","NA");
						tObject.put(eventTicketsArray[k].getTicketId(),ticketObject);
						ticketObject.put("Available","Y");
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.showstartdate","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.startdatewithnotime","");
							shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
						}
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.showtime","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.startdatewithtime","");
							shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
							shortmsg=shortmsg.replace("**Starttime**",eventTicketsArray[k].getTicketStartTime());
						}
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.showenddate","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.enddatewithnotime","");
							shortmsg=format.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
						}
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.showtime","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.enddatewithtime","");
							shortmsg=format.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
							shortmsg=shortmsg.replace("**Endtime**",eventTicketsArray[k].getTicketEndTime());
						}
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.showenddate","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.bothwithnotime","");
							shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
							shortmsg=shortmsg.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
							//shortmsg=eventTicketsArray[k].getTicketStartDate()+" - "+eventTicketsArray[k].getTicketEndDate();
						}
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.notyetstartedtickets.showtime","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.bothwithtime","");
							shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
							shortmsg=shortmsg.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
							shortmsg=shortmsg.replace("**Starttime**",eventTicketsArray[k].getTicketStartTime());
							shortmsg=shortmsg.replace("**Endtime**",eventTicketsArray[k].getTicketEndTime());
						}
						ticketObject.put("smallDesc",shortmsg);
					}
					else if("Active".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.status","yes"))){
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.showstartdate","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.startdatewithnotime","");
							shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
						}
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.showtime","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.startdatewithtime","");
							shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
							shortmsg=shortmsg.replace("**Starttime**",eventTicketsArray[k].getTicketStartTime());
						}
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.showenddate","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.enddatewithnotime","");
							//System.out.println("format===="+format);
							shortmsg=format.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
						}
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.showtime","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.enddatewithtime","");
							shortmsg=format.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
							shortmsg=shortmsg.replace("**Endtime**",eventTicketsArray[k].getTicketEndTime());
						}
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.showenddate","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.bothwithnotime","");
							shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
							shortmsg=shortmsg.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
						}
						if("yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.activetickets.showtime","yes"))){
							String format=GenUtil.getHMvalue(ticketDisplayOptionsMap,"event.ticketsale.bothwithtime","");
							shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
							shortmsg=shortmsg.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
							shortmsg=shortmsg.replace("**Starttime**",eventTicketsArray[k].getTicketStartTime());
							shortmsg=shortmsg.replace("**Endtime**",eventTicketsArray[k].getTicketEndTime());
						}
						ticketObject.put("smallDesc",shortmsg);
						tObject.put(eventTicketsArray[k].getTicketId(),ticketObject);
					}	
				}catch(Exception e){
					System.out.println("Exception is"+e.getMessage());
				}
			}
		}
			
		tObject.put("groups", ticketgroups);
	}catch(Exception e){
		System.out.println("Exception occured in getJsonTicketsData is"+e.getMessage()+"eid:"+eid);
		e.printStackTrace();
	}
	
	return tObject;	
}

public void getWaitListDetails(String eid,String waitListId,JSONObject jsonObj){
	
	String waitListQuery="select tk.ticketid,tr.status,tk.wait_list_id,tk.ticket_name,tk.ticket_qty,tr.exp_date,tr.exp_time,tr.eventdate from wait_list_tickets tk,wait_list_transactions tr where "+
	                     " tk.wait_list_id=tr.wait_list_id and tk.wait_list_id=? and tk.eventid=?::bigint and tr.status in('In Process','Expired')";
	DBManager dbm=new DBManager();
	StatusObj sbj=dbm.executeSelectQuery(waitListQuery,new String[]{waitListId,eid});
	JSONObject waitListObj=new JSONObject();
	try{
	if(sbj.getStatus() && sbj.getCount()>0){
		for(int i=0;i<sbj.getCount();i++){
			waitListObj.put("tktid",dbm.getValue(i,"ticketid",""));
			waitListObj.put("wid",dbm.getValue(i,"wait_list_id",""));
			waitListObj.put("tktname",dbm.getValue(i,"ticket_name",""));
			waitListObj.put("tktqty",dbm.getValue(i,"ticket_qty",""));
			waitListObj.put("expdate",dbm.getValue(i,"exp_date",""));
			waitListObj.put("exptime",dbm.getValue(i,"exp_time",""));
			waitListObj.put("eventdate",dbm.getValue(i,"eventdate",""));
			waitListObj.put("status",dbm.getValue(i,"status",""));
		}
	}
	boolean flag=true;
	if(waitListObj.has("expdate"))
	flag=checkTimeDiffrence((String)waitListObj.get("expdate"),(String)waitListObj.get("exptime"));
	if(!flag){
	jsonObj.put("waitList",new JSONObject().put("status","Expired"));
	makeWaitListExpired(eid,waitListId);
	}else
	jsonObj.put("waitList",waitListObj);
	
	}catch(Exception e){
		System.out.println("the exception occured in getWaitListDetails :"+e.getMessage());
	}
}


boolean checkTimeDiffrence(String expdate,String exptime){
    boolean flag=false;
    String time=expdate+" "+exptime;
    String timequery="select '"+time+"'>now()";
    System.out.println("timequery: "+timequery);
    String val=DbUtil.getVal(timequery,null);
    if("t".equals(val))
        flag=true;
return flag;
}

public void makeWaitListExpired(String eid,String waitlistId){
	DbUtil.executeUpdateQuery("update wait_list_transactions set status='Expired' where eventid=?::BIGINT and wait_list_id=?",new String[]{eid,waitlistId});
}



public  HashMap getGroupTicketsVec(String eid,String ticketurlcode,String evtdate){
HashMap hm=new HashMap();
Vector ticketGroupsVector=new Vector();
String ticketslist[]={};
try{
TicketingInfo ticketInfo=new TicketingInfo();
ArrayList  ticketidsArray=new ArrayList();
HashMap configMap=DisplayAttribsDB.getAttribValues(eid,"TicketDisplayOptions");
boolean isLooseTicket=true;
ticketInfo.intialize(eid,ticketurlcode,evtdate);
ArrayList ticketsArray=ticketInfo.requiredTicketGroups;
HashMap configEntries=ticketInfo.configMap;

for(int i=0;i<ticketsArray.size();i++){
Vector ticketsVector=new Vector();
HashMap TicketGroupMap=new HashMap();
TicketGroup evt_TicketGroups=(TicketGroup)ticketsArray.get(i);
EventTicket eventTicketsArray[]=(EventTicket[])evt_TicketGroups.getGroupTicketsArray();
isLooseTicket=evt_TicketGroups.isAutoGroup();
if(!isLooseTicket){
TicketGroupMap.put("ticketGroupName",evt_TicketGroups.getTicketGroupName());
TicketGroupMap.put("ticketGroupDesc",evt_TicketGroups.getTicketGroupDescription());
TicketGroupMap.put("ticketGroupId",evt_TicketGroups.getTicketGroupId());
}
for(int k=0;k<eventTicketsArray.length;k++){
HashMap ticketMap=new HashMap();
if(isLooseTicket)
ticketMap.put("isLooseTicket","Yes");
String tid=eventTicketsArray[k].getTicketName();
ticketMap.put("ticketName",eventTicketsArray[k].getTicketName());
ticketMap.put("ticketPrice",eventTicketsArray[k].getTicketPrice()+"");
ticketMap.put("processFee",eventTicketsArray[k].getTicketProcessFee()+"");
ticketMap.put("ticketStatus",eventTicketsArray[k].getTicketStatus());
ticketMap.put("minQty",eventTicketsArray[k].getTicketMinQty()+"");
ticketMap.put("maxQty",eventTicketsArray[k].getTicketMaxQty()+"");
ticketMap.put("ticketType",eventTicketsArray[k].getTicketType());
ticketMap.put("ticketType",eventTicketsArray[k].getTicketType());
ticketMap.put("ticketGroupId",evt_TicketGroups.getTicketGroupId());
if(!"".equals(eventTicketsArray[k].getTicketDescription()))
ticketMap.put("ticketDescription",eventTicketsArray[k].getTicketDescription());
ticketMap.put("isMemberTicket",eventTicketsArray[k].isMemberTicket()+"");
String ticketdiv="<div id='"+eventTicketsArray[k].getTicketId()+"' class='tktWedgetClass'></div>";
ticketMap.put("ticketWidget",ticketdiv);
if("Closed".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.closedtickets.status","yes"))){
ticketsVector.add(ticketMap);
ticketidsArray.add(eventTicketsArray[k].getTicketId());
}
else if("Sold Out".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.soldouttickets.status","yes"))){
ticketsVector.add(ticketMap);
ticketidsArray.add(eventTicketsArray[k].getTicketId());
}
else if("Active".equals(eventTicketsArray[k].getTicketStatus())){
ticketsVector.add(ticketMap);
ticketidsArray.add(eventTicketsArray[k].getTicketId());
}
else if("NOT_STARTED".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.status","no"))){
ticketsVector.add(ticketMap);
ticketidsArray.add(eventTicketsArray[k].getTicketId());
}
}
TicketGroupMap.put("tickets",ticketsVector);
if(ticketsVector.size()>0)
ticketGroupsVector.add(TicketGroupMap);
}

if(ticketidsArray!=null&&ticketidsArray.size()>0){
ticketslist=(String[])ticketidsArray.toArray(new String[ticketidsArray.size()]);
}
hm.put("ticketVec",ticketGroupsVector);
hm.put("ticketsarray",ticketslist);
hm.put("configEntries",configEntries);
}
catch(Exception e){
System.out.println("exception occured in getGroupTicketsVec is--"+e.getMessage());
}
return hm;
}



}