<%@ page import="org.eventbee.sitemap.util.Presentation,com.eventbee.general.StatusObj" %>
<%@ include file="TicketingManager.jsp" %>
<%@ include file="getcontextdata.jsp" %>

<%   
String eventid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid"});
TicketingManager ticketingManager=new TicketingManager();
StatusObj eventsb=ticketingManager.validateEvent(eventid);
if(!eventsb.getStatus()){
%>			
<jsp:forward page='/ningapp/ticketing/regticketnotavailable.jsp'>
	<jsp:param name='eventstatus' value='<%=eventsb.getErrorMsg()%>' />
</jsp:forward>	
			
<%	
return;
}
String tid=Presentation.GetRequestParam(request,  new String []{"tid","transactionid"});
if(tid==null){
HashMap contextdata=new HashMap();
contextdata.put("useragent",request.getHeader("User-Agent"));
contextdata.put("oid",request.getParameter("oid"));
contextdata.put("domain",request.getParameter("domain"));
tid=ticketingManager.createNewTransaction(eventid,contextdata);
if("-1".equals(tid)){
//send to error page
return;
}

response.sendRedirect("/ningregister/register.jsp?eid="+eventid+"&tid="+tid);
return;
}
StatusObj status=FillContextData(eventid,request,tid);

%>
<jsp:forward page="/ningregister/regticket.jsp" />





