<%@page import="java.util.HashMap"%>
<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%! 

public void loadSeatingContent(String groupid,String venueid){	
	
	String notavail=null,unassign=null,notavailmsg=null,unassignmsg=null;
	StringBuffer seatingcontent=new StringBuffer();
	String venuecss=DbUtil.getVal("select layout_css from venue_sections where venue_id=CAST(? AS INTEGER)",new String[]{venueid});
	notavail=DbUtil.getVal("select image from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='notavailable'",new String[]{venueid});	
	notavailmsg=DbUtil.getVal("select message from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='notavailable'",new String[]{venueid});	
	unassign=DbUtil.getVal("select image from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='unassign'",new String[]{venueid});		
	unassignmsg=DbUtil.getVal("select message from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='unassign'",new String[]{venueid});		
	
	seatingcontent.append("<style type='text/css'>"+venuecss+"</style>");
	if(notavail!=null) seatingcontent.append("<input type='hidden' name='notavailimage' id='notavailimage' value='"+notavail+"'>");
	if(notavailmsg!=null) seatingcontent.append("<input type='hidden' name='notavailmsg' id='notavailmsg' value='"+notavailmsg+"'>");
	if(unassign!=null) seatingcontent.append("<input type='hidden' name='unassign' id='unassign' value='"+unassign+"'>");
	if(unassignmsg!=null) seatingcontent.append("<input type='hidden' name='unassignmsg' id='unassignmsg' value='"+unassignmsg+"'>");
	HashMap seatingMap=new HashMap();
	seatingMap.put("seatingcontent",seatingcontent.toString());
	CacheManager.updateData(groupid+"_eventinfo", seatingMap, false);
	System.out.println("seating content loading successfully ...");
	
}
%>
<% 
String groupid=request.getParameter("groupid");
String venueid=request.getParameter("venueid");
loadSeatingContent(groupid,venueid);
%>