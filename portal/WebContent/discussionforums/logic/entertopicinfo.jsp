<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*"  %>
<%@ page import="com.eventbee.forum.ForumDB" %>
<%!

   final static String FILE_NAME="discussionforums/logic/entertopicinfo.jsp";

	String getDBValue(String query,String params[],String defval){
		String val=DbUtil.getVal(query,params);
		if(val==null || "".equals(val.trim())) val=defval;
		return val;
	}
%>
<jsp:include page="/stylesheets/CoreRequestMap.jsp" />
<% 


String authid=null,forumid=null,subject="",reply="";
	String groupid="",enabledPosting="No";
	String eunitid="";
	

String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
if("Delete".equals(request.getParameter("submit"))){ 
	
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"deletetopics.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	int res=0;
	String message="";
	forumid=request.getParameter("forumid");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"Topics/Messages to Delete",EventbeeLogger.LOG_START_PAGE,null);
	
	String msgid[]=request.getParameterValues("delmsgid");
	
	String pagetype=request.getParameter("page");
	if(pagetype==null || "".equals(pagetype.trim())) 
		pagetype="Message";
	if(msgid!=null && msgid.length > 0)
		res=ForumDB.deleteDiscForum(msgid,"single","Yes");
		
	message=(""+res)+" "+pagetype+"(s) Deleted ";		
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"Topics/Messages ",message,null);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"Topics/Messages to Delete",EventbeeLogger.LOG_END_PAGE,null);
	GenUtil.Redirect(response,"/mytasks/dffinalinfo.jsp?forumid="+forumid+"&message="+message+"&GROUPID="+request.getParameter("GROUPID"));%>
<%}%>
<%
	

	final String posting_key="forumposting.enabled.level";
	HashMap fmsghash=null;
	Vector errorvector=null;
	String postingLevel=EbeeConstantsF.get(posting_key,"UNIT");
	String club_title=EbeeConstantsF.get("club.label","Community");


		
		Authenticate authData=AuthUtil.getAuthData(pageContext);
		//(Authenticate)session.getAttribute("authData");

		forumid=request.getParameter("forumid");

		if("yes".equalsIgnoreCase(request.getParameter("isnew"))){
			//eunitid=request.getParameter("UNITID");
			groupid=request.getParameter("GROUPID");
		}else{
			fmsghash=(HashMap)session.getAttribute("fmsghash");
			errorvector=(Vector)session.getAttribute("errorvector");
			if(fmsghash!=null){
				subject=(String)fmsghash.get("subject");
				reply=(String)fmsghash.get("reply");
				forumid=GenUtil.getHMvalue(fmsghash,"forumid");
				groupid=GenUtil.getHMvalue(fmsghash,"GROUPID");
				eunitid=GenUtil.getHMvalue(fmsghash,"13579");
			}
		}

		String ClubUrl="/portal/club?id="+groupid;
		String redirecturl="";
                if (authData!=null){
      			 authid=authData.getUserID();
			 postingLevel=getDBValue("select value from config where name=? and config_id in (select config_id from clubinfo where clubid=?)",new String[]{posting_key,groupid},postingLevel);
			 if("UNIT".equalsIgnoreCase(postingLevel))
			 	enabledPosting="Yes";
			 else if("CLUB".equalsIgnoreCase(postingLevel)){
			 	enabledPosting=getDBValue("select 'Yes' as member from club_member where userid=? and clubid=? and status in ('ACTIVE')",new String[]{authid,groupid},"No");
			}
		}else{
			//if("/portal".equals(appname)){
				String isnew=("yes".equalsIgnoreCase(request.getParameter("isnew")))?"&isnew="+request.getParameter("isnew")+"":"";
				redirecturl=PageUtil.appendLinkWithGroup(appname+"/auth/listauth.jsp?purpose=FORUM_ADD_TOPIC&forumid="+request.getParameter("forumid")+isnew,(HashMap) request.getAttribute("REQMAP"));
			//}else{

			//}
			response.sendRedirect(redirecturl);
		}
%>

<%
String url="";
 HashMap urlmap=PageUtil.getPageNameAndUrl(request.getParameter("PS"),request.getParameter("GROUPID"));
// EbeeConstatnsF.get(EventbeeLogger.DEBUG,EventbeeLogger.LOGGER_MAIN,"entertopicinfo.jsp",null,"urlmap value is----------"+urlmap,null);
	if(urlmap!=null)
	{
	request.setAttribute("tabtype","unit");
	request.setAttribute("subtabtype","Communities");
	//request.setAttribute("tabtype",(String)urlmap.get("tabtype"));
	request.setAttribute("NavlinkNames",new String[]{(String)urlmap.get("navlink")});
	request.setAttribute("NavlinkURLs",new String[]{appname+(String)urlmap.get("backurl") });
	url=appname+(String)urlmap.get("backurl") ;
	}else
		url=appname+"/hub/clubview.jsp";
    		request.setAttribute("tabtype","unit");
	String forumname=(String)session.getAttribute(forumid+"_FORUMNAME");
	if(forumname==null||"".equals(forumname)){
    forumname=DbUtil.getVal("select forumname from forum where forumid="+forumid,null);
    session.setAttribute(forumid+"_FORUMNAME",forumname);
    }
        request.setAttribute("tasktitle",(("".equals(forumname)||forumname==null)?"Discussion Forum":forumname));
%>

	<table width="100%" align="center" class="taskblock">

		<% if("No".equals(enabledPosting)){%>
			<tr>
				<td align="center">
				Forum posting is limited to Community members. To become a <%=EventbeeStrings.getDisplayName(club_title,"Community")%>  member, visit <%=EventbeeStrings.getDisplayName(club_title,"Community")%>  page and
				click on Join <%=EventbeeStrings.getDisplayName(club_title,"Community")%>  link
				</td>
			</tr>
			<tr>
				<td align='center'><a href="<%=PageUtil.appendLinkWithGroup(url,(HashMap)request.getAttribute("REQMAP"))%>">Back to <%=EventbeeStrings.getDisplayName(club_title,"Community")%> Page</a></td>
			</tr>
		<%}else{%>
			<%--<form name="form" action="<%=appname%>/discussionforums/logic/insertDFMessage.jsp" method="POST"> --%>
			<form name="form" action="/discussionforums/logic/insertDFMessage" method="POST">
				  <input type="hidden" name="forumid" value="<%=forumid%>"/>
				  <input type="hidden" name="parentid" value="0"/>
				  <input type='hidden' name='topicid' value='0'/>
				  <input type='hidden' name='source' value='entertopicinfo.jsp'/>
				  <input type='hidden' name='authid' value='<%=authid%>' />
				  <%=com.eventbee.general.PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>
				<%for(int i=0;errorvector!=null && i<errorvector.size();i++){ %>
					<tr><td width="100%" colspan="2"><font class="error"><%=(String)errorvector.get(i)%></font></td></tr>
				<%}%>

				<table cellspacing="0" cellpadding="0" width="100%" class="taskblock">
					<tr>
						<td width="36%" class="inputlabel">Subject *</td>
						<td width="70%" class="inputvalue" ><input type="text" name="subject" value="<%=subject%>" size="52" /></td>
					</tr>
					<tr>
						<td class="inputlabel">Message*</td>
						<td class="inputvalue">
							<textarea name="reply" rows="10" cols="50" maxlength="10005" onfocus="this.value=(this.value==' ')?'':this.value" ><%=(reply==null || "".equals(reply.trim()))?" ":reply%></textarea>
						</td>
					</tr>
					<tr>

						<td colspan="2" align="center">
							
							<input type="submit" name="submit" value="Post"/>
							<input type="button" name="submit" value="Cancel" onclick="history.back()" />
						</td>
					</tr>
				</table>
			</form>
		<%}%>
	</table>
