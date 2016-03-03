<%@ page import="com.eventbee.general.*, com.eventbee.authentication.Authenticate" %>
<%!
public static class EventMgmtAuth{
public static boolean authenticateManageRequest(String groupid, PageContext pageContext, String purpose){
ServletRequest req=pageContext.getRequest();
boolean authenticated=true;
Authenticate authData=AuthUtil.getAuthData(pageContext);
if (authData!=null){
	String authid=authData.getUserID();
	String mgridselectquery="select count(*) as foundcount from eventinfo where eventid=? and mgr_id=?";
	String foundcount=DbUtil.getVal(mgridselectquery,new String[]{groupid, authid});
	if("0".equals(foundcount)){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.WARNING,"EventMgmtAuth","authenticateManageRequest","Unauthorized "+purpose+" attempt by userid: "+authid +" to the event ID: "+groupid,null);
		authenticated=false;
	}	
}else{
	String mgrtokenid = req.getParameter("mgrtokenid");
	mgrtokenid=mgrtokenid==null?"null":mgrtokenid;
	String mgridselectquery="select mgr_tokenid from manager_tokenids,eventinfo where eventid=? and userid=mgr_id";
	String mgrid=DbUtil.getVal(mgridselectquery,new String[]{groupid});
	if(!("null".equals(mgrtokenid)) && !mgrid.equals(mgrtokenid)){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.WARNING,"EventMgmtAuth","authenticateManageRequest","Unauthorized "+purpose+" attempt by mgrtokenid: "+mgrtokenid +" to the event ID: "+groupid,null);
		authenticated=false;
	}
}
if(!authenticated){	
	req.setAttribute("errormessage",EbeeConstantsF.get("managertokenid.errormessage","You are not allowed to perform this operation"));
	return false;
}
return true;
}
}
%>