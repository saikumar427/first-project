package com.eventregister;

import java.util.ArrayList;
import java.util.Map;

import java.util.HashMap;

import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.cachemanage.CacheManager;
import com.eventbee.general.DBManager;
import com.eventbee.general.EbeeCachingManager;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;

import com.eventbee.regcaheloader.TicketSettingsLoader;
import com.eventbee.regcaheloader.TicketsInfoLoader;

public class TicketingInfo{
private String eventid=null;
public ArrayList  requiredTicketGroups=null;
public HashMap configMap=null;
public boolean isDiscountExists=true;
public boolean isMemberTicketsExists=true;
public HashMap memberTicketsMap=null;
private String evtdate=null;
private HashMap detailsMap=null;
private HashMap recSoldQtyMap=null;
private HashMap tktFormatMap=null;
public HashMap avaiabiltyMsgMap=new HashMap();
TicketsDB ticketdb=new TicketsDB();
public String currencyformat="";
public String discnbuy="";
Map ticketSettingsMap=null;
Map ticketsInfoMap=null;

public void intialize(String evtid,String ticketurlcode,String evtdate){
	intialize(evtid,ticketurlcode,evtdate,null);
}

public void intialize(String evtid,String ticketurlcode,String evtdate,HashMap<String, String> priorityparams){
	
evtdate=evtdate;
eventid=evtid;

//MaxminMap=checkTicket(evtid,evtdate);
//tktFormatMap=getTicketMessage(eventid);
//memberTicketsMap=ticketdb.getMemberTicketsMap(evtid);
if(!CacheManager.getInstanceMap().containsKey("ticketsettings")){
	CacheLoader ticketsettings=new TicketSettingsLoader();
	ticketsettings.setRefreshInterval(5*60*1000);
	ticketsettings.setMaxIdleTime(5*60*1000);
	CacheManager.getInstanceMap().put("ticketsettings",ticketsettings);		
}
ticketSettingsMap=CacheManager.getData(eventid, "ticketsettings");
int i=0;
while(ticketSettingsMap==null && i<20){
	try {
	    Thread.sleep(200);
	    ticketSettingsMap=CacheManager.getData(eventid, "ticketsettings");
	    i++;
	} catch(InterruptedException ex) {
		System.out.println("InterruptedException in TicketingInfo intialize: eventid: "+eventid+" iteration: "+i+" Exception: "+ex.getMessage());
	    Thread.currentThread().interrupt();
	}
}

if(i>0 && ticketSettingsMap==null)
	System.out.println("Exception::: TicketingInfo intialize ticketSettingsMap is null for Thread id: "+Thread.currentThread().getId()+ " eventid: "+eventid+" iteration: "+i);

tktFormatMap=(HashMap)ticketSettingsMap.get("tktFormatMap");

configMap=(HashMap)ticketSettingsMap.get("configmap");

//configMap=ticketdb.getConfigValuesFromDb(eventid);
RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
if(!"YES".equals(GenUtil.getHMvalue(configMap,"event.loading.quick","NO")))
regtktmgr.autoLocksAndBlockDelete(eventid, "", "jsonlevel",GenUtil.getHMvalue(configMap,"timeout","14"),GenUtil.getHMvalue(configMap,"event.seating.enabled","NO"));

requiredTicketGroups=getGroupsAndTickets(eventid,ticketurlcode,evtdate,priorityparams);

String discountExists=(String)ticketSettingsMap.get("discountExists");

if("yes".equals(discountExists)) isDiscountExists=true;
else isDiscountExists=false;
//isDiscountExists=ticketdb.isCouponcodeExists(eventid);
currencyformat=(String)ticketSettingsMap.get("currencyformat");
discnbuy=GenUtil.getHMvalue(configMap,"event.discBuy.up","dn");

}

public ArrayList getGroupsAndTickets(String eventid,String ticketurlcode,String evtdate,HashMap<String, String> priorityparams){
ticketTimeZoneConversion  ticketTimezones=new ticketTimeZoneConversion();
ArrayList ParamList=new ArrayList();
ParamList.add(eventid);

String query="";
if(ticketurlcode!=null&&!"".equals(ticketurlcode)&&!"null".equals(ticketurlcode)){
query="select * from ticketurl_tickets_info where eventid=? and code=?";
ParamList.add(ticketurlcode);
}

if(evtdate!=null&&!"".equals(evtdate)){
	detailsMap=ticketdb.getrecurringEventdetails(eventid,evtdate,ticketurlcode);
	recSoldQtyMap=getRecurringSoldQty(eventid,evtdate);
}

DBManager db=new DBManager();
ArrayList requiredGroupTickets=new ArrayList();

HashMap hm=new HashMap();
TicketGroup tktGrp=null;
ArrayList groupTicketsArray=null;
int groupIndex=0;
StatusObj sb=null;

if(ticketurlcode!=null&&!"".equals(ticketurlcode)&&!"null".equals(ticketurlcode)){
	sb=db.executeSelectQuery(query,(String[])ParamList.toArray(new String[ParamList.size()]));
}else{
	
	try{
		ticketsInfoMap=getTicketsInfoMap(eventid);
		sb=(StatusObj)ticketsInfoMap.get("TicketsInfoStatusObj");
		db=(DBManager)ticketsInfoMap.get("TicketsInfoDBManager");
	}catch(Exception e){
		System.out.println("Exception:::: for ticketsInfoMap eventid: "+eventid+" ERROR: "+e.getMessage());
	}
	
}

try{
	
if(sb !=null && sb.getStatus()){
	String timezone=GenUtil.getHMvalue(configMap,"event.timezone","");
	HashMap maxmin=new HashMap();
	if("".equals(evtdate) && (ticketurlcode==null || "".equals(ticketurlcode) || "null".equals(ticketurlcode))){
		 maxmin=(HashMap)ticketsInfoMap.get("checkTicket");
		 if(maxmin==null) maxmin=new HashMap();
	 }else{
		 maxmin=checkTicket(eventid,evtdate);
	 }
	
	//priority reg block start
	ArrayList<String> allPriTickets=null;
	ArrayList<String> listIdPriTickets=null;
	try{
		HashMap<String, ArrayList<String>> priTktsMap=null;
		if(priorityparams!=null)
			priTktsMap=getPriorityTickets(eventid,priorityparams.get("prilistid"));
		if(priTktsMap!=null){
			allPriTickets=priTktsMap.get("allPriTkts");
			listIdPriTickets=priTktsMap.get("listIdPriTkts");
		}
	}catch(Exception e){
		System.out.println("Exception occured in TicketingInfo.java at priority reg block ERROR: "+e.getMessage());
	}//priority reg block end
	
for(int i=0;i<sb.getCount();i++){
	if(evtdate!=null&&!"".equals(evtdate)){
		if(detailsMap.get(db.getValue(i,"price_id",""))==null)continue;
	}
	
	if(priorityparams!=null && "Continue".equals(priorityparams.get("priregtype"))){
		if(listIdPriTickets!=null && allPriTickets!=null)
			if(!listIdPriTickets.contains(db.getValue(i,"price_id","")) && allPriTickets.contains(db.getValue(i,"price_id","")))
				continue;
	}else if(priorityparams!=null && "Skip".equals(priorityparams.get("priregtype"))){
		if(allPriTickets!=null && allPriTickets.contains(db.getValue(i,"price_id",""))) continue;
	}
	
if(hm.get(db.getValue(i,"ticket_groupid",""))==null){
groupIndex++;
tktGrp=new TicketGroup();
groupTicketsArray=new ArrayList();
tktGrp.setTicketGroupName(db.getValue(i,"groupname",""));
if(!"".equals(db.getValue(i,"groupname","")))
tktGrp.setAutoGroup(false);
tktGrp.setTicketGroupId(db.getValue(i,"ticket_groupid",""));
tktGrp.setTicketGroupDescription(db.getValue(i, "grpdescription", ""));
}

EventTicket eventTicketObj=new EventTicket();
if("Yes".equals(db.getValue(i,"isdonation","")))
eventTicketObj.setTicketType("donationType");
else if("Yes".equalsIgnoreCase(db.getValue(i,"isattendee","")))
eventTicketObj.setTicketType("attendeeType");
else
eventTicketObj.setTicketType("nonAttendee");
eventTicketObj.setTicketName(db.getValue(i,"ticket_name",""));
eventTicketObj.setTicketPrice(Double.parseDouble(db.getValue(i,"ticket_price","0")));
eventTicketObj.setTicketProcessFee(Double.parseDouble(db.getValue(i,"process_fee","0")));
eventTicketObj.setTicketDescription(db.getValue(i,"description",""));
eventTicketObj.setTicketId(db.getValue(i,"price_id",""));
eventTicketObj.setTicketCapacity(Integer.parseInt(db.getValue(i,"max_ticket","0")));
eventTicketObj.setTicketSoldQty(Integer.parseInt(db.getValue(i,"sold_qty","0")));
HashMap timeHm=new HashMap();
if(evtdate!=null&&!"".equals(evtdate)){
timeHm=(HashMap)detailsMap.get(db.getValue(i,"price_id",""));
if(recSoldQtyMap.get(db.getValue(i,"price_id",""))!=null)
eventTicketObj.setTicketSoldQty(Integer.parseInt((String)recSoldQtyMap.get(db.getValue(i,"price_id",""))));
else eventTicketObj.setTicketSoldQty(0);
}

String tkktid="";
int max=Integer.parseInt(db.getValue(i,"max_qty","0"));
int min=Integer.parseInt(db.getValue(i,"min_qty","0"));
eventTicketObj.setOriginalMax(max);
tkktid=db.getValue(i,"price_id","");
 int rem=0;
 /*if(maxmin.get("seat_"+tkktid)==null) //commented on 10-jun-2016 for waitlist with seating issue.
 {*/
 try{
	 rem= eventTicketObj.getTicketCapacity()- eventTicketObj.getTicketSoldQty()-Integer.parseInt(GenUtil.getHMvalue(maxmin,"hold_"+tkktid,"0"));
   if(rem<0)rem=0;
  }catch(Exception e){System.out.println("error in holding ticketinginfo "+e.getMessage());}

 if(rem<max && maxmin.get("seat_"+tkktid)==null)//no need update max if rem<max for seat assigned ticket. on 10-jun-2016 for waitlist with seating issue.
  {
	max=rem;
	if(rem<min){min=0;max=0;}
   }
 //}
 eventTicketObj.setRemainQty(rem);
 if(tktFormatMap !=null && tktFormatMap.containsKey(tkktid)){
	 avaiabiltyMsgMap.put("capacity_"+tkktid, eventTicketObj.getTicketCapacity()+"");
	 avaiabiltyMsgMap.put("soldqty_"+tkktid,eventTicketObj.getTicketSoldQty()+"");
	 avaiabiltyMsgMap.put("remaining_"+tkktid,(eventTicketObj.getTicketCapacity()- eventTicketObj.getTicketSoldQty())+"");
	 avaiabiltyMsgMap.put("hold_"+tkktid, GenUtil.getHMvalue(maxmin,"hold_"+tkktid,"0"));
	 avaiabiltyMsgMap.put(tkktid,tktFormatMap.get(tkktid));
 }

eventTicketObj.setTicketMaxQty(max);
eventTicketObj.setTicketMinQty(Integer.parseInt(db.getValue(i,"min_qty","0")));

if(evtdate!=null&&!"".equals(evtdate)){
eventTicketObj.setSoldStatus((String)timeHm.get("soldstatus"));
eventTicketObj.setStartStatus((String)timeHm.get("startstatus"));
eventTicketObj.setEndStatus((String)timeHm.get("endstatus"));
}
else{
timeHm.put("startYear",db.getValue(i,"start_yy",""));
timeHm.put("startMonth",db.getValue(i,"start_mm",""));
timeHm.put("startYear",db.getValue(i,"start_yy",""));
timeHm.put("startDay",db.getValue(i,"start_dd",""));
timeHm.put("endYear",db.getValue(i,"end_yy",""));
timeHm.put("endMonth",db.getValue(i,"end_mm",""));
timeHm.put("endDay",db.getValue(i,"end_dd",""));
timeHm.put("starttime",(db.getValue(i,"starttime","")==null|| "".equals(db.getValue(i,"starttime","")) )?"01:00":db.getValue(i,"starttime","")   );
timeHm.put("endtime",(db.getValue(i,"endtime","")==null|| "".equals(db.getValue(i,"endtime","")) )?"01:00":db.getValue(i,"endtime","")   );
eventTicketObj.setSoldStatus(db.getValue(i,"soldstatus",""));
eventTicketObj.setStartStatus(db.getValue(i,"startstatus",""));
eventTicketObj.setEndStatus(db.getValue(i,"endstatus",""));
timeHm.put("soldstatus",db.getValue(i,"soldstatus",""));
timeHm.put("startstatus",db.getValue(i,"startstatus",""));
timeHm.put("endstatus",db.getValue(i,"endstatus",""));

}

ticketTimezones.getTimezones(timeHm,eventid,timezone);
eventTicketObj.setTicketStartDate((String)timeHm.get("start_date"));
eventTicketObj.setTicketEndDate((String)timeHm.get("end_date"));
eventTicketObj.setTicketStartTime((String)timeHm.get("starttime"));
eventTicketObj.setTicketEndTime((String)timeHm.get("endtime"));
if(("NOT_SOLD".equals((String)timeHm.get("soldstatus")))&&("STARTED".equals(eventTicketObj.getStartStatus()))&&("NOT_CLOSED".equals((String)timeHm.get("endstatus"))))
eventTicketObj.setTicketStatus("Active");
else if("SOLD_OUT".equals((String)timeHm.get("soldstatus")))
eventTicketObj.setTicketStatus("Sold Out");
else if(("STARTED".equals((String)timeHm.get("startstatus")))&&("CLOSED".equals((String)timeHm.get("endstatus"))))
eventTicketObj.setTicketStatus("Closed");
else if("NOT_STARTED".equals((String)timeHm.get("startstatus")))
eventTicketObj.setTicketStatus("NOT_STARTED");
eventTicketObj.setMemberTicketFlag(false);
eventTicketObj.setIsAtDoor(db.getValue(i,"is_at_door","Y"));
eventTicketObj.setWaitListType(db.getValue(i,"wait_list_type","NO"));
eventTicketObj.setWaitListLimit(Integer.parseInt(db.getValue(i,"wait_list_max_qty","0")));
groupTicketsArray.add(eventTicketObj);
if(groupTicketsArray!=null){
EventTicket eventTicketsArray[]=new EventTicket[groupTicketsArray.size()];
for(int k=0;k<groupTicketsArray.size();k++){
eventTicketsArray[k]=(EventTicket)groupTicketsArray.get(k);
}
tktGrp.setGroupTicketsArray(eventTicketsArray);
}
if(hm.get(db.getValue(i,"ticket_groupid",""))==null){
requiredGroupTickets.add(tktGrp);
hm.put(db.getValue(i,"ticket_groupid",""),"Y");
}
else{
requiredGroupTickets.set(groupIndex-1,tktGrp);
}
}
}
}
catch(Exception e){
System.out.println("exeption in get Ticket Groups method in TicketInfo");
}

return requiredGroupTickets;
}

public HashMap getTicketMessage(String eventid){
	HashMap hm=new HashMap();
	String query="select b.ticketid, c.display_format as format from ticketsfordisplayformats b,ticketsavailability_display_formats c where  c.eventid=? and b.formatid=c.formatid and c.eventid=b.eventid";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query,new String[]{eventid});
	 
	if(sb.getStatus()){
		
		for(int i=0;i<sb.getCount();i++){
			String tktid=db.getValue(i,"ticketid","");
			String format=db.getValue(i,"format","");
			hm.put(tktid,format);
		}
	}
	return hm;
}

public HashMap getTicketMessage(String eventid,String eventdate){
	HashMap hm=new HashMap();
	HashMap rec_hm=new HashMap();
	DBManager db=new DBManager();
	StatusObj sb=null;

	String hold_qty="select sum(locked_qty) as holdqty,ticketid  from event_reg_locked_tickets where eventid=? and tid not in (select tid from event_reg_transactions where eventid=?) group by ticketid";
	try{
		if(!"".equals(eventdate)){
				String rec_qry="select ticketid,soldqty from reccurringevent_ticketdetails where eventid=CAST(? AS BIGINT) and eventdate=?";
				 sb=db.executeSelectQuery(rec_qry,new String[]{eventid,eventdate});
				if(sb.getStatus()){
					for(int i=0;i<sb.getCount();i++){
						rec_hm.put(db.getValue(i,"ticketid",""),db.getValue(i,"soldqty",""));
					}
				}
				hold_qty="select sum(locked_qty) as holdqty,ticketid  from event_reg_locked_tickets where eventid=? and tid not in (select tid from event_reg_transactions where eventid=?) and eventdate=? group by ticketid";
				sb=db.executeSelectQuery(hold_qty,new String[]{eventid,eventid,eventdate});
				
			}
		else{
			sb=db.executeSelectQuery(hold_qty,new String[]{eventid,eventid});
			
		}
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				hm.put("hold_"+db.getValue(i, "ticketid", ""),db.getValue(i, "holdqty", ""));
			}
		}
		String query="select a.price_id as ticketid,a.max_ticket as capacity,a.sold_qty as soldoutqty,(a.max_ticket-a.sold_qty) as remainingqty,c.display_format as format from price a ,ticketsfordisplayformats b,ticketsavailability_display_formats c where  c.eventid=? and a.price_id=b.ticketid and b.formatid=c.formatid and c.eventid=b.eventid";
		
		 sb=db.executeSelectQuery(query,new String[]{eventid});
		 
		if(sb.getStatus()){
			
			for(int i=0;i<sb.getCount();i++){
				String tktid=db.getValue(i,"ticketid","");
				String format=db.getValue(i,"format","");
				hm.put(tktid,format);
				hm.put("capacity_"+tktid,db.getValue(i,"capacity",""));
				if(!"".equals(eventdate)){
					if(	rec_hm.containsKey(tktid)){
						hm.put("soldqty_"+tktid,rec_hm.get(tktid));
						int remqty=Integer.parseInt(db.getValue(i,"capacity",""))-Integer.parseInt((String) rec_hm.get(tktid));
						hm.put("remaining_"+tktid,remqty);
					}else{
						hm.put("remaining_"+tktid,db.getValue(i,"capacity",""));
						hm.put("soldqty_"+tktid,"0");
					}
				}else{
					hm.put("remaining_"+tktid,db.getValue(i,"remainingqty",""));
					hm.put("soldqty_"+tktid,db.getValue(i,"soldoutqty",""));
				}
				if(!hm.containsKey("hold_"+tktid)){
					hm.put("hold_"+tktid, "0");
				}
			}
		}
	}catch(Exception e){}
	return hm;
	}


public HashMap checkTicket(String eventid,String eventdate){
	System.out.println("checkTicket in TicketingInfo eventdate: "+eventdate+" eventid: "+eventid);
	HashMap hm=new HashMap();
	HashMap rec_hm=new HashMap();
	DBManager db=new DBManager();
	DBManager dbm=new DBManager();
	StatusObj sb=null;
	String hold_qty="select sum(locked_qty) as holdqty,ticketid  from event_reg_locked_tickets where eventid=? group by ticketid";
	try{
		if(!"".equals(eventdate)){
				hold_qty="select sum(locked_qty) as holdqty,ticketid  from event_reg_locked_tickets where eventid=? and eventdate=? group by ticketid";
				sb=db.executeSelectQuery(hold_qty,new String[]{eventid,eventdate});
			}
		else{
			sb=db.executeSelectQuery(hold_qty,new String[]{eventid});
		}
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				hm.put("hold_"+db.getValue(i, "ticketid", ""),db.getValue(i, "holdqty", ""));
			}
		}
		
		String seatingEnabled="";
		try{
			Map ticketSettingsMap=CacheManager.getData(eventid, "ticketsettings");	
			HashMap configMap=(HashMap)ticketSettingsMap.get("configmap");
			seatingEnabled=GenUtil.getHMvalue(configMap,"event.seating.enabled","");
		}catch(Exception  e){
			System.out.println("Exception Ticketinginfo.java checkTicket eventid: "+eventid+" ERROR:: "+e.getMessage());
		}
		
		if("YES".equals(seatingEnabled)){
			String isseatingevent="SELECT ticketid from seat_tickets where eventid=CAST(? AS BIGINT)";
			sb= dbm.executeSelectQuery(isseatingevent, new String[]{eventid});
			if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){	
					String tktid=dbm.getValue(i,"ticketid","");
					hm.put("seat_"+tktid, "yes");
				}
			
			}
		}
	}catch(Exception e){System.out.println("Exception at minmaxmap calculations"+e.getMessage()); }
	return hm;
	}

public HashMap getRecurringSoldQty(String eventid,String eventdate){
	HashMap rec_hm=new HashMap();
	DBManager db=new DBManager();
	StatusObj sb=null;
	String rec_qry="select ticketid,soldqty from reccurringevent_ticketdetails where eventid=CAST(? AS BIGINT) and eventdate=?";
	sb=db.executeSelectQuery(rec_qry,new String[]{eventid,eventdate});
	if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
			rec_hm.put(db.getValue(i,"ticketid",""),db.getValue(i,"soldqty",""));
		}
	}
	return rec_hm;
	}

public boolean getBlockedInfo(String eid){
    HashMap blockedEventsMap=(HashMap)EbeeCachingManager.get("blockedEvents");
     if("Y".equalsIgnoreCase((String)blockedEventsMap.get(eid)) && "hightraffic".equals(blockedEventsMap.get(eid+"_cancelby")))
         return true;
     else
         return false;
}

public HashMap<String, Integer> getWaitListHoldQty(String eid, String eventdate) {
HashMap<String, Integer> totalHoldTickets = new HashMap<String, Integer>();
HashMap<String, Integer> InProceesMap = new HashMap<String, Integer>();
DBManager dbManager=new DBManager();
StatusObj statusObj=null;
int totalQty=0;
if(eventdate==null || "".equals(eventdate))
statusObj=dbManager.executeSelectQuery("select a.wait_list_id, a.ticket_qty,a.ticketid,b.status from wait_list_tickets a, wait_list_transactions b where  a.wait_list_id= b.wait_list_id and a.eventid=cast(? as integer)", new String[]{eid});
else
statusObj=dbManager.executeSelectQuery("select a.wait_list_id, a.ticket_qty,a.ticketid,b.status from wait_list_tickets a, wait_list_transactions b where  a.wait_list_id= b.wait_list_id and b.eventid=cast(? as integer) and b.eventdate=?", new String[]{eid,eventdate});
for(int i=0;i<statusObj.getCount();i++){
totalQty=totalQty+Integer.parseInt(dbManager.getValue(i, "ticket_qty", "0"));
if(totalHoldTickets.containsKey(dbManager.getValue(i, "ticketid", "")))
totalHoldTickets.put(dbManager.getValue(i, "ticketid", ""), totalHoldTickets.get(dbManager.getValue(i, "ticketid", ""))+Integer.parseInt(dbManager.getValue(i, "ticket_qty", "0")));	
else
totalHoldTickets.put(dbManager.getValue(i, "ticketid", ""), Integer.parseInt(dbManager.getValue(i, "ticket_qty", "0")));


if("In Process".equalsIgnoreCase(dbManager.getValue(i,"status", "")) || "Waiting".equalsIgnoreCase(dbManager.getValue(i,"status", ""))){
	if(totalHoldTickets.containsKey("inprocess_"+dbManager.getValue(i, "ticketid", "")))
		totalHoldTickets.put("inprocess_"+dbManager.getValue(i, "ticketid", ""), totalHoldTickets.get("inprocess_"+dbManager.getValue(i, "ticketid", ""))+Integer.parseInt(dbManager.getValue(i, "ticket_qty", "0")));	
		else
		totalHoldTickets.put("inprocess_"+dbManager.getValue(i, "ticketid", ""), Integer.parseInt(dbManager.getValue(i, "ticket_qty", "0")));
}	
}




totalHoldTickets.put("all_tickets_qty", totalQty);
return totalHoldTickets;
}

public String isSeatingEvent(String eid){
	if("YES".equals(GenUtil.getHMvalue(configMap,"event.seating.enabled","")))
       return "YES";
       else
    	  return "NO";
}

public static Map getTicketsInfoMap(String eventid){
	Map ticketsinfomap=null;
	try{
		if(!CacheManager.getInstanceMap().containsKey("ticketsinfo")){
			CacheLoader ticketsinfo=new TicketsInfoLoader();
			ticketsinfo.setRefreshInterval(2*60*1000);
			ticketsinfo.setMaxIdleTime(2*60*1000);
			CacheManager.getInstanceMap().put("ticketsinfo",ticketsinfo);		
		}
		ticketsinfomap=CacheManager.getData(eventid, "ticketsinfo");
		
		int i=0;
		while(ticketsinfomap==null && i<20){
			try {
			    Thread.sleep(200);
			    ticketsinfomap=CacheManager.getData(eventid, "ticketsinfo");
			    i++;
			} catch(InterruptedException ex) {
				System.out.println("InterruptedException in TicketingInfo getTicketsInfoMap(): eventid: "+eventid+" iteration: "+i+" Exception: "+ex.getMessage());
			    Thread.currentThread().interrupt();
			}
		}
		
		if(i>0 && ticketsinfomap==null){
			ticketsinfomap=new HashMap();
			System.out.println("Exception:::: TicketingInfo getTicketsInfoMap() is null for Thread id: "+Thread.currentThread().getId()+ " eventid: "+eventid+" iteration: "+i);
		}
	}catch(Exception e){
		System.out.println("Exception:::: TicketingInfo getTicketsInfoMap() cachemanager block eventid: "+eventid+" ERROR::: "+e.getMessage());
	}
	
	return ticketsinfomap;
}

public static Map<String, Map<String, String>> getTicketIdsWithName(String eventid){
	Map<String, String> ticketIdsWithName=new HashMap<String, String>();
	Map<String, Map<String, String>> ticketIdsWithNameList=new HashMap<String, Map<String, String>>();
	try{
		DBManager db=new DBManager();
		StatusObj sb=null;
		Map ticketsinfomap=getTicketsInfoMap(eventid);
		sb=(StatusObj)ticketsinfomap.get("TicketsInfoStatusObj");
		db=(DBManager)ticketsinfomap.get("TicketsInfoDBManager");
		if(sb !=null && sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				ticketIdsWithName=new HashMap<String, String>();
				ticketIdsWithName.put("tkt_group_name", db.getValue(i,"groupname",""));
				ticketIdsWithName.put("tkt_name", db.getValue(i,"ticket_name",""));
				//ticketIdsWithName.put("tkt_id", db.getValue(i,"price_id",""));
				ticketIdsWithNameList.put(db.getValue(i,"price_id",""),ticketIdsWithName);
			}
		}
	}catch(Exception e){
		System.out.println("Exception:::: for ticketsInfoMap eventid: "+eventid+" ERROR: "+e.getMessage());
	}
	return ticketIdsWithNameList;
}

public static HashMap<String, ArrayList<String>> getPriorityTickets(String eid,String listId){
	HashMap<String, ArrayList<String>> priorityTicketsMap=null;
	try{
		String priTktsQry="select list_id,tickets from priority_list where eventid=CAST(? AS BIGINT)";
		DBManager db=new DBManager();
		StatusObj sb=null;
		sb=db.executeSelectQuery(priTktsQry,new String[]{eid});
		ArrayList<String> allPriTickets=null;
		ArrayList<String> listIdPriTickets=null;
		
		if(sb !=null && sb.getStatus()&&sb.getCount()>0){
			priorityTicketsMap=new HashMap<String, ArrayList<String>>();
			allPriTickets=new ArrayList<String>();
			listIdPriTickets=new ArrayList<String>();
			for(int i=0;i<sb.getCount();i++){
				String tickets=db.getValue(i,"tickets","");
				String list_id=db.getValue(i,"list_id","");
				String [] tktsAry=tickets.split(",");
				for(String tkt:tktsAry){
					if(!allPriTickets.contains(tkt))
						allPriTickets.add(tkt);
					if(list_id.equals(listId) && !listIdPriTickets.contains(tkt))
						listIdPriTickets.add(tkt);
				}
			}
			priorityTicketsMap.put("allPriTkts", allPriTickets);
			priorityTicketsMap.put("listIdPriTkts", listIdPriTickets);
			
		}
	}catch(Exception e){
		System.out.println("Exception:::: for getPriorityTickets eventid: "+eid+" ERROR: "+e.getMessage());
	}
	
	return priorityTicketsMap;
}



}
