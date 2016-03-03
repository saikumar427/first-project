<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbeepartner.partnernetwork.PartnerDetails" %>
<%@ page import="com.eventbee.general.*"%>
<%
Authenticate authData=AuthUtil.getAuthData(pageContext);
String userid=(authData!=null)?authData.getUserID():"";
String platform = request.getParameter("platform");
String linktarget="_self";
String URLBase="mytasks";
if("ning".equals(platform)){
	linktarget="_blank";
	URLBase="ningapp";
}
if(platform==null) platform="";
PartnerDetails pd=new PartnerDetails();
Vector events=new Vector();//pd.getTopNtsEvents(); commented for slowquery on 19-jan-2015
HashMap eventstatusmap=pd.PartnerApprovalStatusForEvents(userid);
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/";
com.eventbee.general.formatting.CurrencyFormat cf=new com.eventbee.general.formatting.CurrencyFormat();
if(events!=null&events.size()>0){
%>
<script>
function  registerevent(id,platform){		                
	window.location.href="/event?eid="+id+"&platform="+platform;			
}
	

</script>

</script>
 <table cellpadding='5' cellspacing='0' align='center' width='100%'>
	<tr><td colspan='3' class='memberbeelet-header'>Top Network Ticket Selling Events</td></tr>
	<tr class='colheader'><td >Date</td><td  >Event</td><td>Earn/Ticket</td></tr>
<%
        for(int i=0;i<events.size();i++){
		String base=(i%2==0)?"evenbase":"oddbase";
		HashMap hm=(HashMap)events.get(i);
		String evntname=(String)GenUtil.getHMvalue(hm,"eventname","0");
		String eventid=(String)GenUtil.getHMvalue(hm,"eventid","");
		String eventdisplayname=GenUtil.TruncateData(evntname,20);
		String eventurl= serveraddress+"event?eid="+eventid+"&platform="+platform;
		String agentstatus=pd.getAgentStatus(eventstatusmap, eventid,"");		
%>
		<tr colspan='4'>
		<td  class='<%=base%>' align='left'>
		<%=GenUtil.getHMvalue(hm,"startdate","0")%></td>
		<td  class='<%=base%>' align='left'>
		<a href='#' onclick=registerevent('<%=eventid%>','<%=platform%>')><%=eventdisplayname%></a>
                </td>
                <td class='<%=base%>' align='left'><%=cf.getCurrencyFormat("$",GenUtil.getHMvalue(hm,"commission",""),true)%></td>
		</tr>
		<tr><td class='<%=base%>'  colspan='4'>Status: <%=agentstatus%>
<%
		if("Need Approval".equals(agentstatus)){
%>
		&raquo;&nbsp;<a href='/<%=URLBase%>/getntsapproval.jsp?groupid=<%=eventid%>&platform=<%=platform%>' >Get Approval</a>
<%
		}else if("Approved".equals(agentstatus)){
%>
		&raquo;&nbsp;<a href='/<%=URLBase%>/partnerlinks.jsp?groupid=<%=eventid%>&platform=<%=platform%>' >Manage</a>
<%
		}
%>
		</td></tr>
<%
		}
}
%>
</table>