<%@page import="com.eventregister.BDiscountManager"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.eventbee.general.EventbeeLogger"%>

<%//Author: Venkat Reddy
	//Version: 0.1
	//File: getEventTickets.jsp 
	//Created: 14/05/2014 
	//Modified: 17/05/2014 by venkat reddy*/%>
<%@page trimDirectiveWhitespaces="true"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.eventregister.BCheckTicketStatus"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONTokener"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventregister.BRegistrationTiketingManager"%>
<%@ include file="cors.jsp" %>

<%
	String eid = request.getParameter("event_id");
	String tid = request.getParameter("transaction_id");
	String edate = request.getParameter("event_date");
	String selectedTickets = request.getParameter("selected_tickets");
	String discountCode = request.getParameter("disc_code");
	String email = request.getParameter("email");
	String phoneNumber = request.getParameter("phone");
	String regSource=request.getParameter("reg_source");
	String context=request.getParameter("context");
	
	if(regSource==null||"".equalsIgnoreCase(regSource)){
		regSource="boxoffice";
	}
	if(context==null||"".equalsIgnoreCase(context)){
		context="android";
	}
		
	BRegistrationTiketingManager regManager = new BRegistrationTiketingManager();
	BCheckTicketStatus checkStatus = new BCheckTicketStatus();
	BDiscountManager discountManager=new BDiscountManager();
	JSONObject responseJSON = new JSONObject();
	if (eid == null||"".equals(eid) || selectedTickets == null||"".equals(selectedTickets)) {
		responseJSON.put("status", "fail");
		responseJSON.put("reason", "required parameters missing");
		out.println(responseJSON.toString(2));
		return;
	}

	if(edate==null){
		edate="";
	}
	JSONArray selTickQty = new JSONArray();
	try {
		selTickQty = new JSONArray(selectedTickets);
	} catch (Exception e) {
		System.out
		.println("(Box Office)Error while processing selected ticket:eid:"
				+ eid + "tid::" + tid + "" + e.getMessage());
		responseJSON.put("status", "fail");
		responseJSON.put("reason", "invalid params");
		out.println(responseJSON.toString(2));
		return;
	}

	System.out.println("(Box office)checking ticket status....");
	
	regManager.autoLocksAndBlockDelete(eid, tid,
	"(Box Office) setTicketQuantities.jsp");

	
	
	
	HashMap<String,HashMap<String, String>> eventTickets=null;
	String discount="0";
	String discountType="ABSOLUTE";	
	if(discountCode==null)
		discountCode="";
	
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
	if (!"".equals(edate)) {
		notAvailableTickets = checkStatus
		.getRecurringEventTicketsAvailibility(eid,edate,tid,selTickQty,eventTickets);
	} else {
		notAvailableTickets = checkStatus.getNONRecurringEventTicketsAvailibility(
		eid,tid, selTickQty,eventTickets);
	}
	if (notAvailableTickets.isEmpty()) {
		responseJSON.put("status", "success");		
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "(Box Office) Regform action.jsp", "Registration Strated for the  event---->"+eid, "", null);
		String customerIp=request.getHeader("x-forwarded-for");
		if(customerIp==null || "".equals(customerIp)) customerIp=request.getRemoteAddr();
		if(customerIp==null || "".equals(customerIp)) customerIp="";	
		
		if(tid==null||"".equals(tid)){
			HashMap<String,String> paramsData=new HashMap<String,String>();
			paramsData.put("user_agent",customerIp);			
			paramsData.put("edate",edate);
			if(regSource!=null)
				paramsData.put("reg_source",regSource);
				
			paramsData.put("context",context);
		
			paramsData.put("disc_code",discountCode);			
			tid=regManager.createNewTransaction(eid,paramsData);
			}
		
		HashMap<String,String> paramsData=new HashMap<String,String>();
		
		paramsData.put("disc_code",discountCode);	
		paramsData.put("eid", eid);
		paramsData.put("edate", edate);
		paramsData.put("tid", tid);
		paramsData.put("user_agent",customerIp);
		paramsData.put("json",selectedTickets);
		HashMap<String,String> resDetailsMap=checkStatus.doRegformAction(paramsData,regManager,discountManager,eventTickets);	
		System.out.println("(Box office)response after regform action"+resDetailsMap);
		
		if("fail".equalsIgnoreCase(resDetailsMap.get("status"))){
			responseJSON.put("status", "fail");
			responseJSON.put("reason", resDetailsMap.get("reason"));
			//System.out.println("(insde fail regform action"+responseJSON.toString());
			
		}
		//System.out.println("final response"+responseJSON.toString());
		else{
			responseJSON.put("details", resDetailsMap);
		}
		
	} else {
		responseJSON.put("status", "fail");
		if(BCheckTicketStatus.EVENT_LEVEL_QTY_CRITERIA_MSG.equalsIgnoreCase(notAvailableTickets.get("criteria").get("criteria"))){
			responseJSON.put("reason", BCheckTicketStatus.EVENT_LEVEL_QTY_CRITERIA_MSG);			
					
			Iterator<Map.Entry<String,HashMap<String,String>>> transactionsItereator = notAvailableTickets.entrySet().iterator();
			while (transactionsItereator.hasNext()) {
			    Map.Entry<String,HashMap<String,String>> pairs = (Map.Entry<String,HashMap<String,String>>)transactionsItereator.next();
			    if(!"criteria".equals(pairs.getKey())){
			    	responseJSON.put("details", pairs.getValue());			    	
			    }
			    transactionsItereator.remove(); // avoids a ConcurrentModificationException
			}							
		}
		else{			
			responseJSON.put("reason", BCheckTicketStatus.TICKET_LEVEL_QTY_CRITERIA_MSG);
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





