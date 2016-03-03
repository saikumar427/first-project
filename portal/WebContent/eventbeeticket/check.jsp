<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.general.*"%>
<%@ page import="java.util.*,java.io.*,java.io.IOException"%>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.StatusObj,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.WriteSelectHTML" %>
<%@ page import="java.util.*,java.io.IOException,com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.f2f.F2FEventDB"%>
<%
String groupid=request.getParameter("GROUPID");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"check.jsp","null","groupid value is  :"+groupid,null);
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
	userid=authData.getUserID();
}
String foroperation="";
String setid=F2FEventDB.getVal(F2FEventDB.getSetIDVal_Query,groupid);
String agentidq="select agentid from group_agent where settingid=? and userid=? ";
String agentid=DbUtil.getVal(agentidq, new String[]{setid,userid});
if (agentid!=null){
	foroperation="edit";
	response.sendRedirect("/portal/mytasks/agentcomm.jsp?UNITID=13579&setid="+setid+"&GROUPID="+groupid+"&foroperation=edit&agentid="+agentid);
	return;
}
else{
	foroperation="add";
	response.sendRedirect("/portal/mytasks/loginevent.jsp?UNITID=13579&setid="+setid+"&GROUPID="+groupid+"&foroperation=add");
}
%>

