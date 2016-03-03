<%@ page import="java.util.*" %>

<%

String oid=request.getParameter("oid");

String eventid=request.getParameter("GROUPID");

String purpose=request.getParameter("purpose");

String platform=request.getParameter("platform");

HashMap hm=new HashMap();
hm.put("eventid",eventid);
hm.put("purpose",purpose);
hm.put("platform",platform);

session.setAttribute(oid+"_ningntssession",hm);

out.print("Success");


%>

