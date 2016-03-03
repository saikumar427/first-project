<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<script type='text/javascript' language='JavaScript' src='/home/js/jQuery.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/prototype.js'></script>

<script>
function getReports(groupid,trackcode,secretecode){
var displayflag=true;
 var eventdate='';
if(document.getElementById('eventdate')){
 var index=document.getElementById('eventdate').selectedIndex;
 eventdate=document.getElementById('eventdate').options[index].value;
 if(eventdate=='')
  displayflag=false
 }
  
  
  if(displayflag){
	new Ajax.Request('/ntspartner/trackingreports.jsp?timestamp='+(new Date()).getTime(), {
	  method: 'get',
	  parameters:{groupid:groupid,trackcode:trackcode,secretcode:secretecode,eventdate:eventdate},
	  onSuccess: reportsResponse
	  
  });
  }
  else{
  $('reports').innerHTML='';
  }
	
}




function reportsResponse(response){
if($('reports'))
$('reports').update(response.responseText);		
}
</script>
<%!
public ArrayList getRecurringEventDates(String eventid){

ArrayList al=new ArrayList();
DBManager db=new DBManager();
String str=null;
String query="";

String isrecurr=DbUtil.getVal("select value from config where config_id in(select config_id from eventinfo "+
                    " where eventid=to_number(?,'999999999')) and name='event.recurring'",new String[]{eventid});  
                    
if("Y".equals(isrecurr)){

 /* String powertype=DbUtil.getVal("select value from config where config_id " +
	" in(select config_id from eventinfo where eventid=to_number(?,'999999999')) and name='event.rsvp.enabled'",new  String[]{eventid});
   
   query=" select  to_char(zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH12:MI:SS') as text) "+
    " as time ),'Dy, Mon DD, YYYY HH12:MI AM') as evt_start_date"+
    " from event_dates where eventid=? and (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),"+
    " 'HH12:MI:SS aaa') as text) as time ))>=current_date order by (zone_startdate+cast "+
    " (cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH12:MI:SS aaa') as text) as time ))";
    
    
    */
       
    query="select distinct eventdate as evt_start_date from event_reg_transactions  "+
				"where eventid=? and eventdate!=''";  

        
      
 }   
 
 
StatusObj stob=db.executeSelectQuery(query,new String[]{eventid} );
System.out.println("status in get recurring dates"+stob.getStatus());
if(stob.getStatus()){
for(int i=0;i<stob.getCount();i++){
al.add(db.getValue(i,"evt_start_date",""));
}
}
return al;
}



%>




<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
ArrayList al=getRecurringEventDates(groupid);


if(al!=null&&al.size()>0){
%>


<table >
<tr><td align='left'>Event Date: </td><td><select name='eventdate' id='eventdate' onChange="getReports(<%=groupid%>,'<%=request.getParameter("trackcode")%>','<%=request.getParameter("secretcode")%>')");
'>
<option value=''>--Select date--</option>

<%
for(int i=0;i<al.size();i++){

%>
<option val='<%=al.get(i)%>'><%=al.get(i)%></option>
<%}%>
</select>
</td></tr>

<tr height='20'><td></td></tr>
</table>
<%
}
%>

<div id='reports'></div>


<script>
getReports(<%=groupid%>,'<%=request.getParameter("trackcode")%>','<%=request.getParameter("secretcode")%>');
</script>
