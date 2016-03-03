<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Set"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eventbee.general.DBManager"%>

<%	//Author: Venkat Reddy
	//Version: 0.1
	//File: getSellerTransactions.jsp 
	//Created: 03/08/2014 
	//Modified: 4/08/2014 by venkat reddy
%>

<%@page trimDirectiveWhitespaces="true"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>		
<%
String tid=request.getParameter("transaction_id");
String apiKey=request.getParameter("api_key");
String eventId=request.getParameter("event_id");

JSONObject responseObject=new JSONObject();
if (tid == null ||"".equals(tid)||apiKey == null||"".equals(apiKey)||eventId == null||"".equals(eventId)){
	responseObject.put("status", "fail");
	responseObject.put("reason", "required parameters missing");
	out.println(responseObject.toString(2));
	return;
}

DBManager dbManger=new DBManager();
HashMap<String,HashMap<String,String>> ticketsWithQty=new HashMap<String,HashMap<String,String>>();
JSONArray attendees=new JSONArray();

String ticketsQtyQuery="select ticketqty,fee,ticketid,ticketname,ticketprice,discount,ticketstotal from transaction_tickets  where tid=? and eventid=?";
StatusObj statusObj=dbManger.executeSelectQuery(ticketsQtyQuery, new String[]{tid,eventId});
if(statusObj.getStatus()){	
	HashMap<String,String> eachTicket=null;
	for(int i=0;i<statusObj.getCount();i++){		
		eachTicket=new HashMap<String,String>();
		eachTicket.put("ticket_name", dbManger.getValue(i, "ticketname", ""));
		eachTicket.put("ticket_price", dbManger.getValue(i, "ticketprice", ""));
		eachTicket.put("service_fee", dbManger.getValue(i, "fee", ""));
		eachTicket.put("discount", dbManger.getValue(i, "discount", ""));
		eachTicket.put("tickets_total_price", dbManger.getValue(i, "ticketstotal", ""));
		eachTicket.put("ticket_qty", dbManger.getValue(i, "ticketqty", ""));
		ticketsWithQty.put(dbManger.getValue(i, "ticketid", ""),eachTicket);		
	}	
}

String query="select fname,lname,profilekey,ticketid from profile_base_info where transactionid=? and eventid=CAST(? AS BIGINT)";
statusObj=dbManger.executeSelectQuery(query, new String[]{tid,eventId});
if(statusObj.getStatus()){
	
	JSONObject eachAttendee=null;
	for(int i=0;i<statusObj.getCount();i++){		
		eachAttendee=new JSONObject();
		eachAttendee.put("fname", dbManger.getValue(i, "fname", ""));
		eachAttendee.put("lname", dbManger.getValue(i, "lname", ""));
		eachAttendee.put("attendee_key", dbManger.getValue(i, "profilekey", ""));
		eachAttendee.put("ticket_id", dbManger.getValue(i, "ticketid", ""));
		try{
			eachAttendee.put("ticket_name", ticketsWithQty.get(dbManger.getValue(i, "ticketid", "")).get("ticket_name"));
		}catch(Exception e){
			eachAttendee.put("ticket_name", "");
		}
		attendees.put(eachAttendee);
		
	}	
	
	
}



responseObject.put("status", "success");
responseObject.put("attendees", attendees);
JSONArray tcikets=new JSONArray();
Iterator<Map.Entry<String,HashMap<String,String>>> ticketsItereator = ticketsWithQty.entrySet().iterator();
JSONObject eachTicketObject=null;
while (ticketsItereator.hasNext()) {
	eachTicketObject=new JSONObject();
    Map.Entry<String,HashMap<String,String>> pairs = (Map.Entry<String,HashMap<String,String>>)ticketsItereator.next();
    eachTicketObject.put("ticket_id",pairs.getKey());
    eachTicketObject.put("ticket_name",pairs.getValue().get("ticket_name"));
    eachTicketObject.put("ticket_qty",pairs.getValue().get("ticket_qty"));
    eachTicketObject.put("ticket_price",pairs.getValue().get("ticket_price"));
    eachTicketObject.put("service_fee",pairs.getValue().get("service_fee"));
    eachTicketObject.put("disc_amount",pairs.getValue().get("discount"));
    eachTicketObject.put("tickets_total_price",pairs.getValue().get("tickets_total_price"));
    tcikets.put(eachTicketObject);
    ticketsItereator.remove(); // avoids a ConcurrentModificationException
}
responseObject.put("ticket_details",tcikets);

String transactionInfoQuery="select fname,lname,phone,email,discountcode,current_discount,original_amount,current_tax,ordernumber,to_char(transaction_date, 'Mon DD, YYYY HH:MI AM') as transaction_date from event_reg_transactions b where  b.tid=?";
StatusObj staObj=dbManger.executeSelectQuery(transactionInfoQuery, new String[]{tid});
JSONObject transactionInfo=new JSONObject();
transactionInfo.put("fname", dbManger.getValue(0, "fname", ""));
transactionInfo.put("lname", dbManger.getValue(0, "lname", ""));
transactionInfo.put("email", dbManger.getValue(0, "email", ""));
transactionInfo.put("phone", dbManger.getValue(0, "phone", ""));
transactionInfo.put("disc_code", dbManger.getValue(0, "discountcode", ""));
transactionInfo.put("disc_amount", dbManger.getValue(0, "current_discount", ""));
transactionInfo.put("tax", dbManger.getValue(0, "current_tax", ""));
transactionInfo.put("total_amount", dbManger.getValue(0, "original_amount", ""));
transactionInfo.put("order_num", dbManger.getValue(0,"ordernumber", ""));
transactionInfo.put("transaction_date", dbManger.getValue(0, "transaction_date", ""));
responseObject.put("transaction_details", transactionInfo);

out.println(responseObject.toString(2));

%>