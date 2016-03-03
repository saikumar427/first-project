



<%
String ningoid=request.getParameter("oid");
String ningviewerid=request.getParameter("vid");
String eventid=(String)session.getAttribute(ningviewerid+"_EventDisplay");

%>
<jsp:forward page="/eventdetails/event.jsp" > 
<jsp:param name="eventid" value="<%=eventid%>" />

</jsp:forward> 





