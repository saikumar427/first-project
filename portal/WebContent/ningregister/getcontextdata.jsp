<%@ page import="com.eventbee.useraccount.AccountDB" %>

<%!
StatusObj FillContextData(String eventid,HttpServletRequest request,String tid){
TicketingManager ticketingManager=new TicketingManager();
String oid=null;
String domain=null;
HashMap networkMap=ticketingManager.getNetWorkDetails(tid);
if(networkMap!=null&&networkMap.size()>0){
domain=(String)networkMap.get("domain");
oid=(String)networkMap.get("oid");
request.setAttribute("oid",oid);
request.setAttribute("domain",domain);

}


String communityMsgQuery="";
String isCommunityEvent=isContainsMemberTickets(eventid);
if("Y".equals(isCommunityEvent)){
String isEventSpecificMsgExists=DbUtil.getVal("select 'Y' from event_ticket_communities where eventid=?",new String []{eventid});

if("Y".equals(isEventSpecificMsgExists))
communityMsgQuery="select ec.loginmsg,ec.description,ec.signupmsg,ec.clubid,c.clubname from event_ticket_communities ec,clubinfo c where c.clubid=ec.clubid and ec.eventid=?";
else
communityMsgQuery="select * from user_communities where userid in(select mgr_id from eventinfo where eventid=?)";
getCommunityMessages(communityMsgQuery,eventid,request);
}

String  SSLProtocol=EbeeConstantsF.get("SSLProtocol","https");
String sslserveraddress=SSLProtocol+"://"+EbeeConstantsF.get("sslserveraddress","www.eventbee.com");
request.setAttribute("serverHTTPSAddress",sslserveraddress);
request.setAttribute("currencySymbol",getEventCurrency(eventid));
request.setAttribute("eid",eventid);
request.setAttribute("eventName",getEventname(eventid));
request.setAttribute("headerContent", getEventHeader(eventid));
request.setAttribute("isCommunityEvent",isCommunityEvent);
request.setAttribute("tid",tid);
request.setAttribute("TaxLabel", "Tax");
request.setAttribute("optTicketsHeaderMessage","Select Ticket Types");
request.setAttribute("pageTitle", "Eventbee - Online EventManagement");
request.setAttribute("reqTicketsHeaderMessage","Select Required Ticket");
request.setAttribute("RegistrationLabel", "Register");
request.setAttribute("serverHTTPAddress","http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com"));
request.setAttribute("TaxLabel", "Tax");
request.setAttribute("TicketsFeeLabel","Fee");
request.setAttribute("TicketsPriceLabel","Price");
request.setAttribute("TicketsQtyLabel","Qty");
request.setAttribute("TaxPercentvalue","0");
String configquery="select * from config where config_id in(select config_id from eventinfo where eventid=?)";
DBManager dbmanager=new DBManager();
StatusObj sb=dbmanager.executeSelectQuery(configquery,new String[]{eventid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++){
if("event.ticketpage.refundpolicy.statement".equals(dbmanager.getValue(i,"name",""))){
request.setAttribute("termsAndConditions",dbmanager.getValue(i,"value",""));
}
if("event.tax.amount".equals(dbmanager.getValue(i,"name","")))
request.setAttribute("TaxPercentvalue",dbmanager.getValue(i,"value","0"));
if("ticket.requiredticketslabel".equals(dbmanager.getValue(i,"name","")))
request.setAttribute("reqTicketsHeaderMessage",dbmanager.getValue(i,"value",""));
if("ticket.optionalticketslabel".equals(dbmanager.getValue(i,"name","")))
request.setAttribute("optTicketsHeaderMessage",dbmanager.getValue(i,"value",""));
if("event.feelabel".equals(dbmanager.getValue(i,"name","")))
request.setAttribute("TicketsFeeLabel",dbmanager.getValue(i,"value",""));
}
}
return new StatusObj(true,"","");
}
void getCommunityMessages(String query,String eventid,HttpServletRequest request){
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String[]{eventid});
if(sb.getStatus()){
request.setAttribute("memberShipDetailsMessage",db.getValue(0,"description",""));
request.setAttribute("MemberLoginMessage",db.getValue(0,"loginmsg",""));
request.setAttribute("memberShipLinkMessage",db.getValue(0,"signupmsg",""));
request.setAttribute("memberCommunity",db.getValue(0,"clubid",""));
HashMap clubinfo=AccountDB.getClubInfo(db.getValue(0,"clubid",""));
String clubname=db.getValue(0,"clubname","");
String userid=(String)clubinfo.get("mgr_id");
String loginname=DbUtil.getVal("select login_name from authentication where auth_id=?", new String []{userid});
String cluburl="";
cluburl=ShortUrlPattern.get(loginname)+"/community/"+(String)clubinfo.get("code")+"/signup";
request.setAttribute("membersignupURL",cluburl);
String loggedinmsg="As a member, you can avail Member Only Tickets";
request.setAttribute("LoggedInMessage",loggedinmsg);

}
}
String isContainsMemberTickets(String eventid){
String isContains=DbUtil.getVal("select 'Y' from event_communities where eventid=?",new String[]{eventid});
if(isContains==null)
isContains="N";
return isContains;
}
String getEventCurrency(String eventid){
String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{eventid});
if(currencyformat==null)
currencyformat="$";
return currencyformat;      
}
String getEventHeader(String eventid){
DBManager dbmanager=new DBManager();
String header="";
StatusObj statobj=dbmanager.executeSelectQuery("select * from configure_looknfeel where refid=? and idtype=? ",new String []{eventid,"eventdetails"});
	if(statobj.getStatus()){
	header=dbmanager.getValue(0,"headerhtml",null);
	}
	return header;
}
String getEventname(String eventid){
String eventName=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{eventid});
return eventName;
}
%>