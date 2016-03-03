<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.f2f.F2FEventDB"%>

<%!


HashMap  getCountDetails(String userid){
 
 
 DBManager dbmanager=new DBManager();
 StatusObj sb=dbmanager.executeSelectQuery("select enableparticipant,count(*)as count from group_agent_settings a,eventinfo e where   a.groupid=e.eventid and e.status='ACTIVE' and e.listtype='PBL' group by enableparticipant", null);
 Vector vec=new Vector();
  HashMap hm=new HashMap();

 if(sb.getStatus()){
 for(int i=0;i<sb.getCount();i++){

 hm.put(dbmanager.getValue(i,"enableparticipant",""),dbmanager.getValue(i,"count",""));
 
}
 
 }
return hm;
}


%>



<%
String maxcommission=" ";
String mincommission=" ";

String serveraddress=(String)session.getAttribute("HTTP_SERVER_ADDRESS");
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
	userid=authData.getUserID();
}
CurrencyFormat cf=new CurrencyFormat();	
%>





<script language="javascript" src="/home/js/advajax.js" >
dummy23456=888111;

</script>

<script language="javascript" src="/home/js/ajax.js" >
dummy2335256=532567;

</script>
<link rel="stylesheet" type="text/css"  href="/home/css/webintegration.css" />
<script type="text/javascript" language="JavaScript" src="/home/js/dhtmlpopup.js">
        function dummy() { }
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/webintegration.js">
</script>

<script>

function getparticipated(){

if(document.participated.showhide1.value=='Hide'){
	document.participated.showhide1.value='Show';
		document.getElementById('participatedevents').innerHTML='';
		return;
	}
	
		document.participated.showhide1.value='Showing....';
	 	
		
	advAJAX.submit(document.getElementById("participated"), {
    	onSuccess : function(obj) {
			var data=obj.responseText;
			document.getElementById('participatedevents').innerHTML=obj.responseText;
			document.participated.showhide1.value='Hide';
			},
    		onError : function(obj) { alert("Error: " + obj.status); }
		});











}





function getnotenabled(){
	if(document.notenabledevents.showhide.value=='Hide'){
		document.notenabledevents.showhide.value='Show';
		document.getElementById('notenabled').innerHTML='';
		return;
	}
	
		document.notenabledevents.showhide.value='Showing....';
	 	
		
	advAJAX.submit(document.getElementById("notenabledevents"), {
    	onSuccess : function(obj) {
			var data=obj.responseText;
			document.getElementById('notenabled').innerHTML=obj.responseText;
			document.notenabledevents.showhide.value='Hide';
			},
    		onError : function(obj) { alert("Error: " + obj.status); }
		});
}

function getdetails(evtid,val){

advAJAX.get( {
			url : "/portal/eventbeeticket/commissiondetails.jsp?GROUPID="+evtid+"&result="+val,
			
			onSuccess : function(obj) {
			
			document.getElementById("mypopup"+val).innerHTML=obj.responseText;
			},
			
			onError : function(obj) { alert("Error: " + obj.status); }
		});
}


function closepopup(position){
document.getElementById("mypopup"+position).innerHTML = ' ';

}

function closepopup1(position){
document.getElementById("popup"+position).innerHTML = ' ';

}
function getdetails1(evtid,val){
advAJAX.get( {
			url : "/portal/eventbeeticket/ticketdetails.jsp?GROUPID="+evtid+"&result="+val,
			
			onSuccess : function(obj) {
			
			document.getElementById("popup"+val).innerHTML=obj.responseText;
			
			},
			
			onError : function(obj) { alert("Error: " + obj.status); }
		});
}

</script>
<%
int count=0;
int count1=0;
String evtcount="";

String evtcount1="";

HashMap gm=getCountDetails(userid);

if(gm!=null&&gm.size()>0){
try{
  evtcount=(String)gm.get("No");
  evtcount1=(String)gm.get("Yes");

 }
catch(Exception e){

System.out.println("Exception occured is--------------"+e.getMessage());

}

}


%>
<table cellpadding="5"  cellspacing="0" align="center" width="100%">
<!--form action="/portal/mytasks/evtInformFriends.jsp" method="post"-->


<div class='memberbeelet-header'>My Network Ticket Selling Participation</div>


<%

 try{
 
 count=Integer.parseInt(evtcount1);
 }
 catch(Exception e){
 
 count=0;
 evtcount1="0";
 }
 
  try{
  
  count1=Integer.parseInt(evtcount);
  }
  catch(Exception e){
  
  count1=0;
  evtcount="0";
 }
 
 
 
 
 
%>


<table cellpadding="5"  cellspacing="0" align="center" width="100%">
<form name='notenabledevents' id='notenabledevents' action='/eventbeeticket/notenabled.jsp' method='post' onsubmit='getnotenabled();return false'>

<%--<tr><td colspan='5' id='head' class='colheader'><b>Events without Participation Page</b></td></tr>--%>
<%--<tr><td colspan='5' class='evenbase' id='msg'>There are <%=evtcount%> events, <a href='#' id='myAnchor' onclick='getnotenabled()'>click here</a> to view them.</td></tr>--%>
<%if(count1==1){%>

<tr><td colspan='5' class='evenbase'>There is <%=evtcount%> event.   <input type='submit' id='showhide1' name='showhide1' value='Show'/></td></tr>
<%}
else{
%>

<tr><td colspan='5' class='evenbase'>There are <%=evtcount%> events.   <input type='submit' id='showhide' name='showhide' value='Show'/></td></tr>

<%}%><tr><td colspan='5' class='evenbase'><div id='notenabled'></div></td></tr>

</form>
</table>
<%-- <table cellpadding="5"  cellspacing="0" align="center" width="100%">
<form id='participated' name='participated' action="/eventbeeticket/eventswithparticipationpage.jsp" method="post" onsubmit='getparticipated();return false'>
<tr><td colspan='5' class='colheader'><b>Events with Custom Participation Page</b></td></tr>

<%
if(count==1){%>

<tr><td colspan='5' class='evenbase'>There is <%=evtcount1%> event.   <input type='submit' id='showhide1' name='showhide1' value='Show'/></td></tr>
<%}
else
{%>
<tr><td colspan='5' class='evenbase'>There are <%=evtcount1%> events.   <input type='submit' id='showhide1' name='showhide1' value='Show'/></td></tr>
<%}

%>
<tr><td colspan='5' class='evenbase'><div id='participatedevents'></div></td></tr>
	
<input type='hidden' name="UNITID" value='13579'>
<input type="hidden" name="category" value="f2fselling">
</form>
</table>--%>
</table>

<%
try{
if(Integer.parseInt(evtcount)==0){%>
<script>
 document.notenabledevents.showhide.disabled=true;
 </script>
 <%}}
 
 catch(Exception e)
 
 {
 
System.out.println("Exception occured in Myf2f Page.jsp is ---------------"+e.getMessage());
 }%>

