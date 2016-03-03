<%@ page import="org.json.*,com.eventbee.general.*" %>
<%@ include file="soldqtyupdation.jsp" %>
<%!
	public String TR_TICKETS_DELETE="delete from transaction_tickets where eventid=? and tid=? ";
	public String TR_TICKETS_INSERT="insert into transaction_tickets(groupname,ticket_groupid,ticketid,ticketname,ticketqty,ticketprice,discount,tid,eventid,ticketstotal) values (?,?,?,?,?,?,?,?,?,?)";
	public String EVT_REG_TRN_UPDATE="update event_reg_transactions set current_tickets=?,current_discount=?,current_amount=?,current_tax=?,modifiedon=now() where eventid=? and tid=?";
%>

<%
String final1= request.getParameter("finali");
int finali = Integer.valueOf(final1).intValue();
JSONArray ticketsArray=new JSONArray();
String eventid=request.getParameter("eventid");
String tax=request.getParameter("tax");
String transactionid=request.getParameter("transactionid");
String totaldiscount=request.getParameter("totaldiscount1");
String totalamount=request.getParameter("totalamount1");

updateSoldQty(transactionid,eventid,"-1");
StatusObj statobj=DbUtil.executeUpdateQuery(TR_TICKETS_DELETE,new String[]{eventid,transactionid});

for (int i=1;i<=finali;i++){
	String ticketid=request.getParameter("ticketid"+i);
	String ticketgroupid=request.getParameter("ticketgroupid"+i);
	String ticketname=request.getParameter("ticketname"+i);
	String groupname=request.getParameter("groupname"+i);	
	String price=request.getParameter("ticketprices"+i);
	String discount=request.getParameter("discount"+i);
	String qty=request.getParameter("qty"+i);
	String total=request.getParameter("total"+i);
	JSONObject TicketObject=new JSONObject();
	if("0".equals(qty)){
	}else{
	TicketObject.put("gn",groupname);
	TicketObject.put("gid",ticketgroupid);
	TicketObject.put("tn",ticketname);
	TicketObject.put("qty",qty);
	TicketObject.put("tid",ticketid);
	TicketObject.put("d",discount);
	TicketObject.put("p",price);
	TicketObject.put("ttotal",total);
	ticketsArray.put(TicketObject);
	StatusObj statobj1=DbUtil.executeUpdateQuery(TR_TICKETS_INSERT,new String[]{groupname,ticketgroupid,ticketid,ticketname,qty,price,discount,transactionid,eventid,total});

	}
} //end for()
updateSoldQty(transactionid,eventid,"1");
DbUtil.executeUpdateQuery(EVT_REG_TRN_UPDATE,new String[]{ticketsArray.toString(),totaldiscount,totalamount,tax,eventid,transactionid});
%>
