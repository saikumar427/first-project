<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
String trackcode=request.getParameter("trackcode");
String secretcode=request.getParameter("secretcode");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=CAST(? AS BIGINT)",new String[]{groupid});
String userid=DbUtil.getVal("select userid from accountlevel_track_partners where scode=?",new String[]{secretcode});
String globallink="/portal/guesttasks/manageacctleveltrackingurls.jsp?userid="+userid+"&trackcode="+trackcode+"&secretcode="+secretcode;
if(eventname==null)
eventname=" ";
String link="<a href='/guesttasks/managetrackingurls.jsp?groupid="+groupid+"&trackcode="+trackcode+"&secretcode="+secretcode+"'>"+trackcode+"</a>";
request.setAttribute("tasktitle",""+eventname+" > "+link+" - Tracking URL Report");
if(userid!=null){
request.setAttribute("tasksubtitle","<a href='"+globallink+"'>My Global Settings</a>");
}
request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%	
	taskpage="/ntspartner/trackreport.jsp";
	
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		      		
	