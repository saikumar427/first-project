<%@ page import="java.util.*,com.eventbee.general.*,com.eventbeepartner.partnernetwork.*,com.eventbee.authentication.*"%>
<%
int intBeginIndex=0;
int RECORDS_COUNT =50;
String reqBeginIndex=request.getParameter("begin");
if(reqBeginIndex!=null){
try{
	intBeginIndex=Integer.parseInt(reqBeginIndex);
}catch(Exception e){}
}
String eventname=request.getParameter("eventname");
if(eventname==null) eventname="";
eventname=eventname;
String platform = request.getParameter("platform");
if("null".equals(platform)) platform="";
String linktarget="_self";
String URLBase="mytasks";
String formurl="/mytasks/networkticketsellingpage.jsp";
if("ning".equals(platform)){
	linktarget="_blank";
	URLBase="ningapp";
	formurl="/ningapp/ntstab";
	RECORDS_COUNT =5;
}
Authenticate auth=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
String uid=(auth!=null)?auth.getUserID():null;
String serveradd="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String pid=(String)session.getAttribute(uid+"_partnerid");
PartnerDetails pd=new PartnerDetails();
Vector partnerParticipatedNtsEvents=pd.getParticipatedNtsEvents(intBeginIndex, RECORDS_COUNT, eventname);
String oid=request.getParameter("oid");
String userid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{oid});
HashMap eventstatusmap=pd.PartnerApprovalStatusForEvents(uid);
if(eventstatusmap.isEmpty (  )){
eventstatusmap=pd.PartnerApprovalStatusForEvents(userid);
}

if(pid==null){

pid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});


}

String evtnamesrchPlsHld="Enter Event Name";
String evtdisplay=eventname;
String evtdisplayclass="stdstyle";
if("".equals(eventname)){
	evtdisplay=evtnamesrchPlsHld;
	evtdisplayclass="greystyle";
}

%>

<style>
.greystyle {
	color: gray;
	
}
.stdstyle {
	color: black;
	
}
</style>
<form name="searchform" method="post" action="<%=formurl%>" >
<table cellpadding="0"  cellspacing="0" align="center" valign="top" width="100%">
<tr><td class='colheader' >
<input type="text" class="<%=evtdisplayclass%>" value="<%=evtdisplay%>" onfocus="clearPlaceholderContent(this,'<%=evtnamesrchPlsHld%>');" onblur="showPlaceholderContent(this,'<%=evtnamesrchPlsHld%>');"  name="eventname" id="eventname"> 
<input type="button" value="Search"  onclick="javascript:searchevents('<%=evtnamesrchPlsHld%>');">

<a href="#" onclick="javascript:resetevents();">Reset</a>

</td></tr>
<tr><td align="right"  class='colheader' >

<%
if(intBeginIndex>0){
%>
<a href="#" onclick="getPreviousSet('<%=(intBeginIndex-RECORDS_COUNT)%>')" >Previous</a>
<%
}
%>
<%
if(partnerParticipatedNtsEvents!=null && partnerParticipatedNtsEvents.size()==RECORDS_COUNT){
%>
<a href="#" onclick="getNextSet('<%=(intBeginIndex+RECORDS_COUNT)%>')" >Next</a>
<%
}
%>
</td></tr>
<%
  if(partnerParticipatedNtsEvents!=null && partnerParticipatedNtsEvents.size()>0){
	for(int i=0;i<partnerParticipatedNtsEvents.size();i++){
		String base=(i%2==0)?"evenbase":"oddbase";
		HashMap ntsEventMap=(HashMap)partnerParticipatedNtsEvents.elementAt(i);		
		String eventdisplayname=(String)GenUtil.getHMvalue(ntsEventMap,"eventname","");
		String apprvstatus=(String)GenUtil.getHMvalue(ntsEventMap,"nts_approvaltype","");
		String eventid=(String)GenUtil.getHMvalue(ntsEventMap,"eventid","");
		String agentstatus= pd.getAgentStatus(eventstatusmap, eventid,apprvstatus);		
		String eventurl= serveradd+"/event?eid="+eventid+"&pid="+pid;
%>
		<tr><td class="<%=base%>" ></td></tr>
		<tr> 
		<td   class="<%=base%>" valign='top' >
		<a href='#' onclick=eventregister('<%=eventid%>','<%=pid%>','<%=platform%>')><%=eventdisplayname%></a>
		</td></tr>
		<tr><td class="<%=base%>" >Status: <%=agentstatus%>
<%
		if("Need Approval".equals(agentstatus)){
%>            
			&raquo;&nbsp;<a href='#' onclick=getapproval('<%=eventid%>','<%=platform%>') >Get Approval</a>
<%
		} else if("Approved".equals(agentstatus)){%>
			
			&raquo;&nbsp;<a href='#' onclick=manageevent('<%=eventid%>','<%=platform%>') >Manage</a>
<%
  		}
%>
    		</td></tr>			 
<%	
	}
  }else{	
%>
	<tr><td class="evenbase" >No Events Found.</td></tr>

<%}%>
</table>
</form>