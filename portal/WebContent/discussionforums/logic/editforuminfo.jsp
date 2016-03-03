<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>

<%@ page import="com.eventbee.forum.ForumDB" %>
<%@ page import="com.eventbee.authentication.*" %>
<%		
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"editforuminfo.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	String forumid=null,name=null,description=null,status=null,loginname="",enableposting="no",header1="",footer1="",footertype="Text",headertype="Text";
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	HashMap hm=null;
	boolean forumentryexists=false;
	Authenticate authData_auth=AuthUtil.getAuthData(pageContext);
	Vector errorvector=null;
	forumid=request.getParameter("forumid");
	boolean display=true;
	DBManager dbmanager=new DBManager();
	StatusObj statobj1=null;
	String clubname=request.getParameter("clubname");
	if(clubname!=null)
	clubname=java.net.URLEncoder.encode(clubname);

	
	

	if("yes".equalsIgnoreCase(request.getParameter("isnew"))){
		hm=ForumDB.getForumInfoByForumID(forumid);
		if(!"MEM".equals(authData_auth.getRoleCode())){
		statobj1=dbmanager.executeSelectQuery("select header,footer,headertype,footertype from email_templates where unitid=? and purpose='FORUMS' ",new String [] {authData_auth.getUnitID()});
			if(statobj1.getStatus()){
			forumentryexists=true;
			hm.put("header1",dbmanager.getValue(0,"header",""));
			hm.put("footer1",dbmanager.getValue(0,"footer",""));
			hm.put("headertype",dbmanager.getValue(0,"headertype",""));
			hm.put("footertype",dbmanager.getValue(0,"footertype",""));
			}
		}
		}else{
		
		hm=(HashMap)session.getAttribute("forumhash");
		errorvector=(Vector)session.getAttribute("errorvector");
		enableposting=(String)hm.get("enableposting");

	}
	forumid=GenUtil.getHMvalue(hm,"forumid",forumid);
	StatusObj statobj=dbmanager.executeSelectQuery("select loginname,status from custom_mail_box where refid=? ",new String [] {forumid});
	if(statobj.getStatus()){
	loginname=dbmanager.getValue(0,"loginname","");
	status=dbmanager.getValue(0,"status","");
	if("PENDING".equals(status))
	enableposting="no";
	else
	enableposting="yes";
	display=false;

	}else	loginname="";
	if("yes".equalsIgnoreCase(request.getParameter("isnew"))){
	hm.put("loginname",loginname);
	hm.put("enableposting",enableposting);
	}
	enableposting=(String)hm.get("enableposting");

	name=GenUtil.getHMvalue(hm,"forumname");
	description=GenUtil.getHMvalue(hm,"description");
	status=GenUtil.getHMvalue(hm,"status");

String domain=EbeeConstantsF.get("support.email","support@beeport.com");
 domain=domain.replaceAll("support","");

	
%>	

   <table border="0" width="100%" align="center" class="taskblock">
	<form name="form" action="/discussionforums/logic/insertDiscForum" method="POST">
	<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>"/>
	<input type="hidden" name="clubname" value="<%=clubname%>"/>
		<%=com.eventbee.general.PageUtil.writeHiddenCore((HashMap) request.getAttribute("REQMAP"))%>
		<% for(int i=0;errorvector!=null && i<errorvector.size();i++){ %>
			<tr><td width="100%" colspan="2"><font class="error"><%=(String)errorvector.get(i)%></font></td></tr>
		<%}%>	
		<tr><td colspan='2'>			
		<table cellspacing="0" cellpadding="0" border="0" width="100%" align="center" class="block">
			<tr>
				<td align="left" width="50%" class="inputlabel"> Forum Name *</td>
				<td width="36%" class="inputvalue">
					<input type="text" name="name" value="<%=name%>" size="42"/>
					<input type="hidden" name="forumid" value="<%=forumid%>"/>
				</td>
			</tr>
			<tr>
				<td align="left" class="inputlabel">Description </td>
				<td class="inputvalue">
					<textarea name="description" rows="10" cols="60" onfocus="this.value=(this.value==' ')?'':this.value"><%=(description==null || "".equals(description.trim()))?" ":description%></textarea>
				</td>
			</tr>	
			<tr>
					<td class="inputlabel">Enable email posting to forum</td>
					<td class="inputvalue"><table width='100%'><tr><td width='100%'>

						<input type="radio"  name="enableposting" value="no" <%if(!"yes".equals(enableposting))out.println("checked='checked'");%>/>No
						</td></tr><tr><td>
						<input type="radio"  name="enableposting" value="yes" <%if("yes".equals(enableposting))out.println("checked='checked'");%>/>Yes, Forum Email ID
						<%if(display){%>
						<input type="text" size="27" name="loginname" value="<%=(String)hm.get("loginname")%>"/><%=domain%>
						<%}else{%>
						<input type="hidden" name="loginname" value='<%=(String)hm.get("loginname")%>'/>
						<input type="hidden" name="isedit" value='yes'/>
						<%}%><%=loginname%>
						</td></tr>
					</table>
					</td>
				</tr>
			<tr>
				<td class="inputlabel" align="left">Status</td>
				<td class="inputvalue">
					<%=WriteSelectHTML.getSelectHtml(new String[]{"Activate","Deactivate","Suspend"}, new String[]{"Yes","No","Suspend"},"status",status,null,null)%>
				</td>
			</tr>
			<%if((!"MEM".equals(authData_auth.getRoleCode()))&&forumentryexists){%>
			<tr><td  class="inputlabel">Postings Email Header</td><td class="inputvalue"><input type="radio" name="headertype" value="Text" <%if("Text".equals((String)hm.get("headertype")))out.println("checked='checked'");%> />Text <input type="radio" name="headertype" value="HTML" <%if("HTML".equals((String)hm.get("headertype")))out.println("checked='checked'");%> />HTML</td></tr>
					<tr><td class="inputlabel" ></td><td class="inputvalue" >
					<textarea name="header1" rows="20" cols='50' onfocus="this.value=(this.value==' ')?'':this.value"><%=(String)hm.get("header1")%></textarea>
	</td></tr>

	<tr><td  class="inputlabel">Postings Email Footer</td><td class="inputvalue"><input type="radio" name="footertype" value="Text"  <%if("Text".equals((String)hm.get("footertype")))out.println("checked='checked'");%> />Text <input type="radio" name="footertype" value="HTML"  <%if("HTML".equals((String)hm.get("footertype")))out.println("checked='checked'");%> />HTML</td></tr>
					<tr><td class="inputlabel" ></td><td class="inputvalue" >
					<textarea name="footer1" rows="20" cols='50' onfocus="this.value=(this.value==' ')?'':this.value"><%=(String)hm.get("footer1")%></textarea>
	</td></tr>
	<%}%>
				<tr><td colspan="2">
					<table align="center">
						<tr>
							
							<td>
								<input type="hidden" name="display" value="<%=display%>"/>
								<input type="hidden" name="mode" value="multiple"/>
								<input type="submit" name="submit" value="Delete"/>
								<input type="submit" name="submit" value="Update"/>
							</td>
							<td><input type="button" name="submit" value="Cancel" onclick="history.back()" /></td>
							<td></td>
						</tr>
					</table>
				</td></tr>
			</table>
			</td></tr>					 
		 </form>
  </table>			
