<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.eventbee.authentication.*" %> 
<%@ page import="com.eventbee.general.*" %>
 
<jsp:include page='/auth/checkpermission.jsp' />	
<%		
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"previewmsginfo.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	String authid=null,postedbytype=null,username=null;
	HashMap fourmHash=(HashMap) session.getAttribute("fmsghash");
	String msgid=GenUtil.getHMvalue(fourmHash,"parentid");
	String forumid=GenUtil.getHMvalue(fourmHash,"forumid");
	String forumname=(String)session.getAttribute(forumid+"_FORUMNAME");
    if(forumname==null||"".equals(forumname)){
    forumname=DbUtil.getVal("select forumname from forum where forumid="+forumid,null);
    session.setAttribute(forumid+"_FORUMNAME",forumname);
    }
	String parentThreadid=GenUtil.getHMvalue(fourmHash,"parentThreadid");
	String topicid=GenUtil.getHMvalue(fourmHash,"topicid");
	String source=GenUtil.getHMvalue(fourmHash,"source");
	String subject=GenUtil.getHMvalue(fourmHash,"subject");
	String reply=GenUtil.getHMvalue(fourmHash,"reply");	
	String oldmsgid=GenUtil.getHMvalue(fourmHash,"oldmsgid");
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	Authenticate authData=AuthUtil.getAuthData(pageContext); //(Authenticate)session.getAttribute("authData");
        if (authData!=null){      
      		authid=authData.getUserID();
      		postedbytype="U";
      	}else{			
		authid=(String)session.getAttribute("transactionid");
		postedbytype="T";
	}
	SimpleDateFormat sdf=new SimpleDateFormat("MMMMMMMMMMMM dd yyyy hh:mm a");
	String datetime=sdf.format(new java.util.Date());
	username=(String) (authData.UserInfo.get("FirstName"))+" "+(String) authData.UserInfo.get("LastName");
	
	session.removeAttribute("errorvector");
	session.setAttribute("FORUM_REPLY",reply);	
%> 


<%  
    String navName=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{request.getParameter("GROUPID")});
    request.setAttribute("tasktitle",forumname);
    if("clubmanage".equals(request.getParameter("PS")) || "clubview".equals(request.getParameter("PS"))){
		request.setAttribute("tabtype","club");
		request.setAttribute("NavlinkNames",new String[]{navName});
		String url=com.eventbee.general.PageUtil.appendLinkWithGroup("/portal/hub/clubview.jsp",(HashMap)request.getAttribute("REQMAP"));
		if("clubmanage".equals(request.getParameter("PS")))
			url=com.eventbee.general.PageUtil.appendLinkWithGroup("/portal/hub/clubmanage.jsp",(HashMap)request.getAttribute("REQMAP"));
		request.setAttribute("NavlinkURLs",new String[]{url});
    }else  if("clubdetails".equals(request.getParameter("PS")) || "clubpage".equals(request.getParameter("PS"))){
    		 request.setAttribute("NavlinkNames",new String[]{navName});
		String url=com.eventbee.general.PageUtil.appendLinkWithGroup("/portal/clubdetails/clubdetails.jsp",(HashMap)request.getAttribute("REQMAP"));
		if("clubpage".equals(request.getParameter("PS")))
			url=com.eventbee.general.PageUtil.appendLinkWithGroup("/portal/clubpage/clubpage.jsp",(HashMap)request.getAttribute("REQMAP"));
		request.setAttribute("NavlinkURLs",new String[]{url});	
    }else if("eventmanage".equals(request.getParameter("PS")))
		request.setAttribute("tabtype","event");
    else
    		request.setAttribute("tabtype","unit");
%>
				
		<table width="100%" align="center" class="block">									
		    <tr><td>
			<form name="form" action="<%=appname%>/discussionforums/logic/insertDFMessage.jsp" method="POST">				
			<table width="100%" align="center" cellspacing="0" cellpadding="0">					
			   <tr class="evenbase"><td>
			     <table border="0" align="center" width="100%" cellspacing="0">
				<tr>			
					<td width="100%" align="left">
						<input type="hidden" name="parentThreadid" value="<%=parentThreadid%>"/>
						<input type="hidden" name="oldmsgid" value="<%=oldmsgid%>"/>
						<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>"/>
						<input type="hidden" name="subject" value="<%=GenUtil.getEncodedXML(subject)%>"/>
						<input type="hidden" name="parentid" value="<%=msgid%>"/>
						<input type="hidden" name="authid" value="<%=authid%>"/>
						<input type="hidden" name="forumid" value="<%=forumid%>"/>
						<input type='hidden' name='topicid' value='<%=topicid%>'/>
						<input type="hidden" name="source" value="previewmsginfo.jsp"/>
						<input type="hidden" name="postedbytype" value="<%=postedbytype%>"/>
						<%=com.eventbee.general.PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>
					</td>
				</tr>
				<tr>					
					<td width="100%" align="left">
					<table border='0' cellpadding='0' cellspacing='0' width='100%'>
					<tr>
						<td>
							<table border='0' cellpadding='0' cellspacing='0' width='100%'>
							<tr><td>
							<input type="hidden" name="username" value="<%=username%>"/> 
							<b><%=datetime%></b>
							<input type="hidden" name="time" value="<%=datetime%>"/>
							</td></tr>
							<tr><td><%=GenUtil.getEncodedXML(subject)%></td></tr>
							<tr><td><br/></td></tr>
							<tr><td><%=GenUtil.processTextHtml(GenUtil.getEncodedXML(reply))%>
							</td></tr>	
							</table>
						</td>
						
					</tr>	
					</table>
					</td>
					
				</tr>
						
			       </table>
			      </td></tr>
			</table>
			
			<table border="0" width="100%" align="center">
				<tr><td width="50%" align="right">	     
					<!--input type="button" name="Back" value="Back" Onclick="Javascript:history.back()" /-->
					<input type="submit" name="submit" value="Edit" />
				     </td>
				     <td width="50%" align="left">
						<input type="submit" name="submit" value="Post" />
				     </td>					     	     
				</tr>	
			  </table> 
			</form>					     	
		  </td></tr>
		</table>					
