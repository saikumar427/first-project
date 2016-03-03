<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.hub.*" %>

<%! 
	
	int totalReplies(Vector v,int i,int total){
		if(v.elementAt(i) instanceof HashMap){
			HashMap hm=(HashMap) v.elementAt(i);
			if(hm!=null && !(hm.isEmpty())){
				total++;
			}
		}else if(v.elementAt(i) instanceof Vector){
			Vector v1=(Vector) v.elementAt(i);
			for(int j=0;j<v1.size();j++){
				total=totalReplies(v1,j,total);
			}
		}
		return total;
	}
	int noOfPages(int total,int noperpage){
		int k=0;
		if(total%noperpage!=0)
		k=1;
		return (int) (java.lang.Math.floor(total/noperpage)+k);
	}
Vector getForumTopicMessages(String msgid,String forumid,String topic){
	Connection con=null;
	return getForumTopicMessages(msgid,forumid,topic,con);
}	
    Vector getForumTopicMessages(String msgid,String forumid,String topic,Connection con){
     
       PreparedStatement pstmt=null;
       ResultSet rs=null;
       Vector v=new Vector(); 
       boolean conclose=false;
       String Q=" and parentid=? ";
       if("0".equals(topic))	
       		Q=" and (msgid=? and parentid=0) ";
       String GET_FORUM_TOPICS="select a.unit_id,ur.role_name,"
			+"(u.first_name || ' ' || u.last_name) as name,getMemberMainPhoto(a.user_id||'') as photourl,u.user_id, "
			+" f.reply,f.subject,f.parentid,f.msgid,"
			+" to_char(f.postedat,'Month DD YYYY HH:MI AM') as postedat, a.acct_status "
			+" from forummessages f,user_profile u ,user_role ur,authentication a "
			+" where u.user_id=f.postedby and a.user_id=u.user_id and forumid=? "
			+Q
			+" and ur.role_id in (a.role_id ) order by msgid ";
       try{
       		if(con==null){
		 	con=EventbeeConnection.getReadConnection("forums");
			conclose=true;
		 }
		 pstmt=con.prepareStatement(GET_FORUM_TOPICS);
		
		 pstmt.setString(1,forumid);
		 pstmt.setString(2,msgid);
		
		 rs=pstmt.executeQuery();
		 while(rs.next()){
		 	HashMap hm=new HashMap();
			hm.put("role_name",rs.getString("role_name"));
			hm.put("msgsubject",rs.getString("subject"));
			hm.put("msgreply",rs.getString("reply"));
			hm.put("postedat",rs.getString("postedat"));
			hm.put("userid",rs.getString("user_id"));
			hm.put("unitid",rs.getString("unit_id"));
			hm.put("username",rs.getString("name"));
			hm.put("photourl",rs.getString("photourl"));
			hm.put("msgid",rs.getString("msgid"));
			String rp=getReplyCount(rs.getString("msgid"),con);
			hm.put("replycount",rp);
			hm.put("acct_status",rs.getString("acct_status"));
			v.add(hm);
			
			if(Integer.parseInt(rp)>0){
		 			v.add(getForumTopicMessages(rs.getString("msgid"),forumid,null,con));
			}
		}
		rs=null;
		pstmt.close();
	}catch(Exception e){
		System.out.println("Exception Occured at showForumTopics.jsp at getForumTopics"+e);
		v=null;
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(conclose){
				if(con!=null) {con.close();con=null;}
			}
		}catch(Exception ex){}
	}
	return v;
    }
    
    String getHMvalue(HashMap hm,String key,String defval){
    	return GenUtil.getHMvalue(hm,key,defval,true);
     }
		
    String generateLinkName(String viewrole,String viewunitid,String sendrole,String sendunitid,String appname){

	String linkpath="";
	if("Manager".equalsIgnoreCase(sendrole)){
		
	}else if("Member".equalsIgnoreCase(viewrole)){	
		linkpath=""+appname+"/editprofiles/networkuserprofile.jsp";
	}else if("Manager".equalsIgnoreCase(viewrole)){
		if(viewunitid.equals(sendunitid)){
			linkpath=""+appname+"/sms/unitmemberprofile.jsp";
		}else{
			linkpath=""+appname+"/sms/guestmemberprofile";
		}	
	}	
	return linkpath;
    }		
     HashMap getForumTopicInfo(String parentid,String msgid,String forumid){
       Connection con=null;	
       PreparedStatement pstmt=null;
       ResultSet rs=null;
       boolean conclose=false;	
	HashMap topicinfo=new HashMap();
       String GET_FORUM_TOPIC_INFO="select forumname,status,subject,reply,description,"
				+"to_char(postedat,'Month DD YYYY HH:MI AM') as postedat "
				+" from forummessages,forum f "
				+" where msgid=? and f.forumid=?";

       try{
		 if(con==null){
			 con=EventbeeConnection.getReadConnection("forums");
			 conclose=true;
		 }
		 pstmt=con.prepareStatement(GET_FORUM_TOPIC_INFO);
  		 
		 pstmt.setString(1,msgid);
		 pstmt.setString(2,forumid);
		 rs=pstmt.executeQuery();
		 if(rs.next()){
			topicinfo.put("status",rs.getString("status"));
			topicinfo.put("forumname",rs.getString("forumname"));
			topicinfo.put("description",rs.getString("description"));
			topicinfo.put("postedat",rs.getString("postedat"));
			topicinfo.put("topicname",rs.getString("subject"));
			topicinfo.put("topicdesc",rs.getString("reply"));
		}
		rs=null;
		pstmt.close();
	}catch(Exception e){
		System.out.println("Exception Occured at showTopicMessages.jsp at getForumTopicInfo "+e);
		topicinfo=null;	
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(conclose){
				if(con!=null){con.close();con=null;}
			}
		}catch(Exception ex){}
	}
	return topicinfo;

     }	
     String getReplyCount(String msgid,Connection con){
       PreparedStatement pstmt=null;
       ResultSet rs=null;
       boolean conclose=false;	
	String replycount="0";
       String GET_ReplyCount="select count(*) from forummessages where parentid=?";

       try{
		 if(con==null){
			 con=EventbeeConnection.getReadConnection("forums");
			 conclose=true;
		 }
		 pstmt=con.prepareStatement(GET_ReplyCount);
  		 pstmt.setString(1,msgid);
		 rs=pstmt.executeQuery();
		 if(rs.next()){
			replycount=rs.getString("count");
		}
		rs=null;
		pstmt.close();
	}catch(Exception e){
		System.out.println("Exception Occured at showTopicMessages.jsp at getReplyCount"+e);
		replycount=null;	
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(conclose){
				if(con!=null){con.close();con=null;}
			}
		}catch(Exception ex){}
	}
	
	return replycount;

     }	
   // String generateHTML(Vector v,int i,int level,HashMap rowcount,String role,String unitid,String appname,String forumid,String topicid,String pagecount,String perpage,String parentThreadid,String oldparent,HashMap levels,String msgid,String authid,HashMap reqmap,boolean moderator,String fstatus){
       String generateHTML(Vector v,int i,int level,HashMap rowcount,String role,String unitid,String appname,String forumid,String topicid,String parentThreadid,String oldparent,HashMap levels,String msgid,String authid,HashMap reqmap,boolean moderator,String fstatus,String groupid){ 	
		StringBuffer sb=new StringBuffer(" ");
		
		int rows=0,rowk=1,nomsg=20;
	/*	int pagek=1;
		try{
			pagek=Integer.parseInt(pagecount.trim());
		}catch(Exception e1){pagek=1;}
		try{
			rowk=Integer.parseInt(((String)rowcount.get("pagek")).trim());
		}catch(Exception e2){rowk=1;}
		try{
			nomsg=Integer.parseInt(perpage.trim());
		}catch(Exception e3){nomsg=20;}
		
		System.out.print("nomsg   :"+nomsg);
		System.out.print("   rowk in HashMap is:"+rowk); */
		
		if(v.elementAt(i) instanceof HashMap){
			rowcount.put("pagek",""+(rowk+1));
		/*	if(rowk>((pagek-1)*nomsg) && rowk<=(pagek*nomsg)){
				
			}else{
				System.out.println("Not displayed for HashMap rowk :"+rowk);
				return sb.toString();
			}  */
			HashMap hm=(HashMap) v.elementAt(i);
			String base="";
			try{
				rows=Integer.parseInt(((String)rowcount.get("rows")).trim());
			}catch(Exception e){ rows=0;}	
			if(rows%2==0)
				base="evenbase";
			else
				base="oddbase";  
			
			sb.append("<tr class='"+base+"'>");
			if(moderator){
				sb.append("<td align='center' valign='top' >");
				     sb.append("<table border='0' cellpadding='0' cellspacing='0'>");
			 			sb.append("<tr>");
						sb.append("<td><input type='checkbox' name='delmsgid' value='"+getHMvalue(hm,"msgid","")+"'/></td>");
						sb.append("</tr>");
						/*	sb.append("<tr>");   // Numbering purpose like #1 #2  #3 .....
						sb.append("<td align='center'><B>#"+(rows+1)+"</B></td>");
						sb.append("</tr>");  */
				     sb.append("</table>");
				sb.append("</td>");
			}
		         
			
			sb.append("<td align='left' valign='top'>");
			sb.append("<table width='100%' border='0' bordercolor='blue' cellpadding='0' cellspacing='0'>");
			if(rows==0){
				
				if(!topicid.equals(parentThreadid)){
				String prelink=appname+"/guesttasks/showTopicMessages.jsp?GROUPID="+groupid+"&forumid="+forumid+"&amp;topicid="+topicid;
				String levelid=getHMvalue(levels,msgid,topicid);	
				if(!levelid.equals(topicid)){
					prelink+="&amp;msgid="+levelid;
				}
				sb.append("<tr><td colspan='3'><a href='"+com.eventbee.general.PageUtil.appendLinkWithGroup(prelink,reqmap)+"'>One Level Up</a></td></tr>");
				}
			}
			sb.append("<tr>");
			if(level!=1){ 
				sb.append("<td width='"+((level*20)+5)+"'></td>");
			}
			sb.append("<td valign='top'>");
		
			sb.append("<table border='0' width='100%' cellspacing='0' cellpadding='0'>");
			sb.append("<tr valign='top'>");
			sb.append("<td valign='top' ><b>"+getHMvalue(hm,"postedat",null)+"</b></td>");
			 if(!("0".equals(getHMvalue(hm,"replycount","0")))){ 
				sb.append("<td valign='top' align='right'>");
			/*	sb.append("<a href='"+appname+"/discussionforums/showTopicMessagesinfo?GROUPID="+groupid+"&forumid="+forumid+"&amp;topicid="+topicid+"&amp;msgid="+getHMvalue(hm,"msgid",null)+"'>");
				sb.append("Reply Threads ("+getHMvalue(hm,"replycount","0")+")");   
				sb.append("</a>"); */
				sb.append("</td>");
			} 
			sb.append("</tr>");
			sb.append("<tr valign='top'><td valign='top' colspan='3'>");
			sb.append(getHMvalue(hm,"msgsubject",null));
			sb.append("</td></tr>");
			sb.append("<tr><td colspan='3'><br/></td></tr>");
			sb.append("<tr valign='top'>");
				sb.append("<td valign='top' colspan='3'>");
					sb.append("<table border='0' align='left' width='100%' cellspacing='0' cellpadding='0' height='50'>");
					sb.append("<tr valign='top'>");
						sb.append("<td valign='top' align='left'>");
							String topicbody=GenUtil.getHMvalue(hm,"msgreply",null);
							try{
									topicbody=GenUtil.processTextHtml(topicbody);
								}catch(Exception e){System.out.println("forum: gererateHTML():"+e);}
							sb.append(topicbody);
						sb.append("</td>");
					sb.append("</tr>");
					if(level==5 && !("0".equals(getHMvalue(hm,"replycount","0")))){
						sb.append("<tr>");
						sb.append("<td align='right' valign='center'>");
							sb.append("<a href='"+com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/guesttasks/showTopicMessages.jsp?GROUPID="+groupid+"&forumid="+forumid+"&amp;topicid="+topicid+"&amp;msgid="+getHMvalue(hm,"msgid",null)+"&amp;parentThreadid="+parentThreadid,reqmap)+"'>");
								//sb.append("More Threads ("+getHMvalue(hm,"replycount","0")+")");
								sb.append("More Messages");
								long l=0;
								try{
									l=Integer.parseInt(getHMvalue(hm,"msgid",null));
								}catch(Exception e){l=0;}
								levels.put(""+l,parentThreadid);
							sb.append("</a>");	
						sb.append("</td>");
						sb.append("</tr>");
					}
					sb.append("</table>");
				sb.append("</td>");
			sb.append("</tr>");
			sb.append("<tr><td height='2'></td></tr>");
			sb.append("</table>");
		sb.append("</td>");	
		sb.append("</tr>");	
		sb.append("</table>");	
		sb.append("</td>");
		sb.append("<td align='center' valign='top'>");
			sb.append("<table border='0' width='100%' cellspacing='0' cellpadding='0'>");
			sb.append("<tr><td height='10'></td></tr>");
			String imagepath=getHMvalue(hm,"photourl",null);
			if(imagepath!=null && !("".equals(imagepath.trim()))){ 
				
				imagepath=EbeeConstantsF.get("smallthumbnail.photo.image.webpath","")+"/"+imagepath;
				sb.append("<tr valign='top'><td align='center' valign='center'>");
				sb.append("<img src='"+imagepath+"' border='0' width='60' height='60' align='absmiddle' />");
				sb.append("</td></tr>");
			}
			sb.append("<tr valign='top'><td align='center' valign='top'>");	
			if("Manager".equalsIgnoreCase((String)hm.get("role_name"))){ 
				sb.append("<span class='error'>Moderator</span>");
			}else{
				String linkpath=generateLinkName(role,unitid,"Member",(String)hm.get("unitid"),appname);
				System.out.println("groupid");
				String membertype=DbUtil.getVal("select value from community_config_settings where key='AUTHOR_LINK_SHOW_IN_FORUM_TOPICS' and clubid=? ",new String [] {groupid});
				String acct_status=getHMvalue(hm,"acct_status",null);
				if("N".equals(membertype))
					sb.append(getHMvalue(hm,"username",null));
				else{
					sb.append("<a href='"+com.eventbee.general.PageUtil.appendLinkWithGroup(linkpath+"?userid="+getHMvalue(hm,"userid",""),reqmap)+"'>");
					sb.append(getHMvalue(hm,"username",null));
					sb.append("</a>");
				}
			}
			sb.append("</td></tr>");
			sb.append("<tr><td valign='top'>");
			sb.append("<input type='submit' name='submit' value='Send Message' OnClick=\"javascript:msgto.value='"+getHMvalue(hm,"userid","")+"';to.value='"+getHMvalue(hm,"username",null)+"' \" />");
	                sb.append("</td></tr>");
			sb.append("<tr><td height='10'></td></tr>");
			sb.append("</table>");
			sb.append("</td>");
		sb.append("<td align='center' valign='top'>");
				sb.append("<table border='0' cellpadding='2' cellspacing='2' width='100%' valign='top'>");
					if("Yes".equalsIgnoreCase(fstatus)){ 
						sb.append("<tr><td valign='top'>");
							sb.append("<input value='Post Reply' type='submit' name='submit' onclick=\"javascript:changeMsgid("+getHMvalue(hm,"msgid",null)+")\"/>");
						sb.append("</td></tr>");
					}	
					/* 
					sb.append("<tr><td valign='top'>");
					sb.append("<input type='submit' name='submit' value='Send Message' OnClick=\"javascript:msgto.value='"+getHMvalue(hm,"userid","")+"';to.value='"+getHMvalue(hm,"username",null)+"' \" />");
					sb.append("</td></tr>");
					*/
				sb.append("</table>");
		sb.append("</td>");
		
	sb.append("</tr>");
	rows++;
	rowcount.put("rows",""+rows);
	}else if(v.elementAt(i) instanceof Vector){
		if(level<5){ 
			Vector v1=(Vector) v.elementAt(i);
			for(int j=0;v1!=null && j<v1.size();j++){
		  	      sb.append("\n");	
			      //sb.append(generateHTML(v1,j,level+1,rowcount,role,unitid,appname,forumid,topicid,pagecount,perpage,parentThreadid,oldparent,levels,msgid,authid,reqmap,moderator,fstatus));
			      sb.append(generateHTML(v1,j,level+1,rowcount,role,unitid,appname,forumid,topicid,parentThreadid,oldparent,levels,msgid,authid,reqmap,moderator,fstatus,groupid ));
			}
		}	
	}
	return sb.toString();	
	}
%>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ShowTopicMessages.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	String forumid=request.getParameter("forumid");
	String topicid=request.getParameter("topicid");
	String oldparent=request.getParameter("parentThreadid");
	String groupid=request.getParameter("GROUPID");
	String grouptype=request.getParameter("GROUPTYPE");
	String PS=request.getParameter("PS");
	String parentThreadid="";
	
	boolean loggedin=false;
	boolean cont=true;
	boolean moderator=false;
	try{
		if(Integer.parseInt(forumid)<=0 || Integer.parseInt(topicid)<=0){
			throw new Exception();
		}
	}catch(Exception e){
		System.out.println("Exception occured at converting forum no or topicid:"+e);
		cont=false;
	}
	
	String msgid=request.getParameter("msgid");
	
	String pagecount=request.getParameter("pagecount");
	String perpage="2";
	if(pagecount==null || "".equals(pagecount.trim()))
	pagecount="1";
	
	String authid=null,role=null,unitid=null;
	String imagepath=null;
	String appname=null;
	
	HashMap hmParent=new HashMap();
	Authenticate authData= AuthUtil.getAuthData(pageContext);   //(Authenticate)session.getAttribute("authData");
	if (authData!=null){
		 authid=authData.getUserID();
		 role=authData.getRoleName();
		 unitid=authData.getUnitID();
		 loggedin=true;
		 if("Manager".equals(role)){
		 	moderator=true;
		 }else{
		 	moderator=("HUBMGR".equalsIgnoreCase(HubMaster.getUsersHubStatus(authid,groupid)));
		 }
	}else{
		 role="Member";
	}
	
	appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";

%>

<%  
     String navName=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{groupid});
     String forumname=(String)session.getAttribute(forumid+"_FORUMNAME");
     HashMap foruminfo=getForumTopicInfo("0",topicid,forumid);
     if(forumname==null||"".equals(forumname))
    forumname=GenUtil.getHMvalue(foruminfo,"forumname","");
     request.setAttribute("tasktitle",forumname);
     
    HashMap urlmap=PageUtil.getPageNameAndUrl(request.getParameter("PS"),request.getParameter("GROUPID"));
	if(urlmap!=null)
	{
	request.setAttribute("tabtype","unit");
	//request.setAttribute("tabtype",(String)urlmap.get("tabtype"));
	request.setAttribute("subtabtype","Communities");
	request.setAttribute("NavlinkNames",new String[]{(String)urlmap.get("navlink")});
	request.setAttribute("NavlinkURLs",new String[]{appname+(String)urlmap.get("backurl") });
	}else{
    		request.setAttribute("tabtype","unit");
    }		
%>
<% if(cont) { %>
<form method="POST" action="<%=appname%>/discussionforums/logic/redirector.jsp"  name="form">
<%= com.eventbee.general.PageUtil.writeHiddenCore( (HashMap)request.getAttribute("REQMAP") )%>

<!--<script language='javascript' src='/home/js/forum.js'>-->
<script language='javascript' src='<%=EbeeConstantsF.get("js.webpath","http://www.beeport.com/home/js") %>/forum.js' >
function dummy(){}
</script>
<input type='hidden' name='authid' value='<%=authid%>'/>
<input type='hidden' name='forumid' value='<%=forumid%>'/>
<input type='hidden' name='parentid' value='0'/>
<input type='hidden' name='subject' value=''/>
<input type='hidden' name='page' value='Message'/>
<input type='hidden' name='GROUPID' value='<%=groupid%>'/>
<input type='hidden' name='PS' value='<%=PS%>'/>
<input type='hidden' name='GROUPTYPE' value='<%=grouptype%>'/>


<input type='hidden' name='topicid' value='<%=topicid%>'/>
<input type='hidden' name='oldparentid' value='<%=oldparent%>'/>
<input type='hidden' name='oldmsgid' value='<%=msgid%>'/>
<input type='hidden' name='msgto' />
<input type='hidden' name='to' />
<input type='hidden' name='isnew' value='yes' />
<table border='0' width='100%' cellspacing='0' cellpadding='0'>
<tr><td align='right'></td></tr>
<tr><td height='10'></td></tr>
</table>
<%

	String fstatus=GenUtil.getHMvalue(foruminfo,"status");
	if(foruminfo!=null && !(foruminfo.isEmpty())){
%>
	
<% }%>
<% if(msgid!=null && !("".equals(msgid.trim())) && !("null".equalsIgnoreCase(msgid.trim()))){
	out.println("<input type='hidden' name='msgid' value='"+msgid+"'/>");
	out.println("<input type='hidden' name='parentThreadid' value='"+msgid+"'/>");
	parentThreadid=msgid;
	HashMap parentmsg=getForumTopicInfo(topicid,msgid,forumid);
	
	if(parentmsg!=null && !(parentmsg.isEmpty())){  
%>
	
<%      }
  }else{
  	out.println("<input type='hidden' name='msgid' value='"+topicid+"'/>");
	out.println("<input type='hidden' name='parentThreadid' value='"+topicid+"'/>");
	parentThreadid=topicid;
  }
%>
	


<table class="block" width="800">
<tr><td>
<% Vector v;
	if(msgid!=null && !("".equals(msgid.trim())) && !("null".equalsIgnoreCase(msgid.trim()))){ 
		v= getForumTopicMessages(msgid,forumid,null);
	}else{
		v= getForumTopicMessages(topicid,forumid,"0");
	}
	int total=0;
	/*for(int i=0;v!=null && i<v.size();i++){
		total=totalReplies(v,i,total);
	}*/
		
%>
<table border="0" width="100%" >
<tr><td align="right"></td></tr>

<tr>
<td colspan='5'>
<table border='0' width='100%'>

<tr>

<% if(moderator){ %>
	
<td align='left'>
	<input type='submit' name="submit" value="Delete"/>
</td>
<% } %>
<!--td align="right">Back to <a href='<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/guesttasks/showForumTopics.jsp?forumid="+forumid+"&GROUPID="+groupid, (HashMap)request.getAttribute("REQMAP") )   %>'><%=GenUtil.getHMvalue(foruminfo,"forumname",null,true)%></a>
</td-->

<%--td align='right'>Total Replies <%=total%></td--%>
</tr>
<tr><td colspan='2' height='5'></td></tr>
<!--<tr><td colspan='2' align='right'>Page <%--=pagecount--%> of <%--=noOfPages(total,5)--%> [ 
<%
/*	int pagek=0;
	try{
		pagek=Integer.parseInt(pagecount.trim());
		if (pagek<=10){
			pagek=1;
		}
		
	   }catch(Exception e){pagek=1;}	
	for(;pagek<=noOfPages(total,5);pagek++){ %>
		<a href='/<%=appname%>/discussionforums/showTopicMessagesinfo?forumid=<%=forumid%>&amp;topicid=<%=topicid%>&amp;msgid=<%=msgid%>&amp;pagecount=<%=pagek%>'>
			<%=pagek%>
		</a>  
<%	}  */ %>	
]</td></tr> 
<tr><td colspan='2' height='5'></td></tr> -->
</table>
</td>
</tr>


<% if(v!=null && v.size()>0) { %>
<tr class='colheader'>
	<% if(moderator){ %>
	<td align='center' width='5%'>
		<input type='checkbox' name='topics' onclick="javascript:selectAll(this)"/>
	</td>
	<% } %>

<td align='center' width='75%'><b></b></td>
<td align='center' width='15%'><b>Author</b></td>
<td align='center'><b></b></td>
</tr>

<% } %> 
<%	
	HashMap rowcount=new HashMap();
	HashMap levels=(HashMap) session.getAttribute(forumid+"_LEVEL_MAP");
	if(levels==null){
		levels=new HashMap();
		session.setAttribute(forumid+"_LEVEL_MAP",levels);
	}
	rowcount.put("rows","0");
	rowcount.put("pagek","1");
	for(int i=0;v!=null && i<v.size();i++){
		//out.println(generateHTML(v,i,1,rowcount,role,unitid,appname,forumid,topicid,pagecount,perpage,parentThreadid,oldparent,levels,msgid,authid,(HashMap)request.getAttribute("reqmap"),moderator),fstatus);
		out.println(generateHTML(v,i,1,rowcount,role,unitid,appname,forumid,topicid,parentThreadid,oldparent,levels,msgid,authid,(HashMap)request.getAttribute("REQMAP"),moderator,fstatus,groupid));
	}
%>
</table>
</td></tr>
</table>
</form>
<% } %>
