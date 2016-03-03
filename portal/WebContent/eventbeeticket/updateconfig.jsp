<%@ page import="java.util.*,java.io.*,java.io.IOException"%>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.StatusObj,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.WriteSelectHTML" %>
<%@ page import="java.util.*,java.io.IOException,com.eventbee.general.formatting.*"%>
<%
StatusObj status=null;
String configidq="select config_id from eventinfo where eventid=?";
String UPDATEQ="update config set value=? where config_id=? and name=?";
String configid=DbUtil.getVal(configidq, new String[]{request.getParameter("GROUPID")});
status=DbUtil.executeUpdateQuery(UPDATEQ,new String [] {"No",configid,"event.enable.agent.settings"});
%>
<%
response.sendRedirect("/portal/eventmanage/eventmanage.jsp?GROUPID="+request.getParameter("GROUPID")+"&UNITID="+request.getParameter("UNITID"));
%>
