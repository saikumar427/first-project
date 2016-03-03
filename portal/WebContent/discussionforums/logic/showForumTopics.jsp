<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.pagenating.*" %>
<%@ page import="java.util.*,java.sql.*" %>
<%! 
     
    String generateLinkName(String viewrole,String viewunitid,String sendrole,String sendunitid,String appname){

	String linkpath="";
	if("Manager".equalsIgnoreCase(sendrole)){
		
	}else if("Member".equalsIgnoreCase(viewrole)){	
		linkpath="/"+appname+"/editprofiles/networkuserprofile.jsp";
	}else if("Manager".equalsIgnoreCase(viewrole)){
		if(viewunitid.equals(sendunitid)){
			linkpath="/"+appname+"/sms/unitmemberprofile.jsp";
		}else{
			linkpath="/"+appname+"/sms/guestmemberprofile.jsp";
		}	
	}	
	return linkpath;
    }		
     HashMap getForumInfo(String forumid){
       Connection con=null;	
       PreparedStatement pstmt=null;
       ResultSet rs=null;
       boolean conclose=false;	
	HashMap foruminfo=new HashMap();
       String GET_FORUM_INFO="select status,forumname,description,"
				+" to_char(createdat,'Month DD YYYY HH:MI AM') as createdat, "
			+" to_char(updatedat,'Month, DD YYYY HH:MI AM')as updatedat "
			+" from forum where forumid=?";

       try{
		 if(con==null){
			 con=EventbeeConnection.getReadConnection("forums");
			 conclose=true;
		 }
		 pstmt=con.prepareStatement(GET_FORUM_INFO);
  		 pstmt.setString(1,forumid);
		 rs=pstmt.executeQuery();
		 if(rs.next()){
			foruminfo.put("status",rs.getString("status"));
			foruminfo.put("forumname",rs.getString("forumname"));	
			foruminfo.put("createdat",rs.getString("createdat"));
			foruminfo.put("updatedat",rs.getString("updatedat"));
			foruminfo.put("description",rs.getString("description"));
		}
		rs=null;
		pstmt.close();
	}catch(Exception e){
		System.out.println("Exception Occured at showForumTopics.jsp at getForumInfo"+e);
		foruminfo=null;	
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(conclose){
				if(con!=null){con.close();con=null;}
			}
		}catch(Exception ex){}
	}
	return foruminfo;

     }	
	
      Vector getForumTopics(String forumid){

       Connection con=null;
       PreparedStatement pstmt=null;
       ResultSet rs=null;
       Vector v=new Vector();
       String GET_FORUM_TOPICS="select a.unit_id,ur.role_name,"
			+"(u.first_name || ' ' || u.last_name) as name,u.photourl,u.user_id, "
			+" f.reply,f.subject,f.parentid,f.msgid,"
			+" to_char(f.postedat,'Month DD YYYY HH:MI AM') as postedat "
			+" from forummessages f,user_profile u ,user_role ur,authentication a "
			+" where u.user_id=f.postedby  and forumid=? and  parentid=0 and a.user_id=u.user_id and " 
			+" ur.role_id in (a.role_id) order by msgid desc";
       try{
		 con=EventbeeConnection.getReadConnection("forums");
		 pstmt=con.prepareStatement(GET_FORUM_TOPICS);
  		 pstmt.setString(1,forumid);
		 rs=pstmt.executeQuery();
		 while(rs.next()){
			HashMap hm=new HashMap();
			hm.put("role_name",rs.getString("role_name"));
			hm.put("topicname",rs.getString("subject"));
			hm.put("description",rs.getString("reply"));
			hm.put("postedat",rs.getString("postedat"));
			hm.put("userid",rs.getString("user_id"));
			hm.put("unitid",rs.getString("unit_id"));
			hm.put("username",rs.getString("name"));
			hm.put("photourl",rs.getString("photourl"));
			hm.put("msgid",rs.getString("msgid"));
			getTopicStats(hm,con);
			v.add(hm);	
		}
		rs=null;
		pstmt.close();
	}catch(Exception e){
		System.out.println("Exception Occured at showForumTopics.jsp at getForumTopics"+e);
		v=null;
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(con!=null) {con.close();con=null;}
		}catch(Exception ex){}
	}
	return v;
    }
    HashMap getTopicStats(HashMap statmap,Connection con){

       PreparedStatement pstmt=null;
       ResultSet rs=null;
       boolean conclose=false;	
    String GET_FORUM_TOPIC_STAT="select count(*),to_char(max(postedat),'MM/DD/YYYY HH:MI AM')" 
				   +" as postedat from forummessages where topicid=?";
       try{
		 if(con==null){
			 con=EventbeeConnection.getReadConnection("forums");
			 conclose=true;
		 }
		 pstmt=con.prepareStatement(GET_FORUM_TOPIC_STAT);
  		 pstmt.setString(1,(String)statmap.get("msgid"));
		 rs=pstmt.executeQuery();
		 if(rs.next()){
			statmap.put("count_posts",rs.getString("count"));
			statmap.put("lastpostedat",rs.getString("postedat"));
		}
		rs=null;
		pstmt.close();
	}catch(Exception e){
		System.out.println("Exception Occured at showForumTopics.jsp at getTopicStats"+e);
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(conclose){
				if(con!=null){con.close();con=null;}
			}
		}catch(Exception ex){}
	}
	return statmap;
    } 
    	
%>
<jsp:include page='/stylesheets/CoreRequestMap.jsp' />
<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ShowForumTopics.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	String forumid=request.getParameter("forumid");
	String pageIndex=request.getParameter(".pageIndex");
	String groupid=request.getParameter("GROUPID");
	boolean moderator=false;	
	session.removeAttribute(forumid+"_LEVEL_MAP");
	int pageindex=1;
	boolean cont=true;
	String membertype=null;
	try{
		if(Integer.parseInt(forumid)<=0){
			throw new Exception();
		}
	}catch(Exception eno){
		System.out.println("Exception occured at converting forum no:"+eno);
		cont=false;
	}
	try{
		pageindex=Integer.parseInt(pageIndex);
	}catch(Exception e){
		pageindex=1;
	}
	
	String authid=null,role=null,unitid=null;
	String imagepath=null;
	String appname=null;
	
	HashMap hmParent=new HashMap();
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if (authData!=null){
		 authid=authData.getUserID();
		 role=authData.getRoleName();
		 unitid=authData.getUnitID();
		 if("Manager".equals(role)){
		 	moderator=true;
		 }else{
		 	moderator=("HUBMGR".equalsIgnoreCase(HubMaster.getUsersHubStatus(authid,groupid)));
		 }
	}else{
		 role="Member";
	}
	
	if("Manager".equalsIgnoreCase(role.trim()))
		appname="manager";
	else
		appname="portal";
		
	HashMap foruminfo=getForumInfo(forumid);
	Vector v= getForumTopics(forumid);
	boolean topics=false;
	if(v!=null && v.size()>0)  topics=true;
	List L=null;
	boolean redirect=false;
	pageNating pageNav=new pageNating();
	pageNav.setLink(PageUtil.appendLinkWithGroup("/"+appname+"/guesttasks/showForumTopics.jsp?forumid="+forumid,(HashMap)request.getAttribute("REQMAP")));
	if(topics ){
		try{
			L=pageNav.getPagenatingElements(0,pageindex,50,v);
		}catch(pageNatingException e){
			System.out.println(e.toString());
			redirect=true;
		}
	}	
	if(redirect){
		response.sendRedirect(com.eventbee.general.PageUtil.appendLinkWithGroup("/"+appname+"/mytasks/forumerror.jsp",(HashMap)request.getAttribute("REQMAP")));
	}else{	
%>

<% 
    String navName=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{groupid});
    String forumname=(String)session.getAttribute(forumid+"_FORUMNAME");
    if(forumname==null||"".equals(forumname))
    forumname=GenUtil.getHMvalue(foruminfo,"forumname","");
    
    HashMap urlmap=PageUtil.getPageNameAndUrl(request.getParameter("PS"),request.getParameter("GROUPID"));
	if(urlmap!=null)
	{
	
	request.setAttribute("NavlinkNames",new String[]{(String)urlmap.get("navlink")});
	String navlinkurl="/portal/hub/clubview.jsp?GROUPID="+request.getParameter("GROUPID");
	request.setAttribute("NavlinkURLs",new String[]{navlinkurl });
	    }
%>		

<% if(cont){ 


if(authid==null){%>
<form action="/<%=appname%>/auth/listauth.jsp" method="POST" name='form'>
<input type="hidden" name="purpose" value="FORUM_ADD_TOPIC" />

<%}
else
%>
<form action="/mytasks/entertopicinfo.jsp" method="POST" name='form'>




<script language='javascript' src='<%=EbeeConstantsF.get("js.webpath","http://www.beeport.com/home/js") %>/forum.js' >
function dummy(){}
</script>
<%= com.eventbee.general.PageUtil.writeHiddenCore( (HashMap)request.getAttribute("REQMAP") )%>
<input type="hidden" name="forumid" value="<%=forumid%>" />
<input type="hidden" name="mode" value="single" />
<input type='hidden' name='page' value='Topic' />
<input type='hidden' name='isnew' value='yes' />

<%
	String clublogo="none";
if("13579".equals(EbeeConstantsF.get("defaultunitid","13579")))
clublogo=DbUtil.getVal("select clublogo from clubinfo where clubid=?",new String [] {groupid});
else
if("13578".equals(EbeeConstantsF.get("defaultunitid","13579")))
clublogo=DbUtil.getVal("select unit_code from org_unit where unit_id=(select unitid from clubinfo where clubid= ?)",new String [] {groupid} );

	String forumrsslink="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/p/"+clublogo+"/rss/forum?id="+request.getParameter("forumid");
	String fstatus=GenUtil.getHMvalue(foruminfo,"status");
	if(foruminfo!=null && !(foruminfo.isEmpty())){
%>
	<table  width="100%" cellpadding='2' cellspacing='0'>
	<!--tr>
		<td >
		<%=GenUtil.textToHtml(GenUtil.getHMvalue(foruminfo,"description","",true),true)%></td>
	</tr-->
	<%
	String displaywidth=("13579".equals(  EbeeConstantsF.get("defaultunitid","13579")    ) )?"30%":"15%";
	%>
	<!--tr><td  colspan='2'><table>
		<tr ><td><br /></td></tr>
		<tr><td width='<%=displaywidth %>'>
		<%
		if("13579".equals(  EbeeConstantsF.get("defaultunitid","13579")    ) ){
		%>
		<a target="_blank" href='http://add.my.yahoo.com/rss?url=<%=forumrsslink %>' style="text-decoration:none"  >
		<img src='/home/images/addtomyyahoo.gif' border='0' alt="Add to My Yahoo!" />
		</a>
		<%
		}
		%>
		<a href='/<%="p/"+clublogo+"/rss/forum?id="+request.getParameter("forumid")%>'  ><img src='/home/images/rss.gif' border='0' /></a>
		<a href="javascript:popupwindow('<%=EbeeConstantsF.get("static.webpath","http://www.beeport.com/home/")%>/links/rsshelp.html','RssHelp','600','400')">
		<img src="<%=EbeeConstantsF.get("resources.image.webpath","http://www.beeport.com/home/images")%>/rsshelp.gif" border='0'></img></a>
		</td>
		<td><%=forumrsslink %>
		</td>

		</tr>-->
		</table></td></tr>

			<tr></tr>
	</table>
<% }%>
<table border="0" height="20">
<tr><td></td></tr>	
</table>
<%
	
%>
<table class="block" width="800">
<tr><td>
<table border="0" width="100%">
<tr>
<td colspan='5'>
<table border='0' width='100%'>
<tr>

	<% if(moderator){ %>
	<td align='left'>
		<%if(topics){%>
		<input type='submit' name="submit" value="Delete"/>
		
		<%}%>
	</td>
	<% } %>
<td align='center'>
	<%if(topics){%>
		<%=pageNav.pageNavigator().replaceAll("&","&amp;")%>
	<%}%>	
	</td>
<td align='right'>
	
	<% if("Yes".equalsIgnoreCase(fstatus)){ %>
		<input type="submit" name="submit" value="Add Topic" />
	<%}%>
	 
</td>
	

</tr>
<tr><td colspan='3'></td></tr>
</table>
</td>
</tr>
<% if(L!=null){ %>
<tr  class='colheader'>
	<% if(moderator){ %>
	<td align='center' >
		<input type='checkbox' name='topics' Onclick="javascript:selectAll(this)"/>
	</td>	
	<% } %>
<td align='center'><b>Topics</b></td>
<td align='center'><b>Replies</b></td>
<td align='center' width='15%'><b>Author</b></td>
<td align='center'><b>Last Reply Posted On</b></td>
</tr>
<%}%>
<%
	for(int i=0;L!=null && i<L.size();i++){
		HashMap hm=(HashMap) L.get(i); 
		String base="";
		if(i%2==0)
			base="evenbase";
		else
			base="oddbase";
%>
	<tr class='<%=base%>'>
			<% if(moderator){ %>
			<td align='center' valign='top'>	
				<input type='checkbox' name="delmsgid" value='<%=GenUtil.getHMvalue(hm,"msgid")%>'/>
			
			</td>	
			<% } %>	
		
		<td align='left' valign='top' width='60%'>
			<b><%=GenUtil.getHMvalue(hm,"postedat",null)%></b><br/>
			<a href='<%=com.eventbee.general.PageUtil.appendLinkWithGroup("/"+appname+"/guesttasks/showTopicMessages.jsp?forumid="+forumid+"&amp;topicid="+GenUtil.getHMvalue(hm,"msgid",null,true),(HashMap)request.getAttribute("REQMAP"))%>' >
				<%=GenUtil.getHMvalue(hm,"topicname",null,true)%>
			</a>
			
		</td>
		<td align='center' valign='top' width='4%'><%=GenUtil.getHMvalue(hm,"count_posts","0")%></td>
		<td valign='top' width='15%'>
		<table border="0" width="100%" cellspacing='0' cellpadding='0' valign='top'>
		<tr><td height='10'></td></tr>
		<%	
			imagepath=GenUtil.getHMvalue(hm,"photourl");
			if(imagepath!=null && !("".equals(imagepath.trim()))){ 
			imagepath=EbeeConstantsF.get("profile.image.webpath","")+"/"+imagepath;
		%>
			<tr><td align='center'  valign='top'>
			<img src='<%=imagepath%>' border="0" width="60" height="60" align="absmiddle" />
			</td></tr>
			<% 
				}
			%>
				<tr valign='top'><td valign='top' align='center'>	
			<%
				if("Manager".equalsIgnoreCase((String)hm.get("role_name"))){ %>
				<span class='error'>Moderator</span>
			<%}else{
				String linkpath=generateLinkName(role,unitid,"Member",(String)hm.get("unitid"),appname);
			
				membertype=DbUtil.getVal("select value from community_config_settings where key='MEMBER_ACCOUNT_TYPE' and clubid=? ",new String [] {groupid});
				if("EXCLUSIVE".equals(membertype)){
			%>
			<%=GenUtil.getHMvalue(hm,"username",null,true)%>
			<%	}else{%>
				<a href='<%=com.eventbee.general.PageUtil.appendLinkWithGroup(linkpath+"?userid="+GenUtil.getHMvalue(hm,"userid",""),(HashMap)request.getAttribute("REQMAP"))%>'>
					<%=GenUtil.getHMvalue(hm,"username",null,true)%>
				</a>
			<%	}
			
			}%>
		</td></tr>

		<tr><td height='10'></td></tr>
		</table>
		</td>
		<td align='left' valign='top'><%=GenUtil.getHMvalue(hm,"lastpostedat",null)%></td>
		<input type='hidden' name='msgid' value='<%=GenUtil.getHMvalue(hm,"msgid")%>' />
	</tr>
<%}%>
</table>
</td></tr>
</table>
</form>
<% } %>

<%}%>

