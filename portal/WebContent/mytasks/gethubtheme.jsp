<%@ page import="com.eventbee.general.*" %>




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



if("PUBLICPAGES".equals(request.getParameter("PS"))){
	request.setAttribute("mtype","My Public Pages");
	request.setAttribute("tasktitle","My Community Page > Change Theme");


}else{

request.setAttribute("mtype","My Console");
request.setAttribute("stype","Community");
request.setAttribute("tasktitle","Community Manage > "+clubmanagelink+" >  Change Theme");

}
%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/club/clubtheme/gethubtheme.jsp";
%>
	    
	    
<%@ include file="/templates/taskpagebottom.jsp" %>
	