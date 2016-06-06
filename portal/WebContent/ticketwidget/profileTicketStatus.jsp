<%@page import="com.eventregister.CCheckProfileTicketStatus"%>
<%@page import="com.eventbee.general.EventbeeLogger"%>
<%@page import="com.eventregister.CDiscountManager"%>
<%@page import="com.eventregister.CCheckTicketStatus"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<% 
	String eid = request.getParameter("eventid");
	System.out.println("Ticket Checking Status in profileTicketStatus.jsp eventid= "+eid);
	
	String tid=request.getParameter("transaction_id");
	String selectedtickets=request.getParameter("selected_tickets");
	String eventdate=request.getParameter("event_date");
	String seating_enabled  = request.getParameter("seating_enabled");
	String seatSectionId = request.getParameter("seatSectionId");
	
	if(eventdate==null || "".equals(eventdate))eventdate="";
	
	JSONObject responseJSON = new JSONObject();
	if (eid == null||"".equals(eid) || selectedtickets == null||"".equals(selectedtickets)) {
		responseJSON.put("status", "fail");
		responseJSON.put("reason", "required parameters missing");
		out.println(responseJSON.toString(2));
		return;
	}
	
	JSONArray selTickQty = new JSONArray();
	try {
		selTickQty = new JSONArray(selectedtickets);
	} catch (Exception e) {
		System.out.println("(Box Office)Error while processing selected ticket:eid:"+ eid + "tid::" + tid + "" + e.getMessage());
		responseJSON.put("status", "fail");
		responseJSON.put("reason", "invalid params");
		out.println(responseJSON.toString(2));
		return;
	}
	
	HashMap<String,HashMap<String,String>>  notAvailableTickets = new HashMap<String,HashMap<String,String>> ();
	CCheckTicketStatus checkStatus = new CCheckTicketStatus();
	CCheckProfileTicketStatus checkprofile = new CCheckProfileTicketStatus();
	
	
	if (!"".equals(eventdate)) {
		notAvailableTickets = checkprofile.getRecurringEventTicketsAvailibility(eid,eventdate,tid,selTickQty);
	}else{
		notAvailableTickets =  checkprofile.getNONRecurringEventTicketsAvailibility(eid,tid, selTickQty,eventdate);
	}
	
	System.out.println("notAvailableTickets in profile page-  "+notAvailableTickets);
	
	
	if(notAvailableTickets.isEmpty()){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "(Box Office) profileTicketStatus.jsp", "profile submit started for the  event---->"+eid, "", null);
		// This code for check seatstatus start
		boolean checkSeatStatus = true;
		if("y".equalsIgnoreCase(seating_enabled)){
			checkSeatStatus  = checkStatus.getSeatChecking(seatSectionId,eid,eventdate,tid,selTickQty,"level2");
		}
		if(checkSeatStatus){
			responseJSON.put("status", "success");
		}else{
			responseJSON.put("status", "fail");
			responseJSON.put("reason", "noSeat");
		}
		// This code for check seatstatus end
	}
	
	System.out.println("final result "+responseJSON);
	out.println(responseJSON.toString(2));
%>