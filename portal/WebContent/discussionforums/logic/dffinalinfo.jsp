<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>


<jsp:include page="/stylesheets/CoreRequestMap.jsp" />
<%





   String clubname=request.getParameter("clubname");
  
   String link="";
    String forumid=request.getParameter("forumid");
    String forumname=(String)session.getAttribute(forumid+"_FORUMNAME");
    String groupid=request.getParameter("GROUPID");
        if(forumname==null||"".equals(forumname)){
	    forumname=DbUtil.getVal("select forumname from forum where forumid="+forumid,null);
	    session.setAttribute(forumid+"_FORUMNAME",forumname);
    }
    if(forumname==null||"".equals(forumname.trim()))
   	 forumname="Discussion Forum";
    
    String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal"; 
    HashMap urlmap=PageUtil.getPageNameAndUrl(request.getParameter("PS"),request.getParameter("GROUPID"));
	if(urlmap!=null){
		
		String url=(String)urlmap.get("backurl");
		link="<a href='"+PageUtil.appendLinkWithGroup(appname+url+"?type=Community",(HashMap) request.getAttribute("REQMAP"))+"'>"+(String)urlmap.get("backpage")+"</a>";
	}else{
    		
    		link="<a href='/mytasks/clubmanage.jsp?GROUPID="+groupid+"'>Back to Manage page</a>";
	}
	
   	String mes=(String)request.getAttribute("message");
   	 	if(mes==null)
		mes=request.getParameter("message");
%>

	<table align="center" width="100%" cellspacing="0" cellpadding="3" >
	    <tr height="50"><td></td></tr>

		<tr>
			<td align="center" class="inform"><%=(mes==null)?"":mes%></td>
		</tr>
		
			<tr><td align="center"><%=link%></td>
		</tr>
		<tr height="200"><td></td></tr>

	</table>				
