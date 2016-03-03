<%@ page import="com.eventbee.general.*"%>
<%
String platform = request.getParameter("platform");
String oid = request.getParameter("oid");
if(oid==null){
oid=(String)session.getAttribute("oid");
}

System.out.println("oid in allnts"+oid);
String linktarget="_self";
String URLBase="mytasks";
String path="allntsparticipationeventsview.jsp";
if("ning".equals(platform)){
	linktarget="_blank";
	URLBase="ningapp";
	path="ning_allntsparticipationeventsview.jsp";
}

java.util.Date date=new java.util.Date();
String contenturl="/ntspartner/"+path+"?tm="+date.getTime()+"&platform="+platform+"&oid="+oid;
System.out.println(contenturl);
%>
<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}         
         
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy1() { }
</script>

<script>
function getNextSet(newBeginIndex){
	url="<%=contenturl%>&begin="+newBeginIndex;
	makeRequest(url,"allntsevents");
	
}
function getPreviousSet(newBeginIndex){
	
	url="<%=contenturl%>&begin="+newBeginIndex;
	makeRequest(url,"allntsevents");
	
}

function  eventregister(id,pid){
		                
	window.location.href='/event?eid='+id+'&participant='+pid;			
}
</script>
<script>
function searchevents(evtnamesrchPlsHld) {
var eventname=document.getElementById('eventname').value;
if(eventname=="Enter Event Name") eventname="";
clearPlaceholderContent('eventname','evtnamesrchPlsHld');
  url="<%=contenturl%>&eventname="+eventname;
	makeRequest(url,"allntsevents");
	}

function resetevents(){
makeRequest("<%=contenturl%>","allntsevents");
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
</script>
<script>
function  manageevent(id,platform){
	window.location.href='/mytasks/partnerlinks.jsp?groupid='+id+'&platform='+platform;			
}	

function  getapproval(id,platform){
	window.location.href='/mytasks/getntsapproval.jsp?groupid='+id+'&platform='+platform;			
}	
function  registerevent(id,platform){
	window.location.href='/event?eid='+id+'&platform='+platform;			
}	


</script>


<table cellpadding="0"  cellspacing="0" align="center" valign="top" width="100%">
<tr><td  class='memberbeelet-header'>My Network Ticket Selling Participation</td></tr>
<tr><td valign="top" >

<div id="allntsevents" >

<jsp:include page='<%=contenturl%>' />
</div>

</td></tr>


</table>




