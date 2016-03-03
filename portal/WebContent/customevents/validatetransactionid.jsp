
<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.*"%>


<%

String transactionid=request.getParameter("transactionid");
String groupid=request.getParameter("GROUPID");

if(session.getAttribute("Custom_"+groupid)!=null){
session.removeAttribute("Custom_"+groupid);
	}

String isdone="";
if(transactionid!=null)
isdone=DbUtil.getVal("select 'yes' from transaction where transactionid=? and refid=? and purpose=?",new String []{transactionid,groupid,"EVENT_REGISTRATION"});
if("yes".equals(isdone)){
session.setAttribute(groupid+"_OldTranId",transactionid);
out.print("Success");


}
else
out.print("Invalid");

%>