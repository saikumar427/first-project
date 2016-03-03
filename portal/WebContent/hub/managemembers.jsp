<%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.customconfig.*" %>

<jsp:include page="/auth/checkpermission.jsp" />

<%!

	final String HUBMEMBERSWITHSTATUS="select first_name,last_name,email,u.user_id,c.statement,c.ismgr,to_char(c.created_at,'Mon DD, YYYY') as created1  from authentication a,user_profile u,club_member c  "
		+" where u.user_id=c.userid and a.user_id=u.user_id and (a.membership_status='DIRECT' or a.membership_status is null) and c.status=?  and  c.clubid=? order by c.created_at desc";
	
	final String HUBMEMBERSAPPROVAL="select first_name,last_name,email,u.user_id,c.statement,c.ismgr,to_char(c.created_at,'Mon DD, YYYY') as created1  from user_profile u,club_member c  "
				+" where u.user_id=c.userid and c.status=?  and  c.clubid=? order by c.created_at desc";
		
	final String HUBPASSIVEMEMBERSWITHSTATUS="select first_name,last_name,email,u.user_id,c.statement,c.ismgr,to_char(c.created_at,'Mon DD, YYYY') as created1  from authentication a,user_profile u,club_member c  "
			+" where u.user_id=c.userid and a.user_id=u.user_id and a.membership_status='INDIRECT' and c.status=?  and  c.clubid=? order by c.created_at desc";
	
	List getHubMembersApprovalWait(String groupid, String status){
			List members=new ArrayList();
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(HUBMEMBERSAPPROVAL,new String[]{status,groupid});
			int recordcount=statobj.getCount();
			if(statobj.getStatus() && recordcount>0 ){
				for (int i=0;i<recordcount;i++){
					String name=(dbmanager.getValue(i,"first_name","")+" "+dbmanager.getValue(i,"last_name","")).trim();
					Map membermap=new HashMap();
					membermap.put("name",name);
					membermap.put("user_id",dbmanager.getValue(i,"user_id","0"));
					membermap.put("email",dbmanager.getValue(i,"email",""));
					membermap.put("statement",dbmanager.getValue(i,"statement",""));
					membermap.put("ismgr",dbmanager.getValue(i,"ismgr",""));
					membermap.put("created_at",dbmanager.getValue(i,"created1",""));
					members.add(membermap);
				}
			}
			return members;
	}		
	List getHubMembersWithStatus(String groupid, String status){
		List members=new ArrayList();
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(HUBMEMBERSWITHSTATUS,new String[]{status,groupid});
		int recordcount=statobj.getCount();
		if(statobj.getStatus() && recordcount>0 ){
			for (int i=0;i<recordcount;i++){
				String name=(dbmanager.getValue(i,"first_name","")+" "+dbmanager.getValue(i,"last_name","")).trim();
				Map membermap=new HashMap();
				membermap.put("name",name);
				membermap.put("user_id",dbmanager.getValue(i,"user_id","0"));
				membermap.put("email",dbmanager.getValue(i,"email",""));
				membermap.put("statement",dbmanager.getValue(i,"statement",""));
				membermap.put("ismgr",dbmanager.getValue(i,"ismgr",""));
				membermap.put("created_at",dbmanager.getValue(i,"created1",""));
				members.add(membermap);
			}
		}
		return members;
	}
	
	List getHubPassiveMembersWithStatus(String groupid, String status){
			List members=new ArrayList();
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(HUBPASSIVEMEMBERSWITHSTATUS,new String[]{status,groupid});
			int recordcount=statobj.getCount();
			if(statobj.getStatus() && recordcount>0 ){
				for (int i=0;i<recordcount;i++){
					String name=(dbmanager.getValue(i,"first_name","")+" "+dbmanager.getValue(i,"last_name","")).trim();
					Map membermap=new HashMap();
					membermap.put("name",name);
					membermap.put("user_id",dbmanager.getValue(i,"user_id","0"));
					membermap.put("email",dbmanager.getValue(i,"email",""));
					membermap.put("statement",dbmanager.getValue(i,"statement",""));
					membermap.put("ismgr",dbmanager.getValue(i,"ismgr",""));
					membermap.put("created_at",dbmanager.getValue(i,"created1",""));
					members.add(membermap);
				}
			}
		return members;
	}

%>

<%
	String userid=null,unitid="";
	unitid=request.getParameter("UNITID");
	String groupid=request.getParameter("GROUPID");
	String displaydel="";
	HashMap hubinfohash=com.eventbee.hub.hubDB.getHubInfo(groupid,null);
	String clubname=GenUtil.getHMvalue(hubinfohash,"clubname","");
	Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
	if (authData!=null){
		userid=authData.getUserID();
	}else{
	HashMap groupinfo=new HashMap();
	groupinfo.put("UNITID","13579");
	groupinfo.put("GROUPID",groupid);
	
	
%>
<jsp:forward page="/mytasks/showhubmessage.jsp" />
<%
	}
	
	List approvalwaitinglist=getHubMembersApprovalWait(groupid,"PENDING");
	List activememberlist=getHubMembersWithStatus(groupid,"ACTIVE");
	List passivememberlist=getHubPassiveMembersWithStatus(groupid,"ACTIVE");
%>

<% 
	//request.setAttribute("tasktitle","Members");
	//request.setAttribute("tasksubtitle","Manage");
	request.setAttribute("NavlinkNames",new String[]{clubname});
	//request.setAttribute("tabtype","club");
	request.setAttribute("subtabtype","Communities");
	String navlinkurl="/portal/hub/clubview.jsp?GROUPID="+request.getParameter("GROUPID");
	request.setAttribute("NavlinkURLs",new String[]{navlinkurl });
%>



<table width='100%' class="taskblock" >
<tr><td><%= (request.getParameter("message")!=null)?request.getParameter("message"):"" %></td></tr>

<%

if(approvalwaitinglist!=null&&approvalwaitinglist.size()>0){	
%>
<!-- approved waiting -->
	
	<tr><td>
		<table width='100%' class='block' cellspacing='0' cellpadding='0'>
		<tr><td colspan='5'><b>Approval Waiting</b></td></tr>
		<tr class="colheader">
		<td >Name</td>
		<td>Joined Date</td>
		<td>Introduction</td>
		<td></td>
		<td></td>
		</tr>
		<% 
			for(int i=0,waitingcount=approvalwaitinglist.size();i<waitingcount;i++){
				String htmltdclass="evenbase";
				if(i%2==0)htmltdclass="oddbase";
				Map membermap=(Map)approvalwaitinglist.get(i);
				String memuserid=GenUtil.getHMvalue(membermap,"user_id","");
				String memlink="/portal/mytasks/networkuserprofile.jsp?userid="+memuserid;
				String name=GenUtil.getHMvalue(membermap,"name","");
				String email=GenUtil.getHMvalue(membermap,"email","");
		%>
		<tr class='<%=htmltdclass %>'>
			<td ><a href='<%=memlink%>'><%= name%></a></td>
			<td><%=GenUtil.getHMvalue(membermap,"created_at","") %></td>
			<td><%=GenUtil.getHMvalue(membermap,"statement","") %></td>
			<td>
			<form name='approve' action="/portal/mytasks/appdec.jsp" method='post' >
			<input type='hidden' name='formname' value='approve' />
			<input type='hidden' name='memuserid' value='<%=memuserid %>' />
			
			<input type='hidden' name='name' value='<%=name %>' />
			<input type='hidden' name='email' value='<%=email %>' />
			<input type='hidden' name='GROUPID' value='<%=request.getParameter("GROUPID") %>' />
			<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
			<input type='submit' name='submit' value='Approve' />
			</form>
			</td>
			<td>
				<form name='decline' action="/portal/mytasks/appdec.jsp" method='post' >
					<input type='hidden' name='formname' value='decline' />
					<input type='hidden' name='memuserid' value='<%=memuserid %>' />
					<input type='hidden' name='name' value='<%=name %>' />
					<input type='hidden' name='email' value='<%=email %>' />
					<input type='hidden' name='GROUPID' value='<%=request.getParameter("GROUPID") %>' />
			<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
			<input type='submit' name='submit' value='Decline' />
			</form>
			</td>
		</tr>
		<% }%>
		</table>
	</td></tr>

<%}%>


<!-- active members -->
<%

if(activememberlist!=null&&activememberlist.size()>0){
	int activememcount=activememberlist.size();
	
	if(activememcount>1)
		displaydel=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))+"<br /><input type='submit' name='submit' value='Delete' />";
%>

<tr><td>
<form name='deletehubmembers' action="/portal/mytasks/hubmembers.jsp" method='post' >
<input type='hidden' name='formname' value='deleteactivemembers' />

<input type='hidden' name='GROUPID' value='<%=groupid%>' />

		<table width='100%' class='block' cellspacing='0' cellpadding='0'>
		<tr><td colspan='3'><b>Members (Active)</b></td></tr>
		
		<tr class="colheader">
		<td>
		<%=displaydel %>
		
		
		</td>
		<td >Name</td>
		<td >Email ID</td>
		<td>Joined Date</td>
		<td>Introduction</td>
		
		</tr>
		<% 
			for(int i=0,activecount=activememberlist.size();i<activecount;i++){
				String htmltdclass="evenbase";
				if(i%2==0)htmltdclass="oddbase";
				Map membermap=(Map)activememberlist.get(i);
				String memuserid=GenUtil.getHMvalue(membermap,"user_id","");
				String memlink="/portal/editprofiles/networkuserprofile.jsp?userid="+memuserid;
				
				String deletestr="<input type='checkbox' name='del1' value='"+memuserid+"' />";
					if("true".equals(GenUtil.getHMvalue(membermap,"ismgr","false")) ){
						deletestr="Moderator";
					}
		%>
		<tr class='<%=htmltdclass %>'>
			<td><%=deletestr %></td>
			<td ><a href='<%=memlink%>'><%=GenUtil.getHMvalue(membermap,"name","") %></a></td>
			<td><%=GenUtil.getHMvalue(membermap,"email","") %></td>
			<td><%=GenUtil.getHMvalue(membermap,"created_at","") %></td>
			<td><%=GenUtil.getHMvalue(membermap,"statement","") %></td>
			
		</tr>
		<% }%>
		</table>
		<% }%>
</form>

<!-- Passive members -->
	<%
	    if(passivememberlist!=null&&passivememberlist.size()>0){
			int passivememcount=passivememberlist.size();
			if(passivememcount>=1)
				displaydel=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))+"<br /><input type='submit' name='submit' value='Delete' />";

		

	%>
	<form name='deletehubmembers' action="/portal/mytasks/hubmembers.jsp" method='post' >
	<input type='hidden' name='formname' value='deletepassivemembers' />
	
	<input type='hidden' name='GROUPID' value='<%=groupid%>' />
	<table width='100%' class='block' cellspacing='0' cellpadding='0'>
		<tr><td colspan='4'><b>Members (Passive)</b></td></tr>

	<tr class="colheader">
	<td>
	<%=displaydel %>
	</td>
	<td >Name</td>
	<td  colspan='2'>Email ID</td>

	</tr>
	<% 
		for(int i=0,passivecount=passivememberlist.size();i<passivecount;i++){
			String htmltdclass="evenbase";
			if(i%2==0)htmltdclass="oddbase";
			Map membermap=(Map)passivememberlist.get(i);
			String memuserid=GenUtil.getHMvalue(membermap,"user_id","");
			String memlink="/portal/editprofiles/networkuserprofile.jsp?userid="+memuserid;

			String deletestr="<input type='checkbox' name='del2' value='"+memuserid+"' />";
				if("true".equals(GenUtil.getHMvalue(membermap,"ismgr","false")) ){
					deletestr="Moderator";
				}
	%>
	<tr class='<%=htmltdclass %>'>
		<td width='20%'><%=deletestr %></td>
		<td width='30%'><%=GenUtil.getHMvalue(membermap,"name","") %></td>
		<td width='40%'><%=GenUtil.getHMvalue(membermap,"email","") %></td>
		<td width='20%'><a href='/mytasks/editpassivemem.jsp?GROUPID=<%=groupid%>&userid=<%=GenUtil.getHMvalue(membermap,"user_id","false")%>'>Edit</a></td>

	</tr>
	<% }%>
	</table>

</form>
	</td></tr>

<%}%>
</table>

