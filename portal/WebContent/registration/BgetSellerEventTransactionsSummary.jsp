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

<%	//Author: Venkat
	//Version: 0.1
	//File: BgetSellerEventTransactionsSummary.jsp 
	//Created: 26/07/2014 
	//Modified: 26/07/2014 by venkat*/
%>

<%@page trimDirectiveWhitespaces="true"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>		
<%
String sellerId=request.getParameter("seller_id");
String eid=request.getParameter("event_id");
String edate=request.getParameter("event_date");
String apiKey=request.getParameter("api_key");
JSONObject responseObject=new JSONObject();
if (sellerId == null ||"".equals(sellerId)||apiKey == null||"".equals(apiKey)||eid == null||"".equals(eid)){
	responseObject.put("status", "fail");
	responseObject.put("reason", "required parameters missing");
	out.println(responseObject.toString(2));
	return;
}
DBManager dbManger=new DBManager();
edate=(edate==null)?"":edate;
String query="select max_ticket,price_id,ticket_name from price where evt_id=CAST(? AS BIGINT)";
StatusObj status=dbManger.executeSelectQuery(query, new String[]{eid});
HashMap<String,Integer> ticketsWithMaxQty=new HashMap<String,Integer>();
HashMap<String,String> ticketsWithName=new HashMap<String,String>();
if(status.getStatus()&&status.getCount()>0){
	for(int i=0;i<status.getCount();i++){
		ticketsWithMaxQty.put(dbManger.getValue(i, "price_id", "0"), Integer.parseInt(dbManger.getValue(i, "max_ticket", "0")));
		ticketsWithName.put(dbManger.getValue(i, "price_id", "0"), dbManger.getValue(i, "ticket_name", ""));
	}
}
StatusObj statusObj=null;
if("".equals(edate)){
	query="select count(*) as qty,a.ticketid from profile_base_info a,event_reg_transactions b where  a.transactionid=b.tid  and b.userid=? and b.eventid=? and upper(b.paymentstatus) in ('COMPLETED', 'PENDING') group by a.ticketid";
	 statusObj=dbManger.executeSelectQuery(query, new String[]{sellerId,eid});
}
else{
	query="select count(*) as qty,a.ticketid from profile_base_info a,event_reg_transactions b where  a.transactionid=b.tid  and b.userid=? and b.eventid=? and b.eventdate=? and upper(b.paymentstatus) in ('COMPLETED', 'PENDING') group by a.ticketid";
	 statusObj=dbManger.executeSelectQuery(query, new String[]{sellerId,eid,edate});
	}
JSONArray ticketsSummary=new JSONArray();
ArrayList<String> alreadyFilledTicketIDs=new ArrayList<String>();
if(statusObj.getStatus()){	
	JSONObject eachTicket=null;	
	for(int i=0;i<statusObj.getCount();i++){		
		eachTicket=new JSONObject();		
		alreadyFilledTicketIDs.add(dbManger.getValue(i, "ticketid", ""));
		eachTicket.put("ticket_id", dbManger.getValue(i, "ticketid", ""));
		eachTicket.put("sold", Integer.parseInt(dbManger.getValue(i, "qty", "0")));
		eachTicket.put("total", ticketsWithMaxQty.get(dbManger.getValue(i, "ticketid", "0"))==null?"0":ticketsWithMaxQty.get(dbManger.getValue(i, "ticketid", "0")));
		eachTicket.put("ticket_name", ticketsWithName.get(dbManger.getValue(i, "ticketid", "0")));
		ticketsSummary.put(eachTicket);		
	}	
}

Iterator<Map.Entry<String,Integer>> transactionsItereator = ticketsWithMaxQty.entrySet().iterator();
while (transactionsItereator.hasNext()) {
	Map.Entry<String,Integer> pairs = (Map.Entry<String,Integer>)transactionsItereator.next();
	JSONObject eachTicket=null;
	System.out.println("id"+pairs.getKey());
   if(!alreadyFilledTicketIDs.contains(pairs.getKey())){
	   eachTicket=new JSONObject();		
		eachTicket.put("ticket_id",pairs.getKey());
		eachTicket.put("sold", 0);
		eachTicket.put("total", pairs.getValue());
		eachTicket.put("ticket_name", ticketsWithName.get(pairs.getKey()));
		ticketsSummary.put(eachTicket);		   
   }
}	


responseObject.put("status", "success");
responseObject.put("summary", ticketsSummary);
out.println(responseObject.toString(2));


%>
