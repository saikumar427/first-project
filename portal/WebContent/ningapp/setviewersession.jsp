<%@ page import="java.util.*" %>

<%

String vid=request.getParameter("vid");
String eventid=request.getParameter("GROUPID");
String pid=request.getParameter("pid");

HashMap hm=new HashMap();
hm.put("vid",vid);
hm.put("eid",eventid);
hm.put("pid",pid);

session.setAttribute("partnersession",hm);

out.print("Success");


%>

