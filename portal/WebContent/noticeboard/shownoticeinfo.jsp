<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.noticeboard.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>

<jsp:include page='/auth/checkpermission.jsp'>
	<jsp:param name='authtype' value='<%=request.getParameter("PS")%>'/>
<jsp:param name='Dummy_ph' value='' /></jsp:include>


   <%
   EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"Shownoticeinfo.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
   String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
   request.setAttribute("tasktitle","Noticeboard");
      String evtname="";
	HashMap urlmap=PageUtil.getPageNameAndUrl(request.getParameter("PS"),request.getParameter("GROUPID"));
	if(urlmap!=null)
	{
	String ttype=(String)urlmap.get("tabtype");
	if("events".equals(ttype)||"unit".equals(ttype))
		request.setAttribute("tabtype",ttype);

	if("event".equals(ttype) )
	request.setAttribute("subtabtype","My Pages");

	else
	request.setAttribute("subtabtype","Communities");
	String navlink="/portal/hub/clubview.jsp?GROUPID="+request.getParameter("GROUPID");
	request.setAttribute("NavlinkNames",new String[]{(String)urlmap.get("navlink")});
	request.setAttribute("NavlinkURLs",new String[]{navlink});
	}
	else
		request.setAttribute("tabtype","community");

  %>

<%

String status="OK";
String notice="";
String  noticetype="";
String noticeid,groupid,grouptype;
String defaulttypes[]={"Alert","Info","Message"};
HashMap noticehash=null;
Vector errorvector=null;
if("yes".equalsIgnoreCase(request.getParameter("isnew"))){
	noticeid=request.getParameter("noticeid");
	groupid=request.getParameter("GROUPID");
	grouptype=request.getParameter("GROUPTYPE");	
	noticehash=NoticeboardDB.getNoticeInfo(noticeid);
}else{
	
	noticehash=(HashMap)session.getAttribute("noticehash");
	errorvector=(Vector)session.getAttribute("noticeerrorvector");
	groupid=GenUtil.getHMvalue(noticehash,"GROUPID");
	grouptype=GenUtil.getHMvalue(noticehash,"GROUPTYPE");
	noticeid=GenUtil.getHMvalue(noticehash,"noticeid");
}

noticetype=(String)noticehash.get("noticetype");
notice=(String)noticehash.get("notice");

%>
<form name="form" action="/noticeboard/updateNotice" method="post">	
			<input type="hidden" name="source" value="shownoticeinfo"/>
			<input type="hidden" name="noticetype" value="<%=noticetype%>"/>
			<input type="hidden" name="noticeid" value="<%=noticeid%>"/>
			<input type='hidden' name='from' value='<%=request.getParameter("from")%>'/>
			<input type='hidden' name='pname' value='<%=request.getParameter("pname")%>'/>
			<input type="hidden" name="GROUPID" value=<%=groupid%> "/>	 

<table border="0" width="100%" align="center">
									
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

			<tr><td width="100%">
			<table cellspacing="0" cellpadding="0" border="0" width="100%" align="center" class="block" >
			<tr><td><input type="hidden" name="groupid" value="<%=groupid%>"/></td></tr>
			<tr><td><input type="hidden" name="grouptype" value="<%=grouptype%>"/></td></tr>
				<td width="50%" class="inputlabel">Type</td>
				<td width="50%" class="inputvalue"><%=noticetype%>
				<%--<%=WriteSelectHTML.getSelectHtml(defaulttypes, defaulttypes, "noticetype",noticetype, null, null)%>--%>
				</td>

				<tr>
					<td width="36%" class="inputlabel">Notice *</td>
					<td width="70%" class="inputvalue"><textarea name="notice" rows="10" cols="51" onfocus="this.value=(this.value==' ')?'':this.value" ><%=GenUtil.getEncodedXML(notice).trim()%> </textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2" width="100%" align="center"> 
					    <%=com.eventbee.general.PageUtil.writeHiddenCore((HashMap) request.getAttribute("REQMAP"))%>	    
					     <input type="submit" name="submit" value="Update"/>
					     <input type="button"  value="Cancel" onClick="javascript:window.history.back()"/>
					</td>
				 </tr> 
			</table>		 
		</td></tr>
	</table>

	
</form>

		 	
  </body>
</html> 


