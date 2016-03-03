<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*" %>
<%@ page import="java.util.HashMap" %>
<%!
String query="select type,eventname,evt_level,mgr_id from eventinfo where eventid=?";
	HashMap getevtdet(String evtid){
		DBManager dbmanager=new DBManager();
		HashMap hm=new HashMap();
		StatusObj stobj=dbmanager.executeSelectQuery(query,new String[]{evtid});
		if(stobj.getStatus()){
			hm.put("mgr_id",dbmanager.getValue(0,"mgr_id",""));
			hm.put("evttype",dbmanager.getValue(0,"type",""));
			hm.put("eventname",dbmanager.getValue(0,"eventname",""));
			hm.put("evtlevel",dbmanager.getValue(0,"evt_level",""));
		}
		return hm;
	}
%>

<%
String groupid=request.getParameter("GROUPID");
String unitid=request.getParameter("UNITID");	
String mgrtokenid=request.getParameter("mgrtokenid");
if(groupid==null){
request.setAttribute("errormessage","Unable to process request");
%>
<jsp:forward page="/guesttasks/errormessage.jsp" />
<%
}
String authid=null;
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData!=null)authid=authData.getUserID();
HashMap groupinfo=getevtdet(groupid);
String userid=GenUtil.getHMvalue(groupinfo,"mgr_id","",true);
if(!authid.equals(userid)){
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.WARNING,"eventmanage.jsp","","Unauthorized access attempt by userid: "+authid +" to the event ID: "+groupid,null);
request.setAttribute("errormessage",EbeeConstantsF.get("managertokenid.errormessage","You are not allowed to perform this operation"));

%>
<jsp:forward page="/guesttasks/errormessage.jsp" />
<%
}
if(mgrtokenid==null)
mgrtokenid=DbUtil.getVal("select mgr_tokenid from manager_tokenids where userid=?",new String[]{authid});

if(mgrtokenid==null){
String mgrencodedid=EncodeNum.encodeNum(authid);
DbUtil.executeUpdateQuery("insert into manager_tokenids(userid,mgr_tokenid) values(?,?)",new String[]{authid,mgrencodedid});
mgrtokenid=mgrencodedid;
}
request.setAttribute("mgrtokenid",mgrtokenid);
String evtname=GenUtil.getHMvalue(groupinfo,"eventname","",true);
groupinfo.put("GROUPID",groupid);
groupinfo.put("groupid",groupid);
if(unitid!=null){
	groupinfo.put("UNITID",unitid);
	groupinfo.put("unitid",unitid);
}
groupinfo.put("GROUPTYPE","Event");
groupinfo.put("grouptype","Event");
groupinfo.put("PS","eventmanage");

session.setAttribute("groupinfo",groupinfo);
session.removeAttribute("currency");

request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
request.setAttribute("layout", "DEFAULT");
request.setAttribute("tasktitle","Event Manage  > "+evtname );

%>
<%@ include file="/templates/beeletspagetop.jsp" %>

<%
	com.eventbee.web.presentation.beans.BeeletItem item;       
   
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("evtmgmt");
	item.setResource("/eventmanage/mgreventinfoBeelet.jsp");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("discounts");
	item.setResource("/discounts/discountsbeelet.jsp");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("links");
	item.setResource("/editevent/links.jsp");
	leftItems.add(item);
   
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("configevt");
	item.setResource("/eventmanage/ConfigureEvent.jsp");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Noticeboard");
	item.setResource("/noticeboard/mgrnotices.jsp?from=events");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Tracking URLs");
	item.setResource("/eventmanage/trackingurls.jsp");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("eventinfo");	
	item.setResource("/editevent/evtmgmt.jsp");
	rightItems.add(item);		
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("evtmkt");
	item.setResource("/editevent/evtmkt.jsp");
	rightItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("advertising");
	item.setResource("/networkadvertising/advertisingbeelet.jsp");
	rightItems.add(item);	
		
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("agentsinfo");
	item.setResource("/eventbeeticket/agentsinfo.jsp");
	rightItems.add(item);
%>
      		
<%@ include file="/templates/beeletspagebottom.jsp" %>