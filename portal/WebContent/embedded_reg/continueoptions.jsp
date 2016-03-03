<%@ page import="com.eventbee.general.*"%>
<%@ include file='/globalprops.jsp' %>
<div style="text-align:left;height:400px;padding-left:2px;" >
<br/>
<%
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "continueoptions.jsp", "Entered continueoptions.jsp tid is "+tid, "", null);
%>
<ul>
<li>
<%=getPropValue("co.nopayment.first",eid) %> <a href="#" onClick="continueRegistration();"><%=getPropValue("co.nopayment.second",eid) %></a>
</li>
<br/>
<li>
<%=getPropValue("co.payment.first",eid) %><a href="#" onClick="getConfirmation('<%=tid%>','<%=eid%>');"><%=getPropValue("co.payment.second",eid) %></a>
</li>
</ul>

</div>