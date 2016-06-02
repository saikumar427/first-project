<%@page import="java.util.ArrayList"%>
<%@page import="com.eventregister.CCheckTicketStatus"%>
<%@page import="com.eventbee.conditionalticketing.validators.ConditionalTicketingValidator"%>
<%@page import="com.eventregister.CRegistrationTiketingManager"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.eventbee.general.EventbeeLogger"%>
<%@page trimDirectiveWhitespaces="true"%>
<%@page language="java" contentType="application/json; charset=ISO-8859-1"	pageEncoding="ISO-8859-1"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONTokener"%>
<%@page import="org.json.JSONObject"%>
<%@ include file="cors.jsp" %>
<% 
	String tid = request.getParameter("transaction_id");
	
	Map reqmapnet=request.getParameterMap();
	String totalqstr="";
	Iterator iterator = reqmapnet.keySet().iterator();
	while (iterator.hasNext()) {
			String key = (String) iterator.next();
			totalqstr=totalqstr+key+":{";
			String[] stringArray = (String[])reqmapnet.get(key);
			 for(int i=0;i<stringArray.length;i++){
				 if(i==stringArray.length-1)
					 totalqstr=totalqstr+stringArray[i];
				 else
					 totalqstr=totalqstr+stringArray[i]+",";
			  }totalqstr=totalqstr+"} ";
	}try{
		StatusObj sb=DbUtil.executeUpdateQuery("insert into querystring_temp(tid,useragent,created_at,querystring,jsp) values (?,?,now(),?,?)",new String[]{tid, request.getHeader("User-Agent"),totalqstr,"checkTicketQty.jsp step"});
	}catch(Exception eq){
		System.out.println("error in setTicketQuantities.jsp(tid: "+tid+") inserting  query string"+eq.getMessage());
	}
	String eid = request.getParameter("event_id");
	String event_details = request.getParameter("event_details");
	String selectedTickets = request.getParameter("selected_tickets");
	String ticketids = request.getParameter("ticket_ids");
	String edate = request.getParameter("event_date");
	String waitListID = request.getParameter("waitlistId");
	String allticketDeatils = request.getParameter("allticketDeatils");
	String isSeating = request.getParameter("isSeating");
	String seatSectionId = request.getParameter("seatSectionId");
	
	if(isSeating==null||"".equals(isSeating))isSeating="";
	if(seatSectionId==null||"".equals(seatSectionId))seatSectionId="";
	if(edate==null || "".equals(edate))	edate="";
	waitListID=waitListID==null?"":waitListID;
	if(ticketids==null){ticketids="";}
	String[] allticketids=ticketids.split(",");
	
	JSONObject responseJSON = new JSONObject();
	if (eid == null||"".equals(eid) || selectedTickets == null||"".equals(selectedTickets)) {
		responseJSON.put("status", "fail");
		responseJSON.put("reason", "required parameters missing");
		out.println(responseJSON.toString(2));
		return;
	}
	
	JSONArray selTickQty = new JSONArray();
	try {
		selTickQty = new JSONArray(selectedTickets);
	} catch (Exception e) {
		System.out.println("(Box Office)Error while processing selected ticket:eid:"+ eid + "tid::" + tid + "" + e.getMessage());
		responseJSON.put("status", "fail");
		responseJSON.put("reason", "invalid params");
		out.println(responseJSON.toString(2));
		return;
	}
	
	
	/* for Conditional Ticketing start */
	JSONObject ticketData = new JSONObject();
	JSONArray slecttedData = new JSONArray(selectedTickets);
	JSONObject temp ;
	for(int i=0;i<slecttedData.length();i++){
		temp = slecttedData.getJSONObject(i);
		if(temp.has("amount")){
			//
		}else
			ticketData.put(temp.get("ticket_id").toString(),temp.get("qty"));
	}
	
	System.out.println(ticketData);
	
	String selected_Tickets = ticketData.toString();
	ConditionalTicketingValidator condTickValidator = new ConditionalTicketingValidator();
	CCheckTicketStatus checkStatus = new CCheckTicketStatus();
	try{
		//{"condition":"Block","src":"T1","trg":[{"id":"T2"},{"id":"T3"}]}
		// this condition for convert {"ticketid":qty,} TO {"ticketid":qty}  
		if (selected_Tickets.length() > 0 && selected_Tickets.charAt(selected_Tickets.length()-2)==',') 
			selected_Tickets=selected_Tickets.substring(0,selected_Tickets.length()-2)+selected_Tickets.substring(selected_Tickets.length()-1);
		
		JSONArray ja = checkStatus.getConditionalTicketingRules(eid);
		ArrayList<String> errors = condTickValidator.validateConditions(ja, new JSONObject(selected_Tickets),eid);
		if(errors.size()>0){
			responseJSON.put("reason", "conditional_ticketing");
			responseJSON.put("errors", new JSONArray(errors));
			responseJSON.put("tid",tid);
			responseJSON.put("status", "fail");
			out.println(responseJSON.toString());
			return;
		}
	}catch(Exception e){
		System.out.println("Exception in checkticketsstatus.jsp for conditionaltickets:::::"+e.getMessage());
	}
	/* for Conditional Ticketing end */
	

	
	CRegistrationTiketingManager regtktmgr=new CRegistrationTiketingManager();
	regtktmgr.autoLocksAndBlockDelete(eid, tid, "ticketspagelevel");
	
	HashMap<String,HashMap<String, String>> eventTickets=new  HashMap<String,HashMap<String, String>>();
	HashMap<String,String>  hm=new HashMap<String,String>();
	JSONArray tempDetails = new JSONArray(allticketDeatils);
	for(int k = 0;k < tempDetails.length();k++){
		hm.put("isdonation",tempDetails.getJSONObject(k).getString("isdonation"));
		hm.put("ticketid",tempDetails.getJSONObject(k).getString("ticketid"));
		eventTickets.put(tempDetails.getJSONObject(k).getString("ticketid"), hm);
	}
	
	HashMap<String,HashMap<String,String>>  notAvailableTickets = new HashMap<String,HashMap<String,String>> ();
	if (!"".equals(edate)) {
		notAvailableTickets = checkStatus.getRecurringEventTicketsAvailibility(eid,edate,tid,selTickQty,eventTickets);
	}else{
		notAvailableTickets =  checkStatus.getNONRecurringEventTicketsAvailibility(eid,tid, selTickQty,eventTickets,waitListID,edate);
	}
	
	if(notAvailableTickets.isEmpty()){
		/* This code for check seatstatus, this code from checkseatstatus.jsp(portal) */
		boolean checkSeatStatus = true;
		if(isSeating=="true")
			checkSeatStatus  = checkStatus.getSeatChecking(seatSectionId,eid,edate,tid,selTickQty,"");
		/* This code for check seatstatus end */
		if(checkSeatStatus){
			responseJSON.put("status", "success");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "(Box Office) checkTicketQty.jsp", "Registration Strated for the  event---->"+eid, "", null);
		}else{
			responseJSON.put("status", "fail");
			responseJSON.put("reason", "noSeat");
		}
	}else{
		responseJSON.put("status", "fail");
		if(CCheckTicketStatus.EVENT_LEVEL_QTY_CRITERIA_MSG.equalsIgnoreCase(notAvailableTickets.get("criteria").get("criteria"))){
			responseJSON.put("reason", CCheckTicketStatus.EVENT_LEVEL_QTY_CRITERIA_MSG);
			Iterator<Map.Entry<String,HashMap<String,String>>> transactionsItereator = notAvailableTickets.entrySet().iterator();
			while (transactionsItereator.hasNext()) {
			    Map.Entry<String,HashMap<String,String>> pairs = (Map.Entry<String,HashMap<String,String>>)transactionsItereator.next();
			    if(!"criteria".equals(pairs.getKey())){
			    	responseJSON.put("details", pairs.getValue());			    	
			    }
			    transactionsItereator.remove(); // avoids a ConcurrentModificationException
			}	
		}else{
			responseJSON.put("reason", CCheckTicketStatus.TICKET_LEVEL_QTY_CRITERIA_MSG);
			JSONArray ticketQtyInfo=new JSONArray();
			Iterator<Map.Entry<String,HashMap<String,String>>> transactionsItereator = notAvailableTickets.entrySet().iterator();
			while (transactionsItereator.hasNext()) {
			    Map.Entry<String,HashMap<String,String>> pairs = (Map.Entry<String,HashMap<String,String>>)transactionsItereator.next();
			    if(!"criteria".equals(pairs.getKey())){
			    	ticketQtyInfo.put(pairs.getValue());
			    }
			    transactionsItereator.remove(); // avoids a ConcurrentModificationException
			}						
			responseJSON.put("details", ticketQtyInfo);
		}
	}
	
	out.println(responseJSON.toString(2));
%>