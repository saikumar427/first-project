<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>

<%@ include file='/xfhelpers/xffunc.jsp' %>

<%
 EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean"); 
%>
<table width='100%'  align='center'>
<tr><td class="medium">Refund Policy/Terms & Conditions *</td><td><%=getXfBoolean("policy","I Accept",jBean.getPolicy() )%></td><tr><td colspan="2" class="inform">
<% 
   out.println(getXfTextAreaRO("/refundPolicy",jBean.getRefundPolicy(),"10","60"));
%>
</td>
</tr>
</table>