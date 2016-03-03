<%@ page import="java.util.*" %>
<%@ page import="java.io.IOException" %>

<%@ page import="com.eventbee.forum.ForumDB" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.event.ticketinfo.EventTicketDB" %>
<%@ page import="com.eventbee.hub.*" %>
<%!
        final String FILE_NAME="common.webapp.discussionforums.logic.MgrForumBeelet.jsp";
%>

<%
//if(request.getParameter("frompagebuilder") !=null)

//out.println(PageUtil.startContent("Discussion Forums",request.getParameter("border"),request.getParameter("width"),true) );
%>



<%
	
	String clubname=request.getParameter("clubname");
	if(clubname!=null)
	clubname=java.net.URLEncoder.encode(clubname);
	String beeletdisplay="OK",isnetwork=null;
	String role=null,groupid=null,authid=null,grouptype=null;
	String clubrole="HUBMGR";
	HashMap hm=(HashMap)session.getAttribute("groupinfo");
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	if(hm==null){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"groupinfo HM is null at discussionforum", "generate mod", EventbeeLogger.LOG_END_PAGE, null);
	}else{
		groupid=(String)hm.get("groupid");
		grouptype=(String)hm.get("grouptype");
		isnetwork=(String)hm.get("isnetwork");
		if(!( "Yes".equals(isnetwork)) ){
			if( ("Event".equalsIgnoreCase(grouptype)) && ("Yes".equals(EventTicketDB.getEventConfig(groupid, "event.power.ebee") ) ) ){
				isnetwork="Yes";
			}
		}
	}
   
	beeletdisplay="Yes";
	Authenticate authData=AuthUtil.getAuthData(pageContext);     //(Authenticate)session.getAttribute("authData");
	if (authData!=null){
		 authid=authData.getUserID();
		 role=authData.getRoleName();
	}else{
		role="Member";
		authid=(String)session.getAttribute("transactionid");
	}
	session.setAttribute("Rolename",role);
	//if(! "Manager".equalsIgnoreCase(role)){
		clubrole=HubMaster.getUsersHubStatus(authid,groupid);
	//}
	
	if("HUBMGR".equalsIgnoreCase(clubrole)){
		HashMap forums=ForumDB.getForumInfo(groupid);
	
%>	
<%@ include file="/stylesheets/CoreRequestMap.jsp" %>
        <div class='memberbeelet-header'>Discussion Forums</div>
	<table class="portaltable" align="center" cellpadding="0" cellspacing="0"  width="100%" border='0'>
	<form name="form" action="<%=appname%>/mytasks/enterforuminfo.jsp?type=Community" method='post'>
			   <input type='hidden' name='clubname' value='<%=clubname%>'/>
			   <tr><td colspan='3' width='100%'>
			<% if(forums!=null){ %>
				<table align="center" border="0" cellpadding="5" cellspacing="0" width="100%">
				<tr >
				<td class="colheader" width='75%' colspan="2">Name</td>
				
				</tr>

				
					<%
						String forumid=null;
						Set set=forums.entrySet();
						String base="oddbase";
						int k=0;
						for(Iterator i=set.iterator();i.hasNext();){
							base=(k%2==0)?"oddbase":"evenbase";
							k++;
							Map.Entry entry=(Map.Entry)i.next();
							forumid=(String)entry.getKey();
							HashMap forum=(HashMap)forums.get(forumid);
							 String status=(String)forum.get("status");
									if("Yes".equals(status)){
										status="Active";
									}else if("No".equals(status)){
										status="Inactive";
									}else if("Suspend".equals(status)){
										status="Suspended";
									}

					%>		
						<tr >
							<td class="<%=base%>">
								<a href='<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/guesttasks/showForumTopics.jsp?type=Community&forumid="+forumid,hm)%>'><%=GenUtil.TruncateData( GenUtil.getHMvalue(forum,"forumname","",true),27)%></a>

							</td>
							<td class="<%=base%>">
							<A href="<%=PageUtil.appendLinkWithGroup(appname+"/mytasks/editforuminfo.jsp?isnew=yes&type=Community&forumid="+forumid,hm)%>">Settings</a>

							</td>
						</tr>


					<%}%>
					</table>
					<%}%>
					</td></tr><tr><td>

				<%= com.eventbee.general.PageUtil.writeHiddenCore(hm )%>

					<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
					<% if(forums==null){ %>
					<tr >
							<td class="oddbase" align="left" width="100%">
								<%=EbeeConstantsF.get("discussionforum.empty.message","please set the property discussionforum.empty.message in emptybeelts.ebeeprops")%>
							</td>
						</tr>
					<%}%>
						<tr >
							<td class="oddbase" align="center" width="100%">
								<input type='hidden' name='isnew' value='yes' />
								<input type="submit" name="submit" value="<%=(forums==null)?"Enable":"Add Forum"%>"/>
								<input type="hidden" name="source" value="getforuminfo" />
								<input type="hidden" name="authid" value="<%=authid%>" />
								<input type="hidden" name="groupid" value="<%=groupid%>" />

							</td>
						</tr>
					</table>

			</td></tr>
			</form>
		</table>
<%}%>

	<%EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, FILE_NAME, "generate mod", EventbeeLogger.LOG_END_PAGE, null);%>
 <%
//if(request.getParameter("frompagebuilder") !=null)
//		out.println(PageUtil.endContent());
%>
