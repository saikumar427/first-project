<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%
JSONObject resData = new JSONObject();
String eventId = request.getParameter("eid");
String listId = request.getParameter("listId");
String priToken = request.getParameter("priToken");
String expires=DbUtil.getVal("select 'yes' from priority_reg_transactions where expires_at < (select now()) and status='Pending' and eventid=CAST(? AS BIGINT) and list_id=? and pri_token=? ",new String[]{eventId,listId,priToken});
if("yes".equals(expires))
	resData.put("expired", true);
else
	resData.put("expired", false);
out.println(resData.toString(2));
%>