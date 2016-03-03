<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>

<%@ include file="TicketingManager.jsp" %>

<%
JSONObject obj =new JSONObject();
String eid=request.getParameter("eid");
String tid=request.getParameter("tid");
TicketingManager ticketingManager=new TicketingManager();
HashMap regDetails=ticketingManager.getRegTotalAmounts(tid);
if(regDetails!=null&&regDetails.size()>0){
String m_cardamount=(String)regDetails.get("grandtotamount");
String status=(String)regDetails.get("status");
obj.put("total",m_cardamount);
obj.put("status",status);
}
String isReqTicketExists=DbUtil.getVal("select 'yes' from price where evt_id=? and ticket_type=?",new String[]{eid,"Public"});
String reqcount=DbUtil.getVal("select 'yes' from event_reg_ticket_details where tid=? and tickettype=?",new String[]{tid,"required"});
if("yes".equals(isReqTicketExists)&&reqcount==null)
obj.put("reqTicketSelected","N");
else
obj.put("reqTicketSelected","Y");

out.print(obj.toString());
%>