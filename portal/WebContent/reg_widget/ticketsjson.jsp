<%@page import="com.eventbee.general.GenUtil"%>
<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%@page import="com.eventregister.TicketingInfo"%>
<%@page import="java.util.HashMap"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="com.eventregister.TicketsPageJson" %>
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%
long starttime=System.currentTimeMillis();	
String eid=request.getParameter("eid");
String waitListId=request.getParameter("wid");
waitListId=waitListId==null?"":waitListId;
System.out.println("in ticketsjson.jsp eventid: "+eid+"waitListId :"+waitListId);
String evtdate=request.getParameter("evtdate");
String ticketurlcode=request.getParameter("ticketurl");
String seating_enable=request.getParameter("seating_enable");
HashMap configMap=null;
try{
	configMap=(HashMap)CacheManager.getData(eid, "eventinfo").get("configmap");
}catch(Exception e){
	System.out.println("Exception in ticketsjson page for configMap from cache msg ERROR: "+e.getMessage());
}
String isPriority=GenUtil.getHMvalue(configMap,"event.priority.enabled","N");
String priregtoken=request.getParameter("priregtoken");
String priregtype=request.getParameter("priregtype");
String prilistid=request.getParameter("prilistid");
HashMap<String, String> params=null;
if(!"".equals(priregtype)  && "Y".equals(isPriority)){
	params=new HashMap<String, String>();
	params.put("priregtoken",priregtoken);
	params.put("priregtype",priregtype);
	params.put("prilistid",prilistid);
}
TicketsPageJson ticketPage=new TicketsPageJson();
JSONObject jsonObj=ticketPage.getJsonTicketsData(eid,evtdate,ticketurlcode,params);
if(!"".equals(waitListId))
	ticketPage.getWaitListDetails(eid,waitListId,jsonObj); 

try{
	//HashMap configMap=(HashMap)CacheManager.getData(eid, "ticketsettings").get("configmap");
if(configMap!=null && configMap.get("event.buybutton.beside.discount")!=null)
	jsonObj.put("buybuttonbeside",configMap.get("event.buybutton.beside.discount"));
}catch(Exception e){
	System.out.println("Exception in ticketsjson page for buybuttonbeside msg ERROR: "+e.getMessage());
}

try{
	if(jsonObj.length()>0 && jsonObj.has("status") && "blockedbytraffic".equals(jsonObj.get("status"))){
		jsonObj.put("msg","Please wait, more people are accessing the event page than maximum allowed. You will be automatically taken to the event page as soon as possible!"+
                "<br/><div style='height:14px'></div><b><span id='blockedtimer' style='align:center;font-size:16px'><img src='/main/images/home/trafficloader.gif'></span></b>");
	}
}catch(Exception e){
	System.out.println("Exception in ticketsjson page for hightraffic msg ERROR: "+e.getMessage());
}

long totaltime=(System.currentTimeMillis())-starttime;
System.out.println("TicketsPageJson: "+eid+" Total time taken: "+totaltime+" MS");
out.println(jsonObj);
%>
