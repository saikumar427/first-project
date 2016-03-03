<%@ page import="com.eventbee.general.DbUtil" %>

<%
String clubid=request.getParameter("clubid");
try{
clubid=""+Integer.parseInt(clubid);
}
catch(Exception e){
clubid="-1";
}
String clubname="";
if(!"-1".equals(clubid))
clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{clubid});
if(clubname==null)
clubname="Community";
String clubmanagelink="<a href='/mytasks/clubmanage.jsp?type=Community&GROUPID="+clubid+"'/>"+clubname+"</a>";

request.setAttribute("tasktitle","Community Manage > "+clubmanagelink+" > Edit Community");

request.setAttribute("mtype","My Console");
request.setAttribute("stype","Community");

%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/club/editclub.jsp";
%>
	    
	    
<%@ include file="/templates/taskpagebottom.jsp" %>
	