package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONObject;

import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;

public class CTicketsInfo {
	private String eventid=null;
	public ArrayList<CTicketGroup>  requiredTicketGroups=null;
	public ArrayList  optionalTicketGroups=null;
	public String currencySymbol=null;
	public boolean isDiscountExists=true;
	public HashMap configMap=null;
	private HashMap<String,ArrayList<CTicketGroup>> groupTickets=new HashMap<String,ArrayList<CTicketGroup>>();
	private String eventDate=null;
	private HashMap<String,HashMap<String, String>> detailsMap=null;
	private HashMap<String,String> maxMinMap=null;
	HashMap<String,Integer> waitlistQtyMap=null;
	CTicketsDB ticketsDB=new CTicketsDB();
	public void intialize(String evtid,HashMap<String, String> params){
		this.eventDate=params.get("evtdate");
		eventid=evtid;
		configMap=ticketsDB.getConfigValuesFromDb(eventid);
		CRegistrationTiketingManager regtktmgr=new CRegistrationTiketingManager();
		if(!"YES".equals(GenUtil.getHMvalue(configMap,"event.loading.quick","NO")))
			regtktmgr.autoLocksAndBlockDelete(eventid, "", "jsonlevel",GenUtil.getHMvalue(configMap,"timeout","14"),GenUtil.getHMvalue(configMap,"event.seating.enabled","NO"));
		
		maxMinMap=checkTicket(evtid,eventDate);
		
		if(!"".equals(params.get("wid")))
			getWaitListDetails(eventid,params.get("wid")); 
			
		waitlistQtyMap=getWaitListHoldQty(evtid,params.get("evtdate"));
		
		groupTickets.put("tickets",getGroupsAndTickets(eventid,params));
		requiredTicketGroups=(ArrayList<CTicketGroup>)groupTickets.get("tickets");
		isDiscountExists=ticketsDB.isCouponcodeExists(eventid);
	}
	
	public ArrayList<CTicketGroup> getGroupsAndTickets(String eventid,HashMap<String, String> params){
		BTicketTimeZoneConversion  ticketTimezones=new BTicketTimeZoneConversion();
		ArrayList<String> paramList=new ArrayList<String>();
		paramList.add(eventid);

		String query="select * from tickets_info where eventid=? ";
		if(params.get("tkt_url_code")!=null&&!"".equals(params.get("tkt_url_code"))&&!"null".equals(params.get("tkt_url_code"))){
			query="select * from ticketurl_tickets_info where eventid=? and code=?";
			paramList.add(params.get("tkt_url_code"));
		}

		if(eventDate!=null && !"".equals(eventDate)){
			detailsMap=ticketsDB.getrecurringEventdetails(eventid,eventDate,params.get("tkt_url_code"));
		}
		
		JSONObject ticketIncJsonVal=new JSONObject();
		try{
			if(configMap.containsKey("tickets.increment.value")){
				String ticketIncJsonStr=(String)configMap.get("tickets.increment.value");//comming as json string
				ticketIncJsonVal=new JSONObject(ticketIncJsonStr);
			}
		}catch(Exception e){
			System.out.println("Exception occured while getting tickets increment value:"+e.getMessage());
		}

		DBManager db=new DBManager();
		ArrayList<CTicketGroup> requiredGroupTickets=new ArrayList<CTicketGroup>();

		HashMap<String,String> hashMapRef=new HashMap<String,String>();
		CTicketGroup tktGrp=null;
		ArrayList<CEventTicket> groupTicketsArray=null;
		int groupIndex=0;
		StatusObj sb=db.executeSelectQuery(query,(String[])paramList.toArray(new String[paramList.size()]));
		try{
			if(sb.getStatus()){
				
				//priority reg block start
				ArrayList<String> allPriTickets=null;
				ArrayList<String> listIdPriTickets=null;
				try{
					HashMap<String, ArrayList<String>> priTktsMap=null;
					if(!"".equals(params.get("pri_listid")))
						priTktsMap=getPriorityTickets(eventid,params.get("pri_listid"));
					if(priTktsMap!=null){
						allPriTickets=priTktsMap.get("allPriTkts");
						listIdPriTickets=priTktsMap.get("listIdPriTkts");
					}
				}catch(Exception e){
					System.out.println("Exception occured in TicketingInfo.java at priority reg block ERROR: "+e.getMessage());
				}//priority reg block end
				
				String timeZone=GenUtil.getHMvalue(configMap,"event.timezone","");
				for(int i=0;i<sb.getCount();i++){
					if(eventDate!=null&&!"".equals(eventDate)){
						if(detailsMap.get(db.getValue(i,"price_id",""))==null)continue;
					}
					
					if("Continue".equals(params.get("pri_reg_type"))){
						if(listIdPriTickets!=null && allPriTickets!=null)
							if(!listIdPriTickets.contains(db.getValue(i,"price_id","")) && allPriTickets.contains(db.getValue(i,"price_id","")))
								continue;
					}else if("Skip".equals(params.get("pri_reg_type"))){
						if(allPriTickets!=null && allPriTickets.contains(db.getValue(i,"price_id",""))) continue;
					}
					
					if(hashMapRef.get(db.getValue(i,"ticket_groupid",""))==null){
						groupIndex++;
						tktGrp=new CTicketGroup();
						groupTicketsArray=new ArrayList<CEventTicket>();
						tktGrp.setTicketGroupName(db.getValue(i,"groupname",""));
						if(!"".equals(db.getValue(i,"groupname","")))
							tktGrp.setAutoGroup(false);
						tktGrp.setTicketGroupId(db.getValue(i,"ticket_groupid",""));
						tktGrp.setTicketGroupDescription(db.getValue(i, "grpdescription", "")); //optional
					}

					CEventTicket eventTicketObj=new CEventTicket();
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
					
					String tkktid="";
					int max=Integer.parseInt(db.getValue(i,"max_qty","0"));
					int min=Integer.parseInt(db.getValue(i,"min_qty","0"));
					int originalMax=max;
					tkktid=db.getValue(i,"price_id","");
					int rem=0;
					if(maxMinMap.get("seat_"+tkktid)==null){
						try{
							rem= Integer.parseInt(maxMinMap.get("remaining_"+tkktid)+"")-Integer.parseInt(maxMinMap.get("hold_"+tkktid)+"");
							if(rem<0)rem=0;
						}catch(Exception e){System.out.println("error in holding ticketinginfo "+e.getMessage());}

						if(rem<max){
							max=rem;
							if(rem<min){min=0;max=0;}
						}
					}					
					eventTicketObj.setTicketMaxQty(max);
					eventTicketObj.setTicketMinQty(min);
					
					HashMap<String,String> timeHm=new HashMap<String,String>();

					if(eventDate!=null&&!"".equals(eventDate)){
						timeHm=(HashMap<String,String>)detailsMap.get(db.getValue(i,"price_id",""));
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
					
					ticketTimezones.getTimezones(timeHm,timeZone);
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
					else
						eventTicketObj.setMemberTicketFlag(false);
					
					try{
						eventTicketObj.setTicketIncrement(ticketIncJsonVal.has(db.getValue(i,"price_id","")) ? ticketIncJsonVal.getInt(db.getValue(i,"price_id","")) : 1);
					}catch(Exception e){
						System.out.println("Exception occured while getting tickets increment value:"+e.getMessage()+" _ "+db.getValue(i,"price_id",""));
					}
					
					
					if("NO".equalsIgnoreCase(db.getValue(i,"wait_list_type","NO")))
						eventTicketObj.setWaitListType("N");
					else{
						try{
							int waitListCapacity=0;
							try{
								waitListCapacity=Integer.parseInt(db.getValue(i,"wait_list_max_qty","0"));
							}catch(Exception e){waitListCapacity=0;}
							
							if(waitlistQtyMap.containsKey("inprocess_"+db.getValue(i,"price_id","")))
								rem=rem-waitlistQtyMap.get("inprocess_"+db.getValue(i,"price_id",""));
							if(waitListCapacity==100000){
								if(rem<=0){
									eventTicketObj.setWaitListType("Y");
									eventTicketObj.setWaitListLimit(waitListCapacity);
								}
							}else{
								int usedQty=0;
								if(waitlistQtyMap.containsKey(db.getValue(i,"price_id","")))
									usedQty=waitlistQtyMap.get(db.getValue(i,"price_id",""));
								if(waitListCapacity>usedQty && rem<=0){
									eventTicketObj.setWaitListType("Y"); 
									eventTicketObj.setWaitListLimit(waitListCapacity-usedQty);
								}else{
									eventTicketObj.setWaitListType("N");
									eventTicketObj.setWaitListLimit(0);
								}
							}
							
							if(rem<=0){
								if(!"".equals(eventDate) && "YES".equals(GenUtil.getHMvalue(configMap,"event.seating.enabled",""))){}
								else eventTicketObj.setTicketStatus("Sold Out");
							}
							if("Sold Out".equals(eventTicketObj.getTicketStatus()) && "Y".equals(eventTicketObj.getWaitListType())){
								int waitListLimit=eventTicketObj.getWaitListLimit();
								waitListLimit=waitListLimit==100000?originalMax:waitListLimit;
								waitListLimit=waitListLimit>originalMax?originalMax:waitListLimit;
								eventTicketObj.setWaitListLimit(waitListLimit);
							}
							
							}catch(Exception e){
								System.out.println("exception occured at waitlist info::-- "+e.getMessage());
							}
						}
					
					
					groupTicketsArray.add(eventTicketObj);
					if(groupTicketsArray!=null){
						CEventTicket eventTicketsArray[]=new CEventTicket[groupTicketsArray.size()];
						for(int k=0;k<groupTicketsArray.size();k++){
							eventTicketsArray[k]=(CEventTicket)groupTicketsArray.get(k);
						}
						tktGrp.setGroupTicketsArray(eventTicketsArray);
					}
					if(hashMapRef.get(db.getValue(i,"ticket_groupid",""))==null){
						requiredGroupTickets.add(tktGrp);
						hashMapRef.put(db.getValue(i,"ticket_groupid",""),"Y");
					}
					else{
						requiredGroupTickets.set(groupIndex-1,tktGrp);
					}
				}
				///groupTickets.put("Tickets",requiredGroupTickets);
			}
		}
		catch(Exception e){
			System.out.println("exeption in get Ticket Groups method in TicketInfo");
		}

		return requiredGroupTickets;
	}
	
	
	public HashMap<String,String> getTicketMessage(String eventid,String eventdate){
		HashMap<String,String> returnMap=new HashMap<String,String>();
		HashMap<String,String> hashMap=new HashMap<String,String>();
		HashMap<String,String> rec_hm=new HashMap<String,String>();
		DBManager db=new DBManager();
		StatusObj sb=null;

		String checkAvalability=DbUtil.getVal("select 'y' from ticketsavailability_display_formats where eventid=?",new String[]{eventid});
		checkAvalability=checkAvalability==null?"":checkAvalability;
		if("".equals(checkAvalability))
			return returnMap;
		
		String hold_qty="select sum(locked_qty) as holdqty,ticketid  from event_reg_locked_tickets where eventid=? and tid not in (select tid from event_reg_transactions where eventid=?) group by ticketid";
		try{
			if(!"".equals(eventdate)){
				String rec_qry="select ticketid,soldqty from reccurringevent_ticketdetails where eventid=cast(? as numeric)and eventdate=?";
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
					hashMap.put("hold_"+db.getValue(i, "ticketid", ""),db.getValue(i, "holdqty", ""));
				}
			}
			String query="select a.price_id as ticketid,a.max_ticket as capacity,a.sold_qty as soldoutqty,(a.max_ticket-a.sold_qty) as remainingqty,c.display_format as format from price a ,ticketsfordisplayformats b,ticketsavailability_display_formats c where  c.eventid=? and a.price_id=b.ticketid and b.formatid=c.formatid and c.eventid=b.eventid";

			sb=db.executeSelectQuery(query,new String[]{eventid});

			if(sb.getStatus()){

				for(int i=0;i<sb.getCount();i++){
					String tktid=db.getValue(i,"ticketid","");
					String format=db.getValue(i,"format","");
					String holdQty=(hashMap.get("hold_"+tktid)==null)?"0":hashMap.get("hold_"+tktid);
					if(!"".equals(eventdate)){
						if(	rec_hm.containsKey(tktid)){
							int remqty=Integer.parseInt(db.getValue(i,"capacity",""))-Integer.parseInt((String) rec_hm.get(tktid));
							returnMap.put(tktid,format.replace("$soldOutQty",rec_hm.get(tktid)).replace("$capacity", db.getValue(i,"capacity","")).replace("$onHoldQty", holdQty).replace("$remainingQty", ""+remqty));
							
						}else{
							returnMap.put(tktid,format.replace("$soldOutQty","0").replace("$onHoldQty", holdQty).replace("$remainingQty", db.getValue(i,"capacity","")));
							
						}
					}else
						returnMap.put(tktid,format.replace("$soldOutQty",db.getValue(i,"soldoutqty","")).replace("$capacity", db.getValue(i,"capacity","")).replace("$onHoldQty", holdQty).replace("$remainingQty",db.getValue(i,"remainingqty","")));
					
					//   sold:$soldOutQty cap:$capacity rem:$remainingQty hold:$onHoldQty 
				}
			}
		}catch(Exception e){System.out.println(" in exception retufn map is::"+returnMap);}
		
		System.out.println("retufn map is::"+returnMap);
		return returnMap;
	}




	
	public HashMap<String,String> checkTicket(String eventid,String eventdate){
		HashMap<String,String> ticketsHoldDetails=new HashMap<String,String>();
		HashMap<String,String> rec_hm=new HashMap<String,String>();
		DBManager db=new DBManager();
		DBManager dbm=new DBManager();
		StatusObj sb=null;
		String hold_qty="select sum(locked_qty) as holdqty,ticketid from event_reg_locked_tickets where eventid=? group by ticketid";

		try{
			if(!"".equals(eventdate)){
				String rec_qry="select ticketid,soldqty from reccurringevent_ticketdetails where eventid=CAST(? AS BIGINT) and eventdate=?";
				sb=db.executeSelectQuery(rec_qry,new String[]{eventid,eventdate});
				if(sb.getStatus()){
					for(int i=0;i<sb.getCount();i++){
						rec_hm.put(db.getValue(i,"ticketid",""),db.getValue(i,"soldqty",""));
					}
				}
				hold_qty="select sum(locked_qty) as holdqty,ticketid from event_reg_locked_tickets where eventid=? and eventdate=? group by ticketid";
				sb=db.executeSelectQuery(hold_qty,new String[]{eventid,eventdate});
			}
			else
				sb=db.executeSelectQuery(hold_qty,new String[]{eventid});

			if(sb.getStatus()){
				for(int i=0;i<sb.getCount();i++){
					ticketsHoldDetails.put("hold_"+db.getValue(i, "ticketid", ""),db.getValue(i, "holdqty", ""));
				}
			}
			String query="select a.price_id as ticketid,a.max_ticket as capacity,a.sold_qty as soldoutqty,(a.max_ticket-a.sold_qty) as remainingqty from price a where evt_id=CAST(? AS BIGINT)";
			sb=db.executeSelectQuery(query,new String[]{eventid});

			if(sb.getStatus()){
				for(int i=0;i<sb.getCount();i++){
					String tktid=db.getValue(i,"ticketid","");
					String format=db.getValue(i,"format","");
					ticketsHoldDetails.put(tktid,format);
					ticketsHoldDetails.put("capacity_"+tktid,db.getValue(i,"capacity",""));
					if(!"".equals(eventdate)){
						if(	rec_hm.containsKey(tktid)){
							ticketsHoldDetails.put("soldqty_"+tktid,rec_hm.get(tktid));
							int remqty=Integer.parseInt(db.getValue(i,"capacity",""))-Integer.parseInt((String) rec_hm.get(tktid));
							ticketsHoldDetails.put("remaining_"+tktid,remqty+"");
						}else{
							ticketsHoldDetails.put("remaining_"+tktid,db.getValue(i,"capacity",""));
							ticketsHoldDetails.put("soldqty_"+tktid,"0");
						}
					}else{
						ticketsHoldDetails.put("remaining_"+tktid,db.getValue(i,"remainingqty",""));
						ticketsHoldDetails.put("soldqty_"+tktid,db.getValue(i,"soldoutqty",""));
					}
					if(!ticketsHoldDetails.containsKey("hold_"+tktid)){
						ticketsHoldDetails.put("hold_"+tktid, "0");
					}
				}
			}
			
			if("YES".equals(GenUtil.getHMvalue(configMap,"event.seating.enabled",""))){
				String isseatingevent="SELECT ticketid from seat_tickets where eventid=CAST(? AS BIGINT)";
				sb= dbm.executeSelectQuery(isseatingevent, new String[]{eventid});
				if(sb.getStatus()){
					for(int i=0;i<sb.getCount();i++){	
						String tktid=dbm.getValue(i,"ticketid","");
						ticketsHoldDetails.put("seat_"+tktid, "yes");
					}
				}
			}
		}catch(Exception e){System.out.println("Exception at minmaxmap calculations"+e.getMessage()); }
		//System.out.println("maxMinMap::"+hm);
		return ticketsHoldDetails;
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
	
	public HashMap<String, Integer> getWaitListHoldQty(String eid, String eventdate) {
		HashMap<String, Integer> totalHoldTickets = new HashMap<String, Integer>();
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
	
	public HashMap<String,String> getWaitListDetails(String eid,String waitListId){
		String waitListQuery="select tk.ticketid,tr.status,tk.wait_list_id,tk.ticket_name,tk.ticket_qty,tr.exp_date,tr.exp_time,tr.eventdate from wait_list_tickets tk,wait_list_transactions tr where "+
		                     " tk.wait_list_id=tr.wait_list_id and tk.wait_list_id=? and tk.eventid=?::bigint and tr.status in('In Process','Expired')";
		DBManager dbm=new DBManager();
		StatusObj sbj=dbm.executeSelectQuery(waitListQuery,new String[]{waitListId,eid});
		HashMap<String,String> waitListObj=new HashMap<String,String>();
		try{
		if(sbj.getStatus() && sbj.getCount()>0){
			String expdate=dbm.getValue(0,"exp_date","");
			String exptime=dbm.getValue(0,"exp_time","");
			waitListObj.put(dbm.getValue(0,"ticketid",""),dbm.getValue(0,"ticketid",""));
			waitListObj.put("wid",dbm.getValue(0,"wait_list_id",""));
			waitListObj.put("tktqty",dbm.getValue(0,"ticket_qty",""));
			waitListObj.put("status",dbm.getValue(0,"status",""));
			boolean flag=true;
			flag=checkTimeDiffrence(expdate,exptime);
			if(!flag){
				waitListObj.put("status","Expired");
				makeWaitListExpired(eid,waitListId);
			}
		}
		}catch(Exception e){
			System.out.println("the exception occured in getWaitListDetails :"+e.getMessage());
		}
		
		return waitListObj;
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
	
	public HashMap getSelectedSeats(String eid,String edate,String tid){
		System.out.println("the eid:"+eid+":edate:"+edate+":tid:"+tid);
		HashMap<String,ArrayList<String>> blockedSeats=new HashMap<String,ArrayList<String>>();
		if(!"".equals(tid)){
			String query="";
			DBManager dbm=new DBManager();
			StatusObj sbj=null;
			query="select distinct seatindex,ticketid from event_reg_block_seats_temp where eventid=? and transactionid=? and seatindex NOT IN (select seatindex from seat_booking_status where eventid=to_number(?,'99999999999') and seatindex is not null)";
			if(!"".equals(edate)){
				query="select distinct seatindex,ticketid from event_reg_block_seats_temp where eventid=? and transactionid=? and eventdate=? and seatindex NOT IN (select seatindex from seat_booking_status where eventid=to_number(?,'999999999') and eventdate=? and seatindex is not null)";
				sbj=dbm.executeSelectQuery(query,new String[]{eid,tid,edate,eid,edate});
				if(sbj.getStatus() && sbj.getCount()>0){
					for(int i=0;i<sbj.getCount();i++){
						ArrayList<String> arrlist=new ArrayList<String>();
						if(blockedSeats.containsKey(dbm.getValue(i,"ticketid","")))
							arrlist=blockedSeats.get(dbm.getValue(i,"ticketid",""));
						arrlist.add(dbm.getValue(i,"seatindex",""));
						blockedSeats.put(dbm.getValue(i,"ticketid",""),arrlist);
					}	
				}
			}
			else{
				sbj=dbm.executeSelectQuery(query,new String[]{eid,tid,eid});
				if(sbj.getStatus() && sbj.getCount()>0){
					for(int i=0;i<sbj.getCount();i++){
						ArrayList<String> arrlist=new ArrayList<String>();
						if(blockedSeats.containsKey(dbm.getValue(i,"ticketid","")))
							arrlist=blockedSeats.get(dbm.getValue(i,"ticketid",""));
						arrlist.add(dbm.getValue(i,"seatindex",""));
						blockedSeats.put(dbm.getValue(i,"ticketid",""),arrlist);
					}
				}	
			} 
		}
	return blockedSeats;
	}
}
