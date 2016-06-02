<%@page import="com.eventregister.CCheckTicketStatus"%>
<%@page import="com.eventregister.CDiscountManager"%>
<%@page import="java.util.ArrayList"%>
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
	
 	String eid = request.getParameter("event_id");
 	
 	CRegistrationTiketingManager regtktmgr=new CRegistrationTiketingManager();
	regtktmgr.autoLocksAndBlockDelete(eid, tid, "ticketspagelevel");
 	
	String selectedTickets = request.getParameter("selected_tickets");
	String ticketids = request.getParameter("ticket_ids");
	String event_details = request.getParameter("event_details");
	String discountCode = request.getParameter("disc_code");
	String fbuserid = request.getParameter("fbuserid");
	String fname = request.getParameter("fname");
	String lname = request.getParameter("lname");
	String email = request.getParameter("email");
	
	
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
	
	if("0".equals(fbuserid))
		fbuserid="";
	if(fbuserid==null||"".equals(fbuserid))fbuserid="";
	if(fname==null||"".equals(fname))fname="";
	if(lname==null||"".equals(lname))lname="";
	if(email==null||"".equals(email))email="";
	
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

	CCheckTicketStatus checkStatus = new CCheckTicketStatus();
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
	
	
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "(Box Office) setTicketQuantities.jsp", "Registration Strated for the  event---->"+eid, "", null);
	CRegistrationTiketingManager regTktMgr = new CRegistrationTiketingManager();
			
	HashMap ntsdata=new HashMap();
	HashMap ntsdetails=new HashMap();
	System.out.println("calling nts code..");
	 if(!"".equals(fbuserid)){
		 System.out.println("in  nts code..");
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
	}
	 
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
		/* JSONObject obj=new JSONObject();
		try{
			obj=(JSONObject)new JSONTokener(selectedTickets).nextValue();
		}catch(Exception e){
				System.out.println("Error while processing buyticket hold checking:eid:"+eid+"tid::"+tid+""+e.getMessage());
		} */
	 
		contextdata.put("selected_tickets",selectedTickets);
		contextdata.put("eid",eid);
		contextdata.put("allTicketIds",ticketids);
		contextdata.put("tid",tid);
		contextdata.put("nts_enable",nts_enable);
		contextdata.put("nts_commission","0");
		contextdata.put("referral_ntscode",referral_ntscode);
		
		if(!"".equals(selectedTickets)){
			String trackquery="insert into querystring_temp (tid,useragent,created_at,querystring,jsp ) values(?,?,now(),?,?)";
			DbUtil.executeUpdateQuery(trackquery,new String[]{tid,request.getHeader("User-Agent"),contextdata+"","setTicketQuantities.jsp step"});
		}
			
		HashMap<String,String> resDetailsMap=checkStatus.doRegformAction(contextdata,regtktmgr,discountManager,eventTickets);
		if("fail".equalsIgnoreCase(resDetailsMap.get("status"))){
			responseJSON.put("status", "fail");
			responseJSON.put("reason", resDetailsMap.get("reason"));
			
		}else{
			responseJSON.put("status", "success");
			responseJSON.put("details", resDetailsMap);
			
			ntsdata.put("ntscode",ntscode);
			ntsdata.put("ntsenable",nts_enable);
			ntsdata.put("tid", tid);
			ntsdata.put("referral_ntscode",referral_ntscode);
			regTktMgr.updateDetailsTempNTSDetails(ntsdata);
		}
			
	
	out.println(responseJSON.toString(2));
%>





