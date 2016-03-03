<%@ page import="java.util.*,java.sql.*,java.text.*" %>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.event.ticketinfo.*" %>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.noticeboard.NoticeboardDB" %>
<%@ page import="com.eventbee.contentbeelet.*"%>
<%@ page import="com.eventbee.event.EventsContent" %>

<script>
function addAgents(){
document.register.particpant.value=document.agents.particpant.value;
}
function validateAgent(salelimit,totalsales,message){
				if (totalsales==null)
				totalsales="0";
				if (totalsales>=salelimit){
					alert(message);
					document.register.target="_self";
					document.register.submit();
				}else 
					return true;
}
</script>
<script>
function getAgentsPage(loginname){
				var id=document.agents.particpant.value;
				document.agents.particpant.value=document.agents.particpant.value;
					if(id!=null&&id!=''){
						document.agents.target="_self";
						document.agents.action="/member/"+loginname+"/event";
						document.agents.submit();
					}
}
</script>
<%
String groupid=request.getParameter("eventid");
if(groupid==null||"".equals(groupid.trim()))
groupid=request.getParameter("GROUPID");
request.setAttribute("GROUPID",groupid);
%>
<%
String userid=(String)request.getAttribute("userid");
HashMap userhm=(HashMap)request.getAttribute("userhm");
String loginname=null;
if(userhm!=null)
loginname=(String)userhm.get("login_name");

UserInfo usrInfo=AccountDB.getUserProfile(userid);

request.setAttribute("USERINFO",usrInfo);
String	userfullname="";
HashMap hm=new HashMap();
if(usrInfo!=null || userid=="-1"){
String	userfirstname=(usrInfo!=null)?usrInfo.getFirstName().trim():"";
String	userlastname=(usrInfo!=null)?usrInfo.getLastName().trim():"";
userfullname=(userfirstname+" "+userlastname).trim();


	request.setAttribute("USERFIRSTNAME",userfirstname);
	request.setAttribute("USERLASTNAME",userlastname);
	request.setAttribute("USERFULLNAME",userfullname);
}
%>
<%
Vector notices=EventsContent.getAllNotices(groupid);
request.setAttribute("NOTICES",notices);
%>
<jsp:include page='/customevents/eventinfo.jsp'/>
<jsp:include page='/customevents/ticket.jsp'/>
<jsp:include page='/customevents/links.jsp'/>
<jsp:include page='/customevents/googlemap.jsp'/>
<jsp:include page='/customevents/agent.jsp'/>
<jsp:include page='/customevents/contentbeelets.jsp'/>
<jsp:include page='basicheader.jsp' />
<jsp:include page='basicfooter.jsp' />
