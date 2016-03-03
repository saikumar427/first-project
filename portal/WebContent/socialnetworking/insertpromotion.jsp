<%@ page import="com.eventbee.general.DbUtil,com.eventbee.general.DateUtil,com.eventbee.general.StatusObj"%>
<%
String mgrId=request.getParameter("mgrid");
String eid=request.getParameter("eid");
String fbuid=request.getParameter("fbuid");
String name=request.getParameter("name");
String nts_code=request.getParameter("nts_code");
eid=(eid==null)?"":eid;
//DbUtil.executeUpdateQuery("insert into social_promoted_users(eventid,fbuid,name,created_at) values(?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))",new String[]{eid,fbuid,name,DateUtil.getCurrDBFormatDate()});
String s=DbUtil.getVal("select 'yes' from ebee_nts_partner where nts_code=? or nts_code_display=?",new String[]{nts_code,nts_code});
System.out.println("s: "+s+", nts: "+nts_code);
	if(s!=null && "yes".equals(s)){
		//StatusObj updateStatusObj=DbUtil.executeUpdateQuery("update nts_visit_track set visit_count=visit_count+1, last_visited_at=now() where eventid=? and nts_code=?",new String[]{groupid,nts_code});
		StatusObj updateStatusObj=DbUtil.executeUpdateQuery("update nts_visit_track set promoted_at=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS') where nts_code=? and eventid=?",new String[]{DateUtil.getCurrDBFormatDate(),nts_code,eid});
		if(updateStatusObj.getCount()==0){
		System.out.println("inserting.....");
			DbUtil.executeUpdateQuery("insert into nts_visit_track (nts_code,eventid,promoted_at,visit_count,ticket_sale_count) values (?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),0,0)",new String[]{nts_code,eid,DateUtil.getCurrDBFormatDate()});
			//DbUtil.executeUpdateQuery("insert into nts_visit_track (nts_code,eventid,last_visited_at,visit_count,ticket_sale_count) values (?,?,now(),1,0)",new String[]{nts_code,groupid});
		}
		DbUtil.executeUpdateQuery("insert into social_promoted_users(eventid,fbuid,name,created_at) values(?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))",new String[]{eid,fbuid,name,DateUtil.getCurrDBFormatDate()});	
	}
%>