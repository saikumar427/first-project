<%@ page import="java.util.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
	

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"enternoticeinfo.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
String status="OK",noticeid=null;
String notice="",PS=null;
String noticetype="";
HashMap noticehash=null;
Vector errorvector=null;
String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
String groupid=null,grouptype=null,authid=null;
		
//String query="select email from eventattendee where groupid=?";

String defaulttypes[]={"Alert","Info","Message"};


if("yes".equalsIgnoreCase(request.getParameter("isnew"))){
	groupid=request.getParameter("GROUPID");
	grouptype=request.getParameter("GROUPTYPE");
	noticeid=request.getParameter("noticeid");
	
		
}else{
	noticehash=(HashMap)session.getAttribute("noticehash");
	errorvector=(Vector)session.getAttribute("noticeerrorvector");
	if(noticehash!=null){
		noticetype=(String)noticehash.get("noticetype");
		notice=(String)noticehash.get("notice");
		groupid=(String)noticehash.get("GROUPID");
		
		grouptype=(String)noticehash.get("GROUPTYPE");
	}


}
	
String from=request.getParameter("from");
String mailto="";
if("events".equals(from))

mailto="Attendees";
else
mailto="Members";
	
Authenticate authData=AuthUtil.getAuthData(pageContext);
if (authData!=null){      
	 authid=authData.getUserID();
}

%>
<jsp:include page='/auth/checkpermission.jsp'>
	<jsp:param name='authtype' value='<%=request.getParameter("PS")%>' />
<jsp:param name='Dummy_ph' value='' /></jsp:include>

  <% 
  request.setAttribute("tasktitle","Noticeboard");
     	String evtname="";
	HashMap urlmap=PageUtil.getPageNameAndUrl(request.getParameter("PS"),request.getParameter("GROUPID"));
	if(urlmap!=null)
	{
		String ttype=(String)urlmap.get("tabtype");
		if("events".equals(ttype)||"unit".equals(ttype))
		request.setAttribute("tabtype",ttype);
		
		if("event".equals(ttype) ){
		request.setAttribute("subtabtype","My Pages");
		
			String urlstring="<a href='/myevents/myevents.jsp?type=Events'>My Pages</a> &raquo; ";
		
			HashMap urlmap1=PageUtil.getPageNameAndUrl("eventmanage",request.getParameter("GROUPID"));
			
			if(urlmap1!=null)
			{
			request.setAttribute("tabtype","events");
			urlstring+="<a href='/portal/eventmanage/eventmanage.jsp?GROUPID="+request.getParameter("GROUPID")+"'>"+(String)urlmap1.get("navlink")+"</a> &raquo; ";
			//request.setAttribute("NavlinkURLs",new String[]{appname+(String)urlmap.get("backurl") });
			}
			urlstring+="Post Notice";
			request.setAttribute("tasktitle",urlstring);
		
		
		
		}
		

		else
		request.setAttribute("subtabtype","Communities");
		
	
	request.setAttribute("NavlinkURLs",new String[]{appname+(String)urlmap.get("backurl") });
	}
	else
		request.setAttribute("tabtype","community");

  %>
	<table cellspacing="0" cellpadding="5" border="0" width="100%" align="center" class="taskblock" >		
		<form name="form" action="/noticeboard/insertNotice"  method="post">	
			<input type="hidden" name="source" value="enternoticeinfo"/>
			<input type="hidden" name="owner" value="<%=authid%>"/>
			<input type="hidden" name="GROUPID" value="<%=groupid%>"/>
			<input type='hidden' name='from' value='<%=from%>'/>
			<input type='hidden' name='pname' value='<%=request.getParameter("pname")%>'/>
				 
	 
	<%
	if(errorvector!=null){
		
			for(int i=0;i < errorvector.size();i++){
%>
<tr><td width="100%">
<font class="error"><%=(String)errorvector.elementAt(i)%></font>
</td></tr>
				
<%			
			}
		}
%>




	
		
  	
	<table cellspacing="0" cellpadding="0" border="0" width="100%" align="center" class="taskblock"  >
		<tr>
		<td width="50%" class="inputlabel">Type</td>
		<td width="50%" class="inputvalue">
		<%=WriteSelectHTML.getSelectHtml(defaulttypes, defaulttypes, "noticetype",noticetype, null, null)%>
		</td>
		</tr>
		
		<tr>
			<td width="36%" class="inputlabel">Notice *</td>
			<td width="70%" class="inputvalue"><textarea name="notice" rows="10" cols="51" onfocus="this.value=(this.value==' ')?'':this.value" ><%=GenUtil.getEncodedXML(notice).trim()%> </textarea></td>
		</tr>
		<tr>
		
		
		<td colspan="2" width="100%" align="center"><input type="checkbox" name="sendmail"  > Send email to <%=mailto%></td>
		
		</tr>
		<tr>
		<td colspan="2" width="100%" align="center"> 
		  
		  <%=com.eventbee.general.PageUtil.writeHiddenCore((HashMap) request.getAttribute("REQMAP"))%>
		  <input type="submit" name="submit" value="Post"/>
		  <input type="button"  value="Cancel" onClick="javascript:window.history.back()"/>
		</td>
		 </tr> 
	</table>		 
		</form>
	</table>		 	
  
		
