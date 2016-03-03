<%@ page import="java.util.*" %>

<%

String oid=request.getParameter("oid");
String eventid=request.getParameter("GROUPID");
String eventname=request.getParameter("evtname");
String purpose=request.getParameter("purpose");

HashMap hm=new HashMap();
hm.put("eventid",eventid);
hm.put("eventname",eventname);
hm.put("purpose",purpose);

session.setAttribute(oid+"_ningsession",hm);

out.print("Success");


%>

