<%@page import="com.eventbee.conditionalticketing.validators.ConditionalTicketingValidator"%>
<%@ page import="com.event.dbhelpers.*,com.eventregister.*,com.eventbee.general.*,org.json.JSONArray"%>
<%@ page import="java.util.*,java.util.ArrayList,org.json.*"%>
<%@ page import="com.eventbee.cachemanage.CacheManager"%>
<%@ page import="com.eventbee.cachemanage.CacheLoader"%>
<%@ page import="com.eventbee.regcaheloader.CheckTicketStatusLoader"%>
<%!
public HashMap eventLevelCheck(String eid,String tid,String eventdate,String sel_qty){
	HashMap result=new HashMap();
	String limitcount="";
	//String limitcount=DbUtil.getVal("select value from config where config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT)) and name='event.reg.eventlevelcheck.count'",new String[]{eid});
	Map eventinfoMap=null;
	try{
		eventinfoMap=CacheManager.getData(eid, "eventinfo");
		HashMap configMap=(HashMap)eventinfoMap.get("configmap");
		limitcount=GenUtil.getHMvalue(configMap,"event.reg.eventlevelcheck.count","");
	}catch(Exception e){
		System.out.println("Exception checkticketstatus.jsp eventLevelCheck CacheManager: eventid: "+eid+" ERROR:: "+e.getMessage());
	}
	limitcount=limitcount==null?"":limitcount.trim();
	if("".equals(limitcount))
	 return result;
	 
	try{Integer.parseInt(limitcount);
	}catch(Exception e){return result;}
     
	 String query="";
	String params[]=null;	 
	if(!"".equals(tid)){
		  if("".equals(eventdate))
	    {     query="select (?::integer -((select COALESCE(sum(locked_qty),0) from event_reg_locked_tickets where eventid=? and tid!=?)+(select COALESCE(sum(sold_qty),0) from price where evt_id=?::bigint and isdonation='No' ))) as re_qty";
		   params=new String[]{limitcount,eid,tid,eid};
	   }
	   else
	    {	    query="select (?::integer -((select COALESCE(sum(locked_qty),0) from event_reg_locked_tickets where eventid=? and eventdate=? and tid!=?)+(select COALESCE (sum (soldqty),0) from  reccurringevent_ticketdetails where eventid=?::bigint and eventdate=? and isdonation='No'))) as re_qty";
	         params=new String[]{limitcount,eid,eventdate,tid,eid,eventdate};
       }	
	}
		else{
		   if("".equals(eventdate))
	        { query="select (?::integer -((select COALESCE(sum(locked_qty),0) from event_reg_locked_tickets where eventid=?)+(select COALESCE(sum(sold_qty),0) from price where evt_id=?::bigint and isdonation='No'))) as re_qty";
		   params=new String[]{limitcount,eid,eid};
			}
			 else
		    {query="select (? ::integer -((select COALESCE(sum(locked_qty),0) from event_reg_locked_tickets where eventid=? and eventdate=?)+(select COALESCE( sum (soldqty),0) from reccurringevent_ticketdetails where eventid=?::bigint and eventdate=? and isdonation='No'))) as re_qty";
			params=new String[]{limitcount,eid,eventdate,eid,eventdate};
            }
		}
	if("".equals(query))	
	return result;
	String reqty=DbUtil.getVal(query,params);
	System.out.println("reqty:::::::"+reqty+"  params::"+ params);
	try{
	if(Integer.parseInt(reqty)<Integer.parseInt(sel_qty))
	  { 
	    result.put("sel_"+eid,sel_qty);
	    result.put("remaining_"+eid,reqty);
	    if(eventinfoMap!=null)
	    	result.put("Name",(String)eventinfoMap.get("eventname"));
	    else result.put("Name",DbUtil.getVal("select eventname from eventinfo where eventid=?::bigint",new String[]{eid}));
	  }	
	 }catch(Exception e ){System.out.println("Error While calculating the event level check:::"+tid+"::"+e.getMessage());
	}


return result;	
}
public HashMap getregularticketsAvailibility(HashMap hm,JSONObject jobj){
	HashMap hmap=new HashMap();
	HashMap remainingcounthm=new HashMap();
	ArrayList<HashMap<String,Integer>> waitListHoldQty=null;
	try{
		String eventid=(String) hm.get("eid");
		String tid=(String)hm.get("tid");
		String[] allticketid=(String[])hm.get("allticketids");
		DBManager db=new DBManager();
		StatusObj sb=null;
		
		//eid,tid,allticketIDs,wid
		//{'tktID':qty}
	/****strt eventlevelcheck****/
	int sel_qty=0;
    try{	 
	    for(int i=0;i<allticketid.length;i++){
			String tktid=allticketid[i];			
			if(jobj.has(tktid)){
				sel_qty=sel_qty+jobj.getInt(tktid);	
			}
		}
	}catch(Exception e){System.out.println("error qty cal::"+tid);sel_qty=0;}	

	waitListHoldQty=getWaitListHoldQty((String) hm.get("eid"), hm.containsKey("eventdate")? (String) hm.get("eventdate"):"", hm.containsKey("wid")? (String) hm.get("wid"):"");
   

	hmap=eventLevelCheck(eventid, tid,"",sel_qty+"");
	if(!hmap.isEmpty())
    return hmap;
    /****end eventlevel check****/
	
	 
		if(!"".equals(tid)){
			String pricequery="select (max_ticket-sold_qty) as remaining_qty, price_id as "
						 +"ticketid from price a where evt_id=CAST(? AS BIGINT) and price_id not"
						 +" in (select ticketid from event_reg_locked_tickets where "
						 +"eventid=? and tid!=?) union "
						 +"select a.max_ticket-a.sold_qty-sum(locked_qty)  as remaining_qty,"
						 +"ticketid from event_reg_locked_tickets b,  price a "
						 +"where eventid=? and tid!=? and a.price_id=b.ticketid "
                         +"group by ticketid, a.max_ticket, a.sold_qty";
			
			sb=db.executeSelectQuery(pricequery,new String[]{eventid,eventid,tid,eventid,tid});
		
		}
		else{
			String pricequery="select (max_ticket-sold_qty) as remaining_qty, price_id as "
						 +" ticketid from price a where evt_id=CAST(? AS BIGINT) and price_id not "
						 +"in (select ticketid from event_reg_locked_tickets where "
						 +"eventid=? ) union "
						 +"select a.max_ticket-a.sold_qty-sum(locked_qty)  as remaining_qty, "
						 +"ticketid from event_reg_locked_tickets b,  price a " 
						 +"where eventid=? and a.price_id=b.ticketid "
                         +"group by ticketid, a.max_ticket, a.sold_qty";
			sb=db.executeSelectQuery(pricequery,new String[]{eventid,eventid,eventid}); 
			
			/* if(!CacheManager.getInstanceMap().containsKey("checkticketstatus")){
				CacheLoader cacheLoader=new CheckTicketStatusLoader();
				cacheLoader.setRefreshInterval(1*60*1000);
				cacheLoader.setMaxIdleTime(1*60*1000);
				CacheManager.getInstanceMap().put("checkticketstatus",cacheLoader);		
			}
			Map checkTicketStatusMap=CacheManager.getData(eventid, "checkticketstatus");
			int t=0;
			while(checkTicketStatusMap==null && t<20){
				try {
				    Thread.sleep(200);
				    checkTicketStatusMap=CacheManager.getData(eventid, "checkticketstatus");
				    t++;
				} catch(InterruptedException ex) {
					System.out.println("InterruptedException in checkticketstatus: eventid: "+eventid+" iteration: "+t+" Exception: "+ex.getMessage());
				    Thread.currentThread().interrupt();
				}
			}
			sb=(StatusObj)checkTicketStatusMap.get("remaining_status_obj");
			db=(DBManager)checkTicketStatusMap.get("remaining_dbmanager"); */
			
		}
    
		if(sb.getStatus() && sb.getCount()>0){
			for(int i=0;i<sb.getCount();i++){	
				
				if( !"".equals(hm.get("wid")) && waitListHoldQty.get(0).containsKey(hm.get("wid")) ){
					remainingcounthm.put(db.getValue(i,"ticketid",""),db.getValue(i,"remaining_qty",""));
				}				
				else{
					int waitedQty=0;
					if(waitListHoldQty!=null)
						waitedQty=waitListHoldQty.get(1).get(db.getValue(i,"ticketid",""))==null?0:waitListHoldQty.get(1).get(db.getValue(i,"ticketid",""));
					remainingcounthm.put(db.getValue(i,"ticketid",""),(Integer.parseInt(db.getValue(i,"remaining_qty",""))-waitedQty)+"");
				}
			}
		}
		
		
		for(int i=0;i<allticketid.length;i++){
			String tktid=allticketid[i];
			
			if(jobj.has(tktid)){
				int qty=jobj.getInt(tktid);
				int remainingqty=Integer.parseInt((String)remainingcounthm.get(tktid));
				
				if(qty>remainingqty){
					hmap.put("sel_"+tktid,qty);
					hmap.put("remaining_"+tktid,remainingqty);
				}
			}
		}
	}catch(Exception e){
		System.out.println("exception in regular method is: "+e.getMessage());
	}
	
	return hmap;
}

public HashMap getrecurringticketsAvailibility(HashMap hm,JSONObject jobj){
	HashMap hmap=new HashMap();
	HashMap remainingcounthm=new HashMap();
	try{
	StatusObj price_sb=null,rec_sb=null,locked_sb=null;
	String eventid=(String) hm.get("eid");
	String tid=(String)hm.get("tid");
	String eventdate=(String)hm.get("eventdate");
	DBManager Db=new DBManager();
	String[] allticketid=(String[])hm.get("allticketids");
	/****strt eventlevelcheck****/
	int sel_qty=0;
    try{	 
	    for(int i=0;i<allticketid.length;i++){
			String tktid=allticketid[i];			
			if(jobj.has(tktid)){
				sel_qty=sel_qty+jobj.getInt(tktid);	
			}
		}
	}catch(Exception e){System.out.println("error qty cal::"+tid);sel_qty=0;}	
	
	hmap=eventLevelCheck(eventid, tid,eventdate,sel_qty+"");
	if(!hmap.isEmpty())
    return hmap;
    /****end eventlevel check****/
	
	
	String price_qry="select price_id,max_ticket,min_qty,max_qty from price where evt_id=CAST(? AS BIGINT)";
	price_sb=Db.executeSelectQuery(price_qry,new String[]{eventid});
	String rec_sold_qty_qry="select ticketid,soldqty from reccurringevent_ticketdetails where eventid=CAST(? AS BIGINT) and eventdate=?";
	
	String locked_qry="select sum(locked_qty) as locked_qty,ticketid from event_reg_locked_tickets where eventid=? and eventdate=? group by ticketid";

		if(price_sb.getStatus()&&price_sb.getCount()>0){
			for(int i=0;i<price_sb.getCount();i++){
			remainingcounthm.put("p_"+Db.getValue(i,"price_id",""),Db.getValue(i,"max_ticket",""));
			remainingcounthm.put("min_"+Db.getValue(i,"price_id",""),Db.getValue(i,"min_qty","0"));
			remainingcounthm.put("max_"+Db.getValue(i,"price_id",""),Db.getValue(i,"max_qty","0"));
			}
		}
		rec_sb=Db.executeSelectQuery(rec_sold_qty_qry,new String[]{eventid,eventdate});
		if(rec_sb.getStatus()&&rec_sb.getCount()>0){
		for(int i=0;i<rec_sb.getCount();i++){
			remainingcounthm.put("r_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"soldqty",""));
			}
			}
		if(!"".equals(tid)){
		locked_qry="select sum(locked_qty) as locked_qty,ticketid from event_reg_locked_tickets where eventid=? and eventdate=? and tid!=? group by ticketid";
		locked_sb=Db.executeSelectQuery(locked_qry,new String[]{eventid,eventdate,tid});
	}
	else{
		locked_sb=Db.executeSelectQuery(locked_qry,new String[]{eventid,eventdate});
	}
	
	if(locked_sb.getStatus()&&locked_sb.getCount()>0){
	
		for(int i=0;i<locked_sb.getCount();i++){
			remainingcounthm.put("l_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"locked_qty",""));
			}
	}
	
		
		for(int i=0;i<allticketid.length;i++){
			String tktid=allticketid[i];
			if(jobj.has(tktid)){
				int qty=jobj.getInt(tktid);
				int l_qty=0,p_qty=0,r_qty=0;
				int minqty=0;
				int maxqty=0;
				try{
					if(remainingcounthm.get("p_"+tktid)!=null)
					p_qty=Integer.parseInt((String)remainingcounthm.get("p_"+tktid));
				}catch(Exception e){}
				try{
				if(remainingcounthm.get("l_"+tktid)!=null)
					l_qty=Integer.parseInt((String)remainingcounthm.get("l_"+tktid));
				}catch(Exception e){}
				try{
					if(remainingcounthm.get("r_"+tktid)!=null)
					r_qty=Integer.parseInt((String)remainingcounthm.get("r_"+tktid));
				}catch(Exception e){System.out.println("exception is"+e.getMessage());}
				try{
					if(remainingcounthm.get("min_"+tktid)!=null)
						minqty=Integer.parseInt((String)remainingcounthm.get("min_"+tktid));
				}catch(Exception e){minqty=0;}
				try{
					if(remainingcounthm.get("max_"+tktid)!=null)
						maxqty=Integer.parseInt((String)remainingcounthm.get("max_"+tktid));
				}catch(Exception e){maxqty=0;}
				int remainingqty=p_qty-l_qty-r_qty;
				if(qty>remainingqty || qty<minqty || qty>maxqty){
					hmap.put("sel_"+tktid,qty);
					hmap.put("remaining_"+tktid,remainingqty);
				}
			}
		}
	}catch(Exception e){
	}
	
	return hmap;
	
	
	
	
	
}



	public ArrayList<HashMap<String, Integer>> getWaitListHoldQty(String eid, String eventdate,String waitListID) {
		ArrayList<HashMap<String, Integer>> returnMap=new  ArrayList<HashMap<String, Integer>>();
		HashMap<String, Integer> totalHoldTickets = new HashMap<String, Integer>();
		HashMap<String, Integer> allWids = new HashMap<String, Integer>();
		DBManager dbManager=new DBManager();
		StatusObj statusObj=null;
		int totalQty=0;
		if(eventdate==null || "".equals(eventdate))
			statusObj=dbManager.executeSelectQuery("select a.wait_list_id, a.ticket_qty,a.ticketid from wait_list_tickets a, wait_list_transactions b where  a.wait_list_id= b.wait_list_id and  b.status in('In Process','Waiting')  and a.eventid=cast(? as integer)", new String[]{eid});
		else
			statusObj=dbManager.executeSelectQuery("select a.wait_list_id, a.ticket_qty,a.ticketid from wait_list_tickets a, wait_list_transactions b where  a.wait_list_id= b.wait_list_id and  b.status in('In Process','Waiting')  and b.eventid=cast(? as integer) and b.eventdate=?", new String[]{eid,eventdate});
		for(int i=0;i<statusObj.getCount();i++){
			totalQty=totalQty+Integer.parseInt(dbManager.getValue(i, "ticket_qty", "0"));
			if(waitListID.equalsIgnoreCase(dbManager.getValue(i, "wait_list_id", "0")))
				allWids.put(dbManager.getValue(i, "wait_list_id", "0"),0);			
			if(totalHoldTickets.containsKey(dbManager.getValue(i, "ticketid", "")))
				totalHoldTickets.put(dbManager.getValue(i, "ticketid", ""), totalHoldTickets.get(dbManager.getValue(i, "ticketid", ""))+Integer.parseInt(dbManager.getValue(i, "ticket_qty", "0")));			
			else
				totalHoldTickets.put(dbManager.getValue(i, "ticketid", ""), Integer.parseInt(dbManager.getValue(i, "ticket_qty", "0")));
		}	
		totalHoldTickets.put("all_tickets_qty", totalQty);
		returnMap.add(allWids);
		returnMap.add(totalHoldTickets);
	
		System.out.println("returnMap:"+returnMap);

		return returnMap;
	}



	public JSONArray getConditionalTicketingRules(String eid){
	JSONArray conditionJsonAry=new JSONArray();
	String conditions = DbUtil.getVal("select rules from conditional_ticketing_rules where eventid=CAST(? AS BIGINT)", new String[]{eid});
	if(conditions==null) conditions="";
	try{
		conditionJsonAry = new JSONArray(conditions);
	}catch(Exception e){
	}
	return conditionJsonAry;
	}







%>
<%


String tid=request.getParameter("tid");

Map reqmapnet=request.getParameterMap();
		String totalqstr="";
		Iterator iterator = reqmapnet.keySet().iterator();
		while (iterator.hasNext()) {
				String key = (String) iterator.next();
				totalqstr=totalqstr+key+":{";
				String[] stringArray = (String[])reqmapnet.get(key);
				 
				 for(int i=0;i<stringArray.length;i++)
				  {
				  if(i==stringArray.length-1)
				   totalqstr=totalqstr+stringArray[i];
				   else
				  totalqstr=totalqstr+stringArray[i]+",";
				  }totalqstr=totalqstr+"} ";
	}
	 try{
			StatusObj sb=DbUtil.executeUpdateQuery("insert into querystring_temp(tid,useragent,created_at,querystring,jsp) values (?,?,now(),?,?)",new String[]{tid, request.getHeader("User-Agent"),totalqstr,"checkticketsstatus.jsp"});
	 }catch(Exception eq){System.out.println("error in profileformaction.jsp(tid: "+tid+") inserting  query string"+eq.getMessage());}



String eid=request.getParameter("eid");
String eventdate=request.getParameter("eventdate");
String selectedtickets=request.getParameter("selected_tickets");
String ticketids=request.getParameter("all_ticket_ids");
String waitListID=request.getParameter("wid");
waitListID=waitListID==null?"":waitListID;
if(ticketids==null){ticketids="";}
String[] allticketids=ticketids.split("_");

//System.out.println("checking ticket status....");

RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
regtktmgr.autoLocksAndBlockDelete(eid, tid, "ticketspagelevel");


/* DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid in (select tid from event_reg_details_temp where  eventid=?  and current_action in ('','profile page','tickets page','payment section','confirmation page'))and locked_time <(select now()- interval '20 minutes') and tid not in (?)",new String[]{eid,tid});

DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid in (select tid from event_reg_transactions where eventid=? and paymentstatus ='Completed')",new String[]{eid});


DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid in (select tid from event_reg_details_temp where  eventid=?  and current_action in ('paypal','google','eventbee','other','ebeecredits'))and locked_time <(select now()-interval '1 hours') and tid not in (?)",new String[]{eid,tid});

DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid in (select tid from event_reg_details_temp where eventid=? and current_action is null ) and locked_time < (select now()- interval '20 minutes')and tid not in (?)",new String[]{eid,tid});
 */

JSONObject obj=new JSONObject();
try{
obj=(JSONObject)new JSONTokener(selectedtickets).nextValue();
}catch(Exception e){System.out.println("Error while processing buyticket hold checking:eid:"+eid+"tid::"+tid+""+e.getMessage());}
HashMap hm= new HashMap();
hm.put("eid",eid);
hm.put("tid",tid);
hm.put("allticketids",allticketids);
hm.put("wid",  waitListID);
HashMap notavailabletktids=new HashMap();
//removeWaitListTransactionIds(hm); 
JSONObject jobj=new JSONObject();

ConditionalTicketingValidator condTickValidator = new ConditionalTicketingValidator();
try{
	//{"condition":"Block","src":"T1","trg":[{"id":"T2"},{"id":"T3"}]}
	if (selectedtickets.length() > 0 && selectedtickets.charAt(selectedtickets.length()-2)==',') 
		selectedtickets=selectedtickets.substring(0,selectedtickets.length()-2)+selectedtickets.substring(selectedtickets.length()-1);
	System.out.println("selectedtickets222: "+selectedtickets);
	JSONArray ja = getConditionalTicketingRules(eid);
ArrayList<String> errors = condTickValidator.validateConditions(ja, new JSONObject(selectedtickets),eid);
System.out.println("errors: "+errors);
if(errors.size()>0){
	notavailabletktids.put("status", "failure");
	notavailabletktids.put("reason", "conditional_ticketing");
	notavailabletktids.put("errors", new JSONArray(errors));
	jobj.put("responsemap",notavailabletktids);
	jobj.put("tid",tid);
	out.println(jobj.toString());
	return;
}
}catch(Exception e){
	System.out.println("Exception in checkticketsstatus.jsp for conditionaltickets:::::"+e.getMessage());
}








if(!"".equals(eventdate)){
hm.put("eventdate",eventdate);
notavailabletktids=getrecurringticketsAvailibility(hm,obj);
}
else{
notavailabletktids=getregularticketsAvailibility(hm,obj);
}
if(notavailabletktids.isEmpty()){
notavailabletktids.put("status","success");
}
else{
notavailabletktids.put("status","failure");
}
//JSONObject jobj=new JSONObject();

jobj.put("responsemap",notavailabletktids);
jobj.put("tid",tid);
out.println(jobj.toString());
%>