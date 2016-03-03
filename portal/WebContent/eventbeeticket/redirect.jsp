<%
 String platform = request.getParameter("platform");
 if(platform==null) platform="";
 String URLBase="mytasks";
     if("ning".equals(platform)){
 	URLBase="ningapp/ticketing";	
     }

String groupid=request.getParameter("GROUPID");
String unitid=request.getParameter("UNITID");
String isnew="yes";
String evtname=request.getParameter("evtname");

if(evtname!=null)
evtname=java.net.URLEncoder.encode(evtname);
String foroperation=request.getParameter("foroperation");
String setid=request.getParameter("setid");
String submit=request.getParameter("Submit");

if ("Disable".equals(submit))
    response.sendRedirect("/portal/"+URLBase+"/disableevent.jsp?GROUPID="+groupid+"&UNITID="+unitid+"&evtname="+evtname+"&platform="+platform);
else if("Search Partner".equals(submit))
    response.sendRedirect("/portal/"+URLBase+"/searchpartner.jsp?GROUPID="+groupid+"&UNITID="+unitid+"&evtname="+evtname+"&platform="+platform);
else
    response.sendRedirect("/portal/"+URLBase+"/settask.jsp?GROUPID="+groupid+"&UNITID="+unitid+"&isnew=yes&foroperation="+foroperation+"&setid="+setid+"&Submit="+submit+"&evtname="+evtname+"&platform="+platform);
%>

