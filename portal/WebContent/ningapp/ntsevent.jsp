<%

String eventid=request.getParameter("eid");

String oid=request.getParameter("oid");
String pid=request.getParameter("pid");
String fid=request.getParameter("fid");
session.setAttribute("appname","nts");
String domain=request.getParameter("d");
if(domain.indexOf(".")<0)
	domain=domain+".ning.com";

String purpose=request.getParameter("purpose");
session.setAttribute("platform","ning");

String domainurl="";
if(fid==null){
domainurl="http://"+domain+"/opensocial/ningapps/show?owner="+oid+"&appUrl=http://www.eventbee.com/home/ning/networkticketselling.xml?ning-app-status=network&view_eventid="+eventid+"&view_partnerid="+pid+"&view_purpose=register";

}else{
domainurl="http://"+domain+"/opensocial/ningapps/show?owner="+oid+"&appUrl=http://www.eventbee.com/home/ning/networkticketselling.xml?ning-app-status=network&view_eventid="+eventid+"&view_fid=1&view_partnerid="+pid+"&view_purpose=register";
}
response.sendRedirect(domainurl);
	
%>
