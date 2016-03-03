<%@ page import="java.io.*,org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="java.util.*,com.eventbee.event.*,com.eventbee.event.ticketinfo.*"%>
<%@ page import="org.json.*,com.event.dbhelpers.*"%>

<%@ include file='/eventtickets/TicketingBean.jsp' %>
<%@ include file="registrationConfirmation.jsp" %>


<%



String template=DbUtil.getVal("select content from reg_flow_templates where purpose=?",new String[]{"confirmationpage"});
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
HashMap buyerdetails=null;
String currencyformat=DbUtil.getVal("select html_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{eid});
if(currencyformat==null)
currencyformat="$";
HashMap ticketPageLabels=DisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");

String totalamount=DbUtil.getVal("select grandtotal from event_reg_details_temp where tid=?",new String[]{tid});
String tax=DbUtil.getVal("select tax from event_reg_details_temp where tid=?",new String[]{tid});

buyerdetails=getBuyerInfo(tid);
//******************************************
String ticketNameLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.name.label","Ticket Name");
String ticketPriceLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.price.label","Price");
String ticketQtyLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.qty.label","Quantity");
String processFeeLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.processfee.label","Fee");
String taxAmountLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.tax.amount.label","Tax");
String GrandTotalLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.grandtotal.amount.label","Grand Total");
String totalAmountLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.total.amount.label","Total");
String eventpageLink="<a href='#' onClick='refreshPage()'>Back To Event Page</a>";

//*************************************************************
EventTicketDB edb=new EventTicketDB();
HashMap evtmap=new HashMap();
StatusObj sobj=edb.getEventInfo(eid,evtmap);
String startday=(String)evtmap.get("StartDate_Day");
String starttime=(String)evtmap.get("STARTTIME");
String endday=(String)evtmap.get("EndDate_Day");
String endtime=(String)evtmap.get("ENDTIME");
String venue=(String)evtmap.get("VENUE");
String location=(String)evtmap.get("LOCATION");
ArrayList purchasedTickets=getpurchasedTickets(tid);	

VelocityContext context = new VelocityContext();
context.put("transactionKey",tid);
context.put("buyerDetails",buyerdetails);
context.put("startDay",startday);
context.put("endDay",endday);
context.put("startTime",starttime);
context.put("endTime",endtime);
context.put("venue",venue);
context.put("location",location);
context.put("eventName",(String)evtmap.get("EVENTNAME"));
context.put("mgrFirstName",(String)evtmap.get("FIRSTNAME"));
context.put("mgrLastName",(String)evtmap.get("LASTNAME"));
context.put("mgrEmail",(String)evtmap.get("EMAIL"));
context.put("purchasedTickets",purchasedTickets);
context.put("currencyFormat",currencyformat);
context.put("grandTotal",totalamount);
context.put("tax",tax);
context.put("ticketPriceLabel",ticketPriceLabel);
context.put("ticketNameLabel",ticketNameLabel);
context.put("taxAmountLabel",taxAmountLabel);
context.put("GrandTotalLabel",GrandTotalLabel);
context.put("totalAmountLabel",totalAmountLabel);
context.put("eventpageLink",eventpageLink);
context.put("ticketQtyLabel",ticketQtyLabel);
context.put("processFeeLabel",processFeeLabel);
context.put("googlePayment","yes");
VelocityEngine ve= new VelocityEngine(); 
try{
ve.init();
boolean abletopares=ve.evaluate(context,out,"ebeetemplate", template);
}
catch(Exception exp){
out.println("---"+exp.getMessage());
}  

%>


