<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%
String groupid=request.getParameter("groupid");
String sdate=request.getParameter("sdate");
String edate=request.getParameter("edate");
String durationstr =request.getParameter("durationstr");
String textdesc=request.getParameter("textdesc");
String eventname=request.getParameter("eventname");
String location=request.getParameter("location");


    StringBuffer sb=new StringBuffer();
	
	sb.append("<div style='margin-top: -15px; margin-left: 20px;'><a  href=javascript:Show('calendarlinks')>Add to my calendar</a></div><div style=\"height:5px\"></div>");
	sb.append("<div id='calendarlinks' style='display: none; margin: 10 5 10 5;'>");
	//sb.append(" <a href=javascript:popupwindow('"+EbeeConstantsF.get("vcal.webpath","/jboss32/server/default/deploy/home.war/vcal")+"/vcal_event_"+groupid+".ics','VCal','400','400') ><img src='##resourceaddress##/home/images/ical.png' alt='iCal'  border='0' /> iCal</a>");
	sb.append("<a href='/customevents/downloadics.jsp?event_id="+groupid+"&type=calendar'><div style='float:left;margin-right:5px'><img src='##resourceaddress##/home/images/ical.png' alt='iCal'  border='0' /></div><div style='float:left;margin-top:-3px'> iCal</div></a>");
	sb.append(" <br> ");
	sb.append("<a href='/customevents/downloadics.jsp?event_id="+groupid+"&type=outlook'><div style='float:left;margin-right:2px'><img src='##resourceaddress##/home/images/outlook.png' alt='Outlook'  border='0'></img> </div><div style='float:left;margin-top:-3px'>Outlook</div></a>");
	sb.append(" <br> " );
	sb.append(" <a href='http://www.google.com/calendar/event?action=TEMPLATE&text="+eventname+"&dates="+sdate+"/"+edate+"&sprop=website:http://www.eventbee.com&details="+textdesc+"&location="+location+"&trp=true' target='_blank'><div style='float:left;margin-right:5px'><img src='##resourceaddress##/home/images/google.png' alt='Google'  border='0' /></div><div style='float:left;margin-top:-3px'> Google</div></a>");
	sb.append(" <br> " );
	sb.append("<a href='http://calendar.yahoo.com/?v=60&DUR="+durationstr+"&TITLE="+eventname+"&ST="+sdate+"&ET="+edate+"&in_loc="+location+"&DESC="+textdesc+"' target='_blank'><div style='float:left;margin-right:5px'><img src='##resourceaddress##/home/images/yahoo.png' alt='Yahoo'  border='0' /></div><div style='float:left;margin-top:-3px'> Yahoo!</div></a>");
	sb.append(" </div>");
	
	HashMap calenderconent=new HashMap();
	calenderconent.put("calanderLink",sb.toString());
	CacheManager.updateData(groupid+"_eventinfo", calenderconent, false);

%>