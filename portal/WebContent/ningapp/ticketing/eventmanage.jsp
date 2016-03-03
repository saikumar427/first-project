<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*,java.util.*" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.event.BeeletController,com.eventbee.editevent.*,com.eventbee.event.*" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />


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
String groupid=request.getParameter("GROUPID");
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

String cnt=DbUtil.getVal("select count(*) as count from price where evt_id=?",new String[]{groupid});
int ticketcount=0;
try{
	ticketcount=Integer.parseInt(cnt);
}catch(Exception e){
	System.out.println("Exception---->"+e);
}



%>

<%      

String domain=(String)session.getAttribute("domain");
String oid=(String)session.getAttribute("ning_oid");

String listsession=(String)session.getAttribute("EventListed");

if("Yes".equals(listsession)){
session.removeAttribute("EventListed");

String evtname1=evtname.replaceAll("'"," ");
 evtname1=evtname1.replaceAll("&"," ");
//evtname1=evtname1.replaceAll("?"," ");

%>
<script>
top.location.href='http://<%=domain%>/opensocial/application/show?appUrl=http%3A%2F%2Fwww.eventbee.com%2Fhome%2Fning%2Feventregister.xml%3Fning-app-status%3Dnetwork&owner=<%=oid%>&view_eventid=<%=request.getParameter("GROUPID")%>&view_purpose=manage&view_evtname=<%=evtname1%>';
</script>
<%
}
%>




<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
String Myevents="<a href='/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid="+session.getId()+"'>My Events</a>";
request.setAttribute("tasktitle", Myevents+" > Event Manage > "+evtname);
session.setAttribute("platform","ning");
%>
<jsp:include page="/ningapp/taskheader.jsp"/> 

<table  width='100%'cellpadding="0"  cellspacing="0">
<tr><td align='left' valign='top' width='48%'><table valign='top' width='100%'>
<tr><td >
<jsp:include page='/editevent/evtmgmt.jsp;jsessionid=<%=session.getId()%>' >
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>' />
<jsp:param  name='platform'  value='ning' />
</jsp:include>
</td></tr>
<tr><td height="5"></td></tr>

<tr><td valign='top'>
<jsp:include page='/discounts/discountsbeelet.jsp;jsessionid=<%=session.getId()%>' >
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>'/>
<jsp:param  name='platform'  value='ning' />

</jsp:include>

</td></tr>
<tr><td height="5"></td></tr>

<tr><td valign='top'>
<jsp:include page='/editevent/links.jsp;jsessionid=<%=session.getId()%>' >
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>'/>
<jsp:param  name='platform'  value='ning' />

</jsp:include>
</td></tr>
<tr><td height="5"></td></tr>

</table></td><td width='1%'></td>
<td valign='top' width='48%'><table valign='top' width='100%'>
<tr><td width='100%' style="border: 1px solid #ddddff; padding:5px;" valign='top'>
<jsp:include page="/customconfig/logic/CustomContentBeelet.jsp">
<jsp:param name="portletid" value="NING_APP_MANAGE_EVENT" />
<jsp:param name="forgroup" value="13579" />

</jsp:include>

</td></tr>
<tr><td height="10"></td></tr>

<tr><td>
<jsp:include page='/eventmanage/mgreventinfoBeelet.jsp;jsessionid=<%=session.getId()%>' >
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>'/>
<jsp:param  name='platform'  value='ning' />
</jsp:include>
</td></tr>
<tr><td height="5"></td></tr>

<tr><td>
<jsp:include page='/eventbeeticket/agentsinfo.jsp;jsessionid=<%=session.getId()%>' >
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>'/>
<jsp:param  name='platform'  value='ning' />
</jsp:include>

</td></tr>

</table></td>
</tr>
</table>

