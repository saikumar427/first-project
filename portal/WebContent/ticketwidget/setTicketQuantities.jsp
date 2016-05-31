<%@page import="com.eventregister.CCheckTicketStatus"%>
<%@page import="com.eventregister.CDiscountManager"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eventbee.conditionalticketing.validators.ConditionalTicketingValidator"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventregister.CRegistrationTiketingManager"%>
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
		StatusObj sb=DbUtil.executeUpdateQuery("insert into querystring_temp(tid,useragent,created_at,querystring,jsp) values (?,?,now(),?,?)",new String[]{tid, request.getHeader("User-Agent"),totalqstr,"setTicketQuantities.jsp 1st step"});
	}catch(Exception eq){
		System.out.println("error in setTicketQuantities.jsp(tid: "+tid+") inserting  query string"+eq.getMessage());
	}
	
 	String eid = request.getParameter("event_id");
 	
 	CRegistrationTiketingManager regtktmgr=new CRegistrationTiketingManager();
	regtktmgr.autoLocksAndBlockDelete(eid, tid, "ticketspagelevel");
 	
	String selectedTickets = request.getParameter("selected_tickets");
	String ticketids = request.getParameter("ticket_ids");
	String event_details = request.getParameter("event_details");
	String discountCode = request.getParameter("disc_code");
	
	JSONObject eventDataList = new JSONObject(event_details);
	String regSource=eventDataList.getString("registrationsource");
	String waitListID = eventDataList.getString("waitlistId");
	String edate = eventDataList.getString("event_date");
	String priorityToken = eventDataList.getString("priregtoken");
	String prilistId = eventDataList.getString("prilistid");
	String referral_ntscode = eventDataList.getString("referral_ntscode");
	String actionname=eventDataList.getString("actiontype");
	String track = eventDataList.getString("trackCode");
	String ticketurlcode = eventDataList.getString("ticketurlcode");
	String registrationsource = eventDataList.getString("registrationsource");
	String context = eventDataList.getString("context");
	String nts_enable = eventDataList.getString("nts_enable");
	String isSeating = eventDataList.getString("isSeating");
	String seatSectionId = eventDataList.getString("seatSectionId");
	
	if(priorityToken==null || "".equals(priorityToken))priorityToken="";
	if(prilistId==null || "".equals(prilistId))prilistId="";
	if(ticketids==null || "".equals(ticketids))ticketids="";
	if(referral_ntscode==null || "".equals(referral_ntscode))referral_ntscode="";
	if(waitListID==null||"".equals(waitListID))waitListID="";
	if(regSource==null||"".equalsIgnoreCase(regSource))regSource="manual";
	if(track==null || "".equals(track)) track = "";
	if(ticketurlcode==null||"".equals(ticketurlcode)) ticketurlcode="";
	if(registrationsource==null||"".equals(registrationsource)) registrationsource="";
	if(context==null||"".equals(context)) context="EB";
	if(discountCode==null || "".equals(discountCode))discountCode="";
	if(actionname==null||"".equals(actionname))actionname = "Order Now";
	if(isSeating==null||"".equals(isSeating))isSeating="";
	if(seatSectionId==null||"".equals(seatSectionId))seatSectionId="";
	
	if("FBApp".equals(context))
		regSource = "widget";
	
	String ntscode="",display_ntscode="";
	
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
	if(edate==null || "".equals(edate)){
		edate="";
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
	String selected_Tickets = ticketData.toString();
	System.out.println("selected_Tickets - - "+selected_Tickets);
	/* for Conditional Ticketing end */
	
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
		System.out.println("the events tickets are::"+eventTickets);
	}
	
	HashMap<String,HashMap<String,String>>  notAvailableTickets = new HashMap<String,HashMap<String,String>> ();
	if (!"".equals(edate)) {
		notAvailableTickets = checkStatus.getRecurringEventTicketsAvailibility(eid,edate,tid,selTickQty,eventTickets);
	}else{
		notAvailableTickets =  checkStatus.getNONRecurringEventTicketsAvailibility(eid,tid, selTickQty,eventTickets,waitListID,edate);
	}
	
	
	if(notAvailableTickets.isEmpty()){
		responseJSON.put("status", "success");
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "(Box Office) setTicketQuantities.jsp", "Registration Strated for the  event---->"+eid, "", null);
		
		/* This code for check seatstatus, this code from checkseatstatus.jsp(portal) */
		boolean checkSeatStatus = true;
		if(isSeating=="true")
			checkSeatStatus  = checkStatus.getSeatChecking(seatSectionId,eid,edate,tid,selTickQty,"");
		/* This code for check seatstatus end */
		
		if(checkSeatStatus){
			//note :  	below getTicketDetails data getting from CacheLoader
			//HashMap ticketDetailsMap=checkStatus.getTicketDetails(eid); 
			/*
			HashMap ntsdata=new HashMap();
			HashMap ntsdetails=new HashMap();
			
			 if(!"0".equals(fbuserid)){
				ntsdata.put("fbuserid",fbuserid);
				ntsdata.put("eventid",eid);
				ntsdata.put("ntsenable",nts_enable);
				ntsdata.put("fname",fname);
				ntsdata.put("lname",lname);
				ntsdata.put("email",email);
				ntsdata.put("network","facebook");
				try{
					System.out.println("calling get nts code method: "+fbuserid);
					ntsdetails=regTktMgr.getPartnerNTSCode(ntsdata);
					ntscode=(String)ntsdetails.get("nts_code");
					System.out.println("obtained nts code: "+ntscode);
					display_ntscode=(String)ntsdetails.get("display_ntscode");
				}
				catch(Exception e){
					System.out.println("exception in nts code: "+e.getMessage());
				}
			} */
			HashMap contextdata=new HashMap();
			String customerIp=request.getHeader("x-forwarded-for");
			if(customerIp==null || "".equals(customerIp)) 
				customerIp=request.getRemoteAddr();
			if(tid==null||"".equals(tid)){
				contextdata.put("useragent",request.getHeader("User-Agent")+"["+customerIp+"]");
				contextdata.put("trackurl",track);
				contextdata.put("ticketurlcode",ticketurlcode);
				contextdata.put("eventdate",edate);
				contextdata.put("registrationsource",registrationsource);
				contextdata.put("wid",waitListID);
				contextdata.put("prilistid",prilistId);
				contextdata.put("context",context);
				contextdata.put("pritoken",priorityToken);
				contextdata.put("discountcode",discountCode);
				contextdata.put("clubuserid","");
				tid=regtktmgr.createNewTransaction(eid,contextdata);
			}
			JSONObject obj=new JSONObject();
			try{
				obj=(JSONObject)new JSONTokener(selected_Tickets).nextValue();
			}catch(Exception e){
					System.out.println("Error while processing buyticket hold checking:eid:"+eid+"tid::"+tid+""+e.getMessage());
			}
			contextdata.put("selected_tickets",selectedTickets);
			contextdata.put("eid",eid);
			contextdata.put("allTicketIds",ticketids);
			contextdata.put("tid",tid);
			contextdata.put("nts_enable",nts_enable);
			contextdata.put("nts_commission","0");
			contextdata.put("referral_ntscode",referral_ntscode);
			if(!"{}".equals(obj+"")){
				String trackquery="insert into querystring_temp (tid,useragent,created_at,querystring,jsp ) values(?,?,now(),?,?)";
				DbUtil.executeUpdateQuery(trackquery,new String[]{tid,request.getHeader("User-Agent"),contextdata+"","setTicketQuantities.jsp 2st step"});
			}
			HashMap<String,String> resDetailsMap=checkStatus.doRegformAction(contextdata,regtktmgr,discountManager,eventTickets);
			if("fail".equalsIgnoreCase(resDetailsMap.get("status"))){
				responseJSON.put("status", "fail");
				responseJSON.put("reason", resDetailsMap.get("reason"));
				
			}else{
				responseJSON.put("details", resDetailsMap);
			}
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





