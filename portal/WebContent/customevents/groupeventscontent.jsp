<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%@ include file='/globalprops.jsp' %>
<%!
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
Vector getGroupEvents(String event_groupid,String particpantid,String friendid,String discountcode){
	Vector vec=new Vector();
	DBManager dbmanager=new DBManager();
	StatusObj stobj=null;
	HashMap<String,String> customBtnLblMap = new HashMap<String,String>();
	//String Query="select u.eventid,e.status,eventname,attrib_value as customregister from  group_events u ,eventinfo e left outer join custom_event_display_attribs on custom_event_display_attribs.eventid=e.eventid  and custom_event_display_attribs.attrib_name='event.reg.orderbutton.label' where  event_groupid=? and e.status in('ACTIVE','CLOSED') and e.eventid=CAST(u.eventid AS BIGINT)  order by u.position";
	String customBtnLblQry="select eventid,lang,y->>'event.reg.orderbutton.label' as btn_lbl from (select  d->'data' as y,eventid,lang from("
					+"select json_array_elements((data->0->'modules')::json) as d,eventid,(data->0->>'lang') as lang from custom_event_display_attribs "
					+"where data->0->'modules' @> '[{\"m\": \"RegFlowWordings\"}]' and eventid in(select eventid from eventinfo where eventid in "
					+"(select eventid::int from group_events where event_groupid=?) and status in('ACTIVE','CLOSED'))) a where d::jsonb->'m'='\"RegFlowWordings\"') x";
	stobj=dbmanager.executeSelectQuery(customBtnLblQry,new String[]{event_groupid});
	if(stobj.getStatus()){
		for(int i=0;i<stobj.getCount();i++){
			String btnLbl=dbmanager.getValue(i,"btn_lbl","");
			String eventid=dbmanager.getValue(i,"eventid","");
			String lang=dbmanager.getValue(i,"lang","en_US");
			if("".equals(btnLbl)){
				btnLbl=getPropValue("reg.btn.lbl",eventid);
			}
			customBtnLblMap.put(eventid,btnLbl);
		}
	}
	
	String Query="select u.eventid,e.status,eventname from group_events u ,eventinfo e where event_groupid=? and e.status in('ACTIVE','CLOSED') and e.eventid=CAST(u.eventid AS BIGINT)  order by u.position";
	stobj=dbmanager.executeSelectQuery(Query,new String[]{event_groupid});
	if(stobj.getStatus()){
		for(int i=0;i<stobj.getCount();i++){
			String btnlabel="";
			if(customBtnLblMap.containsKey(dbmanager.getValue(i,"eventid","")))
				btnlabel=customBtnLblMap.get(dbmanager.getValue(i,"eventid",""));
			if("".equals(btnlabel) || btnlabel==null) btnlabel="Register";
			
			String eventurl=serveraddress+"event?id="+dbmanager.getValue(i,"eventid","")+(particpantid!=null?"&participant="+particpantid:"")+(friendid!=null?"&friendid="+friendid:"")+(discountcode!=null?"&code="+discountcode:"");
			String registerform="<form name='register' action='/event/register?eid="+dbmanager.getValue(i,"eventid","")+"' method='post' >";
			registerform+="<input type='hidden' name='GROUPID' value='"+dbmanager.getValue(i,"eventid","")+"' />";
			registerform+="<input type='hidden' name='eventid' value='"+dbmanager.getValue(i,"eventid","")+"' />";
			if(particpantid!=null&&!"".equals(particpantid))
			registerform+="<input type='hidden' name='participant' value='"+particpantid+"'/>";
			if(friendid!=null&&!"".equals(friendid))
			registerform+="<input type='hidden' name='friendid' value='"+friendid+"'/>";
			if(discountcode!=null&&!"".equals(discountcode))
			registerform+="<input type='hidden' name='code' value='"+discountcode+"'/>";
			registerform+="<input type='hidden' name='newreq' value='yes'/>";
			if("ACTIVE".equals(dbmanager.getValue(i,"status","")))
			registerform+="<input type='submit' name='submit' value='"+btnlabel+"'/>";
			else
			registerform+="<div style=\"height:21px\"></div>";
			registerform+="</form>";
			String registerlink=serveraddress+"event/register?eid="+dbmanager.getValue(i,"eventid","")+"&GROUPID="+dbmanager.getValue(i,"eventid","")+"&isnew=yes";
			HashMap hm=new HashMap();
			
			eventurl=eventurl+"&eventgroupid="+event_groupid;
			
			hm.put("username",dbmanager.getValue(i,"username",""));
			hm.put("eventid",dbmanager.getValue(i,"eventid",""));
			hm.put("eventname",dbmanager.getValue(i,"eventname",""));
			hm.put("eventurl",eventurl);
			hm.put("registerButton",registerform);
			hm.put("registerLink",registerlink);
			vec.addElement(hm);
		}
	}
        return vec;
}
%>

<jsp:include page='/customevents/groupmanagercontent.jsp'/>

<jsp:include page='/main/eventfooter.jsp' />
<%
String participantid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
String friendid=request.getParameter("friendid");
String discountcode=request.getParameter("code");
String event_groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "groupid","GROUPID"});
String loginname =DbUtil.getVal("select login_name from authentication where user_id=(select userid from user_groupevents where event_groupid=?)",new String[]{event_groupid});
String fullusername=(String)request.getAttribute("fullusername");
String userfullnamelink="<a href='"+ShortUrlPattern.get(loginname)+"/network' >Listed by "+fullusername+"</a>";
String mgr_events_link="<a href='"+ShortUrlPattern.get(loginname)+"/events' >View other events by "+fullusername+"</a>";
Vector eventdetails=getGroupEvents(event_groupid,participantid,friendid,discountcode);
String event_group_name=DbUtil.getVal("select group_title from user_groupevents where   event_groupid=?",new String[]{event_groupid});
request.setAttribute("GROUP_EVENTS",eventdetails);
request.setAttribute("GROUP_NAME",event_group_name);
request.setAttribute("GROUPEVENTLISTEDBY",userfullnamelink);
request.setAttribute("MGREVENTSLINK",mgr_events_link);
%>