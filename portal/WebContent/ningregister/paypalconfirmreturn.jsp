<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*" %>
<%!
HashMap getTransactionDetails(String tid){
DBManager dbmanager=new DBManager();
HashMap hm=new HashMap();
StatusObj sb=dbmanager.executeSelectQuery("select * from event_reg_details where tid=?",new String[]{tid});
if(sb.getStatus()){
hm.put("oid",dbmanager.getValue(0,"attrib1",""));
hm.put("eventid",dbmanager.getValue(0,"eventid",""));
hm.put("domain",dbmanager.getValue(0,"attrib2",""));
}
return hm;
}
%>

<%
String oid="";
String domain="";
String eventid="";
String tid=request.getParameter("tid");
HashMap pm=getTransactionDetails(tid);
if(pm!=null&&pm.size()>0)
{
oid=(String)pm.get("oid");
eventid=(String)pm.get("eventid");
domain=(String)pm.get("domain");
}
%>
<script>
top.location.href='http://<%=domain%>/opensocial/application/show?appUrl=http%3A%2F%2Fwww.eventbee.com%2Fhome%2Fning%2Feventregister.xml%3Fning-app-status%3Dnetwork&owner=<%=oid%>&view_eventid=<%=eventid%>&view_purpose=paypalregdone&view_id=<%=tid%>';
</script>
			