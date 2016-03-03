<%@ page import="org.json.*"%>
<%@ include file="TicketingManager.jsp" %>
<%@ include file="TicketsJsonBuilder.jsp" %>

<%
String eventid=org.eventbee.sitemap.util.Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid"});
String tid=org.eventbee.sitemap.util.Presentation.GetRequestParam(request,  new String []{"tid","transactionid"});
JSONObject object=new JSONObject();
try{
TicketingManager ticketingManager=new TicketingManager();
TicketsJsonBuilder ticketJsonBuilder=new TicketsJsonBuilder();
ticketingManager.initialize(eventid, tid);
if(ticketingManager.isTransactionComplete){
object.put("istransactioncompleted","Y");
out.println(object.toString());
return;
}
if(ticketingManager.isUnavailableReqTicketsExists){
object.put("isUnavailableReqTicketsExists","Y");
out.println(object.toString());
return;
}
JSONObject ticketsGroupObject=new JSONObject();

if(ticketingManager.reqticketgroupsArray!=null)
ticketJsonBuilder.fillGroupTicketsArry("reqgroups",ticketsGroupObject,ticketingManager.reqticketgroupsArray);
if(ticketingManager.optticketgroupsArray!=null)
ticketJsonBuilder.fillGroupTicketsArry("optgroups",ticketsGroupObject,ticketingManager.optticketgroupsArray);
object.put("ticketsgroup",ticketsGroupObject);
ticketJsonBuilder.fillAmountDetails(ticketingManager.getRegTotalAmounts(tid),object);
object.put("memberTicketsExists",ticketingManager.memberTicketsExists?"Y":"N");
object.put("isMemberLoggedIn",ticketingManager.isMemberLoggedIn?"Y":"N");
ticketJsonBuilder.fillCustomAttribs(ticketingManager.customattribs,ticketingManager.customattribOptions,object,ticketingManager.collectAllProfiles);
if(ticketingManager.selectedProfileInfo!=null){
ticketJsonBuilder.fillselectedProfileInfo(ticketingManager.selectedProfileInfo,object);
}
ticketJsonBuilder.fillPayTypes(ticketingManager.paytypes,object,ticketingManager.selectedPaytype);
ticketJsonBuilder.fillDiscountDetails(ticketingManager.discountsMap,object,ticketingManager.appliedDiscountcode);
}catch(Exception ex){
object.put("status","error");
}
out.println(object.toString());
%>
