<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.eventpartner.PartnerDB" %>

<%!
String INSERTQ="insert into group_partner (partnerid,title,message,userid,url,status,created_at) values (nextval('group_partnerid'),'','',?,'','Active',now())";
String INSERT_GROUP_AGENT="insert into group_agent "
				+" (agentid,title,message,userid,settingid,showsales, "
				+"goalamount,status,created_at,customised) "
				+"select nextval('group_agentid'),'', '',?, settingid, 'No', "
				+"saleslimit, 'Active', now(),'No' "
				+"from group_agent_settings a, eventinfo b "
				+" where  b.status='ACTIVE' and a.groupid=b.eventid "
				+" and a.enablenetworkticketing='Yes'";

%>
<%
String partnerid=request.getParameter("partnerid");
System.out.println("partnerid issssssss:::::::::"+partnerid);
String userid=(String)hm.get("userid");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "/portal/webintegration/signuppartner.jsp", "userid is"+userid, "", null);			
StatusObj stobjt=null;
stobjt=DbUtil.executeUpdateQuery(INSERTQ,new String [] {userid});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "/portal/webintegration/signuppartner.jsp", "stobjt is"+stobjt.getStatus(), "", null);			
stobjt=DbUtil.executeUpdateQuery(INSERT_GROUP_AGENT,new String [] {userid});
%>

