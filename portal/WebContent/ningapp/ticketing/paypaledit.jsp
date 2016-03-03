<%@ page import="com.eventbee.general.*"%>

<%@ page import="java.util.*" %>
<%!
HashMap getTokenDetails(String tid)
{
DBManager dbmanager=new DBManager();
HashMap hm=new HashMap();
StatusObj sb=dbmanager.executeSelectQuery("select * from ning_paypal_tokens where encodedid=?",new String[]{tid});
if(sb.getStatus()){

hm.put("oid",dbmanager.getValue(0,"ningownerid",""));
hm.put("eventid",dbmanager.getValue(0,"eventid",""));
hm.put("domain",dbmanager.getValue(0,"ning_domain",""));
hm.put("transactionid",dbmanager.getValue(0,"transactionid",""));

}
return hm;

}

%>





<%


String oid="";
String domain="";
String eventid="";
String transactionid="";
String tid=request.getParameter("tid");
HashMap pm=getTokenDetails(tid);
if(pm!=null&&pm.size()>0)

{
oid=(String)pm.get("oid");
eventid=(String)pm.get("eventid");
domain=(String)pm.get("domain");
transactionid=(String)pm.get("transactionid");
}

	
%>

<script>
top.location.href='http://<%=domain%>/opensocial/application/show?appUrl=http%3A%2F%2Fwww.eventbee.com%2Fhome%2Fning%2Feventregister.xml%3Fning-app-status%3Dnetwork&owner=<%=oid%>&view_eventid=<%=eventid%>&view_purpose=paypaledit';
</script>
	