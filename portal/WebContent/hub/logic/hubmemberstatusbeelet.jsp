<%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.customconfig.*" %>

<%!


	String CONFIG_GET = " select value as desc from config "
			  +" where config_id=(select config_id from clubinfo where "
			  +" clubid=?) and name=?";


	public String inviteFriendToJoin(HashMap REQMAP){
		StringBuffer sb1=new StringBuffer();
		sb1.append("<tr>");	
				sb1.append("<td align='center'>");
					sb1.append("<table border='0' cellpadding='0' cellspacing='0'>");
						sb1.append("<form name='f' action='/portal/club/invitefriends.jsp' method='post'>");
						sb1.append("<tr><td>");
							sb1.append(com.eventbee.general.PageUtil.writeHiddenCore(REQMAP));
							sb1.append("<input type='submit' name='submit' value='Invite Friends to Join' />");
						sb1.append("</td></tr>");
						sb1.append("</form>");
					sb1.append("</table>");
				sb1.append("</td>");
			sb1.append("</tr>");
		return sb1.toString();	
	}
	String getData(String userid,String groupid,String unitid,String border,String width,Authenticate authData,HashMap REQMAP){
		
		String custombutton="";
		custombutton=DbUtil.getVal(CONFIG_GET,new String[]{groupid,"club.custom.joinbutton"});
		if(custombutton==null||"null".equals(custombutton)||"".equals(custombutton))
		custombutton="Join Community";

		if(custombutton.indexOf("'")>-1){
			custombutton=custombutton.replaceAll("'","&#39;");
		}


		StringBuffer sb=new StringBuffer();
		StringBuffer sb1=new StringBuffer();
		String title="";
		String attr="";
		final String club_title="Community";
		String link="/portal/editprofiles/networkuserprofile.jsp?userid="+userid;
		
		if(authData!=null){
			//title="Welcome  <a href='"+link+"'>"+authData.getUserName()+"</a>";
			title="Welcome  <a href='"+link+"'>"+authData.getUserName()+"</a>";
			attr="cellpadding='5'  class='beelet'  cellspacing='0' ";
		}	
		else{
			border="0";attr="cellpadding='0'  cellspacing='0'";
		}	
		String memberhubstatus =HubMaster.getUsersHubStatus(userid,groupid);
		
		if("HUBGUEST".equalsIgnoreCase(memberhubstatus) || "GUEST".equalsIgnoreCase(memberhubstatus)){
			title="";
			sb1.append("<tr class='oddbase'>");
				
					sb1.append("<td align='center'>");
					sb1.append("<table border='0' cellpadding='0' cellspacing='0'>");
					sb1.append("<form name='f' action='/portal/hub/join.jsp' method='post'>");
					sb1.append("<tr><td>");
						sb1.append(com.eventbee.general.PageUtil.writeHiddenCore(REQMAP));
						sb1.append("<input type='submit' name='submit' value='"+custombutton+"' />");
					sb1.append("</td></tr>");
					sb1.append("</form>");
					sb1.append("</table>");
					
				sb1.append("</td>");
			sb1.append("</tr>");
		}else if("HUBMGR".equalsIgnoreCase(memberhubstatus) ){
			sb1.append("<tr>");
				sb1.append("<td align='center'>");
					sb1.append("<table border='0' cellpadding='0' cellspacing='0'>");
						sb1.append("<form name='f' action='/portal/hub/clubmanage.jsp' method='post'>");
						sb1.append("<tr><td>");
							sb1.append(com.eventbee.general.PageUtil.writeHiddenCore(REQMAP));
							sb1.append("<input type='submit' name='submit' value='Manage "+club_title+"' />");
						sb1.append("</td></tr>");
						sb1.append("</form>");
					sb1.append("</table>");
				sb1.append("</td>");
			sb1.append("</tr>");
			sb1.append(inviteFriendToJoin(REQMAP));
		}else if("HUBMEMBER".equalsIgnoreCase(memberhubstatus) ){
			sb1.append("<tr>");
				sb1.append("<td align='center'>");	
					sb1.append(" Member since "+DbUtil.getVal("select to_char(created_at,'DD Mon, YYYY') from club_member where clubid=? and userid=?",new String[]{groupid,userid}));
				sb1.append("</td>");
			sb1.append("</tr>");
			sb1.append(inviteFriendToJoin(REQMAP));
		}else if("INVALID".equalsIgnoreCase(memberhubstatus) ){
			//sb.append("<tr><td align='center'>Join invald</td></tr>");
		}else{
			if(memberhubstatus!= null){
				sb1.append("<tr>");
					sb1.append("<td align='center'>");
					if("PENDING".equalsIgnoreCase(memberhubstatus) )
						sb1.append("Approval Waiting");
					else
						sb1.append(memberhubstatus);
					sb1.append("</td>");
				sb1.append("</tr>");
			}else{
				DBManager dbmanager=new DBManager();
				StatusObj statobj=dbmanager.executeSelectQuery( "select mgr_comments,status  from club_member where userid=? and clubid=?",new String[]{userid,groupid});
				if(statobj.getStatus() && statobj.getCount()>0 ){
					String status=dbmanager.getValue(0,"status",null);
					String mgr_comments=dbmanager.getValue(0,"mgr_comments","");
					sb1.append("<tr>");
						sb1.append("<td align='center'>");
							if("PENDING".equalsIgnoreCase(status) )
								sb1.append("Approval Waiting");
							else
								sb.append(status);
							sb1.append("<br />"+mgr_comments);
						sb1.append("</td>");
					sb1.append("</tr>");
				}
				
			}
		}
		sb.append(PageUtil.startContent(null,border,width,true));
		sb.append("<table  width='100%' cellpadding='0' cellspacing='0' border='0'>");
			
			if(title!=null && !"".equals(title.trim())){
			sb.append("<tr>");
				sb.append("<td align='center'>");
					sb.append(title);
				sb.append("</td>");
			sb.append("</tr>");
			}
			sb.append(sb1.toString());
			
		sb.append("</table>");
		sb.append(PageUtil.endContent());
		return sb.toString();
	}

%>
<%
	String userid=null,unitid=null;
	String groupid=null;
	
	Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
	if (authData!=null){
		userid=authData.getUserID();
		
	}
	unitid=request.getParameter("UNITID");
	if(unitid==null)unitid="13579";
	
	
	 HashMap hm=(HashMap)session.getAttribute("groupinfo");
	 groupid=(hm!=null)?(String)hm.get("groupid"):request.getParameter("GROUPID");
	
	 
if(groupid !=null){

%>

<%= getData( userid, groupid, "13579",request.getParameter("border"),request.getParameter("width"),authData,(HashMap) request.getAttribute("REQMAP"))%>

<%}%>
