<%@page import="java.util.*" %>

<%@page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>

<jsp:include page='/auth/checkpermission.jsp'>
	<jsp:param name='authtype' value='<%=request.getParameter("PS")%>' />
<jsp:param name='Dummy_ph' value='' /></jsp:include>
<%
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"enterforuminfo.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	String name="",description="",status="Yes",loginname="",enableposting="no";
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	
	String groupid=request.getParameter("GROUPID");
	HashMap forumhash=null;
	String clubname=request.getParameter("clubname");
	Vector errorvector=null;
	if(!"yes".equalsIgnoreCase(request.getParameter("isnew"))){
		forumhash=(HashMap)session.getAttribute("forumhash");
		errorvector=(Vector)session.getAttribute("errorvector");
		if(forumhash!=null){
			name=(String)forumhash.get("name");
			description=(String)forumhash.get("description");
			status=(String)forumhash.get("status");
			loginname=(String)forumhash.get("loginname");
			enableposting=(String)forumhash.get("enableposting");
		}
	}
	String domain=EbeeConstantsF.get("support.email","support@beeport.com");
domain=domain.replaceAll("support","");
%>

<%  //request.setAttribute("tasktitle","Discussion Forum");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"enterforuminfo.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"ps value from request is"+request.getParameter("PS"),null);
    if("clubmanage".equals(request.getParameter("PS")))
    		{
		//request.setAttribute("tabtype","club");
		
		}

    else if("eventmanage".equals(request.getParameter("PS")))
    		{
		//request.setAttribute("tabtype","event");
		request.setAttribute("subtabtype","My Pages");
		}
    else
    		   request.setAttribute("tabtype","unit");
		   request.setAttribute("rightcontent","surround-forum.jsp");
		   request.setAttribute("subtabtype","Communities");
%>		

	<table width="100%" align="center" class="taskblock">
		<%--<form name="form" action="<%=appname%>/discussionforums/logic/isnertDiscForum.jsp" method="POST"> --%>
		<form name="form" action="/discussionforums/logic/insertDiscForum" method="POST">
		<input type="hidden" name="GROUPID" value='<%=groupid%>'/>
		<input type='hidden' name='clubname' value='<%=clubname%>'/>
		
		
			<% for(int i=0;errorvector!=null && i<errorvector.size();i++){ %>
				<tr><td width="100%"><font class="error"><%=(String)errorvector.get(i)%></font></td></tr>	
			<%}%>
			<table cellspacing="0" cellpadding="0" width="100%" align="center" class="taskblock" >
				<tr>
					<td width="30%" class="inputlabel">Forum Name *</td>
					<td width="70%" class="inputvalue"><input type="text" size="42" name="name" value="<%=name%>"/></td>
				</tr>
				<tr>
					<td class="inputlabel">Description </td>
					<td class="inputvalue">
						<textarea name="description" rows="10" cols="50" onfocus="this.value=(this.value==' ')?'':this.value" ><%=(description==null || "".equals(description.trim()))?" ":description%></textarea>
					</td>
				</tr>
				<tr>
					<td class="inputlabel">Enable email posting to forum</td>
					<td class="inputvalue"><table width='100%'><tr><td width='100%'>
						<input type="radio"  name="enableposting" value="no" <%if(!"yes".equals(enableposting))out.println("checked='checked'");%>/>No
						</td></tr><tr><td>
						<input type="radio"  name="enableposting" value="yes" <%if("yes".equals(enableposting))out.println("checked='checked'");%>/>Yes, Forum Email ID
						<input type="text" size="30" name="loginname" value="<%=loginname%>"/><%=domain%>
						</td></tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="inputlabel">Status</td>
					<td class="inputvalue">
						<%=WriteSelectHTML.getSelectHtml(new String[]{"Activate","Deactivate","Suspend"}, new String[]{"Yes","No","Suspend"},"status",status,null,null)%>
					</td>
				</tr>
					<tr><td colspan="2" width="100%" align="center">
					     <%=com.eventbee.general.PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>
					     
					     <input type="submit" name="submit" value="Add"/>
					     <input type="button" name="bbb" value="Cancel" onClick="javascript:history.back()" />
					 </td></tr>
				</table>				 
			</form>						 
	</table>
