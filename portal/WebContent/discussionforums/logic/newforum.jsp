<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.event.BeeletController" %>
<%@ page import="com.eventbee.forum.ForumDB" %>
<%@ page import="com.eventbee.clubmember.*" %>
<%@ page import="com.eventbee.event.ticketinfo.EventTicketDB" %>
<%!
String generateLinkName(String viewrole,String viewunitid,String sendrole,String sendunitid,String appname){

	String linkpath="";
	 if("Member".equalsIgnoreCase(viewrole)){
		linkpath="/"+appname+"/editprofiles/networkuserprofile.jsp";
	}
	/*else if("Manager".equalsIgnoreCase(viewrole)){
		if(viewunitid.equals(sendunitid)){
			linkpath="/"+appname+"/sms/unitmemberprofile.jsp";
		}else{
			linkpath="/"+appname+"/sms/guestmemberprofile";
		}
	}*/
	return linkpath;
    }
%>
<%
String beeletdisplay="OK";
String imagepath=null;
	String role=null,groupid=null,authid=null,grouptype=null,unitid=null;
	String entryunitid=(String)session.getAttribute("entryunitid");

	Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute("authData");
	if (authData!=null){
		 authid=authData.getUserID();
		 role=authData.getRoleName();
		 unitid=authData.getUnitID();
	}else{
		 role="Member";
		 authid=(String)session.getAttribute("transactionid");
		 unitid=(String)session.getAttribute("entryunitid");
	}
	String appname=null;
	//if("Manager".equalsIgnoreCase(role.trim()))
	//	appname="manager";
	//else
		appname="portal";

HashMap forums=(HashMap)request.getAttribute("ALLFORUMS");
HashMap grouphm=(HashMap)session.getAttribute("groupinfo");
String forumid=request.getParameter("forumid");

String clublogo=request.getParameter("clublogo");
if(forums!=null&&forums.size()>0){
HashMap forum_info=(HashMap)forums.get(forumid);
if(forum_info!=null && !(forum_info.isEmpty())){
String fstatus=GenUtil.getHMvalue(forum_info,"status");
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent(GenUtil.getHMvalue(forum_info,"forumname","Disscussion Forum"),request.getParameter("border"),request.getParameter("width"),true) );
String forumrsslink="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/p/"+clublogo+"/rss/forum?id="+forumid;
session.setAttribute(forumid+"_FORUMNAME",forum_info.get("forumname"));
%>
<script language='javascript' src='<%=EbeeConstantsF.get("js.webpath","http://www.beeport.com/home/js") %>/forum.js' >
function dummy(){}
</script>
<%
Vector forum_vector=null;
HashMap forum_map=(HashMap)request.getAttribute("FORUM_MAP");
if(forum_map!=null&&!(forum_map.isEmpty()))
forum_vector=(Vector)forum_map.get(forumid);

%>
	<table border='0' cellpadding='5' cellspacing='0' width='100%'>
        <form action="/<%=appname%>/discussionforums/msg_action" method="POST" name='form'>
	<%= com.eventbee.general.PageUtil.writeHiddenCore( grouphm )%>
	<input type="hidden" name="forumid" value="<%=forumid%>" />
	<input type="hidden" name="mode" value="single" />
	<input type='hidden' name='page' value='Topic' />

	<tr><td width='100%'>
		<table class="block" cellpadding='0' cellspacing='0' width='100%'>
		<tr>
			<td width='100%' >
				<%--<a href='/<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/discussionforums/logic/showForumTopics.jsp?forumid="+forumid,grouphm)  %>'><%=GenUtil.getHMvalue(forum_info,"forumname",null,true)%></a>:--%>
				<%=GenUtil.processTextHtml(GenUtil.getHMvalue(forum_info,"description","",true))%>

			</td>
		</tr>
		<!--tr><td><a href='/<%=appname+"/discussionforums/logic/rssshowForumTopics.jsp?forumid="+forumid %>'  target="_blank"><img src='/home/images/rss.gif' border='0' /></a-->
  		<tr><td  colspan='2' width='100%'><table width='100%'>
		<%
		String displaywidth="30%";
		%>
		<tr ><td><br /></td></tr>
		<tr>
		<td width='<%=displaywidth %>' >
		
		<%
		//if("13579".equals(  EbeeConstantsF.get("defaultunitid","13579")    ) ){
		
		%>
		<a target="_blank" href='http://add.my.yahoo.com/rss?url=<%=forumrsslink %>'  style="text-decoration:none" >
			<img src='/home/images/addtomyyahoo.gif' border='0' alt="Add to My Yahoo!" />
		</a>
		<%
		//}
		%>
		<a href='<%=forumrsslink%>'  ><img src='/home/images/rss.gif' border='0' /></a>
		<a href="javascript:popupwindow('<%=EbeeConstantsF.get("static.webpath","http://www.beeport.com/home/")%>/links/rsshelp.html','RssHelp','600','400')">
		<img src="<%=EbeeConstantsF.get("resources.image.webpath","http://www.beeport.com/home/images")%>/rsshelp.gif" border='0'></img></a>
		</td>
		<td ><%=forumrsslink %>	</td>
		
		</tr>
		</table></td></tr>
		
		<tr>
			<td align='right'>
				<% if(forum_vector!=null && forum_vector.size()>0){ %>
					<a href='/<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/mytasks/showForumTopics.jsp?forumid="+forumid,grouphm)%>'>View All (<%=forum_vector.size()%>)</a>

					<%}%>
			</td>
		</tr>

		</table>
	</td></tr>
	</table>
<table class="block" width="100%" cellpadding='0' cellspacing='0'>
<tr><td width='100%'>
	<table border="0" width="100%" cellpadding='0' cellspacing='0'>
	<tr><td colspan='3'></td></tr>
	<% if(forum_vector!=null && forum_vector.size()>0){ %>
	<tr  class='colheader'>
		<td align='left'><b>Topic</b></td>
		<td align='left'><b>Author</b></td>
		<td align='left'><b>Replies</b></td>
	</tr>
	<%}%>
	<%

	for(int i=0;forum_vector!=null && i<forum_vector.size() && i<10;i++){
		HashMap hm=(HashMap) forum_vector.elementAt(i);
		String base="";
		if(i%2==0)
			base="evenbase";
		else
			base="oddbase";
%>
	<tr class='<%=base%>'>
		<td align='left' valign='top'>
		<%=GenUtil.getHMvalue(hm,"postedat","",true)%><br/>
			<a href='/<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/discussionforums/logic/showTopicMessages.jsp?forumid="+forumid+"&amp;topicid="+GenUtil.getHMvalue(hm,"msgid",null,true) ,grouphm)  %>' >
				<%=GenUtil.getHMvalue(hm,"topicname",null,true)%>
			</a>
		</td>
		<td valign='top' align='left'>
			<table border="0" width="100%" cellspacing='0' cellpadding='0' valign='top'>
			<%	
				imagepath=GenUtil.getHMvalue(hm,"photourl");
				if(imagepath!=null && !("".equals(imagepath.trim()))){ 
				imagepath=EbeeConstantsF.get("profile.image.webpath","")+"/"+imagepath;
			%>
				<tr><td align='left'  valign='top'>
					<!--img src='<%--=imagepath--%>' border="0" width="60" height="60" align="absmiddle"/-->
				</td></tr>
			<% 
				}
			%>
				<tr valign='top'><td valign='top' align='left'>
			<%--
				if("Manager".equalsIgnoreCase((String)hm.get("role_name"))){ --%>
					<!--span class='error'>Moderator</span-->
				<%//}else{
					String linkpath=generateLinkName(role,unitid,"Member","13579",appname);
				%>
					<a href='<%=com.eventbee.general.PageUtil.appendLinkWithGroup(linkpath+"?userid="+GenUtil.getHMvalue(hm,"userid",""),grouphm)  %>'>
						<%=GenUtil.getHMvalue(hm,"username",null,true)%>
					</a>
				<%--}--%>
				</td></tr>
			</table>
		</td>
		<td align='left' valign='top' width='4%'>
			<a href='/<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/discussionforums/logic/showTopicMessages.jsp?forumid="+forumid+"&amp;topicid="+GenUtil.getHMvalue(hm,"msgid",null,true) ,grouphm)   %>' >
				<%=GenUtil.getHMvalue(hm,"no_of_replies","0")%>
			</a>
		</td>
	</tr>
	<%}%>
</table>
</td></tr>
	<% if("Yes".equalsIgnoreCase(fstatus)){ %>
	<tr><td align='center' >
		<a href='/<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/discussionforums/logic/entertopicinfo.jsp?isnew=yes&amp;forumid="+forumid ,grouphm) %>'>Add a Topic</a>
	</td></tr>
	<%}%>
</form>
</table>

</body>
<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
		}
}
%>
