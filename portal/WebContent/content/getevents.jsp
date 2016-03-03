<%@ page import="java.util.*,com.eventbee.event.*,com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.streamer.*"%>

<%!

/*String GET_EVENTS_BY_LOCATION="SELECT eventname,eventid,photourl,trim(to_char(start_date,'DD Mon')) as start_date," 
	+" premiumlevel,a.login_name as username ,getEventTicketCount(''||eventid) as tcount from eventinfo e,authentication a" 
	+" where (premiumlevel not in('EVENT_FEATURED_LISTING','EVENT_CUSTOM_LISTING')or premiumlevel is null ) and " 
	+" a.user_id=e.mgr_id and type=? and showinhomepage='Y' and status='ACTIVE' and listType='PBL' and to_date(start_date,'yyyy-MM-dd')>=to_date(now(),'yyyy-MM-dd') order by e.created_at desc limit ?";
	

String GET_FEATURED_EVENTS_BY_LOCATION="SELECT eventname,eventid,photourl,trim(to_char(start_date,'DD Mon')) as start_date, "
	+" premiumlevel,a.login_name as username ,getEventTicketCount(''||eventid) as tcount from eventinfo e,authentication a" 
	+" where premiumlevel in('EVENT_FEATURED_LISTING','EVENT_CUSTOM_LISTING') "
	+"and a.user_id=e.mgr_id and type=?  and status='ACTIVE' and listType='PBL' and to_date(start_date::text,'yyyy-MM-dd')>=to_date(now()::text,'yyyy-MM-dd') order by e.created_at desc ";

*/
String GET_EVENTS_BY_LOCATION="SELECT eventname,eventid,photourl,trim(to_char(e.start_date,'DD Mon')) as start_date1,"
							+" e.created_at as created, premiumlevel,count(price.price_id) as tcount"
							+"  from  eventinfo e left outer join price on price.evt_id=e.eventid"
							+" where (premiumlevel not in('EVENT_FEATURED_LISTING','EVENT_CUSTOM_LISTING')or premiumlevel is null ) and "
							+"  type=?  and showinhomepage='Y' and e.status='ACTIVE' and listType='PBL' and to_date(e.start_date::text,'yyyy-MM-dd')>=to_date(now()::text,'yyyy-MM-dd')"
							+" and price.evt_id=e.eventid group by eventname,eventid,photourl,start_date1,premiumlevel, created order by e.created_at desc limit ?";
							
String GET_FEATURED_EVENTS_BY_LOCATION="SELECT eventname,eventid,photourl,trim(to_char(e.start_date,'DD Mon')) as start_date1,"
									   +" e.created_at as created, premiumlevel,count(price.price_id) as tcount"
 									   +" from  eventinfo e left outer join price on price.evt_id=e.eventid"
	 								   +" where premiumlevel in('EVENT_FEATURED_LISTING','EVENT_CUSTOM_LISTING') "
									   +"  and type=?   and e.status='ACTIVE' and listType='PBL' and to_date(e.start_date::text,'yyyy-MM-dd')>=to_date(now()::text,'yyyy-MM-dd') "
									   +" group by eventname,eventid,photourl,start_date1,premiumlevel, created order by e.created_at desc ";
							







Vector getEvents(String query ,String []params){

	Vector vec=new Vector();
	HashMap hm=null;
	DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,params);
		int recordcount=statobj.getCount();
		if(recordcount>0){
			for(int i=0;i<recordcount;i++){
				hm=new HashMap();
				hm.put("eventid",dbmanager.getValue(i,"eventid",""));
				hm.put("eventname",dbmanager.getValue(i,"eventname",""));
				hm.put("start_date",dbmanager.getValue(i,"start_date1",""));
				hm.put("username",dbmanager.getValue(i,"username",""));
				hm.put("premiumlevel",dbmanager.getValue(i,"premiumlevel",""));
				hm.put("photourl",dbmanager.getValue(i,"photourl",null));
				hm.put("tcount",dbmanager.getValue(i,"tcount",""));

			vec.add(hm);
			
			}
		}
	return vec;
}
Vector  getUnique(Vector v,int max)
{
Vector vec=new Vector();
	HashMap hm=null;
	HashMap gm=null;
	for(int i=v.size()-1;i>0;i--)
	{
	hm=(HashMap)v.elementAt(i);
	gm=(HashMap)v.elementAt(i-1);
       if(hm.get("eventname").equals(gm.get("eventname")))
        v.remove(gm);
            }
            if(max>0&&v.size()>max){
            for(int i=v.size()-1;i>=max;i--)
	{
	      v.remove(i);
	      
          }  }
	return v;
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
	



Vector getEventGroups(){
	Vector eventgroupsvector= new Vector();
	DBManager dbm =new DBManager();
	HashMap groupdetails= null;		
	String Query="select event_groupid,group_title from  user_groupevents b where showinhomepage='Y' "; 
	StatusObj statobj=dbm.executeSelectQuery(Query,new String[] {});
	if(statobj.getStatus())	{
		for(int k=0;k<statobj.getCount();k++){
			groupdetails =new HashMap();			
			groupdetails.put("group_title",dbm.getValue(k,"group_title",""));
			groupdetails.put("event_groupid",dbm.getValue(k,"event_groupid",""));
			groupdetails.put("username",dbm.getValue(k,"username",""));
			eventgroupsvector.add(groupdetails);
		}

	}
	else 
		System.out.println("statusobject status is:::::::;"+statobj.getStatus());
	return eventgroupsvector;
}


           


%>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";

 HashMap hm=null;
 Vector result_vec=new Vector();
 Vector featured_vec=null;
 int count=5;
 String link="";
 String type=request.getParameter("type"); 
 HashMap partnerevtmap=(HashMap)session.getAttribute("PARTNER_EVENT_LISTING_ATTRIBS");
 if(partnerevtmap!=null)
 	session.removeAttribute("PARTNER_EVENT_LISTING_ATTRIBS");
 HashMap networkevtmap=(HashMap)session.getAttribute("NETWORK_EVENTLIST_ATTRIBS");
 if(networkevtmap!=null)
 	session.removeAttribute("NETWORK_EVENTLIST_ATTRIBS");
 String base="oddbase";
 featured_vec=getEvents(GET_FEATURED_EVENTS_BY_LOCATION,new String [] {type});
 featured_vec=getUnique(featured_vec,-1);
 Vector groupsvector=getEventGroups(); 
	if(featured_vec!=null)
 	{
 		if(featured_vec.size()>=5){
 			result_vec=getEvents(GET_EVENTS_BY_LOCATION,new String [] {type,"20"});
 			result_vec=getUnique(result_vec,2);
 			result_vec.addAll(featured_vec); 
 		}
 		else {  
 			count=5-featured_vec.size();
 			if(count<2)
 			count=2;
 		 	result_vec=getEvents(GET_EVENTS_BY_LOCATION,new String [] {type,"30"});
			result_vec=getUnique(result_vec,count);
			result_vec.addAll(featured_vec); 
 		}
 	}
 	
	
 	
 	/*else{ 	

 	 	result_vec=getEvents(GET_EVENTS_BY_LOCATION,new String [] {type,null});
 		
 	}*/


if(result_vec!=null&&result_vec.size()>0){
String eTypeLabel="event".equals(type)?"Events":"Classes";
%>
<table border="0" width="100%" align="center" cellspacing="0" cellpadding="0">
<tr><td>
<form name="evthomesearch" id="evthomesearch" method="POST" action="/portal/eventdetails/eventcatlist.jsp?evttype=<%=type%>&UNITID=13579&location=USA&category=All">

<table border="0" width="100%" align="center" cellspacing="0" cellpadding="0">
<tr class='one-header' ><td width="30%">Featured <a href='/portal/eventdetails/events.jsp?evttype=<%=type%>&UNITID=13579'><%=eTypeLabel%></a></td>	
<td align='right' >
<input type="text" name="keyword" value="" size="12"/> <input value="Search" name="go" type="submit" />
</td>
</tr>
</table>


</td></tr>
</table>
<%
    
	for(int i=0;i<result_vec.size();i++){
		hm=new HashMap();
		if(i%2==0){
			base="onebase";
		}else{
			base="onebase";
		}
		hm=(HashMap)result_vec.elementAt(i);
		link=serveraddress+"event?eid="+hm.get("eventid");
		
		%>
		<table border="0" width="100%" align="center" cellspacing="0" cellpadding="0">

		<tr class="<%=base%>" width="100%"><td class="<%=base%>" width="15%" ><%=hm.get("start_date")%></td><td align='left' class="<%=base%>" width="85%" >
		
		<%if(!"0".equals(hm.get("tcount"))){%>
			<a HREF="<%=link%>"><img src="/home/images/ticket.gif" width='13' height="11" border='0' alt="Registration Available"/></a>
		<%}if(hm.get("photourl")!=null){%>
			<a HREF="<%=link%>"><img src="/home/images/camera.gif" width='13' height="11" border='0' alt="Photo Available"/></a>
		<%}
		if(!"no".equals(hm.get("premiumlevel"))&&hm.get("premiumlevel")!=null&&!"".equals(hm.get("premiumlevel"))){
		%>
			 <a HREF="<%=link%>"><b><%=GenUtil.textToHtml(GenUtil.TruncateData((String)hm.get("eventname"),40),true)%></b></a>
			 <%}else{%>
			 <a HREF="<%=link%>"><%=GenUtil.textToHtml(GenUtil.TruncateData((String)hm.get("eventname"),45),true)%></a>
		<%}%>
		
		
		
		</td></tr>
		</table>
	<%}if("event".equals(type)){
	if(groupsvector!=null&&groupsvector.size()>0){
	for(int i=0;i<groupsvector.size();i++){
		hm=new HashMap();
		if(i%2==0){
			base="onebase";
		}else{
			base="onebase";
		}
		hm=(HashMap)groupsvector.elementAt(i);
		link=serveraddress+"event?eid="+hm.get("event_groupid");
		String start_date=DbUtil.getVal("select trim(to_char(b.start_date,'DD Mon')) as start_date from group_events a, eventinfo b where a.event_groupid=? and a.eventid=b.eventid order by start_date asc",new String[]{(String)hm.get("event_groupid")});

		%>
		<table border="0" width="100%" align="center" cellspacing="0" cellpadding="0">

		<tr class="<%=base%>" width="100%"><td class="<%=base%>" width="15%" ><%=start_date%></td><td align='left' class="<%=base%>" width="85%" >
		<a HREF="<%=link%>"><img src="/home/images/ticket.gif" width='13' height="11" border='0' alt="Registration Available"/></a>
		 <a HREF="<%=link%>"><%=GenUtil.textToHtml(GenUtil.TruncateData((String)hm.get("group_title"),45),true)%></a>
		
		</td></tr>
		</table>
	<%}
	}	
	%>
		<table border="0" width="100%" align="center" cellspacing="0" cellpadding="0">
	
<tr>

	<td  align='right' colspan="2" class='smallestfont' >
	&raquo;&nbsp;<a href="<%=PageUtil.appendLinkWithGroup("/portal/eventdetails/events.jsp?evttype=event&UNITID=13579",(HashMap)request.getAttribute("REQMAP"))%>">All Events</a>&nbsp;&nbsp;&nbsp;
	&raquo;&nbsp;<a href="/portal/guesttasks/addevent.jsp?isnew=yes">List Event</a>&nbsp;&nbsp;&nbsp;
	</td>
	
</tr>
</table>
<%}
else{
%>
<table border="0" width="100%" align="center" cellspacing="0" cellpadding="0">

<tr >

	
	<td  colspan="2" align="right" class='smallestfont'>
	&raquo;&nbsp;<a href="<%=PageUtil.appendLinkWithGroup("/portal/eventdetails/events.jsp?evttype=class&UNITID=13579",(HashMap)request.getAttribute("REQMAP"))%>">All Classes</a>&nbsp;&nbsp;&nbsp;
	&raquo;&nbsp;<a href="/portal/guesttasks/addevent.jsp?isnew=yes">List Class</a>&nbsp;&nbsp;&nbsp;
	</td>
</tr>
</form>
</table>

<%
}%>

<%}



HashMap pm=getnetadvevents(result_vec); 
String partnerid=EbeeConstantsF.get("networkadv.partner","3809");
boolean isnewsession=(session.getAttribute("netadv_session_"+type)==null);
if(isnewsession)
{
session.setAttribute("netadv_session_"+type,"yes");
if(pm!=null){
PartnerTracking pt=new PartnerTracking(pm);
pt.setInsertionType("homepageimpressions");
pt.setPartnerId(partnerid);
pt.start();

}

}	
 



%>
