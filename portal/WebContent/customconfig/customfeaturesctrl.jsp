<%@page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.*,com.eventbee.customconfig.MemberFeatures"%>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<%!

	//static String mustfeatueres="portal,profile,logout";
	
	

%>
<%@ include file="/stylesheets/CoreRequestMap.jsp" %>
<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"customfeaturesctrl.jsp"," Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"manager":"portal";
	
	Authenticate authData=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
	String authid=null,role=null,unitid=null;
	String eunitid=(String) session.getAttribute("entryunitid");
 	 if (authData!=null){      
      	 	 authid=authData.getUserID();
		 role=authData.getRoleName();
		 unitid=authData.getUnitID();
	 }

	String customfeatures=com.eventbee.customconfig.MemberFeatures.MUSTFEATUERES;
	if(request.getParameterValues("customfeature") !=null)
	 customfeatures= customfeatures+","+GenUtil.stringArrayToStr(request.getParameterValues("customfeature"),",");
	 DbUtil.executeUpdateQuery("delete from  member_tabs where unit_id =?",new String[] {unitid} );
	 DbUtil.executeUpdateQuery("insert into member_tabs(unit_id,tab_code) values(?,?)",new String[] {unitid,customfeatures});
	 
	 response.sendRedirect(PageUtil.appendLinkWithGroup("/"+appname+"/customconfig/logic/Done.jsp?message=customfeatures.add.done&title=Member Features",(HashMap)request.getAttribute("REQMAP")));
	
	 
%>
