<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.editprofiles.ProfileValidator"%>
<%@ page import="com.eventbee.useraccount.*"%>
<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.invitedemails.InvitedEmailDB"%>
<%@ page import="com.eventbee.nuser.*" %>
<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.util.*" %>

<%
String selected_task=request.getParameter("task");

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"processevtauth.jsp",null,"selected_task value is------"+selected_task,null);
if("login".equals(selected_task)){%>
<%@ include file="loginprocess.jsp"%>
<%}else{
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"processevtauth.jsp",null,"in the else block",null);
%>
<%@ include file="signupprocess.jsp"%>
<%}%>