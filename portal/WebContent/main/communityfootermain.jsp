<%@ include file="communityfooter.jsp" %>

<%
String footer=(String)request.getAttribute("BASICEVENTFOOTER");


if(footer!=null){
%>

<%=footer%>

<%}%>