<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.useraccount.AccountDB" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.*,com.eventbee.event.ticketinfo.*" %>
<%@ page import="com.eventbee.general.formatting.EventbeeStrings" %>
<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function dummy1() { }
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy1() { }
</script>


<%
String domainurl="";
String domain=(String)session.getAttribute("domain");
if(domain==null)
domain=request.getParameter("domain");
if("ning.com".equals(domain))
domain="eventbee.ning.com";

if("eventbee.ning.com".equals(domain))

 domainurl="http://"+domain+"/opensocial/application/show?appUrl=http://www.eventbee.com/home/ning/test.xml?ning-app-status=child";
else
domainurl="http://"+domain+"/opensocial/application/show?appUrl=http://www.eventbee.com/home/ning/eventregister.xml";



%>


<script>

function SetSession(evtid,evtname,oid,purpose){

advAJAX.get( {
		url   : '/ningapp/ticketing/setownersession.jsp?GROUPID='+evtid+'&evtname='+evtname+'&oid='+oid+'&purpose='+purpose,
	    onSuccess : function(obj) {
	    
	   var  rtxt=obj.responseText;
	  
	    	    		if(rtxt.indexOf("Success")>-1){
	 top.location.href="<%=domainurl%>&owner="+oid;
	 //top.location.href="/ningapp/ticketing/canvasownerpagebeelets.jsp";

	    	    			
	    	    		}else{
	    		}
	  	    
		   },
	    onError : function(obj) { 
	    //alert("Error: " + obj.status); 
	    }
	});
}










</script>









<%!
String buildEvents(Vector myevents,String unitid,String Showmanage,String oid,HttpSession session){
	StringBuffer sb=new StringBuffer("");
	String base="evenbase";
	String powerlink="/portal/ningapp/ticketing/editPoweredBy.jsp;jsessionid="+session.getId()+"?GROUPTYPE=Event&PS=eventmanage&evttype=event&GROUPID=";
		String ticketlink="/portal/ningapp/ticketing/addtickets.jsp;jsessionid="+session.getId()+"?GROUPTYPE=Event&PS=eventmanage&evttype=event&GROUPID=";
	
	int vsize=(myevents.size()>5)?5:myevents.size();
	for(int i=0;i<vsize;i++){
	boolean ispowered=false;
	boolean isrsvpd=false;
		HashMap myevent=(HashMap)myevents.elementAt(i);
		ispowered="Yes".equalsIgnoreCase(EventTicketDB.getEventConfig((String)myevent.get("eventid"), "event.poweredbyEB"));
		isrsvpd=(EventTicketDB.getEventConfig((String)myevent.get("eventid"), "event.rsvp.enabled")!=null);
		String count=DbUtil.getVal("select count(*) from price where evt_id=?",new String [] {(String)myevent.get("eventid")});
		base=(i%2==0)?"oddbase":"evenbase";
		sb.append("<tr ><td class='"+base+"' align='left' width='100%' colspan='4'> ");
		sb.append("<b>"+(String)myevent.get("eventname")+"</b>");
		sb.append("</td>");
		sb.append("</tr>");
			sb.append("<tr ><td class='"+base+"' colspan='4' align='left'>");
		sb.append((String)myevent.get("start_date")+" "+(String)myevent.get("city"));
		if(("".equals(myevent.get("state")))||(myevent.get("state"))==null){
		}else{
			sb.append(", "+(String)myevent.get("state"));
		}
 		if(("".equals(myevent.get("country")))||(myevent.get("country"))==null){
		}else{
			sb.append(", "+(String)myevent.get("country"));
		}
		sb.append("</td></tr>");
		sb.append("<tr >");
		sb.append("<td colspan='2'  class='"+base+"'  align='left' valign='top' width='30%'>");
		sb.append("Status: "+GenUtil.getInitCapString(GenUtil.getHMvalue(myevent,"status").toLowerCase()));
		sb.append("</td>");
		
		sb.append("<td colspan='2' class='"+base+"' align='left' valign='top' width='70%'>");
		
		if("yes".equals(Showmanage)){
				sb.append("&raquo;&nbsp;<a href='/portal/ningapp/ticketing/eventmanage.jsp;jsessionid="+session.getId()+"?GROUPID="+(String)myevent.get("eventid")+"&evtname="+java.net.URLEncoder.encode((String)myevent.get("eventname"))+"'>");
				sb.append("Manage");
				sb.append("</a>");
				}
				else{
				sb.append("&raquo;&nbsp;<a href='# ' onclick=SetSession('"+(String)myevent.get("eventid")+"','"+java.net.URLEncoder.encode((String)myevent.get("eventname"))+"','"+oid+"','manage')>");
				sb.append("Manage");
				sb.append("</a>");
				}
				 sb.append("<br/>");
				if(ispowered){
				 if("0".equals(count)){
				 if("yes".equals(Showmanage))
				 sb.append("&raquo;&nbsp;<a href='"+ticketlink+(String)myevent.get("eventid")+"&evtname="+java.net.URLEncoder.encode((String)myevent.get("eventname"))+"'>Add Tickets</a><br/>");
		                  else
		                  sb.append("&raquo;&nbsp;<a href='#' onclick=SetSession('"+(String)myevent.get("eventid")+"','"+java.net.URLEncoder.encode((String)myevent.get("eventname"))+"','"+oid+"','addtickets')>Add Tickets</a><br/>");
		                 
		                  
		                  }
		
				 }
				 else if(!ispowered){
				 if("yes".equals(Showmanage))
				sb.append("&raquo;&nbsp;<a href='"+powerlink+(String)myevent.get("eventid")+"&evtname="+java.net.URLEncoder.encode((String)myevent.get("eventname"))+"'>Power with Online Registration</a><br/>");
		                 else
		                 sb.append("&raquo;&nbsp;<a href='#' onclick=SetSession('"+(String)myevent.get("eventid")+"','"+java.net.URLEncoder.encode((String)myevent.get("eventname"))+"','"+oid+"','powerwith')>Power with Online Registration</a><br/>");
		                     
		                 }
		sb.append("</td>");
		
		
		
		
		
		sb.append("</tr>");
		
		
	}
	return sb.toString();
}

String getStatusDetails(HashMap lhm,String [] statusArray,String link) {
	int total=0;
	String status="";
	StringBuffer sb=new StringBuffer("");
	for(int i=0;i<statusArray.length;i++){
		status=statusArray[i];
		if(lhm.get(status)==null) lhm.put(status, "0");
	}
	Set set=lhm.entrySet();
	Iterator iter=set.iterator();
	while(iter.hasNext()){
		Map.Entry me=(Map.Entry)iter.next();
		String stat=(String)me.getKey();
		String count=(String)me.getValue();
		if(!("CANCEL".equals(stat))) total=Integer.parseInt(count)+total;
	}
	lhm.put("ALL",total+"");
	String statusString="";
	sb.append("<tr >");
	sb.append("<td class='oddbase' colspan='4'>");
	sb.append("Summary: ");
	int j=0;
	for(int i=0;i<statusArray.length;i++){
		String status1=statusArray[i];
		if(Integer.parseInt((String)lhm.get(status1))>0){
			String count=(String)lhm.get(status1);
			if(j>0) sb.append(", ");
			//sb.append("<a href='"+link+status1+"'>");
                        sb.append("<a href='"+link+status1+"'>");	        
			sb.append(EventbeeStrings.makeFirstCharCaps(status1.toLowerCase())+"("+count+")");
			sb.append("</a>");
			j++;
			}else{
				statusString=(String)lhm.get(status1);
			}
		}
		sb.append("</td>");
		sb.append("</tr>");

	return sb.toString();
}
%>

<%

String reseturl="";
String Showmanage=request.getParameter("Showmanage");
if(session.getAttribute("listmap")!=null)
session.removeAttribute("listmap");

String authid=null,unitid=null,fromcontext=null;
Authenticate authData=(Authenticate)session.getAttribute("authData");

Vector mylistedevents=null;
fromcontext=(String)session.getAttribute("fromcontext");
if (authData!=null){
	authid=authData.getUserID();
	unitid=authData.getUnitID();
}
	boolean listevts=true;
	


mylistedevents=AccountDB.getMgrListedEvents(authid,request.getParameter("eventname"),request.getParameter("status"));
String eventname=request.getParameter("eventname");
if(eventname==null) eventname="";
String status=request.getParameter("status");
if(status==null) status="";

String evtnamesrchPlsHld="Enter Event Name";
String evtdisplay=eventname;
String evtdisplayclass="stdstyle";
if("".equals(eventname)){
	evtdisplay=evtnamesrchPlsHld;
	evtdisplayclass="greystyle";
}



String oid=DbUtil.getVal("select nid from ebee_ning_link where ebeeid=?",new String[]{authid});




	%>
<style>
.greystyle {
	color: gray;
}
.stdstyle {
	color: black;
	
}
</style>
<script>
	function resetevents(url){
		window.location.href=url;
	}
	function showPlaceholderContent(textbox, placeholdertext) {
	    if(textbox.value == ''){
	    	textbox.value = placeholdertext;
	    	textbox.className='greystyle';
	    }
	}
	function clearPlaceholderContent(textbox, placeholdertext) {
	
	    if(textbox.value == placeholdertext){   
	   	textbox.value = '';
	   	textbox.className='stdstyle';
	   }
	}
	function seteventname() {
		clearPlaceholderContent(document.getElementById('eventname'),'<%=evtnamesrchPlsHld%>');
	  
	}
</script>

<div class='memberbeelet-header'>My Listed Events</div>

<table align="center" cellpadding="5" cellspacing="0" width="100%">
<tr>
<td colspan="4" align="right" class="colheader">
<%
if("yes".equals(Showmanage)){

reseturl="/portal/ningapp/ticketing/canvasownerpagebeelets.jsp";

%>
<form name="form" action="/ningapp/ticketing/addevent.jsp;jsessionid=<%=session.getId()%>" method="post" >
      <input type="hidden" name="isnew" value="yes" />
<input type="submit" name="submit" value=" List New Event or Copy Existing Event" />
</form>

<%}
else
{
reseturl="/portal/ningapp/ticketing/myeventsbeelet.jsp";


%>
<input type="button" name="submit" value=" List New Event or Copy Existing Event" onClick="SetSession('1','1','<%=oid%>','addevent')"/>

<%}%>

</td>
</tr>
<tr>
<td colspan="4"  class="colheader">
<%if("yes".equals(Showmanage)){%>
<form name="form" action="/portal/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid=<%=session.getId()%>" method="post" onSubmit="seteventname()">
<%}
else{%>
<form name="form" action="/portal/ningapp/ticketing/myeventsbeelet.jsp;jsessionid=<%=session.getId()%>" method="post" onSubmit="seteventname()">
<%}%>
<input type="text" class="<%=evtdisplayclass%>" value="<%=evtdisplay%>" onfocus="clearPlaceholderContent(this,'<%=evtnamesrchPlsHld%>');" onblur="showPlaceholderContent(this,'<%=evtnamesrchPlsHld%>');"  name="eventname" id="eventname"> 
 <select name="status">
<option value="" <%="".equals(status)?"selected":""%>>All</option>
<option value="ACTIVE" <%="ACTIVE".equals(status)?"selected":""%>>Active</option>
<option value="CLOSED" <%="CLOSED".equals(status)?"selected":""%>>Closed</option>
<option value="PENDING" <%="PENDING".equals(status)?"selected":""%>>Suspended</option>
</select>
<input type="submit" value="Search" >
<a href="#" onClick="resetevents('<%=reseturl%>')" >Reset</a>
</form>
</td>
</tr>


<%
if(mylistedevents==null||mylistedevents.size()==0){
%>
	<tr valign="center" width="100%">
	<td  align="left" class="evenbase" colspan='4'>No Events Listed</td>
	</tr>
<%
}else{
	HashMap lhm=EventStatsDB.getMyListedEventStats(authid);
	String [] statusArray1={"ACTIVE","PENDING","CLONE","CLOSED","HOLD","ALL"};
	String link=request.getContextPath()+"/ningapp/ticketing/myListedEventsDetails.jsp;jsessionid="+session.getId()+"?platform=ning&status=";
%>
	<%=getStatusDetails(lhm,statusArray1,link)%>
	<%=buildEvents(mylistedevents,unitid,Showmanage,oid,session)%>
<%
		
}
%>
</table>
