<%@ page import="java.util.*,com.eventbee.event.*,com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbee.authentication.ProfileData"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.creditcard.*"%>
<%@ include file="TicketingManager.jsp" %>

<%!
String rowdisplay(int count){
if(count%2==0){
return "<td class='oddbase'>";
}else{
return "<td class='evenbase'>";
}
}
%>
<%
String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");
EventRegisterDataBean edb=(EventRegisterDataBean)request.getAttribute("regdatabean");
int rowcount=0;
ProfileData[] pd=edb.getProfileData();
String eventid=edb.getEventId();
EventTicketDB eb=new EventTicketDB();
HashMap scopemap=new HashMap();
double GrandTotal=edb.getGrandTotal();
String oid=null;
String domain=null;
TicketingManager ticketingManager=new TicketingManager();
HashMap networkMap=ticketingManager.getNetWorkDetails(edb.getTransactionId());
if(networkMap!=null&&networkMap.size()>0){
domain=(String)networkMap.get("domain");
oid=(String)networkMap.get("oid");
}
String eventpageLink="/event?eid="+eventid+"&platform=ning"+(oid!=null?"&oid="+oid:"")+(domain!=null?"&domain="+domain:"");
String base="eventbase";
StatusObj sobj=eb.getEventInfo(eventid,scopemap);
String eventurl=serveraddress+"/event?eid="+eventid;
String [] reqTicket=edb.getSelectReqTickets();
String [] optTickets=edb.getSelectOptTickets();
String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{edb.getEventId()});
if(currencyformat==null)
currencyformat="$";	
String feeconfiguration=DbUtil.getVal("select value   from config where name='event.feelabel' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{eventid});
if(feeconfiguration==null)
feeconfiguration="Fee";

String ordernumber=DbUtil.getVal("select ordernumber from event_reg_transactions where tid=?",new String []{edb.getTransactionId()});


String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{eventid});

  if(edb!=null){
%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="/home/customlisting.css" />

<style>
<%@ include file="ticketpagecss.jsp" %>
</style>
</head>
<body>
<div id="topcontainer">
<div id="container">
<table width="100%" cellpadding="0" align="left"><tr><td>
<table width="100%">
<tr><td class='taskheader'>
<div  style='float:left'>
<a href='<%=eventpageLink%>'><%=eventname%></a> > Confirmation
</div>
</td>
</tr>
</table>
<table width="100%" cellpadding="0" align="left"><tr><td>
<p> Your event registration is completed successfully.
A confirmation email with the following information will be sent to <%=pd[0].getEmail() %>.
<tr><td ><font class='error'><br/>
NOTE: If you do not find confirmation email in your Inbox, please do check 
your Bulk folder, and update your spam filter settings to allow Eventbee 
emails.
<br/>
Your Transaction ID is <%=edb.getTransactionId()%> and Order Number is <%=ordernumber%>. <a href="#" onclick="window.print()"/>Print this page</a> (or confirmation email), and bring it to the event venue.
</td></tr></table>
</td></tr>   
<tr><td height="10"/></tr>
<tr><td><table cellpdding="0"><tr><td width="10%"/>
<td >
</td>
<td width="10%"/></tr></table>
</td></tr>
<tr><td height="10"/></tr>
<tr><td> 
<table  width="100%" cellpadding="0" align="left">
<tr><td align="left">When - Starts: <%=GenUtil.getHMvalue(scopemap,"STARTDATE","")%>, <%=GenUtil.getHMvalue(scopemap,"STARTTIME","")%> Ends: <%=GenUtil.getHMvalue(scopemap,"ENDDATE","")%>, <%=GenUtil.getHMvalue(scopemap,"ENDTIME","")%>
</td></tr>   
<tr><td align="left">Where -<%=GenUtil.getHMvalue(scopemap,"LOCATION","")%></td></tr>
<tr><td align="left">Event URL - <%=eventurl%>
</td></tr>
<tr><td height="10"/></td></tr>
<tr><td><b>
Attendees
</b></td></tr>
<%
for (int i=0;i<pd.length;i++) { %>
<tr><%=rowdisplay(i+1)%>
<%=GenUtil.XMLEncode(pd[i].getFirstName())%> <%=GenUtil.XMLEncode(pd[i].getLastName())%>, <%=GenUtil.XMLEncode(pd[i].getEmail())%>,
<%if(GenUtil.XMLEncode(pd[i].getPhone())!=null&&!"".equals(GenUtil.XMLEncode(pd[i].getPhone()))){%>
<%=GenUtil.XMLEncode(pd[i].getPhone())%>
<%}}%>
<tr><td height="10"/></td></tr>
<tr><td ><b>Tickets:</b></td></tr>
<tr><td>
<table   width="100%" cellpadding="0" align="left">
<tr>
<td width="45%"><b>Name</b></td>
<td width="10%"><b>Price (<%=currencyformat%>)</b></td>
<td width="10%"><b><%=feeconfiguration%> (<%=currencyformat%>)</b></td>
<td width="15%"><b>Discount (<%=currencyformat%>)</b></td>
<td width="10%"><b>Quantity</b></td>
<td width="10%"><b>Total (<%=currencyformat%>)</b></td>
</tr>
<%
if(reqTicket!=null){
%>
 <%
   out.println("<tr>");
   rowcount++;
   if(rowcount%2==0) base="evenbase";
  else base="oddbase";
%>
<td class='<%=base%>'><%=GenUtil.XMLEncode(edb.getReqTicketName())%></td>
<td class='<%=base%>'><%=CurrencyFormat.getCurrencyFormat("",""+edb.getTicketDisplayPrice(),true)%></td>
<td class='<%=base%>'><%=CurrencyFormat.getCurrencyFormat("",""+edb.getTicketProcessFee(),true)%></td>
<td class='<%=base%>'><%=CurrencyFormat.getCurrencyFormat("",""+edb.getReqTicketDiscount(),true)%></td>
<td class='<%=base%>'><%=edb.getReqTicketQty()%></td>
<td class='<%=base%>' align='right'><%=CurrencyFormat.getCurrencyFormat("",""+edb.getReqTicketTotal(),true)%></td>
</tr>
<%
}
%> 
<%
if(optTickets!=null){
for(int i=0;i<optTickets.length;i++){
%>
<%
out.println("<tr>");
  rowcount++;
  if(rowcount%2==0) base="evenbase";
  else base="oddbase";
  
  
%>
<td class='<%=base%>'><%=GenUtil.XMLEncode(edb.getOptTicketName()[i])%></td>
<td class='<%=base%>'><%=CurrencyFormat.getCurrencyFormat("",""+edb.getOptTicketDisplayPrice()[i],true)%></td>
<td class='<%=base%>'><%=CurrencyFormat.getCurrencyFormat("",""+edb.getOptTicketProcessFee()[i],true)%></td>
<td class='<%=base%>'><%=CurrencyFormat.getCurrencyFormat("",""+edb.getOptTicketDiscount()[i],true)%></td>
<td class='<%=base%>'><%=edb.getOptTicketQty()[i]%></td>
<td class='<%=base%>' align='right'><%=CurrencyFormat.getCurrencyFormat("",""+edb.getOptTicketTotal()[i],true)%></td>
  </tr>
<%
}
}
%>
<tr>
<td height='10'></td>
</tr> 
<%if(edb.getTaxAmount()>0){%>
 <tr>
  <td colspan='3' align='left' class="evenbase" >Tax (<%=currencyformat%>)</td>
   <td  colspan='3' align='right' class="evenbase"><%=CurrencyFormat.getCurrencyFormat("",""+edb.getTaxAmount(),false)%></td>
</tr>
<%}%>
  <tr>
  <td colspan='3' align='left' class="evenbase" >Total (<%=currencyformat%>)</td>
  
  <td colspan='3' align='right' class="evenbase"><%=CurrencyFormat.getCurrencyFormat("",""+GrandTotal,false)%></td>
</tr>
</table>
</td></tr>
<tr><td>
<%if("other".equalsIgnoreCase(edb.getPayType())){
HashMap ptypehm=PaymentTypes.getPaymentTypeInfo(edb.getEventId(),"Event","other");
String otherdesc=null;
if(ptypehm!=null){
otherdesc=(String)ptypehm.get("attrib_1");
}
%>
<b>Payment:</b> <%=GenUtil.XMLEncode(otherdesc)  %>
<%}%>
</td></tr>
<tr><td>
</td></tr>
</table>

<%}%>
</div> <!--container-->
<div id='footer'>
<%@ include file="footer.jsp" %>
</div>
</div> <!--topcontainer-->
</body>
</html>