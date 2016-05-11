<%@page trimDirectiveWhitespaces="true"%>
<%@page import="com.eventregister.CTicketsJson"%>
<%@page import="com.event.dbhelpers.BDisplayAttribsDB"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@page import="com.eventbee.util.CoreConnector"%>
<%@page import="java.util.UUID"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="org.json.JSONObject"%>
<%@ include file="cors.jsp" %>
<%@ page
	import="com.eventbee.general.GenUtil,com.eventbee.general.DbUtil"%>
<%@ page language="java" contentType="application/json; charset=utf-8"
	pageEncoding="utf-8"%>
<%
long startTime = System.currentTimeMillis();
String eid=request.getParameter("event_id");
String edate=request.getParameter("event_date");
String apiKey=request.getParameter("api_key");
String ticketurlcode=request.getParameter("ticketurl");
String tid=request.getParameter("transaction_id");
String seating_enable=request.getParameter("seating_enable");
String discountCode=request.getParameter("disc_code");
String priregtoken = request.getParameter("Priregtoken");
String priregtype = request.getParameter("Priregtype");
String prilistid = request.getParameter("Prilistid");
HashMap<String, String> params = new HashMap<String, String>();

params.put("evtdate", edate);
params.put("tid", tid);
params.put("tkt_url_code", ticketurlcode);
params.put("disc_code", discountCode);
params.put("source", "widget");
params.put("pri_reg_token", priregtoken);
params.put("pri_reg_type", priregtype);
params.put("pri_listid", prilistid);
String uid=UUID.randomUUID().toString();



if(eid==null||"".equals(eid)||apiKey==null||"".equals(apiKey)){
	JSONObject responseJSON=new JSONObject();
	responseJSON.put("status", "fail");
	responseJSON.put("reason", "required parameters missing");
	out.println(responseJSON.toString(2));
	return;
}

tid=(tid==null)?"":tid.trim();

discountCode=(discountCode==null)?"":discountCode;
edate=(edate==null)?"":edate;

CTicketsJson ticketsJSONObj=new CTicketsJson();

System.out.println("(Box office) starttime:"+new java.util.Date()+" uid::"+uid+"  eid::"+eid+" mis::"+new java.util.Date().getTime());
JSONObject ticketsJSON=ticketsJSONObj.getTicketsJSON(eid,params);
System.out.println("(Box office) restime:"+new java.util.Date()+" uid::"+uid+"  eid::"+eid+" mis::"+new java.util.Date().getTime());
String currencyFormat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code in (select currency_code from event_currency where eventid=?)",new String[]{eid});

if(currencyFormat==null)
	currencyFormat="$";
ticketsJSON.put("currency",currencyFormat);
	//BTicketsInfo ticketInfo = new BTicketsInfo();
	//ticketsJSON.put("availibility_msg",
	//ticketInfo.getTicketMessage(eid, edate));
	String discnbuy = "dn";
	if ("YES".equals(seating_enable)) {
		ticketsJSON.put("seatticketid",com.eventregister.BSeatingDBHelper.getAllticketid(eid));
		discnbuy = DbUtil.getVal("select value from config where name='event.discBuy.up' and config_id=(select config_id from eventinfo where eventid=?:: bigint limit 1)",
		new String[] { eid });
	}
	discnbuy = discnbuy == null ? "dn" : discnbuy;
	ticketsJSON.put("discnbuy", discnbuy);
	
	
	System.out.println("(Box office) processtime:" + new java.util.Date() + " uid::"
	+ uid + "  eid::" + eid + " mis::"
	+ new java.util.Date().getTime());
	ticketsJSON.put("status", "success");
	
		
	long endTime = System.currentTimeMillis();
	System.out.println("time for request procsss "+ (endTime - startTime));
	out.println(ticketsJSON.toString(2));
	System.out.println("response:: "+ticketsJSON.toString());
%>
