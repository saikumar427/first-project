<%@ page import="com.eventbee.general.DbUtil" %>

<%

if("eventpages".equals(request.getParameter("frompage")))
{

String groupid=request.getParameter("GROUPID");
String event_groupid=request.getParameter("event_groupid");
String group_title=DbUtil.getVal("select group_title from user_groupevents where event_groupid=?",new String[]{event_groupid});

String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
String backlink="";
if("Edit CSS".equals(request.getParameter("operation"))||"Edit Template".equals(request.getParameter("operation")))
{
backlink="<a href='/mytasks/eventcustomthemetemplate.jsp?type=event&GROUPID="+groupid+"'>Theme Templates</a>";
if(event_groupid!=null){
link="<a href='/mytasks/eventgroups.jsp?event_groupid="+event_groupid+"&GROUPID="+event_groupid+"'>"+group_title+"</a>";;
backlink="Theme Templates";

}
 request.setAttribute("tasktitle","Event Manage > "+link+" > "+backlink );
 }
 else
 {
  request.setAttribute("tasktitle","Event Manage > "+link);
}
 request.setAttribute("stype","Community");
request.setAttribute("stype","Events");
}
else
{
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
				String  chlink="<a href='/mytasks/gethubtheme.jsp?type=Community&PS=PUBLICPAGES'>Chang Theme</a>";
				request.setAttribute("tasktitle","My Community Page > "+chlink+" > Success");
		}else{
		       request.setAttribute("tasktitle","Community Manage > "+clubmanagelink);
		       request.setAttribute("stype","Community");
		       request.setAttribute("mtype","My Console");
      }
      
}

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/customevents/ThemeDone.jsp";
	%>
<%@ include file="/templates/taskpagebottom.jsp" %>
