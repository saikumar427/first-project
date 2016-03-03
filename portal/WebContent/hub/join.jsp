<%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%
String userid=null,unitid="13579";
	Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
	if (authData!=null){
		userid=authData.getUserID();
		//unitid=authData.getUnitID();
	}
	unitid=request.getParameter("UNITID");
	String groupid=request.getParameter("GROUPID");
	HashMap hubinfohash=com.eventbee.hub.hubDB.getHubInfo(groupid,null);
	
	String clubname=GenUtil.getHMvalue(hubinfohash,"clubname","");
	
%>


<%
	

	
	String club_title=EbeeConstantsF.get("club.label","Community");
	String code=club_title;
	HashMap groupinfo=new HashMap();
	groupinfo.put("groupid",groupid);
	groupinfo.put("grouptype","Club");
	Config conf1=ConfigLoader.getGroupConfig(groupinfo); 
	HashMap conghm=ConfigLoader.getConfig(conf1.getConfigID());
	conf1.setConfigHash(conghm);
	String memberhubstatus =HubMaster.getUsersHubStatus(userid,groupid);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/hub/join.jsp",null,"memberhubstatus value is------"+memberhubstatus,null);
	String clubapprovaltype=conf1.getKeyValue("club.memberapproval.type","Public");
	String membershipscount=DbUtil.getVal("select count(*) from club_membership_master where clubid=?",new String[]{groupid});
	
	
	
	if( membershipscount==null||"0".equals(membershipscount)&& ("Paid".equalsIgnoreCase(clubapprovaltype)) ){
			
			GenUtil.Redirect(response,"/guesttasks/huberror.jsp?UNITID="+unitid+"&GROUPID="+groupid);	
		}
	if("GUEST".equalsIgnoreCase(memberhubstatus)){
		HashMap hm=new HashMap();
		session.setAttribute("BACK_PAGE","hub");
		 hm.put("redirecturl","/guesttasks/hubjoin.jsp?PS=clubview&GROUPID="+groupid+"&UNITID="+unitid);
		 session.setAttribute("REDIRECT_HASH",hm);
		 //response.sendRedirect("/portal/auth/listauth.jsp?id=yes&UNITID="+unitid+"&purpose=joinhub&GROUPID="+groupid);
		//return;
		GenUtil.Redirect(response,"/portal/auth/listauth.jsp?id=yes&UNITID="+unitid+"&purpose=joinhub&GROUPID="+groupid);
	}else
	if("INVALID".equalsIgnoreCase(memberhubstatus) ){
		GenUtil.Redirect(response,"/portal/auth/listauth.jsp?id=yes&UNITID="+unitid+"&purpose=joinhub&GROUPID="+groupid);
	}else{
	
	

	
	String dispalyclubappmess="";
	
	if("HUBGUEST".equalsIgnoreCase(memberhubstatus) ){
	if("Public".equalsIgnoreCase(clubapprovaltype))
	dispalyclubappmess=EbeeConstantsF.get("community.join.public.displayinfo","This is a Public Community. Anyone may join");
	else if("Moderated".equalsIgnoreCase(clubapprovaltype))
	dispalyclubappmess=EbeeConstantsF.get("community.join.moderator.displayinfo","This is a Moderated Community. You will receive a confirmation message when your membership is approved");
	else if("Paid".equalsIgnoreCase(clubapprovaltype)){
		
		
		GenUtil.Redirect(response,"/portal/guesttasks/paidpersonalInfo.jsp?isnew=yes&UNITID="+unitid+"&purpose=joinhub&GROUPID="+groupid);
		//response.sendRedirect("/portal/paidhubs/personalInfo.jsp?isnew=yes&UNITID="+unitid+"&purpose=joinhub&GROUPID="+groupid);
		//return;
	}
	}
	%>


<%if("HUBGUEST".equalsIgnoreCase(memberhubstatus) ){%>
<table width='100%' cellpadding ="5">
<form name="joinform" method="post" action="/hub/joinctrl.jsp">
<input type="hidden" name="UNITID" value="<%=unitid %>" />
<input type="hidden" name="GROUPID" value="<%=groupid %>" />
<input type='hidden' name='clubapprovaltype'  value='<%=clubapprovaltype %>' %>
<tr><td colspan='2'>
	<table class='block' align="center">
	<tr valign='top'><td align="center">
		<a href='/hub/clubview.jsp?GROUPID=<%=groupid %>&UNITID=13579'><%=hubinfohash.get("clubname")%></a>
	</td></tr>
	<tr>
	<td align="center"><%=dispalyclubappmess %></td></tr>
	</table>

</td></tr>
	<%

	if("Moderated".equalsIgnoreCase(clubapprovaltype)){
	%>
	
	
<tr>
<td class='inputlabel' width='30%' valign='top' >Your Introduction<br /><font class="smallestfont">(Comment to the Moderator why you would like to join)</font></td>
<td class='inputvalue'>
<textarea name='statement' rows="10" cols='50'> </textarea>
</td>
</tr>

	<%
	}
	%>
	
<tr><td colspan="2" valign="top"><table align="center" >	
<tr valign='top'><td align="center"><input type='button' name='bbbb' value='Back' onClick='javascript:history.back()' /> <input type='submit' name='submit' value='Join' /></td></tr>
</td></tr></table>
<%

	}else{
%>
<tr><td colspan="2"><table class='block' align="center">
<tr valign='top'><td align="center"><td   align='center'  >
		<%=EbeeConstantsF.get(code+".join.already","You have already joined this Community")%>.<br/><br/>Visit &nbsp<a href='/hub/clubview.jsp?GROUPID=<%=groupid %>&UNITID=13579'><%=hubinfohash.get("clubname")%></a>  
</td></tr>
</td></tr></table>
<div style='height:300px'></div>
<%
	}
%>
</form>
</table>

<% }%>
