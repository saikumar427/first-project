<%@ page import="com.eventbee.customconfig.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<%@ include file="/stylesheets/CoreRequestMap.jsp" %>
<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"customlayout.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	String location=request.getParameter(".page");
	
	String cols=request.getParameter("cols");
	String layout=request.getParameter("lo"+cols);
	
	String C1_lst=request.getParameter("C1_lst");
	String C2_lst=request.getParameter("C2_lst");
	String C3_lst=request.getParameter("C3_lst");
	
	String gap=request.getParameter("gap");
	String alignment=request.getParameter("beelt_align");
	String border=request.getParameter("border");
	String groupid=request.getParameter("groupid");
	
	Authenticate authData=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
	String authid=null,role=null,unitid=null;
 	 if (authData!=null){
      	 	 authid=authData.getUserID();
		 role=authData.getRoleName();
		 unitid=authData.getUnitID();
	 }
	
	
	String query="insert into custom_layout (alignment,gap,border,column3,column2,column1,layout,location,user_id,groupid,unit_id) "
		+" values (?,?,?,?,?,?,?,?,?,?,?) ";
		
	DbUtil.executeUpdateQuery("delete from custom_layout where groupid=? and location=? ",new String[]{groupid,location});
	StatusObj stobj=DbUtil.executeUpdateQuery(query,new String[]{alignment,gap,border,C3_lst,C2_lst,C1_lst,layout,location,authid,groupid,unitid});
	if(stobj.getCount()>0)
		response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/customconfig/layoutdone.jsp?location="+location,(HashMap)request.getAttribute("REQMAP")));
	else
		response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/customconfig/layouterror.jsp?location="+location,(HashMap)request.getAttribute("REQMAP")));
	
%>

