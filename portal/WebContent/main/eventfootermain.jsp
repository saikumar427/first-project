<%@ include file="eventfooter.jsp" %>

<%
String evtfooter=(String)request.getAttribute("BASICEVENTFOOTER");


if(evtfooter!=null){
%>

<%=evtfooter%>

<%}%>