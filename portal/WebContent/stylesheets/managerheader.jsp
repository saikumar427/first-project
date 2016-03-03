<%@page import="com.eventbee.authentication.*" %>
<%@page import="com.eventbee.general.*" %>
<%@page import="com.eventbee.general.formatting.*" %>
<%@page import="com.eventbee.customconfig.MemberFeatures" %>
<%@page import="java.util.*" %>

<%
{
 
	String mem_role=null;
	boolean isactive=false;
	String roleid=null,pkgtype="",roletype="";
	Authenticate auth=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
	if (auth!=null){
		isactive=auth.isActiveAccount();
		mem_role=auth.getRoleName();
		roleid=auth.getRoleID();
		pkgtype=auth.getUnitPkgType();
		roletype=auth.getRoleTypeCode();
		if("CUSTOM".equalsIgnoreCase(roletype))
			roletype="2";
		else
			roletype="1";

	}

	String domainname=EbeeConstantsF.get("link.entryhome.page","Eventbee");
	String SERVER_ADDRESS1="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com");

	if("Manager".equals(mem_role)){
%>
	<table border='0' cellpadding='0' cellspacing='0' width='100%' align='center' valign="top" >
	<tr><td valign='top'><link rel="stylesheet" href="<%=SERVER_ADDRESS1 %>/home/index.css"/></td></tr>
	<tr><td valign='top'>
	<%
		if(isactive){
	
		  String[] beeportCategoryCodes=new String[]{"Home","Community","Wiki Pages","Events","Email Marketing","Surveys & Polls","Collaboration","Tasks","Contacts","Integration","Storage","Reports"};
		  String[] beeportCategoryValues=new String[]{"portal","unit","wiki","events","emailmarketing","surveys","collaboration","Tasks","Contacts","integration","storage","reports"};
		  //String[] beeportCategoryCodes=new String[]{"Home","Tasks","Contacts","Community","Events","Email Marketing","Surveys & Polls","Collaboration","Integration","Storage"};
		 // String[] beeportCategoryValues=new String[]{"portal","Tasks","Contacts","unit","events","emailmarketing","surveys","collaboration","integration","storage"};
		  String[] beeportCategoryURLS=new String[]{
		  	"/manager/mgrhome.jsp?UNITID=13578",
		 	"/manager/clubpagem/clubpage.jsp?UNITID=13578",
			"/manager/managewiki/wiki.jsp?UNITID=13578",
		 	"/manager/mgrutil/mgrevents.jsp?UNITID=13578",
		 	"/manager/emailmarketing/marketing.jsp?UNITID=13578",
		 	"/manager/mgrutil/mgrsp.jsp?UNITID=13578",
			"/manager/mgrutil/collaboration.jsp?UNITID=13578",
			"/manager/customtables/tabledata.jsp?UNITID=13578&.tableid=2&conf=Tasks&fromhome=y",
		 	"/manager/customtables/tabledata.jsp?UNITID=13578&.tableid=1&conf=Contacts&fromhome=y",
			"/manager/mgrlinks/integration.jsp?UNITID=13578",
			"/manager/directory/ManageContent.jsp?UNITID=13578",
			"/manager/mgrlinks/reports.jsp?UNITID=13578"};
	%>
	
	<table border='0' cellpadding='0' cellspacing='0' width='100%' valign='top'>
	<tr >
		<%
			String conf=(String)request.getAttribute("tabtype");
			List AL=null;
			boolean dbhit=false;
			if("portal".equalsIgnoreCase(conf)){
				dbhit=true;
			}else{
				AL=(List) session.getAttribute("MANAGER_MENU_TAB_CONFIG");
				if(AL==null) dbhit=true;
			}
			dbhit=true;
			if(dbhit){

				String MGR_HEADER_QUERY="";
				String[] PARAM_MGR=null;
				if("1".equals(roletype)){
					MGR_HEADER_QUERY="	select distinct context_id from context_beelets "
					     +" where role_type in ('all',?) "
					     +" and account_type in('all', ?) "
					     +" and app_name='HOME_PAGE' ";
					     PARAM_MGR=new String[]{roletype,pkgtype};
				}else{
					MGR_HEADER_QUERY=" select distinct context_id from context_beelets "
						+" where role_type in ('all','2') "
						+" and account_type in('all', ?) "
						+" and app_name='HOME_PAGE' "
						+" and beelet_id in(select beelet_id from portal_config where config_id in "
						+" (select CONFIG_ID  from PORTAL_CONFIG_MASTER WHERE "
						+" Role_ID=? and app_name='HOME_PAGE')) union select distinct 'portal' as context_id from context_beelets "
						+" union  select distinct 'unit' as context_id from context_beelets where exists "
						+" (select CONFIG_ID  from PORTAL_CONFIG_MASTER WHERE  Role_ID=? AND App_name='CLUB_PAGE') ";
						PARAM_MGR=new String[]{pkgtype,roleid,roleid};

				}
 			  AL=DbUtil.getValues(MGR_HEADER_QUERY,PARAM_MGR);
			  session.setAttribute("MANAGER_MENU_TAB_CONFIG",AL);
			}
			
			if(AL==null) AL=new ArrayList();
			if(conf==null) conf="portal";
			session.setAttribute("MANAGER_MENU_CONF_VALUE",conf);
			for(int i=0;i<beeportCategoryCodes.length;i++) {
				String style_class="tab4";
			if(conf.equalsIgnoreCase(beeportCategoryValues[i]))
				style_class="tab3";
				
			 if(AL.contains(beeportCategoryValues[i])){

		%>
		<td width="100" height="25" align='center' class="<%=style_class%>" >
			<a STYLE="text-decoration: none" href="<%=SERVER_ADDRESS1 %><%=beeportCategoryURLS[i]%>" >
			   <font size="-2" color="#FFFFFF"><%=beeportCategoryCodes[i]%></font></a>
		</td>
		<%
			  }
		        }
			for(int i=AL.size();i<beeportCategoryValues.length;i++){ %>
				<td width='60' height='25' ></td>
		<%	}
		%>
	</tr>
	</table>
	</td></tr>
	<%}%>
	<tr><td valign='top'>
	<table border="0" cellPadding="0" cellSpacing="0" width="100%" height="30" valign='top'>

			<tr><td>
				<table border="0" cellPadding="0" cellSpacing="0" width="100%" height="100%">
					<tr>
						<td width="78%" class="tab5" align='right'>
							<table align='right'><tr>
							<font face="verdana" size="1" color="#FFFFFF">
							<%if(isactive){%>
							<td><a target="_top" href="<%=PageUtil.appendLinkWithGroup(SERVER_ADDRESS1+"/manager/editprofiles/mgrProfile.jsp",(HashMap)request.getAttribute("REQMAP"))%>" STYLE="text-decoration: none">
								<font color="#FFFFFF">My Profile</font>
							</a></td>
							<td></td>
							<%}%>
<td><a STYLE="text-decoration: none" href="javascript:popupwindowspec('<%=SERVER_ADDRESS1 %>/home/links/help/lookandfeel.html','800','800');"><font color="#FFFFFF">Help</font></a></td><td></td>
							<td><a target="_top" href="<%=SERVER_ADDRESS1 %>/manager/mgrlogout.jsp?UNITID=13578" STYLE="text-decoration: none"><font color="#FFFFFF">Logout</font></a></td></font>
							</tr></table></td>
					<td class='tab5' width='2%'></td>
					</tr>
					<tr><td height="2" bgcolor="#FFFFFF"></td><td height="2" bgcolor="#FFFFFF"></td></tr>
					<tr><td colspan='2' height="3" bgcolor="#ff9933"></td><td height="3" bgcolor="#ff9933"></td></tr>

					</table>
			</td></tr>
	</table>
	</td></tr>
	</table>

<%}
}%>

