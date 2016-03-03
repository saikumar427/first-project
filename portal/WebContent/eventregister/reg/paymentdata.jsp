<%
String paytype=request.getParameter("type");

if("google".equals(paytype)){
%>
<%@ include file="googlecontent.jsp" %>
<%}
if("paypal".equals(paytype)){
%>
<%@ include file="paypalcontent.jsp" %>
<%}
%>