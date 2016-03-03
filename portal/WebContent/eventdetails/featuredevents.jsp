<%@ page import="java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection,com.eventbee.event.EventDB,com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
String unitid=null,groupid=null,evt_level=null,evt_type=null;
String link=request.getContextPath()+"/eventdetails/eventdetails.jsp?UNITID="+request.getParameter("UNITID")+"&GROUPID=";
HashMap param=new HashMap();
Vector sdorder=new Vector();
HashMap events=null;
java.text.SimpleDateFormat SDF=new java.text.SimpleDateFormat("yyyy-MM-dd");
String reqdate=SDF.format(Calendar.getInstance().getTime());
param.put("startdate",reqdate);
param.put("unitid",request.getParameter("UNITID"));
events=EventInfoDb.getFeaturedEvents(-1, sdorder, param);

%>
<%
String server_addrs="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");

String base="oddbase";
HashMap event;
Vector v1=new Vector();
 Vector v=new Vector();
int dispsize=5;
 int size=1;

if(events!=null&&events.size()>0){

if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent("Featured Events",request.getParameter("border"),request.getParameter("width"),true) );
%>
<table border="0" width="100%" align="center"   cellspacing="0">
<tr width="100%" >
	<td colspan="3" align="right" >
	<a href="<%=PageUtil.appendLinkWithGroup("/portal/eventdetails/events.jsp?evttype=event&UNITID="+request.getParameter("UNITID"),(HashMap)request.getAttribute("REQMAP"))%>">All Events</a>&nbsp&nbsp&nbsp
	<a href="/portal/auth/listauth.jsp?UNITID=13579&purpose=listevt&unitid=13579&entryunitid=13579">List Event</a>
	</td>
</tr>
<%


		for (int i=0;i<sdorder.size();i++){
		base="colheader";
		String startdate=(String)sdorder.elementAt(i);

%>
<tr width="100%" class="<%=base%>">
	<td width="2%"></td>
	<td width="98%" align="left" colspan="2"><b><%=startdate%></b></td>
</tr>
<%

		Vector sdevents=(Vector)events.get(startdate);
		for(int k=0;k<sdevents.size();k++){
		if(k%2==0){
				base="evenbase";
			}else{
				base="oddbase";
			}
			HashMap hmap=(HashMap)sdevents.elementAt(k);
link=server_addrs+"/event?eid=";
%>
<tr width="100%" class="<%=base%>">
	<td colspan="3" height="5"></td>
</tr>
<tr width="100%" class="<%=base%>">
	<td width="2%"></td>
	<td width="98%" align="left">

		 <%=hmap.get("eventtime")%> <%=hmap.get("location")%>
		 <br/>
		<%
		String fontcolor="blue";

			if("3".equals(hmap.get("evtlevel"))){
			fontcolor="green";
			}
			else if("2".equals(hmap.get("evtlevel"))){
			fontcolor="purple";
			}
			if(!"0".equals(hmap.get("tcount"))){%>
			<a HREF="<%=link%><%=hmap.get("eventid")%>"><img src="/home/images/ticket.gif" width='13' height="11" border='0' alt="Registration Available"/></a>
			<%}
			if(hmap.get("photourl")!=null){%>
			<a HREF="<%=link%><%=hmap.get("eventid")%>"><img src="/home/images/camera.gif" width='13' height="11" border='0' alt="Photo Available"/></a>
			<%}%>

			<a HREF="<%=link%><%=hmap.get("eventid")%>"><font color="<%=fontcolor%>">
			  <%=hmap.get("name")%>
			</font></a>
		<%
			if(hmap.get("user_name")!=null)
			{
		%>  - by <a HREF="/portal/editprofiles/networkuserprofile.jsp?UNITID=<%=request.getParameter("UNITID")%>&amp;userid=<%=hmap.get("userid")%>&entryunitid=13579"><%=hmap.get("user_name")%></a>
<%}%>
	</td>
</tr>
<tr width="100%" class="<%=base%>">
	<td colspan="3" height="5"></td>
</tr>

<%}}

%>

</table>
<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
		}
%>




