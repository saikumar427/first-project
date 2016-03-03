<%@page import="com.eventbee.general.GenUtil"%>
<%@page import="com.event.dbhelpers.BDisplayAttribsDB"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eventregister.BDiscountManager"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@ include file="cors.jsp" %>
<%
	//Author: Venkat Reddy
	//Version: 0.1
	//File: getEventTickets.jsp 
	//Created: 14/05/2014 
	//Modified: 17/05/2014 by venkat reddy*/
%>
<%@page trimDirectiveWhitespaces="true"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	long startTime = System.currentTimeMillis();	
	String eid = request.getParameter("event_id");
	String code = request.getParameter("code");
	String apiKey = request.getParameter("api_key");
	JSONObject responseObject = new JSONObject();
	if (eid == null ||"".equals(eid)|| code == null||"".equals(code)||apiKey == null||"".equals(apiKey)) {
		responseObject.put("status", "fail");
		responseObject.put("reason", "required parameters missing");
		out.println(responseObject.toString(2));
		return;
	}
	
	
	BDiscountManager discountsManager = new BDiscountManager();
	HashMap<String, Object> discountDetails = discountsManager
			.getDiscountInfo(code, eid,"");
	String discountMsg = (String) discountDetails.get("message");
	if ("false".equals(discountDetails.get("disc_applied_flag"))) {
		responseObject.put("status", "fail");
		if(discountMsg==null||"".equals(discountMsg)){		
			HashMap<String,String> discountLabels=BDisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
			discountMsg=GenUtil.getHMvalue(discountLabels,"event.reg.discount.not.available.msg","Applied code is Unavailable");			
		}
		responseObject.put("reason", discountMsg);
		responseObject.put("disc_msg", discountMsg);
		out.println(responseObject.toString(2));
		return;
	} else {
		responseObject.put("status", "success");
		HashMap<String,String> discountLabels=BDisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
		discountMsg=GenUtil.getHMvalue(discountLabels,"event.reg.discount.applied.msg","Applied");
		responseObject.put("disc_msg", discountMsg);
		responseObject.put("disc_code", code);
		JSONArray discountsArray = new JSONArray();
		//System.out.println(discountDetails.toString());
		HashMap<String,HashMap<String, String>> eventTickets = (HashMap<String,HashMap<String, String>>) discountDetails.get("disc_info");

		if (eventTickets != null && eventTickets.size() > 0) {
			Set<String> keySet=eventTickets.keySet();
			
	
			for (String key : keySet) {				
				HashMap<String, String> eachTicketMap = eventTickets.get(key);
				//if("yes".equalsIgnoreCase(eachTicketMap.get("disc_applied"))){	
					JSONObject eachTicket = new JSONObject();	
					if(Double.parseDouble(eachTicketMap.get("discount"))!=0){
						eachTicket.put("ticketid", (String) eachTicketMap.get("ticketid"));
						eachTicket.put("discount", (String) eachTicketMap.get("discount"));
						eachTicket.put("price", (String) eachTicketMap.get("price"));
						eachTicket.put("final_price", (String) eachTicketMap.get("final_price"));				
						//eachTicket.put("isdonation",
						//(String) eachTicketMap.get("isdonation").toLowerCase());				
						discountsArray.put(eachTicket);
					}
					
				//}
			}
		}

		responseObject.put("disc_details", discountsArray);
		
		out.println(responseObject.toString(2));

	}
%>



