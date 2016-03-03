<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.event.BeeletController,com.eventbee.editevent.*,com.eventbee.event.*" %>
<%!
String query="select type,eventname from eventinfo where eventid=?";
	HashMap getevtdet(String evtid){

		DBManager dbmanager=new DBManager();
		HashMap hm=new HashMap();
		StatusObj stobj=dbmanager.executeSelectQuery(query,new String[]{evtid});
		if(stobj.getStatus()){
			hm.put("type",dbmanager.getValue(0,"type",""));
			hm.put("eventname",dbmanager.getValue(0,"eventname",""));
		}
		return hm;
	}
%>
<%
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
request.setAttribute("layout", "DEFAULT");

%>

<%
String groupid=request.getParameter("GROUPID");
String event_groupid=request.getParameter("event_groupid");
String group_title=DbUtil.getVal("select group_title from user_groupevents where event_groupid=?",new String[]{event_groupid});
	String unitid=request.getParameter("UNITID");
	HashMap hm=getevtdet(groupid);
	String evttype="";
	String evtname="";
	if(hm!=null){
		evttype=GenUtil.getHMvalue(hm,"type","",true);
		evtname=GenUtil.getHMvalue(hm,"eventname","",true);
	}
	String evtlevel=null;
	if(groupid !=null){
		HashMap groupinfo=new HashMap();
		groupinfo.put("GROUPID",groupid);
		groupinfo.put("groupid",groupid);

		if(unitid!=null){
			groupinfo.put("UNITID",unitid);
			groupinfo.put("unitid",unitid);
		}
		groupinfo.put("GROUPTYPE","Event");
		groupinfo.put("grouptype","Event");
		groupinfo.put("PS","eventmanage");
		groupinfo.put("evttype",evttype);
		EditEventDB evtDB=new EditEventDB();
		if(evtlevel==null){
			evtlevel=""+evtDB.getEventLevel(Integer.parseInt(groupid));
			groupinfo.put("evtlevel",evtlevel);
		}		
		session.setAttribute("groupinfo",groupinfo);
		String authid=null;
		Authenticate authData=AuthUtil.getAuthData(pageContext);
		if(authData!=null)authid=authData.getUserID();
		String sessid=(String)session.getId();
		if(session.getAttribute("event_visited_"+groupid) ==null){
			HitDB.insertHit(new String[]{"eventdetails.jsp","Event",sessid,groupid,authid});
			session.setAttribute("event_visited_"+groupid,groupid) ;
		}
}
%>
<%
request.setAttribute("tasktitle","Event Group Manage  > "+group_title );
session.setAttribute("platform","ning");
%>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy2() { }
</script>

<jsp:include page="/ningapp/taskheader.jsp"/> 
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<table  width='97%'cellpadding="0"  cellspacing="0">
<tr><td align='left' valign='top' width='48%'><table valign='top' width='100%'>
<tr><td >
<jsp:include page='/myevents/eventgroupmanagementtools.jsp' >
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>' />
<jsp:param  name='platform'  value='ning' />
</jsp:include>
</td></tr>
<tr><td valign='top'>
<jsp:include page='/editevent/links.jsp' >
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>'/>
<jsp:param  name='platform'  value='ning' />

</jsp:include>

</td></tr>
</table></td><td width='1%'></td>
<td valign='top' width='48%'><table valign='top' width='100%'>
<tr><td>
<jsp:include page='/myevents/ConfigureEventGroup.jsp' >
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>'/>
<jsp:param  name='platform'  value='ning' />
</jsp:include>
</td></tr>

</table></td>
</tr>
</table>

	