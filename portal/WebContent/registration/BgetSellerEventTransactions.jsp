<%@page import="com.eventbee.general.DbUtil"%>
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
	//File: getSellerEventTransactions.jsp 
	//Created: 11/06/2014 
	//Modified: 11/06/2014 by venkat reddy*/
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

edate=(edate==null)?"":edate;

DBManager dbManger=new DBManager();
HashMap<String,ArrayList<HashMap<String,String>>> eventIDsWithTransacitons=new HashMap<String,ArrayList<HashMap<String,String>>>();
String query="";
StatusObj statusObj=null;
if("".equals(edate)){
	query="select email,discountcode,ordernumber,current_discount,userid,current_amount,tid,to_char(transaction_date, 'Mon DD, YYYY HH:MI AM') as transaction_date,fname ||' '|| lname as name from event_reg_transactions   where userid=? and eventid=? and upper(paymentstatus) in ('COMPLETED', 'PENDING')  order by transaction_date desc" ;
	 statusObj=dbManger.executeSelectQuery(query, new String[]{sellerId,eid});
}
else{
	query="select email,discountcode,ordernumber,current_discount,userid,tid,current_amount,to_char(transaction_date, 'Mon DD, YYYY HH:MI AM') as transaction_date,fname ||' '|| lname as name from event_reg_transactions   where userid=? and eventid=? and eventdate=? and upper(paymentstatus) in ('COMPLETED', 'PENDING')  order by transaction_date desc" ;
	 statusObj=dbManger.executeSelectQuery(query, new String[]{sellerId,eid,edate});
	}
JSONArray transacitons=new JSONArray();
String currencyFormat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code in (select currency_code from event_currency where eventid=?)",new String[]{eid});

if(currencyFormat==null)
	currencyFormat="$";



if(statusObj.getStatus()){	
	JSONObject eachTransaction=null;	
	for(int i=0;i<statusObj.getCount();i++){		
		eachTransaction=new JSONObject();		
		eachTransaction.put("email", dbManger.getValue(i, "email", ""));
		eachTransaction.put("time", dbManger.getValue(i, "transaction_date", ""));
		eachTransaction.put("name", dbManger.getValue(i, "name", ""));
		eachTransaction.put("amount", dbManger.getValue(i, "current_amount", ""));		
		eachTransaction.put("order_num", dbManger.getValue(i, "ordernumber", ""));
		eachTransaction.put("transaction_id", dbManger.getValue(i, "tid", ""));
		transacitons.put(eachTransaction);		
	}	
}
responseObject.put("status", "success");
responseObject.put("currency", currencyFormat);
responseObject.put("transactions", transacitons);
out.println(responseObject.toString(2));


%>