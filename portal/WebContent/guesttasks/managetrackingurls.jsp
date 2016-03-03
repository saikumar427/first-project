<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid","gid","id","GROUPID","groupid"});
String trackcode=request.getParameter("trackcode");
String seccode=request.getParameter("secretcode");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=CAST(? AS BIGINT)",new String[]{groupid});
String userid=DbUtil.getVal("select userid from accountlevel_track_partners where scode=?",new String[]{seccode});
if(eventname==null) eventname=" ";
String globallink="/portal/guesttasks/manageacctleveltrackingurls.jsp?userid="+userid+"&trackcode="+trackcode+"&secretcode="+seccode;
request.setAttribute("tasktitle",""+eventname+" > "+trackcode+" - Tracking URL ");
if(userid!=null){
request.setAttribute("tasksubtitle","<a href='"+globallink+"'>My Global Settings</a>");
}
request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%	
	taskpage="/eventmanage/managetrackingurls.jsp";
	
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		      		
	
