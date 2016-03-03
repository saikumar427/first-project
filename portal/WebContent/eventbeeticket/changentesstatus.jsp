<%@ page import="com.eventbee.general.*"%>
<% 
String partnerid=request.getParameter("partnerid");
String eventid=request.getParameter("eventid");
String status=request.getParameter("status");

String isexist=DbUtil.getVal("select 'Yes' from manual_nts_events where eventid=? and partnerid=?",new String[]{eventid,partnerid});
if(isexist==null)
DbUtil.executeUpdateQuery("insert into manual_nts_events(partnerid,status,eventid)values(?,?,?)",new String[]{partnerid,status,eventid});
else
DbUtil.executeUpdateQuery("update manual_nts_events set status=? where eventid=? and partnerid=?",new String[]{status,eventid,partnerid});

%>
<div><b>Status:</b> <%=status%>
<%if("Suspended".equals(status)){ %> 
	  <input type="button" value="Approve" onclick="changestatus(<%=partnerid%>,<%=eventid%>,'Approved');"/>
	  <%}
	 else if("Approved".equals(status)){
	 %>
	 <input type="button" value="Suspend" onclick="changestatus(<%=partnerid%>,<%=eventid%>,'Suspended');"/>
	 <%}
	 else if("Pending".equals(status)){
	 %>
	 <input type="button" value="Approve" onclick="changestatus(<%=partnerid%>,<%=eventid%>,'Approved');"/>
	 <%}else{
	 %>
	 <input type="button" value="Approve" onclick="changestatus(<%=partnerid%>,<%=eventid%>,'Approved');"/>
	 <%}%>
</div>