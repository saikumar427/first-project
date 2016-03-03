<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.useraccount.*"%>


<%
Authenticate auth=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
String uid=null;
if (auth!=null){
uid=auth.getUserID();
}

String serveradd="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String base="oddbase";

String pid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{uid});
Vector partnerParticipatedNtsEvents=(Vector)session.getAttribute(uid+"_partnerNtsEvents");
HashMap partnerStatus=(HashMap)session.getAttribute(uid+"_partnerApprovalStaus");
%>
<script> 
 function partnerlinks(eventid){
 
window.location.href='/portal/ningapp/links.jsp?groupid='+eventid;

 } 
 </script>
 	
<table cellpadding="5"  cellspacing="0" align="center" width="100%">
<div class='beelet-header'>My Network Ticket Selling Participation</div></td></tr>
<%
if(partnerParticipatedNtsEvents!=null){
for(int i=0;i<partnerParticipatedNtsEvents.size();i++){
		if(i%2==0)
			base="evenbase";
		else
			base="oddbase";
		HashMap hm1=(HashMap)partnerParticipatedNtsEvents.elementAt(i);
		
		String truncatedata=(String)GenUtil.getHMvalue(hm1,"eventname","");
		
		%>
	<tr ><td id="popup<%=i%>" class="<%=base%>" colspan="4"></td></tr>
	
	<tr > 
	  
	
	<td  colspan="4" class="<%=base%>" valign='top' >
	<a href='<%=serveradd%>/eventdetails/event.jsp?eventid=<%=GenUtil.getHMvalue(hm1,"eventid","")%>&participant=<%=pid%>' target='_blank'><%=truncatedata%></a>
	
	
	</td></tr>

		<%
		
		String agentstatus=(String)GenUtil.getHMvalue(partnerStatus,GenUtil.getHMvalue(hm1,"eventid",""),"");
		
		if ("".equalsIgnoreCase(agentstatus)){
		String apprvstatus=GenUtil.getHMvalue(hm1,"nts_approvaltype","");
		if("Auto".equals(apprvstatus))
			agentstatus="Approved";		
		else
			agentstatus="Need Approval";
		}
		%>
		<tr><td class="<%=base%>" colspan="4">Status: <%=agentstatus%>
		
		<%
		String eventinfo= serveradd+"/eventdetails/event.jsp?eventid="+GenUtil.getHMvalue(hm1,"eventid","")+"&participant="+pid;
		%>
			
		  <%if("Need Approval".equals(agentstatus)){ %>            
		 &raquo; <a href='/portal/ningapp/getntsapproval.jsp?groupid=<%=GenUtil.getHMvalue(hm1,"eventid","")%>' >Get Approval</a>
		 <%}
		 else if("Approved".equals(agentstatus)){
		 
		 %>
		 <input type='hidden' name='groupid' value='<%=GenUtil.getHMvalue(hm1,"eventid","")%>' />

		 &raquo; <a href='#' onclick='javascript:partnerlinks("<%=GenUtil.getHMvalue(hm1,"eventid","")%>");'>Manage</a>		 
		 <%}%>
		</td></tr>
			 
<%	
	}
}else{
	
%>

<tr><td class="evenbase" colspan="4">No Events Found.</td></tr>

<%}%>
</table>

















