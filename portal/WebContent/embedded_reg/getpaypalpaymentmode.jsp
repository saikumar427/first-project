<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%
String eid=request.getParameter("eid");
String tid=request.getParameter("tid");
if(eid==null)eid="";
if(tid==null)tid="";

String query="select paymentmode from event_reg_details_temp where eventid=? and tid=?";
String paymentmode=DbUtil.getVal(query, new String[]{eid,tid});

if(paymentmode==null || "".equals(paymentmode) || "null".equals(paymentmode))
	paymentmode="normal";
JSONObject jsonObj=new JSONObject();
jsonObj.put("pmode",paymentmode);
out.println(jsonObj.toString());
%>