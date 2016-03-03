<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ include file='/globalprops.jsp' %>
<%!
	/* String all_events_query="select a.eventid,a.venue,a.city,a.state,a.country,a.eventname,case when a.descriptiontype='text' then a.description else '' end as description ,(select value from config where name='event.eventphotoURL'"
				+" and config_id=a.config_id limit 1) as photourl,(select value from config where name='event.rsvp.enabled'  and config_id=a.config_id limit 1) as isrsvp,(select attrib_value "
				+"from custom_event_display_attribs where eventid=a.eventid and attrib_name='event.reg.orderbutton.label' limit 1) as buttonlabel,"
				+" trim(to_char(a.start_date, 'Day')) ||', '|| to_char(a.start_date, 'Month DD, YYYY') as start_date,"
				+" starttime,endtime,trim(to_char(a.end_date, 'Day')) ||', '|| to_char(a.end_date, 'Month DD, YYYY')"
				+" as end_date,a.phone,trim(to_char(a.end_date, 'Dy')) ||', '|| to_char(a.end_date, 'Mon DD, YYYY') as evt_end_date, trim(to_char(a.start_date, 'Dy')) ||', '|| to_char(a.start_date, 'Mon DD, YYYY') as evt_start_date "
				+" from eventinfo a, box_office_master b where a.mgr_id= CAST(b.userid AS INTEGER) and a.status='ACTIVE' and a.listtype='PBL' and a.enddate_est>=now() and  b.boxoffice_id=? order by a.start_date";
 */
 
 String allEevntsCustomBtnLblQry="select eventid,lang,y->>'event.reg.orderbutton.label' as btn_lbl from (select  d->'data' as y,eventid,lang from("
		 +"select json_array_elements((data->0->'modules')::json) as d,eventid,(data->0->>'lang') as lang from custom_event_display_attribs "
		 +"where data->0->'modules' @> '[{\"m\": \"RegFlowWordings\"}]' and eventid in(select eventid from eventinfo where mgr_id in "
		+"(select CAST(userid AS INTEGER) from box_office_master where boxoffice_id=?) and status='ACTIVE')) a where d::jsonb->'m'='\"RegFlowWordings\"') x";
 
 String selEventsCustomBtnLblQry="select eventid,lang,y->>'event.reg.orderbutton.label' as btn_lbl from (select  d->'data' as y,eventid,lang from("
				 +"select json_array_elements((data->0->'modules')::json) as d,eventid,(data->0->>'lang') as lang from custom_event_display_attribs "
				 +"where data->0->'modules' @> '[{\"m\": \"RegFlowWordings\"}]' and eventid in(select eventid from eventinfo where eventid in "
				+"(select eventid::int from box_office_events where boxoffice_id=?) and status='ACTIVE')) a where d::jsonb->'m'='\"RegFlowWordings\"') x";
 
 String all_events_query="select a.eventid,a.venue,a.city,a.state,a.country,a.eventname,case when a.descriptiontype='text' then a.description else '' end as description ,(select value from config where name='event.eventphotoURL'"
			+" and config_id=a.config_id limit 1) as photourl,(select value from config where name='event.rsvp.enabled'  and config_id=a.config_id limit 1) as isrsvp,"
			+" trim(to_char(a.start_date, 'Day')) ||', '|| to_char(a.start_date, 'Month DD, YYYY') as start_date,"
			+" starttime,endtime,trim(to_char(a.end_date, 'Day')) ||', '|| to_char(a.end_date, 'Month DD, YYYY')"
			+" as end_date,a.phone,trim(to_char(a.end_date, 'Dy')) ||', '|| to_char(a.end_date, 'Mon DD, YYYY') as evt_end_date, trim(to_char(a.start_date, 'Dy')) ||', '|| to_char(a.start_date, 'Mon DD, YYYY') as evt_start_date "
			+" from eventinfo a, box_office_master b where a.mgr_id= CAST(b.userid AS INTEGER) and a.status='ACTIVE' and a.listtype='PBL' and a.enddate_est>=now() and  b.boxoffice_id=? order by a.start_date";
		
				
String group_events_query="select a.eventid,b.group_title from group_events a,user_groupevents b,eventinfo c where a.event_groupid =b.event_groupid and cast(a.eventid as numeric)=c.eventid and c.status='ACTIVE' and c.listtype='PBL' and c.end_date>=now() and b.userid=? order by a.position";

				
	/* String sel_events_query="select a.eventid,a.venue,a.city,a.state,a.country,a.eventname,case when a.descriptiontype='text' then a.description else '' end as description ,(select value from config where name='event.eventphotoURL'"
				+" and config_id=a.config_id limit 1) as photourl,(select value from config where name='event.rsvp.enabled'  and config_id=a.config_id limit 1) as isrsvp,(select attrib_value "
				+"from custom_event_display_attribs where eventid=a.eventid and attrib_name='event.reg.orderbutton.label' limit 1) as buttonlabel,"
				+"trim(to_char(a.start_date, 'Day')) ||', '|| to_char(a.start_date, 'Month DD, YYYY') as start_date,"
				+"starttime,endtime,trim(to_char(a.end_date, 'Day')) ||', '|| to_char(a.end_date, 'Month DD, YYYY')"
				+"as end_date,a.phone,trim(to_char(a.end_date, 'Dy')) ||', '|| to_char(a.end_date, 'Mon DD, YYYY') as evt_end_date, trim(to_char(a.start_date, 'Dy')) ||', '|| to_char(a.start_date, 'Mon DD, YYYY') as evt_start_date "
				+"from eventinfo a, box_office_events b where a.eventid = CAST(b.eventid AS BIGINT) and a.status='ACTIVE'  and a.listtype='PBL' and a.enddate_est>=now() "
				+"and boxoffice_id=? order by position"; */
				
	String sel_events_query="select a.eventid,a.venue,a.city,a.state,a.country,a.eventname,case when a.descriptiontype='text' then a.description else '' end as description ,(select value from config where name='event.eventphotoURL'"
			+" and config_id=a.config_id limit 1) as photourl,(select value from config where name='event.rsvp.enabled'  and config_id=a.config_id limit 1) as isrsvp,"
			+"trim(to_char(a.start_date, 'Day')) ||', '|| to_char(a.start_date, 'Month DD, YYYY') as start_date,"
			+"starttime,endtime,trim(to_char(a.end_date, 'Day')) ||', '|| to_char(a.end_date, 'Month DD, YYYY')"
			+"as end_date,a.phone,trim(to_char(a.end_date, 'Dy')) ||', '|| to_char(a.end_date, 'Mon DD, YYYY') as evt_end_date, trim(to_char(a.start_date, 'Dy')) ||', '|| to_char(a.start_date, 'Mon DD, YYYY') as evt_start_date "
			+"from eventinfo a, box_office_events b where a.eventid = CAST(b.eventid AS BIGINT) and a.status='ACTIVE'  and a.listtype='PBL' and a.enddate_est>=now() "
			+"and boxoffice_id=? order by position";
						
	String box_office_events="select eventid from box_office_events where boxoffice_id=? order by position";	

	ArrayList<String> getBoxOfficeEvents(String boxofficeid){
		ArrayList<String> boxoffice_events=new ArrayList<String>();
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(box_office_events,new String[]{boxofficeid});
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				boxoffice_events.add(db.getValue(i,"eventid",""));
			}
		}
		return boxoffice_events;
	}
	
	ArrayList<HashMap<String,String>> getEventDetails(String boxofficeid,String show_type){
		ArrayList<HashMap<String,String>> events=new ArrayList<HashMap<String,String>>();
		HashMap<String, String> customBtnLblMap=new HashMap<String, String>();
		String query="";
		if(show_type.equals("ALL")){
			customBtnLblMap=getCustomBtnLabelMap(allEevntsCustomBtnLblQry,boxofficeid);
			query=all_events_query;
		}
		if(show_type.equals("SELECTED")) {
			customBtnLblMap=getCustomBtnLabelMap(selEventsCustomBtnLblQry,boxofficeid);
			query=sel_events_query;
		}
		System.out.println("customBtnLblMap: "+customBtnLblMap);
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(query,new String[]{boxofficeid});
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				
				String btnlabel="";
				if(customBtnLblMap.containsKey(db.getValue(i,"eventid","")))
					btnlabel=customBtnLblMap.get(db.getValue(i,"eventid",""));
				if("".equals(btnlabel) || btnlabel==null) btnlabel="Register";
				
				HashMap<String,String> eventMap=new HashMap<String,String>();
				eventMap.put("eventid",db.getValue(i,"eventid",""));
				eventMap.put("eventname",db.getValue(i,"eventname",""));
				eventMap.put("photourl",db.getValue(i,"photourl",""));
				eventMap.put("venue",db.getValue(i,"venue",""));
				eventMap.put("city",db.getValue(i,"city",""));
				eventMap.put("state",db.getValue(i,"state",""));
				eventMap.put("country",db.getValue(i,"country",""));
				eventMap.put("description",db.getValue(i,"description",""));
				eventMap.put("buttonlabel",btnlabel);
				eventMap.put("sdate",db.getValue(i,"start_date",""));
				eventMap.put("edate",db.getValue(i,"end_date",""));
				eventMap.put("stime",getTimeAM(db.getValue(i,"starttime","")));
				eventMap.put("etime",getTimeAM(db.getValue(i,"endtime","")));
				eventMap.put("isrsvp",db.getValue(i,"isrsvp",""));
				events.add(eventMap);
			}
		}
		return events;
	}
	
	HashMap<String,String> getCustomBtnLabelMap(String query,String boxofficeid){
		HashMap<String,String> customBtnLblMap = new HashMap<String,String>();
		try{
			DBManager db=new DBManager();
			StatusObj stobj=null;
			stobj=db.executeSelectQuery(query,new String[]{boxofficeid});
			
			if(stobj.getStatus()){
				for( int i=0;i<stobj.getCount();i++){
					String btnLbl=db.getValue(i,"btn_lbl","");
					String eventid=db.getValue(i,"eventid","");
					String lang=db.getValue(i,"lang","en_US");
					if("".equals(btnLbl)){
						btnLbl=getPropValue("reg.btn.lbl",eventid);
					}
					customBtnLblMap.put(eventid,btnLbl);
				}
			}
		}catch(Exception e){
			
		}
		return customBtnLblMap;
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
		String query="select a.eventid,b.event_groupid from group_events a,user_groupevents b,eventinfo c  where a.event_groupid =b.event_groupid and cast(a.eventid as numeric)=c.eventid and c.status='ACTIVE' and c.listtype='PBL' and c.enddate_est>=now() and b.userid=? order by b.event_groupid, a.position";
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
	HashMap<String,String> getBoxOfficeDetails(String boxofficeid){
		HashMap<String,String> boxofficeMap=new HashMap<String,String>();
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery("select userid,boxoffice_id,photo_url,header,description,events_display_type from box_office_master where boxoffice_id=?",new String[]{boxofficeid});
		for(int i=0;i<sb.getCount();i++){
			boxofficeMap.put("header",db.getValue(i,"header",""));
			boxofficeMap.put("photo_url",db.getValue(i,"photo_url",""));
			boxofficeMap.put("description",db.getValue(i,"description",""));
			boxofficeMap.put("show_type",db.getValue(i,"events_display_type",""));
			boxofficeMap.put("userid",db.getValue(i,"userid",""));
		}
		return boxofficeMap;
	}
	String getTimeAM(String starttime){
		String hour=starttime.substring(0,2);
		String min=starttime.substring(3,starttime.length());
		String shour="",smin="";
		int i=Integer.parseInt(hour);
		int j=Integer.parseInt(min);
		shour=""+i;
		smin=""+j;
		if(j<10) smin="0"+j;
		if(i >=12){
			if(i!=12){
				i=(i-12);
				shour=""+i;
				if(i<10) shour="0"+i;
			}
			starttime=shour+":"+smin+" PM";
			}else {
				if(i<10) shour="0"+i;
				starttime=shour+":"+smin+" AM";
			}
		return starttime;
	}
%>
<% 
	String boxofficeid=request.getParameter("boxoffice");
		String username=request.getParameter("name");	
	HashMap<String,String> boxofficeMap=getBoxOfficeDetails(boxofficeid);
	String boxoff_desc=boxofficeMap.get("description");
	String boxoff_photo=boxofficeMap.get("photo_url");
	String boxoff_title=boxofficeMap.get("header");
	String show_type=boxofficeMap.get("show_type");
	String userid=boxofficeMap.get("userid");
	if(show_type==null || "".equals(show_type)) show_type="ALL";
	ArrayList<HashMap<String,String>> eventDetails=getEventDetails(boxofficeid,"ALL");
	ArrayList<HashMap<String,String>> grpdetails=getUserEventGroups(userid);
	HashMap<String,String> groupdetailsMap=new HashMap<String,String>();
	HashMap<String,ArrayList<String>> grpeventslist=getGroupEventList(userid);
	HashMap<String,HashMap<String,String>> grpEventDetails=new HashMap<String,HashMap<String,String>>();
	HashMap<String,String> grpEvents=getGroupEvents(userid);
	for(int i=0;i<grpdetails.size();i++){
		groupdetailsMap.put(grpdetails.get(i).get("groupid"),grpdetails.get(i).get("group_title"));
	}
	for(int i=0;i<eventDetails.size();i++){
		if(grpEvents.get(eventDetails.get(i).get("eventid"))!=null){
			grpEventDetails.put(eventDetails.get(i).get("eventid"),eventDetails.remove(i));
			i--;
		}
	}
		if(show_type.equals("ALL")){
		for(int j=0;j<grpdetails.size();j++){
			HashMap<String,String> hm=grpdetails.get(j);
			String grpid=hm.get("groupid");
			String grpname=hm.get("group_title");
			ArrayList grpevtslist=grpeventslist.get(grpid);
			if(grpevtslist!=null){
			for(int k=0;k<grpevtslist.size();k++){
				if(grpEventDetails.get(grpevtslist.get(k))!=null){
				HashMap<String,String> eventMap=new HashMap<String,String>(grpEventDetails.get(grpevtslist.get(k)));
				if(k==0){
					eventMap.put("start","yes");
					eventMap.put("grpname",grpname);
				}
				eventMap.put("grpevent","yes");
				eventMap.put("grpid",grpid);
				eventDetails.add(eventMap);
			}
			}
			}
		}
	}
	if(show_type.equals("SELECTED")){
		ArrayList<String>  boevents=getBoxOfficeEvents(boxofficeid);

		for(int i=0;i<eventDetails.size();i++){
				grpEventDetails.put(eventDetails.get(i).get("eventid"),eventDetails.remove(i));
				i--;
		}
		boolean flag=false;
		for(int i=0;i<boevents.size();i++){
			String eid=boevents.get(i);
			if(grpeventslist.get(eid)!=null){
				String grpname=groupdetailsMap.get(eid);
				ArrayList grpevts=grpeventslist.get(eid);
				flag=true;
				for(int j=0;j<grpevts.size();j++){
				if(grpEventDetails.get(grpevts.get(j))!=null){
				HashMap<String,String> eventMap=new HashMap<String,String>(grpEventDetails.get(grpevts.get(j)));
					if(j==0){
						eventMap.put("start","yes");
						eventMap.put("grpname",grpname);
					}
					eventMap.put("grpevent","yes");
					eventMap.put("grpid",eid);
					eventDetails.add(eventMap);
				}
				}
			}else{
			if(grpEventDetails.get(eid)!=null){
			HashMap<String,String> eventMap=new HashMap<String,String>(grpEventDetails.get(eid));
				if(flag){
					eventMap.put("start","yes");
				}
				flag=false;
				eventDetails.add(eventMap);
			}
			}
		}
	}
	
	request.setAttribute("username",username);
	String userfirstname=DbUtil.getVal("select first_name from user_profile where user_id=?",new String[]{userid});
%>
<html>
    <head>
        <meta charset="UTF-8" />
        <title><%=userfirstname%>'s Box Office</title>
		<style type="text/css" media="screen">@import "/home/css/jQtouch/jqtouch.min.css";</style>
		<style type="text/css" media="screen">@import "/home/css/jQtouch/themes/jqt/theme.min.css";</style>
		<style type="text/css" media="screen">@import "/home/css/jQtouch/themes/jqt/boxofficetheme.css";</style>
		<script src="/home/js/jQtouch/jquery.1.3.2.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="/home/js/jQtouch/jqtouch.js" type="application/x-javascript" charset="utf-8"></script>
		<script type="text/javascript" charset="utf-8">
			var prev_div = "";
			var curr_div = "";
			$(function(){
				$('#ebee_back').tap(function(){					
					jQT.goBack();
				});
				$('#ebee_home').tap(function(){					
					goHome();
				});
				});
            var jQT = new $.jQTouch({
			slideSelector: 'body > * > ul li a, .forceSlide,.slide',
                icon: '',
                addGlossToIcon: false,
                startupScreen: 'jqt_startup.png',
                statusBar: 'black',
                preloadImages: [
                    '/home/css/jQtouch/themes/jqt/img/back_button.png',
                    '/home/css/jQtouch/themes/jqt/img/back_button_clicked.png',
                    '/home/css/jQtouch/themes/jqt/img/button_clicked.png',
                    '/home/css/jQtouch/themes/jqt/img/grayButton.png',
                    '/home/css/jQtouch/themes/jqt/img/whiteButton.png',
                    '/home/css/jQtouch/themes/jqt/img/loading.gif',
					'/home/css/jQtouch/themes/jqt/img/103.gif',
					 '/home/images/close.png'
                    ]
            });
			function getToEventPage(eid){
				//window.location.href="http://192.168.1.96/m?eid="+eid;
				var url="/m?eid="+eid;
				var form=document.createElement("form");
				form.setAttribute("action",url);
				form.setAttribute("method","post");
				var input=document.createElement("input");
				input.setAttribute("type","hidden");
				input.setAttribute("name","username");
				input.setAttribute("value","<%=username%>");
				form.appendChild(input);
				document.body.appendChild(form);
				form.submit();															
				document.body.removeChild(form);
			}
        </script>
	</head>
	<body >
	<div style="min-height:100%;">
<%if(boxofficeMap.size()>0){%>
<table width="100%">
	<tr>
		<td colspan="2" align="center">
		<ul class="rounded">
			<li><div class="header"><%=boxoff_title%></div></li>
			</ul>
		</td>
	</tr>
	<tr>
		<td width="30%" valign="top">
			<table width="100%">
			<% if(!"".equals(boxoff_photo)){ %>
				<tr>
					<td align="center">
					<ul class="rounded">
						<li>
							<img src='<%=boxoff_photo%>' alt="No Photo" width="70%" min-height="50%">
						</li>
					</ul>
					</td>
				</tr>
			<%}%>
			<% if(!"".equals(boxoff_desc)){ %>
				<tr>
					<td>
						<ul class="rounded">
					<li><div class="description"><%=boxoff_desc%></div></li>
						</ul>
					</td>
				</tr>
				<%}%>
			</table>
		</td>
		<td width="70%" valign="top">
			<div id="events">
			<%	if(eventDetails.size()>0){ %>
				<ul class="rounded">
							<%
								for(int i=0;i<eventDetails.size();i++){
								HashMap<String,String> eventMap=eventDetails.get(i);
								if(eventMap.get("start")!=null){
									if(i!=0){
										out.println("</ul>");
										out.println("<ul class='rounded'>");
										}
									if(eventMap.get("grpname")!=null){	
									out.println("<li>"+eventMap.get("grpname")+"</li>");
									}
									}
								String eid=eventMap.get("eventid");
								String sdate=eventMap.get("sdate");
								String edate=eventMap.get("edate");
								String stime=eventMap.get("stime");
								String etime=eventMap.get("etime");
								String venuename=eventMap.get("venue");
								String city=eventMap.get("city");
								String state=eventMap.get("state");
								String country=eventMap.get("country");
								String address="";
								if(!"".equals(venuename)) address+=venuename;
								if(!"".equals(city)) address+=", "+city;
								if(!"".equals(state)) address+=", "+state;
								if(!"".equals(country)) address+=", "+country;
								if(address.startsWith(", "))
									address=address.substring(2);
								String description=eventMap.get("description");
								if(description==null) description="";
								else
									description=description.trim();
								String buttonlabel=eventMap.get("buttonlabel");
								String isrsvp=eventMap.get("isrsvp");
								if(isrsvp==null) isrsvp="";
								/* if(isrsvp.equalsIgnoreCase("YES")){
									buttonlabel="RSVP";
								}else  */
								if(buttonlabel==null || "".equals(buttonlabel))
									buttonlabel="Register";
								String photourl=eventMap.get("photourl");
								if(photourl==null) photourl="";
								String eventdate="";
								if(sdate.equals(edate)){
									eventdate=sdate+", "+stime+" - "+etime;
								}
								else
									eventdate=sdate+" "+stime+" - "+edate+" "+etime;
							%>
											<li>
							<div >
							<table width="100%">
								<tr>
								<%if(eventMap.get("grpevent")!=null){%>
								<td width="5%"></td>
								<%}%>
								<td align="left" width="20%" valign="top">
										<%if(!"".equals(photourl)){%>
										<img src="<%=photourl%>" style="width:100px; height:100px;" />
										<%}%>
									</td>
									<td valign="top"><b><%=eventMap.get("eventname")%></b> 
									<%
										String descid=eid;
										if(eventMap.get("grpevent")!=null)
											descid=eventMap.get("grpid")+"_"+eid;
									%>
									<% if(!"".equals(description)){%><img class="show_hide1" id="<%=descid%>" src="/home/images/expand.gif"/><%}%><br>
									<span class="smallfont"><%=eventdate%>
									<% if(!"".equals(address)){%><br><%=address%> <%}%>
									</span>
									<% if(!"".equals(description)){%>
									<div id="desc_<%=descid%>" class="description" style="display:none">
											<%=eventMap.get("description")%>
									</div>
									<%}%>
									</td>
									<td valign="top" align="right">
										<input type="button" class="mybutton" value="<%=buttonlabel%>" onclick="getToEventPage('<%=eid%>')"/>
									</td>
								</tr>
								<tr>
									<td colspan="3">
									</td>
								</tr>
								</table>
					</div>
				</li>
				<%} %>
				</ul>
							<%} %>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<ul class="rounded">
			<li>
					<div id='footer' align="center" width="90%">
						<table align='center' cellpadding='5' cellspacing="5" >
							<tr>
								<td align='left' valign='top'>
									<a href='http://www.eventbee.com'>
										<img src='/home/images/poweredby.jpg' border='0'/>
									</a>
								</td>
								
								<td align='left' valign='middle'><span class="smallfont">Powered by Eventbee - Your Online Registration, Membership Management and Event Promotion solution. <br/>For more information, send an email to support at eventbee.com</span>
								</td>
							</tr>
						</table>
					</div>
			</li>
			</ul>
		</td>
	</tr>
	</table>
	<script>
		$(".show_hide1").click(function(){
					var imgid=this.id
					$("#desc_"+imgid).slideToggle(
						function(){
							var a=document.getElementById(this.id).style.display;
							if(a=="none")
								$("#"+imgid).attr("src","/home/images/expand.gif")
							else
								$("#"+imgid).attr("src","/home/images/collapse.gif")
						}
					);
		});
	</script>
	<%}else{%>
				<center><h1 style="color:white">Sorry, invalid box office</h1><center>
		</ul>
	<%}%>
	</div>
	</body>
</html>	