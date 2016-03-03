<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.EventDB" %>
<%!
public Vector getTrackingURLdetails(String groupid){
	Vector v= new Vector();
	DBManager dbm =new DBManager();
	HashMap userhashmap=null;
	StatusObj statobj=null;
	String	query="select eventid,trackingcode,trackingid,count,secretcode from  trackurls  where  eventid=?";
	statobj=dbm.executeSelectQuery(query,new String[]{groupid});
	if(statobj.getStatus()){
		for(int k=0;k<statobj.getCount();k++){
			userhashmap=new HashMap();
			userhashmap.put("eventid",dbm.getValue(k,"eventid",""));
			userhashmap.put("trackingid",dbm.getValue(k,"trackingid",""));
			userhashmap.put("trackingcode",dbm.getValue(k,"trackingcode",""));
			userhashmap.put("count",dbm.getValue(k,"count",""));
			userhashmap.put("secretcode",dbm.getValue(k,"secretcode",""));
			v.add(userhashmap);
		}
	}
	return v;
	}	
	
	
	
%>
<%
String groupid=null;
	String serveraddress=EbeeConstantsF.get("serveraddress","www.eventbee.com");
   
	HashMap hm=(HashMap)session.getAttribute("groupinfo");
	if(hm!=null){
		groupid=(String)hm.get("groupid");
		
	}
	String username="";
		HashMap evthm=EventDB.getEventInfo(groupid);
			   
		if(evthm!=null){
				username=(String)evthm.get("username");
	}
String eventurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
if(eventurl!=null)
eventurl=eventurl+"/track/";
	
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links";
String isexist=DbUtil.getVal("select 'Yes' from trackurls where eventid=?",new String[]{groupid});
Vector v1=getTrackingURLdetails(groupid);
String base="oddbase";
%>

<script>
function createTrackingURL(groupid){
advAJAX.get( {			
		url : '/portal/eventmanage/ajaxtrackingurlprocessor.jsp?groupid='+groupid,
		onSuccess : function(obj) {
		var data=obj.responseText;
		data=testtrim(data);
		if(data.indexOf("Success")>-1){
		document.getElementById('trackname').style.display="block";		
		document.getElementById('trackurl').disabled=true;

		}else{
		alert("Event Custom URL is required to create Tracking URLs. Create Custom URL in Integration Links, then create Tracking URLs");
		}
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
			
	
}

function back()
{
	document.getElementById('trackname').style.display='none';
	document.getElementById("errormsg").innerHTML="";
	document.getElementById("trackurl").disabled=false;
		
}

function inserttrackingurl(groupid){
var name=document.getElementById('name').value;	
document.getElementById('name').value=name.replace(/^(?:\s)*/g,'').replace(/(?:\s)*$/g,'');
if(name==""){
document.getElementById("errormsg").innerHTML="Enter Name";
return;
}
		advAJAX.get( {			
		url : '/portal/eventmanage/inserttrackingdetails.jsp?groupid='+groupid+'&name='+name,
		onSuccess : function(obj) {
		var data=obj.responseText;
		data=testtrim(data);
		if(data.indexOf("Name Exists")>-1){
		document.getElementById("errormsg").innerHTML="This name is not available, please enter new name";
		document.getElementById("trackurl").disabled=false;
		}else if(data.indexOf("spacesInUrl")>-1)
			{
			document.getElementById("errormsg").innerHTML="Use alphanumeric characters only";
			}else{
		
		document.getElementById('trackname').style.display="none";
		window.location.reload(true);
		}
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});

}

</script>
<script type="text/javascript">
function gettrackname()
{
document.getElementById('url').value=document.getElementById('name').value;
}
</script>
<table class="portaltable" align="center" cellpadding="0" cellspacing="0" width="100%" border='0'>
<tr>
<td class='memberbeelet-header' >Tracking URLs [<a href="javascript:popupwindow('<%=linkpath%>/trackingurls.html','Tags','600','400')">?</a>]</td>
</tr>
<tr>
<td class='colheader' align="right" >
<input type="button" name="trackurl"  id="trackurl" value="Create" onclick="createTrackingURL(<%=groupid%>);" >&nbsp;&nbsp;
<%if(isexist!=null){%>
<a href="/mytasks/trackingreportsummary.jsp?eid=<%=groupid%>&from=manager"  >All Reports</a>
<%}%>
</td>
</tr>
<tr><td id='errormsg' class='error'></td></tr>
<tr>
<td ><div id="trackname" class='colheader' style="display:none"> 
Name: <input type="text" name="name" id="name" onkeyup="gettrackname()"; onkeydown="gettrackname()"; /><br>
<%=eventurl%><input type="label" name="url" id="url" readonly><br>
<input type="button" name="button" value="Submit" onclick="inserttrackingurl(<%=groupid%>);" />
<input type="button" value="Cancel" onclick="back();" />
</div></td>
</tr>
</table>

<%
if(eventurl!=null){
if(v1.size()>0){
   if(v1!=null&&v1.size()>0){
   for(int i=0;i<v1.size();i++){
   	   if(i%2==0)
   	  		base="evenbase";
   	  	else
   		base="oddbase";
   		  HashMap hmt=(HashMap)v1.elementAt(i);
   		  String eventid=(String)hmt.get("eventid");	
   		  String trackingcode=(String)hmt.get("trackingcode");	
   		  String trackingid=(String)hmt.get("trackingid");
   		  String count=(String)hmt.get("count");
   		  String secretcode=(String)hmt.get("secretcode");

   		  
%>
<table  class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<tr>
<td class="<%=base%>">
Name: <%=trackingcode%>&nbsp;&nbsp;<a href='/mytasks/managetrackingurls.jsp?gid=<%=groupid%>&trackcode=<%=trackingcode%>&count=<%=count%>&from=manager&secretcode=<%=secretcode%>'>Manage</a>
</td>
</tr>
<tr>
<td class="<%=base%>">
URL: <%=eventurl%><%=trackingcode%>
</td>
</tr>
<tr>
<td class="<%=base%>">
Visits: <%=count%>
</td>
</tr>
<tr>
<td class="<%=base%>">
Tickets Sold: <a href='/mytasks/trackreport.jsp?landf=yes&filter=manager&gid=<%=eventid%>&trackcode=<%=trackingcode%>&secretcode=<%=secretcode%>'>Report</a>
</td>
</tr>
</table>
<%}
}
}
}%>