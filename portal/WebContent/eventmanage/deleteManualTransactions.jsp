<%@ page import="com.eventbee.general.*"%>
<%!

void updateTicketCounts(String transid){
	String query="select ticketid ,ticketqty  from attendeeticket where transactionid = ? group by ticketid,ticketqty";
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String [] {transid});
	if(statobj.getStatus()){   
		for(int k=0;k<statobj.getCount();k++){
			String tickid=dbmanager.getValue(k,"ticketid","");
			String ticketqty=dbmanager.getValue(k,"ticketqty","");
			DbUtil.executeUpdateQuery("update price set sold_qty= sold_qty - ? where price_id = ?",new String[] {ticketqty, tickid});
		}
	}   			
}
	
%>
<%!
	String DELETE_TRANSACTION_EVENTATTENDEE="delete from eventattendee where eventid=? and transactionid=?";
	String DELETE_TRANSACTION="delete from transaction where refid=? and transactionid=?";
	String DELETE_TRANSACTION_ATTENDEETICKET="delete from attendeeticket where eventid=? and transactionid=?";
	
	 
%>

<%
String transactionid=request.getParameter("transactionid");
String eventid=request.getParameter("eventid");
updateTicketCounts(transactionid);
String[] queries =new String[]{DELETE_TRANSACTION_EVENTATTENDEE,DELETE_TRANSACTION,DELETE_TRANSACTION_ATTENDEETICKET} ;
for(int i=0;i<queries.length;i++){
DbUtil.executeUpdateQuery(queries[i],new String[]{eventid,transactionid});
}
%>
<status>success</status>
