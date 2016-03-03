<%@ page import="java.util.*,java.sql.*,java.text.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.event.ticketinfo.*" %>
<%@ page import="com.eventbee.editevent.*" %>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.contentbeelet.*"%>
<%@ page import="com.eventbee.polls.*" %>
<%@ page import="com.eventbee.general.DBQueryObj.*"%>
<%@ page import="com.eventbee.event.EventsContent" %>
<%@ page import="com.eventbee.eventpartner.*" %>
<%@ page import="com.eventbee.streamer.*"%>
<%@ include file="../getresourcespath.jsp" %>
<%@ include file='/globalprops.jsp' %>
<script type="text/javascript" language="JavaScript" src="<%=resourceaddress%>/home/js/ajax.js">
        function dummy1() { }
</script>
<script type="text/javascript" language="JavaScript" src="<%=resourceaddress%>/home/js/advajax.js">
        function dummy1() { }
</script>
<script type="text/javascript" language="JavaScript" src="<%=resourceaddress%>/home/js/inlinecalendar.js">
        function dummy2() { }
        
</script>

<script>
function handleNewDate(Day, Month, Year){
document.getElementById('d').value=Day;
document.getElementById('m').value=Month;
document.getElementById('y').value=Year;

document.venueEventsForm.submit();

}


</script>

<%!

String getLoginName(String userid){

String loginname=DbUtil.getVal("select login_name from authentication where user_id=?",new String[]{userid});

return loginname;


}





String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";


public Vector upcomingevents(Vector vec,String userid,String Query){
	
	return upcomingevents(vec,userid,Query,"");
}


public Vector upcomingevents(Vector vec,String userid,String Query,String type)
{
DBManager dbmanager=new DBManager();
StatusObj stobj=null;
if("selected".equals(type))
stobj=dbmanager.executeSelectQuery(Query,null);
else
stobj=dbmanager.executeSelectQuery(Query,new String[]{userid});
	if(stobj.getStatus()){
		for(int i=0;i<stobj.getCount();i++){
			HashMap hm=new HashMap();
			hm.put("userName",dbmanager.getValue(i,"username",""));
			String eid=dbmanager.getValue(i,"eventid","");
			hm.put("eventId",eid);
			hm.put("eventName",dbmanager.getValue(i,"eventname",""));
			hm.put("startdate",dbmanager.getValue(i,"startdate",""));
			String venuename=dbmanager.getValue(i,"venue","");
			String city=dbmanager.getValue(i,"city","");
			String state=dbmanager.getValue(i,"state","");
			String country=dbmanager.getValue(i,"country","");
			String address="";
			if(!"".equals(venuename)) address+=venuename;
			if(!"".equals(city)) address+=", "+city;
			if(!"".equals(state)) address+=", "+state;
			if(!"".equals(country)) address+=", "+country;
			if(address.startsWith(", "))
			address=address.substring(2);
			if(!"".equals(address))
				hm.put("address",address);
			String desc=dbmanager.getValue(i,"description","");
			String photourl=dbmanager.getValue(i,"photourl","");
			if(desc==null) desc="";
			if(photourl==null) photourl="";
			if(!"".equals(desc.trim())){  
				hm.put("description",desc);
				hm.put("descid",eid);
			}
			if(!"".equals(photourl.trim()))  hm.put("photo_url",photourl);			
			String sdate=dbmanager.getValue(i,"start_date","");
			String edate=dbmanager.getValue(i,"enddate","");
			String stime=DateTime.getTimeAM(dbmanager.getValue(i,"starttime",""));
			String etime=DateTime.getTimeAM(dbmanager.getValue(i,"endtime",""));
			String eventdate="";
			if(sdate.equals(edate)){
				eventdate=sdate+", "+stime+" - "+etime;
			}
			else
				eventdate=sdate+" "+stime+" - "+edate+" "+etime;
			hm.put("eventDate",eventdate);
			vec.addElement(hm);
		}
	}
	return vec;
}

HashMap getnetadvevents(Vector v1){
HashMap hm=null;
HashMap hm1=new HashMap();
for(int j=0;j<v1.size();j++){
hm=(HashMap)v1.elementAt(j);
hm1.put("eventid"+j,(String)hm.get("eventid"));
}
return hm1;			

}

Vector getVenueEvents(String userid,String selcteddate){
 java.util.Date date = new java.util.Date(); 
 String query=null;
 String params[]=new String[]{userid,selcteddate};
 DBManager dbmanager=new DBManager();
 if(selcteddate==null||"".equals(selcteddate)){
 query="select eventname,e.eventid,start_date,to_char(e.start_date,'Mon DD') as startdate,to_char(e.end_date,'Mon DD') as enddate,starttime,endtime,descriptiontype,description,mgr_id  from eventinfo e,zone_events z where e.eventid=CAST(z.eventid as INTEGER) and z.zoneid=? and e.status not in('INACTIVE','PENDING','CANCEL')   union all select eventname,eventid,start_date,to_char(start_date,'Mon DD') as startdate,to_char(end_date,'Mon DD') as enddate,starttime,endtime,descriptiontype,description,mgr_id from eventinfo where mgr_id=CAST(? AS INTEGER) and status not in('INACTIVE','PENDING','CANCEL') and start_date>now() order by start_date  ";
 params=new String[]{userid,userid};
 }
 else{
 query="select eventname,e.eventid,start_date,to_char(e.start_date,'Mon DD') as startdate,to_char(e.end_date,'Mon DD') as enddate ,starttime,endtime,descriptiontype,description,mgr_id from eventinfo e,zone_events z where e.eventid=CAST(z.eventid as INTEGER) and z.zoneid=? and e.status not in('INACTIVE','PENDING','CANCEL') and to_date(?,'YYYY-MM-DD') between to_date(e.start_date::text,'YYYY-MM-DD') and to_date(e.end_date::text,'YYYY-MM-DD')  union select eventname,eventid,start_date,to_char(start_date,'Mon DD') as startdate,to_char(end_date,'Mon DD') as enddate,starttime,endtime,descriptiontype,description,mgr_id from eventinfo where mgr_id=CAST(? AS INTEGER) and status not in('INACTIVE','PENDING','CANCEL') and to_date(?,'YYYY-MM-DD') between to_date(start_date::text,'YYYY-MM-DD') and to_date(end_date::text,'YYYY-MM-DD') order by start_date";
 params=new String[]{userid,selcteddate,userid,selcteddate};
 }
 Vector vec=null;
StatusObj stobj=dbmanager.executeSelectQuery(query,params);
if(stobj.getStatus()){
vec=new Vector();
		for(int i=0;i<stobj.getCount();i++){
			HashMap hm=new HashMap();
			hm.put("eventid",dbmanager.getValue(i,"eventid",""));
			hm.put("eventName",dbmanager.getValue(i,"eventname",""));
			hm.put("startDate",dbmanager.getValue(i,"startdate",""));
			hm.put("endDate",dbmanager.getValue(i,"enddate",""));
			if("text".equals(dbmanager.getValue(i,"descriptiontype","")))
			hm.put("description",dbmanager.getValue(i,"description",""));
			hm.put("startTime",DateTime.getTimeAM(dbmanager.getValue(i,"starttime","")));
			hm.put("endTime",DateTime.getTimeAM(dbmanager.getValue(i,"endtime","")));
			hm.put("registerButton",getRegButton(dbmanager.getValue(i,"eventid","")));
			hm.put("eventPageUrl",serveraddress+"event?eid="+dbmanager.getValue(i,"eventid",""));
			hm.put("listedBy",getListedBy(dbmanager.getValue(i,"mgr_id","")));
			vec.addElement(hm);
		}
	}
	return vec;
}

String getRegButton(String eventid){

String Query="select value as customregister from  eventinfo e left outer join config on config.config_id=e.config_id  and config.name= 'event.cnr' where e.eventid=CAST(? AS INTEGER)";
String value=DbUtil.getVal(Query,new String[]{eventid});
String registerform="<form name='register' action='/event/register?eid="+eventid+"' method='post' >";
registerform+="<input type='hidden' name='GROUPID' value='"+eventid+"' />";
registerform+="<input type='hidden' name='eventid' value='"+eventid+"' />";
registerform+="<input type='submit' name='submit' value='"+value+"'/>";
registerform+="</form>";

return registerform;

}

HashMap<String,String> getCustomizeButtons(String userid,String showtype,String csvWithQuote){
	
	String Query="";
	/* if("ALL".equals(showtype))
	Query="select attrib_value as customregister,e.eventid,value as isrsvp from  eventinfo e  left outer join custom_event_display_attribs b on(e.eventid=b.eventid  and attrib_name='event.reg.orderbutton.label' and module='RegFlowWordings')"
							+" left outer join  config  c on(e.config_id=c.config_id and name='event.rsvp.enabled' ) where e.mgr_id=CAST(? AS INTEGER)" ;
	else
	Query="select attrib_value as customregister,e.eventid,value as isrsvp from  eventinfo e  left outer join custom_event_display_attribs b on(e.eventid=b.eventid  and attrib_name='event.reg.orderbutton.label' and module='RegFlowWordings')"
			+" left outer join  config  c on(e.config_id=c.config_id and name='event.rsvp.enabled' ) where e.eventid in("+csvWithQuote+")" ; */
			
			
	String customBtnLblQry="";
	
	if("ALL".equals(showtype)){
		
		customBtnLblQry="select eventid,lang,y->>'event.reg.orderbutton.label' as btn_lbl from (select  d->'data' as y,eventid,lang from("+
				"select json_array_elements((data->0->'modules')::json) as d,eventid,(data->0->>'lang') as lang from custom_event_display_attribs where data->0->'modules' @> '[{\"m\": \"RegFlowWordings\"}]' "+
				"and eventid in(select eventid from eventinfo where mgr_id=CAST(? AS INTEGER))) a where d::jsonb->'m'='\"RegFlowWordings\"') x";
		
		Query="select e.eventid,value as isrsvp from eventinfo e left outer join config c on(e.config_id=c.config_id and name='event.rsvp.enabled' )" 
			+" where e.mgr_id=CAST(? AS INTEGER)" ;
	}else{
			
		customBtnLblQry="select eventid,lang,y->>'event.reg.orderbutton.label' as btn_lbl from (select  d->'data' as y,eventid,lang from("+
				"select json_array_elements((data->0->'modules')::json) as d,eventid,(data->0->>'lang') as lang from custom_event_display_attribs where data->0->'modules' @> '[{\"m\": \"RegFlowWordings\"}]' "+
				"and eventid in("+csvWithQuote+")) a where d::jsonb->'m'='\"RegFlowWordings\"') x";
		
		Query="select e.eventid,value as isrsvp from eventinfo e left outer join config c on(e.config_id=c.config_id and name='event.rsvp.enabled' )"
			+" where e.eventid in("+csvWithQuote+")" ;
		}
	DBManager db=new DBManager();	
	HashMap<String,String>  buttonsMap=new HashMap<String,String>();
	HashMap<String, String> customBtnLblMap=new HashMap<String, String>();
	StatusObj stobj=null;
	if("ALL".equals(showtype)){
		customBtnLblMap=getCustomBtnLabelMap(customBtnLblQry,userid);
		stobj=db.executeSelectQuery(Query,new String[]{userid});
	}else{
		customBtnLblMap=getCustomBtnLabelMap(customBtnLblQry,null);
		stobj=db.executeSelectQuery(Query,null);	
	}
	if(stobj.getStatus()){
			for( int i=0;i<stobj.getCount();i++){
				String isrsvp=db.getValue(i,"isrsvp","");
				//String btnlabel=db.getValue(i,"customregister","");
				String btnlabel="";
				String eventid=db.getValue(i,"eventid","");
				String btnhtml="";
				/* if(isrsvp.equalsIgnoreCase("yes"))
					btnlabel="RSVP";
				else{ */
					if(customBtnLblMap.containsKey(eventid))
						btnlabel=customBtnLblMap.get(eventid);
					if("".equals(btnlabel) || btnlabel==null)
						btnlabel="Register";
				//}
				String registerform="<form action='/event?eid="+eventid+"' method='post' >";
				registerform+="<input type='submit' name='submit' value='"+btnlabel+"'/>";
				registerform+="</form>";
				buttonsMap.put(eventid,registerform);
			}
	}
	return buttonsMap;
}

HashMap<String,String> getCustomBtnLabelMap(String query,String userid){
	HashMap<String,String> customBtnLblMap = new HashMap<String,String>();
	try{
		DBManager db=new DBManager();
		StatusObj stobj=null;
		if(userid !=null)
			stobj=db.executeSelectQuery(query,new String[]{userid});
		else 
			stobj=db.executeSelectQuery(query,null);
		if(stobj.getStatus()){
			for( int i=0;i<stobj.getCount();i++){
				String btnLbl=db.getValue(i,"btn_lbl","");
				String eventid=db.getValue(i,"eventid","");
				String lang=db.getValue(i,"lang","en_US");
				if("".equals(btnLbl.trim())){
					btnLbl=getPropValue("reg.btn.lbl",eventid);
				}
				customBtnLblMap.put(eventid,btnLbl);
			}
		}
	}catch(Exception e){
		
	}
	return customBtnLblMap;
}

HashMap<String,String> getBoxOfficeDetails(String userid){
	String query="select boxoffice_id,description,header,photo_url,events_display_type from box_office_master where userid=?";
	DBManager db=new DBManager();
	HashMap<String,String> boxofficeDetails=new HashMap<String,String>();
	StatusObj stobj=db.executeSelectQuery(query,new String[]{userid});
	if(stobj.getStatus()){
		boxofficeDetails.put("boxoffice_id",db.getValue(0,"boxoffice_id",""));
		String desc=db.getValue(0,"description","");
		String photo=db.getValue(0,"photo_url","");
		if(desc==null) desc="";
		if(photo==null) photo="";
		if(!"".equals(desc.trim())) 
			boxofficeDetails.put("description",desc);
		if(!"".equals(photo.trim())) 
			boxofficeDetails.put("photo_url",photo);
		boxofficeDetails.put("header",db.getValue(0,"header",""));
		boxofficeDetails.put("events_display_type",db.getValue(0,"events_display_type",""));
	}
	return boxofficeDetails;
}
String box_office_events="select eventid from box_office_events where boxoffice_id=(select boxoffice_id from box_office_master where userid=?) order by position";	
ArrayList<String> getBoxOfficeEvents(String userid){
		ArrayList<String> boxoffice_events=new ArrayList<String>();
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(box_office_events,new String[]{userid});
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				boxoffice_events.add(db.getValue(i,"eventid",""));
			}
		}
		return boxoffice_events;
	}

String group_events_query="select a.eventid,b.group_title from group_events a,user_groupevents b,eventinfo c where a.event_groupid =b.event_groupid and cast(a.eventid as numeric)=c.eventid and c.status='ACTIVE' and c.listtype='PBL' and c.end_date>=now()::date and b.userid=? order by a.position";


String getListedBy(String userid){

String Query="select first_name ||' ' ||  last_name as username from  user_profile where user_id=?";

String username=DbUtil.getVal(Query,new String[]{userid});

return username;
}

	HashMap<String,String> getGroupEvents(String userid){
		HashMap<String,String> groupEvents=new HashMap<String,String>();
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(group_events_query,new String[]{userid});
		for(int i=0;i<sb.getCount();i++){
			groupEvents.put(db.getValue(i,"eventid",""),db.getValue(i,"group_title",""));
		}
		return groupEvents;
	}
	HashMap<String,ArrayList<String>> getGroupEventList(String userid){
		HashMap<String,ArrayList<String>> grpeventmap=new HashMap<String,ArrayList<String>>();
		ArrayList<String> events;
		DBManager dbmanager=new DBManager();
		String query="select a.eventid,b.event_groupid from group_events a,user_groupevents b,eventinfo c  where a.event_groupid =b.event_groupid and cast(a.eventid as numeric)=c.eventid and c.status='ACTIVE' and c.listtype='PBL' and c.end_date>=now()::date and b.userid=? order by b.event_groupid, a.position";
		StatusObj stobj=dbmanager.executeSelectQuery(query, new String[]{userid});
		for(int i=0;i<stobj.getCount();i++){
			String grpid=dbmanager.getValue(i, "event_groupid", "");
			if(grpeventmap.containsKey(grpid)){
				events=grpeventmap.get(grpid);
				events.add(dbmanager.getValue(i, "eventid", ""));
			}else{
				events=new ArrayList<String>();
				events.add(dbmanager.getValue(i, "eventid", ""));
				grpeventmap.put(grpid, events);
			}
		}
		return grpeventmap;
	}
	ArrayList<HashMap<String,String>> getUserEventGroups(String userid){
		ArrayList<HashMap<String,String>> grpdetails=new ArrayList<HashMap<String,String>>();
		String query="select event_groupid,group_title from user_groupevents where userid=? order by created_at";
		DBManager dbmanager=new DBManager();
		StatusObj stobj=dbmanager.executeSelectQuery(query, new String[]{userid});
		for(int i=0;i<stobj.getCount();i++){
			HashMap <String,String> grp=new HashMap<String,String>();
			grp.put("groupid",dbmanager.getValue(i, "event_groupid", ""));
			grp.put("group_title",dbmanager.getValue(i, "group_title", ""));
			grpdetails.add(grp);
		}
		return grpdetails;
	}


%>
<%
String platform=(String)session.getAttribute("platform");
String ningvid=request.getParameter("ningviwer");
String ningoid=request.getParameter("ningowner");
String CLASS_NAME="eventspagecontent.jsp";
String authid=(String)request.getAttribute("userid");
String username=(String)request.getAttribute("fullusername");
String name=(String)request.getAttribute("username");
	com.eventbee.general.StatusObj sobj=DbUtil.getKeyValues("select pref_name,pref_value from member_preference where user_id=? ",new String[]{authid});
	HashMap prefMap=new HashMap();
	if(sobj.getCount()>0){
		prefMap=(HashMap) sobj.getData();
	}
	String photodisp=GenUtil.getHMvalue(prefMap,"events.photoDisplay","Yes");
	String profiledisp=GenUtil.getHMvalue(prefMap,"events.ProfileDisplay","");
	String pasteventsdisp=GenUtil.getHMvalue(prefMap,"events.pastEvents","Yes");
	String upcomingeventsdisp=GenUtil.getHMvalue(prefMap,"events.upcomingEvents","Yes");
	String eventsphotoid=GenUtil.getHMvalue(prefMap,"events.photo.photoid","");
 	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "photodisp value is "+photodisp, null);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "profiledisp value is "+profiledisp, null);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "pasteventsdisp value is "+pasteventsdisp, null);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "upcomingeventsdisp value is "+upcomingeventsdisp, null);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "eventsphotoid value is "+eventsphotoid, null);

%>

<%!
String GET_EVENT_PHOTO="select value  from config where config_id=CAST(? AS INTEGER) and  name=?";
%>
<%
//EventsPhoto Display Block
String imgname=null,imgpath="",eventsQuery="",sel_events_query="";
String header="";
if("yes".equalsIgnoreCase(photodisp)&&!"".equals(eventsphotoid)){

		String webpathname="photo.image.webpath";
		webpathname="big.photo.image.webpath";
		imgpath=DbUtil.getVal(GET_EVENT_PHOTO,new String[]{authid,"event.eventsPublicPagephotoURL"});
		if(imgpath!=null && !"".equals(imgpath))
		imgname="<img src='"+imgpath+"' width='260' min-height='150' />";
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "imgname value is------"+imgname, null);
}
//End Of EventsPhoto Display Block.
//EventsProfile Display Block
String profilestmt="";
if("yes".equalsIgnoreCase(profiledisp)){
 profilestmt=GenUtil.getHMvalue(prefMap,"events.profile.processstatement","");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "profilestatement value is-------"+profilestmt,null);
}
//end Of EventsProfile Display Block
//Start of upcoming Events
HashMap<String,String> boxofficeDetails=getBoxOfficeDetails(authid);
Vector newevents=new Vector();
//if("yes".equalsIgnoreCase(upcomingeventsdisp)){

eventsQuery="select a.eventid,a.venue,a.city,a.state,a.country,a.eventname,to_char(a.start_date,'MM/DD')as startdate,case when a.descriptiontype='text' then a.description else '' end as description ,(select value from config where name='event.eventphotoURL'"
				+" and config_id=a.config_id limit 1) as photourl,to_char(start_date,'MM/DD')as startdate,trim(to_char(a.start_date, 'Day')) ||', '|| to_char(a.start_date, 'Month DD, YYYY') as start_date,"
				+"starttime,endtime,trim(to_char(a.end_date, 'Day')) ||', '|| to_char(a.end_date, 'Month DD, YYYY')"
				+"as enddate,getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo  a where mgr_id=CAST(? AS INTEGER) and status='ACTIVE' and listtype='PBL' and a.enddate_est>=now() order by a.start_date ";


		
		
		//if(boxofficeDetails.size()>0){
	String showtype=boxofficeDetails.get("events_display_type");
	String img=boxofficeDetails.get("photo_url");
	if(img!=null && !"".equals(img)) imgname="<img src='"+img+"' width='260' min-height='150' />"; 
	header=boxofficeDetails.get("header");
	if(header==null) header="";
	request.setAttribute("DESCRIPTION",boxofficeDetails.get("description"));
	if(showtype==null) showtype="";
	if("".equals(showtype))showtype="ALL";
	/*if(showtype.equalsIgnoreCase("SELECTED")){
		eventsQuery="select a.eventid,a.eventname,a.venue,a.city,a.state,a.country,to_char(a.start_date,'MM/DD')as startdate,case when a.descriptiontype='text' then a.description else '' end as description ,(select value from config where name='event.eventphotoURL'"
				+" and config_id=a.config_id limit 1) as photourl,to_char(a.start_date,'MM/DD')as startdate,trim(to_char(a.start_date, 'Day')) ||', '|| to_char(a.start_date, 'Month DD, YYYY') as start_date,"
				+"starttime,endtime,trim(to_char(a.end_date, 'Day')) ||', '|| to_char(a.end_date, 'Month DD, YYYY')"
				+"as end_date,getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo a, box_office_events b where a.eventid = to_number(b.eventid,'9999999999999') and a.status='ACTIVE' "
				+"and a.listtype='PBL' and a.end_date>=now() and b.boxoffice_id=(select boxoffice_id from box_office_master where userid=?) order by b.position";
	}*/
//}
sel_events_query="select a.eventid,a.eventname,case when a.descriptiontype='text' then a.description else '' end as description ,(select value from config where name='event.eventphotoURL'"
				+" and config_id=a.config_id limit 1) as photourl,to_char(a.start_date,'MM/DD')as startdate,getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo a, box_office_events b where a.eventid = CAST(b.eventid AS BIGINT) and a.status='ACTIVE' "
				+"and a.listtype='PBL' and b.boxoffice_id=(select boxoffice_id from box_office_master where userid=?) order by b.position";

	ArrayList<HashMap<String,String>> grpdetails=getUserEventGroups(authid);
	HashMap<String,ArrayList<String>> grpeventslist=getGroupEventList(authid);
	
	String csvWithQuote="";
	
	
	if("SELECTED".equals(showtype)){
	ArrayList arrlist=(ArrayList)DbUtil.getValues("select eventid::bigint from box_office_events where boxoffice_id=(select boxoffice_id from box_office_master where userid=?)",new String[]{authid});
	ArrayList grpEvtList=new ArrayList();
	    for(int i=0;i<arrlist.size();i++){
	    	if(grpeventslist.containsKey(arrlist.get(i)))
	    	grpEvtList.addAll(grpeventslist.get(arrlist.get(i)));
	    }
	    grpEvtList.addAll(arrlist);
	 csvWithQuote = grpEvtList.toString().replace("[", "'").replace("]", "'")
	            .replace(", ", "','");
	}
	
	 String eventsQueryBySelected="select a.eventid,a.venue,a.city,a.state,a.country,a.eventname,to_char(a.start_date,'MM/DD')as startdate,case when a.descriptiontype='text' then a.description else '' end as description ,(select value from config where name='event.eventphotoURL'"
				+" and config_id=a.config_id limit 1) as photourl,to_char(start_date,'MM/DD')as startdate,trim(to_char(a.start_date, 'Day')) ||', '|| to_char(a.start_date, 'Month DD, YYYY') as start_date,"
				+"starttime,endtime,trim(to_char(a.end_date, 'Day')) ||', '|| to_char(a.end_date, 'Month DD, YYYY')"
				+"as enddate,getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo  a where a.eventid in("+csvWithQuote+") and status='ACTIVE' and listtype='PBL' and a.enddate_est>=now() order by a.start_date ";				
	 
	
	HashMap<String,String> grpEvents=getGroupEvents(authid);
	System.out.println("showtype::"+showtype);
	
	if("ALL".equals(showtype))
	newevents=upcomingevents(newevents,authid,eventsQuery);
	else
	newevents=upcomingevents(newevents,authid,eventsQueryBySelected,"selected"); 	
	
HashMap pm=getnetadvevents(newevents); 
String netpartnerid=EbeeConstantsF.get("networkadv.partner","3809");
boolean isnewsession=(session.getAttribute("netadv_session")==null);
if(isnewsession)
{
session.setAttribute("netadv_session","yes");
if(pm!=null){
PartnerTracking pt=new PartnerTracking(pm);
pt.setInsertionType("homepageimpressions");
pt.setPartnerId(netpartnerid);
pt.start();
}
}	
Vector upcomingEvents=new Vector();
HashMap<String,String> buttoncodes=getCustomizeButtons(authid,showtype,csvWithQuote);
if(newevents!=null&&newevents.size()>0){
		
		for(int i=0;i<newevents.size();i++){
		HashMap hm1=(HashMap)newevents.get(i);
		String str="";
		String eid=(String)hm1.get("eventId");
		str="<a href='"+serveraddress+"event?eid="+eid+"'>"+(String)hm1.get("eventName")+"</a>";
		hm1.put("eventName",str);
		hm1.put("registerBtn",buttoncodes.get(eid));
		str=(String)hm1.get("startdate")+" "+str;
		if(hm1.get("description")!=null)
			hm1.put("descShowHide","<img class='show_hide' id='"+eid+"' src='/home/images/expand.gif'/>");
		upcomingEvents.add(str);
		}
	}
	HashMap grpEventDetails=new HashMap();
	if(showtype.equals("ALL") && newevents.size()>0){
	for(int i=0;i<newevents.size();i++){
		HashMap eventMap=(HashMap)newevents.get(i);
		String eid=(String)eventMap.get("eventId");
		if(grpEvents.get(eid)!=null){
			grpEventDetails.put(eid,newevents.remove(i));
			i--;
		}
	}
	for(int j=0;j<grpdetails.size();j++){
			HashMap hm=(HashMap)grpdetails.get(j);
			String grpid=(String)hm.get("groupid");
			String grpname=(String)hm.get("group_title");
			ArrayList<String> grpevtslist=grpeventslist.get(grpid);
			if(grpevtslist!=null){
			for(int k=0;k<grpevtslist.size();k++){
			String eid=grpevtslist.get(k);
				HashMap grpevtMap=(HashMap)grpEventDetails.get(eid);
				HashMap eventMap=new HashMap(grpevtMap);
				if(k==0){
					eventMap.put("start","yes");
					eventMap.put("grpname","<b>"+grpname+"</b>");
				}
				eventMap.put("grpevent","yes");
				eventMap.put("grpid",grpid);
				if(eventMap.get("description")!=null){
					String descid=grpid+"_"+eid;
					eventMap.put("descid",descid);
					eventMap.put("descShowHide","<img class='show_hide' id='"+descid+"' src='/home/images/expand.gif'/>");
				}
				newevents.add(eventMap);
			}}//loop end
		}
		}
	if(showtype.equals("SELECTED") && newevents.size()>0){
		HashMap<String,String> groupdetailsMap=new HashMap<String,String>();
		for(int i=0;i<grpdetails.size();i++){
			groupdetailsMap.put(grpdetails.get(i).get("groupid"),grpdetails.get(i).get("group_title"));
		}
		ArrayList<String>  boevents=getBoxOfficeEvents(authid);
		for(int i=0;i<newevents.size();i++){
			HashMap eventMap=(HashMap)newevents.get(i);
			String eid=(String)eventMap.get("eventId");
				grpEventDetails.put(eid,newevents.remove(i));
				i--;
		}
		boolean flag=false;
		for(int i=0;i<boevents.size();i++){
			String eid=boevents.get(i);
			if(grpeventslist.get(eid)!=null){
				String grpname=groupdetailsMap.get(eid);
				ArrayList<String> grpevts=grpeventslist.get(eid);
				flag=true;
				for(int j=0;j<grpevts.size();j++){
				HashMap grpeventMap=(HashMap)grpEventDetails.get(grpevts.get(j));
				HashMap eventMap=new HashMap(grpeventMap);
					if(j==0){
						eventMap.put("start","yes");
						eventMap.put("grpname","<b>"+grpname+"</b>");
					}
					eventMap.put("grpevent","yes");
					eventMap.put("grpid",eid);
					if(eventMap.get("description")!=null){
						String descid=eid+"_"+eventMap.get("eventId");
						eventMap.put("descid",descid);
						eventMap.put("descShowHide","<img class='show_hide' id='"+descid+"' src='/home/images/expand.gif'/>");
					}
					newevents.add(eventMap);
				}
			}else{
			HashMap grpeventMap=(HashMap)grpEventDetails.get(eid);
			if(grpeventMap!=null){
			HashMap eventMap=new HashMap(grpeventMap);
				if(flag){
					eventMap.put("start","yes");
				}
				flag=false;
				newevents.add(eventMap);
				}
			}
		}
	}
	/*if(showtype.equals("ALL") && newevents.size()>0){
	for(int i=0;i<newevents.size();i++){
		HashMap emap=(HashMap)newevents.get(i);
		String eid=(String)emap.get("eventId");
			if(grpEvents.get(eid)!=null){
				grpEventDetails.put(eid,newevents.remove(i));
				i--;
				}
		}
		}*/
	request.setAttribute("UPCOMINGEVENTS",newevents);
	request.setAttribute("UPCOMINGEVENTSOLD",upcomingEvents);
	
//}
//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "upcoming events Details vector value is-------"+comingevents,null);


//End of upcoming events

//Start of Past Events
Vector pastevents=new Vector();

if("yes".equalsIgnoreCase(pasteventsdisp)){
 eventsQuery="select a.eventid,a.eventname,a.venue,a.city,a.state,a.country,to_char(a.start_date,'MM/DD')as startdate,case when a.descriptiontype='text' then a.description else '' end as description ,(select value from config where name='event.eventphotoURL'"
				+" and config_id=a.config_id limit 1) as photourl,to_char(start_date,'MM/DD')as startdate,trim(to_char(a.start_date, 'Day')) ||', '|| to_char(a.start_date, 'Month DD, YYYY') as start_date,"
				+"starttime,endtime,trim(to_char(a.end_date, 'Day')) ||', '|| to_char(a.end_date, 'Month DD, YYYY')"
				+"as end_date,getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo  a where mgr_id=CAST(? AS INTEGER) and status='CLOSED' and listtype='PBL' and end_date<=now() order by end_date desc";
pastevents=upcomingevents(pastevents,authid,eventsQuery);

Vector oldEvents=new Vector();
if(pastevents!=null&&pastevents.size()>0){
		
		for(int i=0;i<pastevents.size();i++){
		HashMap hm1=(HashMap)pastevents.get(i);
		String str="";
		str="<a href='"+serveraddress+"event?eid="+(String)hm1.get("eventId")+"'>"+(String)hm1.get("eventName")+"</a>";
		hm1.put("eventName",str);
		str=(String)hm1.get("startdate")+" "+str;
		oldEvents.add(str);
		}
	}
	request.setAttribute("OLDEVENTS",pastevents);
	request.setAttribute("OLDEVENTSOLD",oldEvents);
}
//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "oldEvents  Details vector value is-------"+oldEvents,null);


//End if Past Events


//Partner Streamer
String selecteddate=null;
String daydate="";
String daymonth="";
String dayyear="";
String selectedcaldate="";
java.util.Date d=null;
if(request.getParameter("d")!=null){
daydate=request.getParameter("d");
daymonth=request.getParameter("m");
dayyear=request.getParameter("y");
Calendar calendar =Calendar.getInstance() ;
try{
calendar.set(Integer.parseInt(dayyear),Integer.parseInt(daymonth)-1,Integer.parseInt(daydate));
}
catch(Exception e){}
  d=calendar.getTime() ;
 DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
  DateFormat dateFormat1 = new SimpleDateFormat("MMM d, yyyy");
   selectedcaldate=dateFormat1.format(d);
 selecteddate=dateFormat.format(d); 
 
}
else{
java.util.Date date=new java.util.Date();
daydate=Integer.toString(date.getDate());
daymonth=Integer.toString(date.getMonth()+1);
dayyear=Integer.toString(date.getYear()+1900);
}
Vector venueEvents=getVenueEvents(authid,selecteddate);
String loginname=getLoginName(authid);

String eventspagepatern="/view/"+loginname+"/events";
request.setAttribute("VENUEEVENTS",venueEvents);
request.setAttribute("EVENTSPAGE",eventspagepatern);

if(selecteddate==null)
request.setAttribute("SELECTEDDATE",selecteddate);
else
request.setAttribute("SELECTEDDATE",selectedcaldate);



 String calender="<div id='cal'>  </div>"
                  +"<script>MakeDate(handleNewDate,'"+dayyear+"','"+daymonth+"','"+daydate+"')</script>"
                  +"<form  method='post' id='venueEventsForm' name='venueEventsForm'>"
                  +"<input type='hidden' name='d' id='d' value='"+dayyear+"'>"
                  +"<input type='hidden' name='m' id='m' value='"+daymonth+"'>"
                  +"<input type='hidden' name='y' id='y' value='"+dayyear+"'>"
                  +"</form>";
                  
                  



request.setAttribute("CALENDER",calender);




EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "useriddddddddd is-------"+authid,null);
String userfirstname=null;
userfirstname=DbUtil.getVal("select first_name from user_profile where user_id=?",new String[]{authid});
String company=DbUtil.getVal("select company from user_profile where user_id=?",new String[]{authid});
if(company!=null&&!"".equals(company))
userfirstname=company;

 String firstname=userfirstname +"'s Events Page";

if("ning".equals(platform))

firstname="Events Page";
if(!"".equals(header))
firstname=header;
 	request.setAttribute("USERNAME",firstname);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "in service", "username value is "+username, null);

String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=? and status='Active'",new String[]{authid});	
Map attribmap=PartnerDB.getStreamingAttributes(authid,partnerid);

request.setAttribute("VENUEOWNER",userfirstname);

%>
			
<%@ include file="userstreamer.jsp" %>
			
<%
//end of Partner Streamer

String networklink="<a href='"+ShortUrlPattern.get((String)request.getAttribute("username"))+"/network'>Network Page</a>";
String Bloglink="<a href='"+ShortUrlPattern.get((String)request.getAttribute("username"))+"/blog'>Blog Page</a>";
String photoslink="<a href='"+ShortUrlPattern.get((String)request.getAttribute("username"))+"/photos'>Photos Page</a>";
String communitylink="<a href='"+ShortUrlPattern.get((String)request.getAttribute("username"))+"/community'>Community Page</a>";

request.setAttribute("NETWORKLINK",networklink);
request.setAttribute("BLOGLINK",Bloglink);
request.setAttribute("PHOTOSLINK",photoslink);
request.setAttribute("COMMUNITYLINK",communitylink);
request.setAttribute("FIRSTNAME",userfirstname);
request.setAttribute("PARTNERSTREAMER",partnerstreamer);
%>
<%
request.setAttribute("PROFILEINFO",profilestmt);
request.setAttribute("EVENTSPHOTO",imgname);
%>
<% /* ######## YAHOO AND GOOGLE ADS FOR EVENTS PAGE 04/04/2007 rajesh #######*/
String content="";
HashMap customcontent_yahooad=null;
customcontent_yahooad=CustomContentDB.getCustomContent("THEME_YAHOO_AD", "13579");
if(customcontent_yahooad!=null){
 content=GenUtil.getHMvalue(customcontent_yahooad,"desc" );
}
if(content==null)content="";
request.setAttribute("YAHOOADS",content);
HashMap customcontent_ad=null;
customcontent_ad=CustomContentDB.getCustomContent("THEME_GOOGLE_AD", "13579");
if(customcontent_ad!=null){
content=GenUtil.getHMvalue(customcontent_ad,"desc" );
}
if(content==null)content="";
request.setAttribute("GEOOGLEADS",content);
/*####### END OF YAHOO AND GOOGLE ADS CONTENT ############*/
%>
<jsp:include page='/main/Themebeeheader.jsp' />

<jsp:include page='/main/eventfooter.jsp' />

<jsp:include page='eventspagelinks.jsp' />

