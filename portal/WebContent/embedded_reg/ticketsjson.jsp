<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="com.event.dbhelpers.*,com.eventregister.TicketsPageJson,com.eventregister.TicketingInfo,com.eventbee.general.*" %>
<%
String eid=request.getParameter("eid");
String evtdate=request.getParameter("evtdate");
String ticketurlcode=request.getParameter("ticketurl");
TicketsPageJson ticketPage=new TicketsPageJson();
JSONObject jsonObj=ticketPage.getJsonTicketsData(eid,evtdate,ticketurlcode);
HashMap ticketPageLabels=DisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
String page_header=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.page.Header","Tickets");

JSONObject obj=new JSONObject();
try{
	String profilePageHeader=GenUtil.getHMvalue(ticketPageLabels,"event.reg.profile.page.Header","");
	String ticketsPageHeader=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.page.Header"," ");
	String paymentsPageHeader=GenUtil.getHMvalue(ticketPageLabels,"event.reg.payments.page.Header"," ");
	String confirmationPageHeader=GenUtil.getHMvalue(ticketPageLabels,"event.reg.confirmation.page.Header"," ");

	obj.put("ticketspage",ticketsPageHeader);
	obj.put("profilepage",profilePageHeader);
	obj.put("paymentpage",paymentsPageHeader);
	obj.put("confirmationpage",confirmationPageHeader);
}
catch(Exception e){
System.out.println("Exception occured in page header is: "+e.getMessage());
}

HashMap tempconfigMap=DisplayAttribsDB.getAttribValues(eid,"TicketDisplayOptions");
HashMap tempwordingsMap=DisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
String descMode=(String) tempconfigMap.get("event.general.tktDescMode");
String eventactivestats=(String) tempconfigMap.get("event.activetickets.status");
if(descMode==null)
descMode="collapse";
jsonObj.put("ticketstatus",eventactivestats);
jsonObj.put("tktDescMode",descMode);
jsonObj.put("page_header",page_header);
TicketingInfo tktinfo=new TicketingInfo();
jsonObj.put("availibilitymsg",tktinfo.getTicketMessage(eid,evtdate));
String selectticketmsg=GenUtil.getHMvalue(tempwordingsMap,"event.reg.selectTicket.msg","Please select ticket(s) Quantity");
jsonObj.put("selectticketmsg",selectticketmsg);
jsonObj.put("headers",obj);

out.println(jsonObj);
%>