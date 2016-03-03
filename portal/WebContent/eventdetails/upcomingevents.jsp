<%@ page import="java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection,com.eventbee.event.EventDB,com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");

String unitid=null,groupid=null,evt_level=null,evt_type=null;
String link=request.getContextPath()+"/eventdetails/eventdetails.jsp?UNITID="+request.getParameter("UNITID")+"&GROUPID=";
HashMap param=new HashMap();
Vector sdorder=new Vector();
HashMap events=null;
java.text.SimpleDateFormat SDF=new java.text.SimpleDateFormat("yyyy-MM-dd");
String reqdate=SDF.format(Calendar.getInstance().getTime());
param.put("startdate",reqdate);
param.put("unitid","13579");
events=EventInfoDb.getEvents(-1, sdorder, param);
%>
<%
String base="oddbase";
HashMap event;
Vector v1=new Vector();
 Vector v=new Vector();
int dispsize=5;
 int size=1;

if(events!=null&&events.size()>0){
%>
<%
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent("Current Events",request.getParameter("border"),request.getParameter("width"),true) );
%>
<table border="0" width="100%" align="center"   cellspacing="0">
<%
boolean viewall=false;
int rcount=0;
if(sdorder.size()>5)
viewall=true;
else{
for (int i=0;i<sdorder.size();i++){
String startdate=(String)sdorder.elementAt(i);
Vector sdevents=(Vector)events.get(startdate);
if(sdevents.size()>5)
{
viewall=true;
break;
}else
{
rcount=rcount+sdevents.size();
if(rcount>5)
{
viewall=true;
 break;
 }
}
}
}
if(viewall){

%>
<tr width="100%" >
	<td colspan="3" align="right" ><a href="<%=PageUtil.appendLinkWithGroup("/portal/eventdetails/events.jsp?evttype=event&UNITID="+request.getParameter("UNITID"),(HashMap)request.getAttribute("REQMAP"))%>">More</a>
	</td>
</tr>
<%
}


		for (int i=0;i<sdorder.size();i++){
		if(size>dispsize) break;
		base="colheader";
		String startdate=(String)sdorder.elementAt(i);

%>
<tr width="100%" class="<%=base%>">
	<td width="2%"></td>
	<td width="98%" align="left" colspan="2"><b><%=startdate%></b></td>
</tr>
<%

		Vector sdevents=(Vector)events.get(startdate);
		for(int k=0;k<sdevents.size()&&size<=dispsize;k++){
		if(size>dispsize) break;
  		size=size+1;
			if(k%2==0){
				base="evenbase";
			}else{
				base="oddbase";
			}
			HashMap hmap=(HashMap)sdevents.elementAt(k);
link=serveraddress+"/event?eid=";
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
			if("3".equals(hmap.get("evtlevel"))){
		%>
			<a HREF="<%=link%><%=hmap.get("eventid")%>"><font color="green">  <%=hmap.get("name")%></font></a>
		<%
			}else if("2".equals(hmap.get("evtlevel"))){
		%>
				<a HREF="<%=link%><%=hmap.get("eventid")%>"><font color="purple">  <%=hmap.get("name")%></font></a>
		<%
			}else{
		%>
				<a HREF="<%=link%><%=hmap.get("eventid")%>"><font color="blue">  <%=hmap.get("name")%></font></a>
		<%
			}
			if(hmap.get("user_name")!=null)
			{
		%>  - <a HREF="/portal/editprofiles/networkuserprofile.jsp?userid=<%=hmap.get("userid")%>&UNITID=13579"><%=hmap.get("user_name")%></a>
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




