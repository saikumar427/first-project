<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>
<jsp:include page="/auth/authenticate.jsp">
<jsp:param name='Dummy_ph' value='' /></jsp:include>
<%

	int count=0;
	String authid=null,unitid=null,to=null,msgto=null,groupid=null,grouptype=null,query=null,shareprofile=null;
	String transactionid=null,totype=null,fromtype=null,message=" ";
	String forumid=null,topicid=null;
	String role=null,appname="";
	String DispName="";
	String msgfrom="";
	HashMap smshash=(HashMap)session.getAttribute("smshash");
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData==null){
		 fromtype="Transactionid";
		 unitid=(String) session.getAttribute("entryunitid");
		
		 response.sendRedirect(PageUtil.appendLinkWithGroup("/portal/auth/listauth.jsp?msgto="+GenUtil.getHMvalue(smshash,"to",request.getParameter("msgto"))+"&to="+GenUtil.getHMvalue(smshash,"toname",request.getParameter("to"))+"&purpose=sendsms",(HashMap) request.getAttribute("REQMAP")));
	}
	HashMap hm=(HashMap)session.getAttribute("groupinfo");
	if(hm!=null){
		groupid=(String)hm.get("groupid");
		grouptype=(String)hm.get("grouptype");	
	}else{
		groupid=request.getParameter("groupid");
		grouptype=request.getParameter("grouptype");
	}
	
	if(smshash==null){
		authid=request.getParameter("fromid");
		to=request.getParameter("to");
		totype=request.getParameter("totype");
		forumid=request.getParameter("forumid");
		topicid=request.getParameter("topicid");
		groupid=request.getParameter("GROUPID");
		msgto=request.getParameter("msgto");
		
		
		
		
	}else{
		authid=(String)smshash.get("msgfrom");
		to=(String)smshash.get("toname");
		msgto=(String)smshash.get("msgto");
		totype=(String)smshash.get("totype");	
		message=GenUtil.getHMvalue(smshash,"message");
		groupid=GenUtil.getHMvalue(smshash,"groupid");
		forumid=GenUtil.getHMvalue(smshash,"forumid");
		topicid=GenUtil.getHMvalue(smshash,"topicid");
		
		
		grouptype=GenUtil.getHMvalue(smshash,"grouptype");
	}
	if (authData!=null){      
		  fromtype="Userid";
		  role=authData.getRoleName();
		  unitid=authData.getUnitID();
		  authid=authData.getUserID();
	}
	String subject=request.getParameter("subject");
	if(subject==null || "".equals(subject.trim())){	
				subject=DbUtil.getVal("select subject from forummessages where msgid=?",new String[]{topicid});
			}
			if(subject!=null)
				if(!subject.startsWith("Re: "))
					subject="Re: "+subject;
					
	
	to=DbUtil.getVal("select  email from user_profile where user_id=?",new String[]{msgto});
	msgfrom=DbUtil.getVal("select  email from user_profile where user_id=?",new String[]{authid});
	Vector errorvector=(Vector)session.getAttribute("smserrorvector");
	String sender_role_name="Member";
	String sender_unit_id="";
		
	appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	
	DBManager dbmanager=new DBManager();
	StatusObj stobj=dbmanager.executeSelectQuery("select role_id,unit_id from authentication where user_id=?",new String[]{msgto});
	if(stobj.getCount()>0){
	
	if(!"-100".equals(dbmanager.getValue(0,"role_id","")))
		sender_role_name="Manager";	
	}
	sender_unit_id=dbmanager.getValue(0,"unit_id","");
	
	DispName=to;
	String linkpath="";
	//if("Manager".equalsIgnoreCase(sender_role_name)){
	//	DispName="Manager";
	//}else 
	if("Member".equalsIgnoreCase(role)){	
		linkpath=appname+"/editprofiles/networkuserprofile.jsp?";
	}//else if("Manager".equalsIgnoreCase(role)){
	//	if(unitid.equals(sender_unit_id)){
	///		linkpath=appname+"/sms/unitmemberprofile.jsp";
	//	}else{
	//		linkpath=appname+"/sms/guestmemberprofile";
	//	}	
	//}
	session.setAttribute("smshash",null);
	session.setAttribute("smserrorvector",null);
%>	

<% //request.setAttribute("tasktitle","Messaging");
   request.setAttribute("tabtype","community");
   request.setAttribute("subtabtype","mymessages");
   if("/manager".equals(appname))
   request.setAttribute("tabtype","portal");
    %>
	<table border="0" width="100%" align="center">
   <Script language="JavaScript" src='<%=EbeeConstantsF.get("js.webpath","http://www.beeport.com/home/js")%>/messagevalidate.js'>
       function dummy{};
   </Script>
	<% if(authid.equals(msgto)){ %>
			<td><%=EbeeConstantsF.get("Sending.messagetoyourself.notallowed","Sending message to yourself is not allowed")%></td>
				<%-- <td>Sending message to yourself is not allowed</td> --%>
			</tr>
			<tr><td align="center" colspan="2"><input type="button" name="bbb" value="Back" onClick="javascript:history.back()" /></td></tr>
		<%}else{%>							
		      <form action="<%=appname%>/discussionforums/logic/sendmessageprocess.jsp" name="frm" method="POST" onSubmit="return(checkmessage(document.frm.msg.value))">
			<% if(errorvector!=null && errorvector.size()>0){
				for(int i=0;i<errorvector.size();i++){ %>
					<tr><td width="100%"><font class="error"><%=(String)errorvector.get(i)%></font></td></tr>
				<%} }%>	
			<tr><td>
			   <table border="0" width="100%" align="center" >
			   
			 

					<input type="hidden" name="sender" size="35" value="<%=msgfrom%>" />

			   
			   
			   
				
				   
						<input type="hidden" name="receipent" size="35"  value="<%=DispName%>"  />
				    
				  
				<tr><td class="inputlabel" width="15%">Subject</td>
								    <td  class="inputvalue">
								   
										<input type="text" name="subject" size="35"  value="<%=subject%>" />
								    
								    </td>
				</tr>
				<tr>
				     <td></td>
				     <td>
				        <input type="hidden" name="GROUPID" value="<%=groupid%>"/>
				        <input type="hidden" name="forumid" value="<%=forumid%>"/>
				        <input type="hidden" name="topicid" value="<%=topicid%>"/>
				        <input type="hidden" name="frompage" value="community"/>
					<input type="hidden" name="msgfrom" value="<%=authid%>"/>
					<input type="hidden" name="toname" value="<%=GenUtil.getEncodedXML(to)%>"/>
					<input type="hidden" name="msgto" value="<%=msgto%>"/>
					<input type="hidden" name="fromtype" value="<%=fromtype%>"/>
					<input type="hidden" name="totype" value="<%=totype%>"/>
					<input type="hidden" name="source" value="profilemessage"/>
					<input type="hidden" name="mode" value="single"/>
					<input type="hidden" name="mailfrom" value="<%=msgfrom%>"/>
				    </td>
			       </tr>		
				<tr><td  height="100" align="left" class="inputlabel" valign="top" >Message *</td><td >
					<textarea  name="msg" cols="50" rows="10"  onfocus="this.value=(this.value==' ')?'':this.value" ><%=("".equals(message.trim()))?" ":GenUtil.getEncodedXML(message.trim())%></textarea>
				</td></tr>
					<tr><td colspan="2" align="center">
						<input type="button" value="Back" name="bbbbbb" onclick="javascript:history.back()"/>
						<%=com.eventbee.general.PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>
						<input type="submit" value="Send" name="submit"/>
					</td></tr>
			    </table>
			  </td></tr>
		</form>	 
		<%}%>
	</table>

