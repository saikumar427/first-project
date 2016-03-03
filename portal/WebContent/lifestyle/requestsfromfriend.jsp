<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.nuser.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<script>
function getinvid(str){
	document.form.invid.value=str;
	alert(str);

}
</script>


<%!
	String CLASS_NAME="requestsfromfriend.jsp";
	


	public String  getMemberScrName(String userid){
		String scrname="none";
		if(userid !=null)
		scrname=DbUtil.getVal("select getMemberPref(?,'pref:myurl','') as scrname", new String[]{userid});
		
		return scrname;
	
	}



	
	
	
%>
<%
	request.setAttribute("tasktitle","My Network");
	request.setAttribute("tasksubtitle","Manage");
	request.setAttribute("tabtype","community");
	request.setAttribute("subtabtype","mynetwork");

%>

<%
String updated=request.getParameter("updated");
String manid=null;
String groupid=null;
String grouptype=null;
String unitid=null;
Authenticate authData=AuthUtil.getAuthData(pageContext);
if (authData!=null){
      	manid=authData.getUserID();
	 groupid=(String)session.getAttribute(ContextConstants.SD_GROUP_ID);
	 unitid=authData.getUnitID();
}
List reqlist=NUserDb.getMyRequests( manid);


%>


<%
//if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent("Friend Requests",request.getParameter("border"),request.getParameter("width"),true) );
%>



<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" class="portalback">


<!-- My Requests -->
<tr>
<td width='100%'>
<table width="100%" cellspacing='0' cellpadding='0'>
<form name="NuserRespond" action="/nuser/NuserRespond.jsp?fordelr=yes" method="post">
<input type='hidden' name='ntype' value='Pending Friend Requests' />

<%
if(!reqlist.isEmpty()){

		Iterator iter=reqlist.iterator();
		out.println("<tr class='colheader'><td width='10%' class='colheader'><input type='submit' name='submit' value='Delete'/></td><td width='35%'></td><td width='35%'>Message</td><td width='20%'> </td></tr>");
		int cntr=0;
		while(iter.hasNext()){
		NUser nuser=(NUser)iter.next();
		cntr++;
		String htmltdclass="oddbase";
		if(cntr%2==0)htmltdclass="evenbase";

%>
<tr class="<%=htmltdclass %>">
<td align='center' class="<%=htmltdclass %>"><input type="checkbox" name="delr" value="<%=nuser.getUserId() %>" /></td>

<td><a href='<%= ShortUrlPattern.get(getMemberScrName(nuser.getUserId()))%>/network'><%=GenUtil.getEncodedLT(nuser.getUserName()) %></a></td>
<td><%=GenUtil.textToHtml(nuser.getMessage()) %></td>
<td>
<a href='<%=PageUtil.appendLinkWithGroup("/nuser/NuserRespond.jsp?ntype=Pending Friend Requests&act=Accept&friendid="+nuser.getUserId()+"&friendname="+GenUtil.getEncodedLT(nuser.getUserName()) , (HashMap)request.getAttribute("REQMAP")   )    %>'>&raquo; Accept</a>
		<div>
		<a href='<%=PageUtil.appendLinkWithGroup("/nuser/NuserRespond.jsp?ntype=Pending Friend Requests&act=Decline&friendid="+nuser.getUserId()+"&friendname="+GenUtil.getEncodedLT(nuser.getUserName()) , (HashMap)request.getAttribute("REQMAP")   )    %>'>&raquo; Decline</a>
		</div>
		</td>



</tr>

<%
}//end of while
}else{

out.println("<tr valign='top'><td colspan=\"3\" class='evenbase' >No Pending Requests</td></tr>");
}
%>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
</form>
</table>

</td>
</tr>
<!-- end of reqs -->

</table>

<%
//if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
%>

