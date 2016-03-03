<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.hub.HubMaster" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*" %>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CheckPermission.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	boolean redirect=false;
	Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate) session.getAttribute("authData");
	if(authData==null){ %>
		<%-- commented to avoid the message showing <Login> 
		<jsp:forward page='/auth/authenticateMessage.jsp' />--%>
		<jsp:forward page='/auth/listauth.jsp' />
	<%}else{
		String userid=authData.getUserID();
		String role=authData.getRoleName();
		String unitid=authData.getUnitID();
		String pkgtype=authData.getUnitPkgType();
		String roletype=authData.getRoleTypeCode();  //CUSTOM or 
		String id=null;
		String authtype=request.getParameter("authtype");
		id=request.getParameter("GROUPID");
		if(authtype==null || "".equals(authtype.trim()) || "null".equals(authtype.trim())){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"checkpermission.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID()+", Authtype: "+authtype:"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);	
		}else if("clubmanage".equals(authtype)){
			if(id!=null){
				String st=HubMaster.getUsersHubStatus(userid,id);  // Possibilities are   GUEST, HUBGUEST, HUBMGR, HUBMEMBER
				if("HUBMGR".equals(st)){
				}else{
				  	redirect=true;
					request.setAttribute("violationmsg","You are not allowed to perform this operation");
				 }
			}else{
				redirect=true;
				request.setAttribute("violationmsg","Sorry, request cannot be processed at this time");
			}
		}else if("eventmanage".equals(authtype)){
			if(id!=null){
				String authid=DbUtil.getVal("select mgr_id from eventinfo where eventid=?",new String [] {id});
				if(userid.equals(authid)){
				}else{
				  	redirect=true;
					request.setAttribute("violationmsg","You are not allowed to perform this operation");
				 }
   			}else{
				redirect=true;
				request.setAttribute("violationmsg","Sorry, request cannot be processed at this time");
			}
		}else if("noticeupdate".equals(authtype)){
			String owner=DbUtil.getVal("select owner from notice where noticeid=? and groupid=? ",new String[]{request.getParameter("noticeid"),id});
			if(owner!=null && owner.equals(userid)){
			}else{
				redirect=true;
				request.setAttribute("violationmsg","You are not allowed to perform this operation");
			}
		}
		else if("logs".equals(authtype)){
			String owner=DbUtil.getVal("select userid from log_master where logid=? ",new String[]{request.getParameter("logid")});
			if(owner!=null && owner.equals(userid)){
			}else{
				redirect=true;
				request.setAttribute("violationmsg","You are not allowed to perform this operation");
			}
		}

	}
	if(redirect){%>
		<jsp:forward page='/guesttasks/permissionviolate.jsp'/>
	<%}%>
