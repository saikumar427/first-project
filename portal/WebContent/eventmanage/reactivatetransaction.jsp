<%@ page import="com.eventbee.general.*"%>
<%@ include file="/ntspartner/soldqtyupdation.jsp" %>

<%!
	public String PRICE_SOLD_QTY_MODIFICATION_MINUS="update price set sold_qty=a.sold_qty-b.ticketqty from price a, transaction_tickets b where a.price_id=b.ticketid and price.price_id=b.ticketid and b.tid =?";

%>

<%
StatusObj statob=null;	
String transactionid=request.getParameter("transactionid");
String eventid=request.getParameter("eventid");
statob= DbUtil.executeUpdateQuery("update event_reg_transactions set paymentstatus=? where tid=? and eventid=?", new String []{"Completed",transactionid,eventid});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"cancel transaction page "," updating event attendee status is  "+statob.getStatus(),"",null);
updateSoldQty(transactionid,eventid,"1");
%>
<status>success</status>
