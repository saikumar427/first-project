<%@ page import="java.util.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.hub.HubMaster" %>




<%
String CLASS_NAME="hub/checkhubmemberdue.jsp";

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"","",null);

String groupid=request.getParameter("GROUPID");
String authid=null;
String ddate=null;
String isDueMember=null;
HashMap duememberhash=null;
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"groupid is: "+groupid,"",null);

Authenticate au=AuthUtil.getAuthData(pageContext);
if(au!=null){

	authid=au.getUserID();
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Auth data is not null,authid is: "+authid,"",null);
	duememberhash=HubMaster.isDueHubMember(authid,groupid);
}
 if(duememberhash!=null&&duememberhash.size()>0){
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"duememberhash details are: "+duememberhash,"",null);
	isDueMember=(String)duememberhash.get("duemember");
	ddate=(String)duememberhash.get("duedate");
	if("yes".equals(isDueMember)){
%> 

		<jsp:forward page='/hub/informduemember.jsp'>
		<jsp:param name='GROUPID' value='<%=groupid%>'/>
		<jsp:param name='duedate' value='<%=ddate%>'/>
		</jsp:forward>
<%	}
}		

%>
	 	    