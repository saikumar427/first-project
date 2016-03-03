
<%@page import="java.util.UUID"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="com.eventregister.TicketsPageJson,com.eventregister.TicketingInfo, com.eventbee.general.GenUtil,com.eventbee.general.DbUtil" %>
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%

String eid=request.getParameter("eid");
String evtdate=request.getParameter("evtdate");
String ticketurlcode=request.getParameter("ticketurl");
String seating_enable=request.getParameter("seating_enable");
String uid=request.getParameter("uid");
System.out.println("call loadjon eid::"+eid+"uid::"+uid);
TicketsPageJson ticketPage=new TicketsPageJson();
System.out.println("Loadjosn starttime:"+new java.util.Date()+" uid::"+uid+"  eid::"+eid+" mis::"+new java.util.Date().getTime());
JSONObject jsonObj=ticketPage.getJsonTicketsData(eid,evtdate,ticketurlcode);
System.out.println("Loadjosn restime:"+new java.util.Date()+" uid::"+uid+"  eid::"+eid+" mis::"+new java.util.Date().getTime());
String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code in (select currency_code from event_currency where eventid=?)",new String[]{eid});
if(currencyformat==null)
currencyformat="$";
jsonObj.put("currencyformat",currencyformat);
JSONObject ticketPageLabels=(JSONObject) jsonObj.get("TicketDisplayOptions");
String descMode="",grpdescMode="";
try{
descMode=(String) ticketPageLabels.get("event.general.tktDescMode");
}catch(Exception e){
descMode="collapse";
}
try{
grpdescMode=(String) ticketPageLabels.get("event.group.tktDescMode");
}catch(Exception e){
grpdescMode="collapse";
}
jsonObj.put("tktDescMode",descMode);
jsonObj.put("tktgrpDescMode",grpdescMode);
try{
jsonObj.put("ticketstatus",(String) ticketPageLabels.get("event.activetickets.status"));
}catch(Exception e){
}

/* TicketingInfo tktinfo=new TicketingInfo();
jsonObj.put("availibilitymsg",tktinfo.getTicketMessage(eid,evtdate)); */
String discnbuy="dn";
if("YES".equals(seating_enable))
	{jsonObj.put("seatticketid",com.eventregister.SeatingDBHelper.getAllticketid(eid));
	 discnbuy=DbUtil.getVal("select value from config where name='event.discBuy.up' and config_id=(select config_id from eventinfo where eventid=?:: bigint limit 1)",new String[]{eid});
	}
discnbuy=discnbuy==null?"dn":discnbuy;
jsonObj.put("discnbuy",discnbuy);
//System.out.println(jsonObj);
//jsonObj=new JSONObject();
System.out.println(" Loadjosn processtime:"+new java.util.Date()+" uid::"+uid+"  eid::"+eid+" mis::"+new java.util.Date().getTime());
DbUtil.executeUpdateQuery("update config set value=? where config_id=(select config_id from eventinfo where eventid=?::bigint) and name='event.json'", new String []{jsonObj.toString(),eid});


%>
