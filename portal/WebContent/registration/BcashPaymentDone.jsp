<%@page import="org.json.JSONArray"%>
<%@page import="com.boxoffice.classes.CheckAvailabilityAtPayment"%>
<%@page import="com.boxoffice.classes.BMakeEmptyProfileInfo"%>
<%
	// Author: Venkat Reddy
	// Version: 0.1 
	// File: authenticateUser.jsp
	// created: 12/05/2014	
	// modified: 13/05/2014 by venkat reddy
%>
<%@page trimDirectiveWhitespaces="true"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventregister.BRegistrationProcessDB"%>
<%@page import="com.eventregister.BRegistrationConfirmationEmail"%>
<%@page import="com.eventbee.general.EventbeeLogger"%>
<%@page import="org.json.JSONObject"%>

<%
	JSONObject responseObject = new JSONObject();
	boolean resultFlag = false;
	String api_key = request.getParameter("api_key");
	String tid = request.getParameter("transaction_id");
	String eid = request.getParameter("event_id");
	String edate = request.getParameter("event_date");
	String sellerId = request.getParameter("seller_id");
	String profilesFilled=request.getParameter("profile_filled");
	String seatingEnabled=request.getParameter("seating_enabled");
	if(edate==null)
		edate="";
	if(seatingEnabled==null||"".equals(seatingEnabled))
		seatingEnabled="n";
	if(profilesFilled==null||"".equals(profilesFilled))
		profilesFilled="y";
		
	
	String  orderNum = "";
	int regMailStatus = 0;

	if (eid == null || "".equals(eid) || tid == null || "".equals(tid)
			|| api_key == null || "".equals(api_key) || sellerId == null
			|| "".equals(sellerId)) {		
		
		responseObject = new JSONObject();
		responseObject.put("status", "fail");
		responseObject.put("reason", "required parameters missing");
		out.println(responseObject.toString(2));
		return;
	}
	
	CheckAvailabilityAtPayment instance=new CheckAvailabilityAtPayment();
	String statusMessage=instance.paymentPageTicketAvailabilityCheck(eid, tid, "eventbee");

		if ("Timedout".equalsIgnoreCase(statusMessage)) {
			// {"errors":["The card number is incorrect"],"status":"error","order_num":"","tid":"RK7YEEBTHJ","eid":"121305643"}
			JSONArray errors = new JSONArray();
			errors.put("You have exceeded the time limit. Try with new transaction");
			out.println(new JSONObject().put("status", "error").put("errors", errors).toString(2));
			return;

		} else if ("maxqty".equalsIgnoreCase(statusMessage)) {
			JSONArray errors = new JSONArray();
			errors.put("You have exceeded the event maximum ticket quantity");
			out.println(new JSONObject().put("status", "error").put("errors", errors).toString(2));
			return;		
		}
	
	
	
	
	if("n".equalsIgnoreCase(profilesFilled)){
		BMakeEmptyProfileInfo emptyProFileEntries=new BMakeEmptyProfileInfo();
		emptyProFileEntries.makeEmptyProfileInfo(seatingEnabled, eid, edate, tid);
	}

	if (eid != null && tid != null) {
		BRegistrationProcessDB regProcessDB = new BRegistrationProcessDB();
       BRegistrationConfirmationEmail regConfirmEmail = new BRegistrationConfirmationEmail();
       String nettotal=DbUtil.getVal("select nettotal from event_reg_details_temp where tid=?", new String[]{tid});
	if(Double.parseDouble(nettotal)==0)
		DbUtil.executeUpdateQuery(
				"update event_reg_details_temp set selectedpaytype=?,collected_servicefee=0,cardfee=0.00,tax=0.0,grandtotal=CAST(? AS NUMERIC),status='Completed',current_action='confirmation page' where tid=?",
				new String[] { "nopayment", nettotal,tid });
		
	else
       DbUtil.executeUpdateQuery(
				"update event_reg_details_temp set selectedpaytype=?,collected_servicefee=0,cardfee=0.00,tax=0.0,grandtotal=CAST(? AS NUMERIC),status='Completed',current_action='confirmation page' where tid=?",
				new String[] { "other", nettotal,tid });
		orderNum = regProcessDB.insertRegistrationDb(tid, eid);
      regMailStatus = regConfirmEmail.sendRegistrationEmail(tid, eid);
		regMailStatus=1;
	}
	if (!"".equals(orderNum) && regMailStatus == 1)
		resultFlag = true;
	if (resultFlag){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.INFO,
				"Registration Process.jsp",
				"Registration Completed for the  event---" + eid
						+ " and transactionid is --->" + tid
						+ " and paytype is " + "other", "", null);
		responseObject.put("status", "success");
		responseObject.put("order_num",orderNum );
		DbUtil.executeUpdateQuery("update event_reg_transactions set userid=? where tid=?", new String[]{sellerId,tid});		
	}
	else{
		responseObject.put("status", "fail");
		responseObject.put("status", "invalid params");
	}
	out.println(responseObject.toString());
%>

