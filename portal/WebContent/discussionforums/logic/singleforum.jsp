<%
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent("Discussion Forum",request.getParameter("border"),request.getParameter("width"),true) );
%>

<body>

<script language='javascript' src='<%=EbeeConstantsF.get("js.webpath","http://www.beeport.com/home/js") %>/forum.js' >
function dummy(){}
</script>

<%


	Vector v=null;
	if(foruminfo!=null && !(foruminfo.isEmpty())){
		v= getForumTopics(forumid);
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
			<td >
				<a href='/<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/mytasks/showForumTopics.jsp?forumid="+forumid,grouphm)  %>'><%=GenUtil.getHMvalue(foruminfo,"forumname",null,true)%></a>:
				<%=GenUtil.processTextHtml(GenUtil.getHMvalue(foruminfo,"description","",true))%>

			</td>
		</tr>
		<!--tr><td><a href='/<%=appname+"/discussionforums/logic/rssshowForumTopics.jsp?forumid="+forumid %>'  target="_blank"><img src='/home/images/rss.gif' border='0' /></a-->
		
		<%
			String forumrsslink="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/"+clublogo+"/rss/forum";
			
			
			String displaywidth=("13579".equals(  EbeeConstantsF.get("defaultunitid","13579")    ) )?"30%":"15%";
			

		%>

		<tr><td  colspan='2'><table>
		<tr ><td><br /></td></tr>
		<tr><td width='<%=displaywidth %>'>
		
		<%
		if("13579".equals(  EbeeConstantsF.get("defaultunitid","13579")    ) ){
		%>
		<a target="_blank" href='http://add.my.yahoo.com/rss?url=<%=forumrsslink %>'  style="text-decoration:none"  >
		<img src='/home/images/addtomyyahoo.gif' border='0' alt="Add to My Yahoo!" />
		</a>
		<%
		}
		%>
		<a href='/<%=appname+"/"+clublogo+"/rss/forum"%>'  ><img src='/home/images/rss.gif' border='0' /></a>
		<a href="javascript:popupwindow('<%=EbeeConstantsF.get("static.webpath","http://www.beeport.com/home/")%>/links/rsshelp.html','RssHelp','600','400')">
		<img src="<%=EbeeConstantsF.get("resources.image.webpath","http://www.beeport.com/home/images")%>/rsshelp.gif" border='0'></img></a>
		</td>
		<td><%=forumrsslink %>
		</td>

		</tr>
		</table></td></tr>
		
		
		<tr>
			<td align='right'>
				<% if(v!=null && v.size()>0){ %>
					<a href='/<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/mytasks/showForumTopics.jsp?forumid="+forumid,grouphm)%>'>View All (<%=v.size()%>)</a>

					<%}%>
			</td>
		</tr>

		</table>
	</td></tr>
	</table>
<% }%>
<table class="block" width="100%" cellpadding='0' cellspacing='0'>
<tr><td width='100%'>
	<table border="0" width="100%" cellpadding='0' cellspacing='0'>
	<tr><td colspan='3'></td></tr>
	<% if(v!=null && v.size()>0){ %>
	<tr  class='colheader'>
		<td align='left'><b>Topic</b></td>
		<td align='left'><b>Author</b></td>
		<td align='left'><b>Replies</b></td>
	</tr>
	<%}%>
	<%

	for(int i=0;v!=null && i<v.size() && i<10;i++){
		HashMap hm=(HashMap) v.elementAt(i);
		String base="";
		if(i%2==0)
			base="evenbase";
		else
			base="oddbase";
%>
	<tr class='<%=base%>'>
		<td align='left' valign='top'>
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
			<%
				if("Manager".equalsIgnoreCase((String)hm.get("role_name"))){ %>
					<span class='error'>Moderator</span>
				<%}else{
					String linkpath=generateLinkName(role,unitid,"Member",(String)hm.get("unitid"),appname);
				%>
					<a href='<%=com.eventbee.general.PageUtil.appendLinkWithGroup(linkpath+"?userid="+GenUtil.getHMvalue(hm,"userid",""),grouphm)  %>'>
						<%=GenUtil.getHMvalue(hm,"username",null,true)%>
					</a>
				<%}%>
				</td></tr>
			</table>
		</td>
		<td align='left' valign='top' width='4%'>
			<a href='/<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/discussionforums/logic/showTopicMessages.jsp?forumid="+forumid+"&amp;topicid="+GenUtil.getHMvalue(hm,"msgid",null,true) ,grouphm)   %>' >
				<%=GenUtil.getHMvalue(hm,"count_posts","0")%>
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
%>
