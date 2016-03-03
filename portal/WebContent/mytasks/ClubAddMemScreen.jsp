<%@ page import="com.eventbee.general.DbUtil" %>

<%


request.setAttribute("mtype","My Pages");
request.setAttribute("stype","Community");


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

request.setAttribute("tasktitle","Community Manage > "+clubmanagelink+" > Add Members");


%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%
String membertype=DbUtil.getVal("select value from community_config_settings where key='MEMBER_ACCOUNT_TYPE' and clubid=? ",new String [] {clubid});

      if("EXCLUSIVE".equals(membertype))
      taskpage="/club/ClubAddUnitMemScreen.jsp";
     else

	taskpage="/club/ClubAddMemScreen2.jsp";
%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	