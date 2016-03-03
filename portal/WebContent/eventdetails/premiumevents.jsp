<%@ page import="java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection,com.eventbee.event.EventDB,com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.streamer.*"%>

<%!
  private String stripHTMLTags( String message ) {
    StringBuffer returnMessage = new StringBuffer(message);
    int startPosition = message.indexOf("&lt;"); // encountered the first opening brace
    int endPosition = message.indexOf(">"); // encountered the first closing braces
    while( startPosition != -1 ) {
      returnMessage.delete( startPosition, endPosition+1 ); // remove the tag
      startPosition = (returnMessage.toString()).indexOf("&lt;"); // look for the next opening brace
      endPosition = (returnMessage.toString()).indexOf(">"); // look for the next closing brace
    }
    return returnMessage.toString();
  }





HashMap getnetadvevents(Vector v1){
HashMap hm=null;
HashMap hm1=new HashMap();
for(int j=0;j<v1.size();j++){
hm=(HashMap)v1.elementAt(j);
hm1.put("eventid"+j,(String)hm.get("eventid"));
}
			
			
			
return hm1;			
			
}
	


%>










<%
String server_addrs="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");

String unitid=null,groupid=null,evt_level=null,evt_type=null;
String link=request.getContextPath()+"/eventdetails/eventdetails.jsp?UNITID="+request.getParameter("UNITID")+"&GROUPID=";
HashMap param=new HashMap();
Vector sdorder=new Vector();
HashMap events=null;
java.text.SimpleDateFormat SDF=new java.text.SimpleDateFormat("yyyy-MM-dd");
String reqdate=SDF.format(Calendar.getInstance().getTime());
param.put("startdate",reqdate);
param.put("unitid","13579");
try{
	Integer.parseInt(request.getParameter("UNITID"));
	events=EventInfoDb.getPremiumEvents(-1, sdorder, param);
}catch(Exception e){}

%>
<%
String base="oddbase";
HashMap event;
Vector v1=new Vector();
 Vector v=new Vector();
int dispsize=5;
 int size=1;
 Vector advvec=new Vector();
 HashMap advmap=null;

if(events!=null&&events.size()>0){%>
<%--
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContentForGuest("Premium Events",request.getParameter("border"),request.getParameter("width"),true,"beelet-header") );
--%>

<table width="100%" border="0" cellpadding="0" cellspacing="0" height="10" class='beelet-header'>
<tr ><td  >
Premium Events </td>
</tr>
</table>

<table border="0" width="100%" align="center"   cellspacing="0">
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
			String evtname=(String)hmap.get("name");
			String noHTMLString = stripHTMLTags(evtname);        
			String truncatedata=GenUtil.TruncateData(noHTMLString,45);
			 advmap=new HashMap();
			advmap.put("eventid",(String)hmap.get("eventid"));
                        advvec.add(advmap);
		
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
                link=server_addrs+"/event?eid=";
		if(!"0".equals(hmap.get("tcount"))){%>
			<a HREF="<%=link%><%=hmap.get("eventid")%>"><img src="/home/images/ticket.gif" width='13' height="11" border='0' alt="Registration Available"/></a>
		<%}
		if(hmap.get("photourl")!=null){%>
			<a HREF="<%=link%><%=hmap.get("eventid")%>"><img src="/home/images/camera.gif" width='13' height="11" border='0' alt="Photo Available"/></a>
		<%}%>
			<a HREF="<%=link%><%=hmap.get("eventid")%>"><font color="<%=fontcolor%>">
			  <%=truncatedata%>
			</font></a>
		<%
			if(hmap.get("user_name")!=null)
			{
		%>  - by <a HREF="/portal/editprofiles/networkuserprofile.jsp?userid=<%=hmap.get("userid")%>&entryunitid=13579"><%=GenUtil.TruncateData(stripHTMLTags((String)hmap.get("user_name")),25)%></a>
<%}%>
	</td>
</tr>
<tr width="100%" class="<%=base%>">
	<td colspan="3" height="5"></td>
</tr>

<%}}
HashMap advobj=getnetadvevents(advvec);







String partnerid=EbeeConstantsF.get("networkadv.partner","3809");
boolean isnewsession=(session.getAttribute("netadv_session")==null);
if(isnewsession)
{
session.setAttribute("netadv_session","yes");
if(advobj!=null){
PartnerTracking pt=new PartnerTracking(advobj);
pt.setInsertionType("homepageimpressions");
pt.setPartnerId(partnerid);
pt.start();

}

}	
%>

</table>
<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
		}
%>




