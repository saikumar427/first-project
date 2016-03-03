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
	//Created: 08/06/2014 
	//Modified: 11/06/2014 by venkat reddy
%>

<%@page trimDirectiveWhitespaces="true"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>		
<%
String sellerId=request.getParameter("seller_id");
String apiKey=request.getParameter("api_key");
JSONObject responseObject=new JSONObject();
if (sellerId == null ||"".equals(sellerId)||apiKey == null||"".equals(apiKey)){
	responseObject.put("status", "fail");
	responseObject.put("reason", "required parameters missing");
	out.println(responseObject.toString(2));
	return;
}

DBManager dbManger=new DBManager();
HashMap<String,ArrayList<HashMap<String,String>>> eventIDsWithTransacitons=new HashMap<String,ArrayList<HashMap<String,String>>>();

String query="select email,userid,eventid,eventdate,tid,to_char(transaction_date, 'Mon DD, YYYY HH:MI AM') as transaction_date,fname ||' '|| lname as name from event_reg_transactions   where  upper(paymentstatus) in ('COMPLETED', 'PENDING')";
StatusObj statusObj=dbManger.executeSelectQuery(query, new String[]{sellerId});
if(statusObj.getStatus()){
	StringBuffer eventid=new StringBuffer();
	HashMap<String,String> eachTransaction=null;
	ArrayList<HashMap<String,String>> transacitons=null;
	for(int i=0;i<statusObj.getCount();i++){
		eventid.append(dbManger.getValue(i, "eventid", ""));
		eachTransaction=new HashMap<String,String>();
		eachTransaction.put("event_date", dbManger.getValue(i, "eventdate", ""));
		eachTransaction.put("email", dbManger.getValue(i, "email", ""));
		eachTransaction.put("time", dbManger.getValue(i, "transaction_date", ""));
		eachTransaction.put("name", dbManger.getValue(i, "name", ""));
		eachTransaction.put("transaction_id", dbManger.getValue(i, "tid", ""));
		if(eventIDsWithTransacitons.containsKey(eventid.toString())){
			eventIDsWithTransacitons.get(eventid.toString()).add(eachTransaction);
		}
		else{
			transacitons=  new ArrayList<HashMap<String,String>>();
			transacitons.add(eachTransaction);
			eventIDsWithTransacitons.put(eventid.toString(), transacitons);
		}
		eventid.setLength(0);
	}	
}
responseObject.put("status", "success");
System.out.println("eventids :: "+eventIDsWithTransacitons.keySet().toString());
responseObject.put("event_ids", eventIDsWithTransacitons.keySet());
Iterator<Map.Entry<String,ArrayList<HashMap<String,String>>>> transactionsItereator = eventIDsWithTransacitons.entrySet().iterator();
while (transactionsItereator.hasNext()) {
    Map.Entry<String,ArrayList<HashMap<String,String>>> pairs = (Map.Entry<String,ArrayList<HashMap<String,String>>>)transactionsItereator.next();
    responseObject.put(pairs.getKey() , pairs.getValue());
    transactionsItereator.remove(); // avoids a ConcurrentModificationException
}
out.println(responseObject.toString(2));

%>