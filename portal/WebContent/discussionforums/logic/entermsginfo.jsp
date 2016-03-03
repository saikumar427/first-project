<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>

<%!
public String getDBValue(String query,String[] params,String defval){
	String val=DbUtil.getVal(query,params);
	if(val==null || "".equals(val.trim())) val=defval;
	return val;
}
boolean isValidId(String id){
	if(id==null || "null".equals(id) || "".equals(id.trim()))
		return false;
	else
		return true;
}
%>
<jsp:include page='/stylesheets/CoreRequestMap.jsp' />
<%

           
	final String posting_key="forumposting.enabled.level";
	String enabledPosting="No";
	String postingLevel=EbeeConstantsF.get(posting_key,"UNIT");
	String club_title=EbeeConstantsF.get("club.label","Bee Hive");
	String authid=null,subject=null,reply=null,loginurl=null;	
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	String forumid="",msgid="",topicid="",parentThreadid="",oldmsgid="",grouptype="",eunitid="",groupid="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate) session.getAttribute("authData");
	Vector errorvector=null;
	HashMap fmsghash=null;
	
	forumid=request.getParameter("forumid");

	if("yes".equalsIgnoreCase(request.getParameter("isnew")) || forumid!=null){
		msgid=request.getParameter("msgid");
		topicid=request.getParameter("topicid");
		parentThreadid=request.getParameter("oldparentid");
		oldmsgid=request.getParameter("oldmsgid");
		subject=request.getParameter("subject");
		grouptype=request.getParameter("GROUPTYPE");
		//eunitid=request.getParameter("UNITID");
		groupid=request.getParameter("GROUPID");
		if(subject==null || "".equals(subject.trim())){	
			subject=DbUtil.getVal("select subject from forummessages where msgid=?",new String[]{msgid});
		}
		if(subject!=null)
			if(!subject.startsWith("Re: "))
				subject="Re: "+subject;
				

	}else{
		errorvector=(Vector)session.getAttribute("errorvector");
		fmsghash=(HashMap)session.getAttribute("fmsghash");
		if(fmsghash!=null && !(fmsghash.isEmpty())){				
			subject=(String)fmsghash.get("subject");
			reply=(String)fmsghash.get("reply");
			forumid=GenUtil.getHMvalue(fmsghash,"forumid",forumid);		
			msgid=GenUtil.getHMvalue(fmsghash,"parentid");
			topicid=GenUtil.getHMvalue(fmsghash,"topicid");
			parentThreadid=GenUtil.getHMvalue(fmsghash,"parentThreadid");
			oldmsgid=GenUtil.getHMvalue(fmsghash,"oldmsgid");
			groupid=GenUtil.getHMvalue(fmsghash,"GROUPID");
			eunitid=GenUtil.getHMvalue(fmsghash,"13579");
			grouptype=GenUtil.getHMvalue(fmsghash,"GROUPTYPE");
		}
	}	
	
	String ClubUrl="/portal/hub/clubview.jsp?GROUPID="+groupid;
		
	String HubJoinUrl="/portal/guesttasks/hubjoin.jsp?GROUPID="+groupid;
		
	
	boolean cont=true;
	
		
        if (authData!=null){      
      			 authid=authData.getUserID();
			 postingLevel=getDBValue("select value from config where name=? and config_id in (select config_id from clubinfo where clubid=?)",new String[]{posting_key,groupid},postingLevel);
			 if("UNIT".equalsIgnoreCase(postingLevel))
			 	enabledPosting="Yes";
			 else if("CLUB".equalsIgnoreCase(postingLevel)){
			 	enabledPosting=getDBValue("select 'Yes' as member from club_member where userid=? and clubid=? and status in (?)",new String[]{authid,groupid,"ACTIVE"},"No"); 
			}
      			 
	}else{
	     String isnew=("yes".equalsIgnoreCase(request.getParameter("isnew")))?"&isnew="+request.getParameter("isnew")+"":"";		
	      String url=appname+"/mytasks/entermsginfo.jsp?forumid="+forumid+"&GROUPID="+groupid;
		if(isValidId(topicid)) 	url+="&topicid="+topicid;	
		if(isValidId(msgid))    url+="&msgid="+msgid;
		if(isValidId(parentThreadid)) url+="&oldparentid="+parentThreadid;
		if(isValidId(oldmsgid))	url+="&oldmsgid="+oldmsgid;
		url=PageUtil.appendLinkWithGroup(url+isnew,(HashMap) request.getAttribute("REQMAP"));
		url=url.replaceAll("&","~");
		if("/portal".equals(appname)){
			cont=false;
			//response.sendRedirect(response.encodeRedirectURL(PageUtil.appendLinkWithGroup(appname+"/auth/listauth.jsp?purpose=FORUM_REPLY_TOPIC&redirecturl="+url+"&GROUPID="+request.getParameter("GROUPID"),(HashMap) request.getAttribute("REQMAP"))));
			GenUtil.Redirect(response,"/portal/auth/listauth.jsp?purpose=FORUM_REPLY_TOPIC&redirecturl="+url+"&GROUPID="+request.getParameter("GROUPID"));
		}
	}	
%>
<% 

if(cont){%>
<%   String forumname=(String)session.getAttribute(forumid+"_FORUMNAME");
    if(forumname==null||"".equals(forumname)){
    forumname=DbUtil.getVal("select forumname from forum where forumid="+forumid,null);
    session.setAttribute(forumid+"_FORUMNAME",forumname);
    }
     String navName=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{request.getParameter("GROUPID")});
    request.setAttribute("tasktitle",forumname);
    HashMap urlmap=PageUtil.getPageNameAndUrl(request.getParameter("PS"),request.getParameter("GROUPID"));
	if(urlmap!=null)
	{
	request.setAttribute("tabtype","unit");
	//request.setAttribute("tabtype",(String)urlmap.get("tabtype"));
	request.setAttribute("subtabtype","Communities");
	request.setAttribute("NavlinkNames",new String[]{(String)urlmap.get("navlink")});
	request.setAttribute("NavlinkURLs",new String[]{appname+(String)urlmap.get("backurl") });
	}
    else
    		request.setAttribute("tabtype","unit");
%>
	<script language="javascript" src="<%=EbeeConstantsF.get("js.webpath","http://www.beeport.com/home/js") %>/forum.js">
		function dummy(){}
	</script>
	<table width="100%" align="center">
		<% if("No".equals(enabledPosting)){
		
		
		%>
			<tr>
				<td align="center">Posting a reply is denied to outside <%=club_title%> members</td>
			</tr>
			<tr>
				<td align='center'><a href="<%=ClubUrl%>">Back to <%=club_title%> Page</a></td>
			</tr><tr>				
				<td align='center'><a href="<%=HubJoinUrl%>">Join Community</a></td>
			</tr>
			
		<%}else{
		
		%>	
		<form name="form" action="<%=appname%>/discussionforums/logic/insertDFMessage.jsp" method="POST" >
			<%=com.eventbee.general.PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>
			<%for(int i=0;errorvector!=null && i<errorvector.size();i++){ %>
				<tr><td width="100%" colspan="2"><font class="error"><%=(String)errorvector.get(i)%></font></td></tr>
			<%}%>
			<table width="100%" align="center" class="block" cellspacing="0" cellpadding="0">
				<tr>
					<td width="36%" class="inputlabel">Subject *</td>
					<td width="70%" class="inputdata"><input type="text" name="subject" value="<%=subject%>" size="52"/></td>
				</tr>	
				<tr>
					<td class="inputlabel">Reply *</td>
					<td class="inputdata">
						<textarea name="reply" rows="10" cols="50"  onfocus="this.value=(this.value==' ')?'':this.value"><%=(reply==null || "".equals(reply.trim()))?" ":reply%></textarea>
					</td>
				</tr>
				<tr><td colspan="2" width="100%" align="center">
					<input type="hidden" name="parentThreadid" value="<%=parentThreadid%>"/>
					<input type="hidden" name="oldmsgid" value="<%=oldmsgid%>"/>
					<input type="hidden" name="parentid" value="<%=msgid%>"/>
					<input type="hidden" name="forumid" value="<%=forumid%>"/>
					<input type="hidden" name="authid" value="<%=authid%>"/>
					<input type="hidden" name="ispreview" />
					<input type='hidden' name='source' value='entermsginfo.jsp'/>
					<input type='hidden' name='topicid' value='<%=topicid%>'/>
					<input type='button' name='Back'   value=' Back ' Onclick="Javascript:history.back()" />  
					<input type="submit" name="submit" value="Preview" OnClick="javascript:document.form.ispreview.value='Yes'" />
					<input type="submit" name="submit" value="Post"  OnClick="javascript:document.form.ispreview.value='No'"/>
				</td></tr>
			</table>	
		</form>	
		<%}%>
	</table>
<%}%>	
