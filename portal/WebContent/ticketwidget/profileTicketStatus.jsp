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
	String ticketids=request.getParameter("ticket_ids");
	String waitListID = request.getParameter("wid");
	String discountCode = request.getParameter("discountCode");
	String seating_enabled  = request.getParameter("seating_enabled");
	String seatSectionId = request.getParameter("seatSectionId");
	
	if(discountCode==null || "".equals(discountCode))discountCode="";
	if(waitListID==null ||"".equals(waitListID))waitListID="";
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
	
	CDiscountManager discountManager=new CDiscountManager();
	HashMap<String,HashMap<String, String>> eventTickets=null;
	String discount="0";
	String discountType="ABSOLUTE";	
	if(!"".equals(discountCode)){	
		HashMap<String,String> discountsMap=discountManager.getDiscountDetails(discountCode,eid);
		if(discountsMap!=null&&discountsMap.size()>0){
			discount=(String)discountsMap.get("discount");
			discountType=(String)discountsMap.get("discounttype");
			System.out.println("before event Tickets MAp"+eventTickets);
			eventTickets=discountManager.getTickets(discountCode, eid,discount,discountType);			
			System.out.println("after event Tickets MAp"+eventTickets);
		}
	}
	else{//if discount code not send as parameter we need to get ticket price again
		eventTickets=discountManager.getTicketsPrices(eid);
	}
	HashMap<String,HashMap<String,String>>  notAvailableTickets = new HashMap<String,HashMap<String,String>> ();
	CCheckTicketStatus checkStatus = new CCheckTicketStatus();
	if (!"".equals(eventdate)) {
		notAvailableTickets = checkStatus.getRecurringEventTicketsAvailibility(eid,eventdate,tid,selTickQty,eventTickets);
	}else{
		notAvailableTickets =  checkStatus.getNONRecurringEventTicketsAvailibility(eid,tid, selTickQty,eventTickets,waitListID,eventdate);
	}
	
	if(notAvailableTickets.isEmpty()){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "(Box Office) profileTicketStatus.jsp", "profile submit started for the  event---->"+eid, "", null);
		responseJSON.put("status", "success");
		// This code for check seatstatus start
		boolean checkSeatStatus = true;
		if("y".equalsIgnoreCase(seating_enabled)){
			checkSeatStatus  = checkStatus.getSeatChecking(seatSectionId,eid,eventdate,tid,selTickQty,"level2");
		}
		if(!checkSeatStatus){
			responseJSON.put("status", "fail");
			responseJSON.put("reason", "noSeat");
		}
		// This code for check seatstatus end
	}
	
	System.out.println("final result "+responseJSON);
	out.println(responseJSON.toString(2));
%>