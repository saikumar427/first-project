<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.context.ContextConstants" %> 

<jsp:include page="/auth/checkpermission.jsp" />
<jsp:include page='/stylesheets/CoreRequestMap.jsp' />

<% 
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"pagecontentfinal.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
  
%>	

<%
	String userid=null;
	boolean delflag=false;
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	String message="",link="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute("authData");		
	if(authData!=null){
	    try{
		userid=authData.getUserID();		
		link="Back to My Page";//EbeeConstantsF.get("link.home.page","Back to My Home Page");
		HashMap pagemap=(HashMap)session.getAttribute("PAGE_HASH_NETWORK");	
		
		if(pagemap!=null){
			String edittype=request.getParameter("edittype");				
			if("delete".equals(edittype)){			
				pagemap.put("statement","");
				pagemap.put("processStatement","");
				pagemap.put("autoProcess","off");
				delflag=true;
			}
			pagemap.put("userid",userid);
			StatusObj sobj=DbUtil.executeUpdateQuery("update user_profile set statement=?,process_statement=?,autoprocess=?,updated_by=?,updated_at=now() where user_id=?",new String [] {(String)pagemap.get("statement"),(String)pagemap.get("processStatement"),(String)pagemap.get("autoProcess"),"PAGECONTENT",(String)pagemap.get("userid")});
			//int rcount=AccountDB.setPitch(pagemap);
			
			if(sobj.getStatus()){
				if("delete".equals(edittype)){			
					message=EbeeConstantsF.get("pagecontent.delete.done","Page Content deleted successfully");
				}else if("edit".equals(edittype)){		
					message=EbeeConstantsF.get("pagecontent.edit.done","Page Content updated successfully");
				}else{
					message=EbeeConstantsF.get("pagecontent.add.done","Page Content added successfully");
				}
%>			
			<table width="100%" align="center">
			    <tr><td align="center"><%=message%></td></tr>
			    <tr><td align="center"><a href="<%=appname%>/mytasks/publicpages.jsp?type=Network"><%=link%></a></td></tr>
			</table>
<%		
			}else{
	 	         message=EbeeConstantsF.get("pagecontent.failure","Sorry.This request can't be processed this time.");
%>
			<table width="100%" align="center">
				<tr><td align="center"><%=message%></td></tr>
				<tr><td align="center"><a href="<%=appname%>/mytasks/publicpages.jsp?type=Network"><%=link%></a></td></tr>
			</table>
<%
			}		
			session.setAttribute("PAGE_HASH",null);
		}else{
			message=EbeeConstantsF.get("pagecontent.reload","Process already completed / aborted. Follow proper way to repeat the process.");
%>
			<table width="100%" align="center">
				<tr><td align="center"><%=message%></td></tr>
			<tr><td align="center"><a href="<%=appname%>/mytasks/publicpages.jsp?type=Network"><%=link%></a></td></tr>
			</table>
<%			
		}
	  }catch(Exception e){
		System.out.println("Exception pagecontentfinal.jsp"+e.getMessage());
	  }
	}else{
	response.sendRedirect("/guesttasks/authenticateMessage.jsp");
	
	}	
	
%>
