<%@ page import="com.eventbee.general.DbUtil" %>
<%

String clubid=request.getParameter("GROUPID");
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

request.setAttribute("tasktitle","Community Manage > "+clubmanagelink+" > Add as Active Members");

request.setAttribute("mtype","My Pages");
request.setAttribute("stype","Community");
%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/club/ClubAddMemScreenManual.jsp";
%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	