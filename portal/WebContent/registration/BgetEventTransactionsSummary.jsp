<%@page import="com.eventbee.general.DBManager"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Set"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>


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
String eid=request.getParameter("event_id");
String edate=request.getParameter("event_date");
String apiKey=request.getParameter("api_key");
JSONObject responseObject=new JSONObject();
if (apiKey == null||"".equals(apiKey)||eid == null||"".equals(eid)){
	responseObject.put("status", "fail");
	responseObject.put("reason", "required parameters missing");
	out.println(responseObject.toString(2));
	return;
}
DBManager dbManager=new DBManager();
edate=(edate==null||" ".equals(edate))?"":edate;

StatusObj statusObj=null;
String query="";
if("".equals(edate)){
	query="select count(a.profilekey) as count ,a.ticketid,b.userid  from profile_base_info a,event_reg_transactions b where a.transactionid=b.tid  and b.eventid=? and upper(b.paymentstatus) in ('COMPLETED', 'PENDING') group by a.ticketid,b.userid ";
	 statusObj=dbManager.executeSelectQuery(query, new String[]{eid});
}
else{
	  query="select count(a.profilekey) as count ,a.ticketid,b.userid  from profile_base_info a,event_reg_transactions b where a.transactionid=b.tid  and b.eventid=? and  b.eventdate=? and upper(b.paymentstatus) in ('COMPLETED', 'PENDING') group by a.ticketid,b.userid ";
	 statusObj=dbManager.executeSelectQuery(query, new String[]{eid,edate});
	}
HashMap<String,ArrayList<HashMap<String, String>>> summaryMap=new HashMap<String,ArrayList<HashMap<String,String>>>();

JSONArray ticketsSummary=new JSONArray();
ArrayList<String> alreadyFilledTicketIDs=new ArrayList<String>();
if(statusObj.getStatus()){	
	HashMap<String,String> eachTicket=null;	
	for(int i=0;i<statusObj.getCount();i++){		
		String ticketId=dbManager.getValue(i, "ticketid", "");
		if(summaryMap.containsKey(ticketId)){
			String user="";
			if("0".equals(dbManager.getValue(i, "userid", ""))||"".equals(dbManager.getValue(i, "userid", "")))
				 user="other sources";
			else
				user=dbManager.getValue(i, "userid", "");
			ArrayList<HashMap<String, String>> tempList=summaryMap.get(ticketId);
			HashMap<String, String> tempMap=new HashMap<String, String>();
			tempMap.put("user_id",user);
			tempMap.put("sold_qty",dbManager.getValue(i, "count", "0"));
			tempList.add(tempMap);
			summaryMap.put(ticketId, tempList);
		
		}else{
			String user="";
			if("0".equals(dbManager.getValue(i, "userid", ""))||"".equals(dbManager.getValue(i, "userid", "")))
				 user="other sources";
			else
				user=dbManager.getValue(i, "userid", "");
			ArrayList<HashMap<String, String>> tempList=new ArrayList<HashMap<String,String>>();
			HashMap<String, String> tempMap=new HashMap<String, String>();
			tempMap.put("user_id",user);
			tempMap.put("sold_qty",dbManager.getValue(i, "count", "0"));
			tempList.add(tempMap);
			summaryMap.put(ticketId, tempList);					
		}	
	}	
}


String maxQtyQuery="select max_ticket,price_id,ticket_name from price where evt_id=CAST(? AS BIGINT)";
StatusObj status=dbManager.executeSelectQuery(maxQtyQuery, new String[]{eid});
JSONObject eachTicket=null;
//System.out.println("map::"+summaryMap);
if(status.getStatus()&&status.getCount()>0){
	for(int i=0;i<status.getCount();i++){
		eachTicket=new JSONObject();
		eachTicket.put("ticket_id", dbManager.getValue(i, "price_id", "0"));
		eachTicket.put("max_qty", Integer.parseInt(dbManager.getValue(i, "max_ticket", "0")));
		eachTicket.put("name", dbManager.getValue(i, "ticket_name", ""));
		if(summaryMap.get(dbManager.getValue(i, "price_id", "0"))==null)
			eachTicket.put("user_sold_qty",new ArrayList());
		else
		   eachTicket.put("user_sold_qty",summaryMap.get((dbManager.getValue(i, "price_id", "0")) ));
		ticketsSummary.put(eachTicket);
	}
	
}

responseObject.put("status", "success");
responseObject.put("summary", ticketsSummary);
out.println(responseObject.toString(2));


%>
