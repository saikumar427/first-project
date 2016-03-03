<%@ page import="java.io.IOException,java.util.*,com.eventbee.event.EventDB"%>
<%@ page import="com.eventbee.event.BeeletController,com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.editevent.*"%>
<%@ page import="com.eventbee.sponsorregister.SponsorDB,com.eventbee.useraccount.AccountDB"%>
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%@ page import="java.util.*,java.io.*,java.io.IOException"%>
<%
		int count=0;
		String groupid=null;
                String grouptype=null;
		String query=null,status=null;
		Vector sponsors=null;
		boolean displaybeelet=false;
		String unitid=null;
		String title=null;
		String header=null;
		String footer=null;
		String configid=null;
		String appname=("/manager".equals(request.getContextPath()))?"/manager":"/portal";
		HashMap contentData=(HashMap)session.getAttribute("groupinfo");
                boolean isContext=("No".equals((String)session.getAttribute("fromcontext")));
		if(contentData!=null){
			groupid=(String)contentData.get("groupid");
                        grouptype=(String)contentData.get("grouptype");
		}
	   HashMap newhm=(HashMap)session.getAttribute("groupinfo");
	     if(newhm!=null){
		   groupid=(String)newhm.get("groupid");
                        grouptype=(String)newhm.get("grouptype");
		   sponsors=SponsorDB.getSponsorships(groupid,grouptype,isContext,true);
		  Config cf=ConfigLoader.getGroupConfig(newhm);
		configid=cf.getConfigID();
	      HashMap hm=ConfigLoader.getConfig(configid);
	      if (hm.size()>0) {
		   title=(String)hm.get("unit.sponsorships.title");
		   if(title==null) title="Sponsorships";
		   header=(String)hm.get("unit.sponsorships.header");
		   footer=(String)hm.get("unit.sponsorships.footer");
	      }
	   }

	if((sponsors==null)||(sponsors.size()==0)){

	}else{
	displaybeelet=true;
	}
	%>

<%	if(displaybeelet){
%>
<%
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent(title,request.getParameter("border"),request.getParameter("width"),true) );
%>
<table class="portaltable" align="center" width="100%" cellspacing="0" cellpadding="0">
<%
		if(header!=null && !("".equals(header.trim())) ){
%>
<tr class="oddbase">
					<td>
					<%=header%>
					</td>
				</tr>
<%}%>

				<tr>
				<td>
<table  align="center" width="100%" cellspacing="0" cellpadding="0">
<%			String base="evenbase";
                        int size=sponsors.size();
			for(int i=0;i<size;i++){
	         	       HashMap sponsor=(HashMap)sponsors.elementAt(i);
				count++;
				if(count%2==0){
					base="oddbase";
				}else{
					base="evenbase";
				}
%>					<tr class="<%=base%>">
				<td width="60%">
				<%=(String)sponsor.get("name")%>
				</td>
         			<td width="40%">
<%
String   sponlink=appname+"/sponsors/getsponsorships.jsp";

%>
			     	<a href="<%=PageUtil.appendLinkWithGroup(sponlink,newhm)%>">
				View
				</a>
				</td>
                                </tr>
     <tr class="<%=base%>">
     <td colspan='2' align='left'>Sell By:
     <%=(String)sponsor.get("cutoffdate")%>
</td>
</tr>
<%}%>
</table></td></tr>
<%if(footer!=null && !("".equals(footer.trim()) ) ){%>
        <tr class="oddbase">
			<td>
			<%=footer%>
</td>
</tr>
<%}%>
</table>
<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
%>
<%}%>

