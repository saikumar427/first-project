<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.event.*,com.eventbee.event.ticketinfo.*" %>
<%@ page import="com.eventbee.general.formatting.EventbeeStrings" %>
<%@ page import="com.eventbee.useraccount.AccountDB" %>
<%@ page import="com.eventbee.f2f.F2FEventDB"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>

<% java.util.Date date=new java.util.Date();%>
<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>
<script language="javascript" src="/home/js/popup.js">
         	function dummy(){}
	</script>	

 <!--  <script type="text/javascript">

var d = new Date();
document.write(d.getTime() + " milliseconds since 1970/01/01");

</script> -->
<script>
function testtrim(str){
	var temp='';
	temp=new String(str);
	temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');
	return temp;
}
function addnwtsellMgrImages(refid,type){
 var cnt=0;

	advAJAX.submit(document.getElementById("nwtImagesMgrUpload"), {
    onSuccess : function(obj) {
	//var data=obj.responseText;
	//var url='';
	//data=testtrim(data);
	document.getElementById('addmgrImages').innerHTML='';
	
	 makeRequest("/eventbeeticket/nwtImagesdisp.jsp?type=mgr&groupid="+refid,"displayntmgrimages");
	 
	cnt++;
		          
			//document.getElementById('displayntimages').innerHTML=data;
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});

  

}


function deleteMgrImage(imgid,evtid){

	advAJAX.get( {
		url : '/portal/eventbeeticket/deleteimage.jsp?type=mgr&imgid='+imgid+'&groupid='+evtid,
		onSuccess : function(obj) {
		var data=obj.responseText;
		data=testtrim(data);
		if(data=='success'){
			makeRequest("/eventbeeticket/nwtImagesdisp.jsp?type=mgr&groupid="+evtid,"displayntmgrimages");
		}
		//document.getElementById('showattributes').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});

}

function getInternalPhotos(){
	document.getElementById('internal_photos').style.display="block";
	document.getElementById('exturl').style.display="none";
}

function getExturl(){
	
	document.getElementById('exturl').style.display="block";
	document.getElementById('internal_photos').style.display="none";

}

</script>
<%
String platform = request.getParameter("platform");
if(platform==null) platform="";
String URLBase="mytasks";
if("ning".equals(platform)){
        URLBase="ningapp/ticketing";
}

String evtname=request.getParameter("evtname");
if(evtname!=null)
evtname=java.net.URLEncoder.encode(evtname);
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
String unitid=request.getParameter("UNITID");
String setid=F2FEventDB.getVal(F2FEventDB.getVal_Query,groupid);
boolean ispowered=false;
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links";
String memcount=DbUtil.getVal("select count(*) from authentication",new String[]{});
int webpgs=Integer.parseInt(memcount)*5;
String nts_approvaltype=DbUtil.getVal("select nts_approvaltype from group_agent_settings where groupid=?",new String[]{groupid});	
String status=F2FEventDB.getVal(F2FEventDB.getStatus_Query,groupid);
if(status==null)
	status="No";

Vector v=new Vector();
v=F2FEventDB.getEventsInfo(v,groupid,F2FEventDB.AGENTS_INFO_QUERY);

String username="";
HashMap evthm=EventDB.getEventInfo(groupid);		   
if(evthm!=null){		
	username=(String)evthm.get("username");
}	
String eventurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
if(eventurl==null)	
	eventurl=ShortUrlPattern.get(username)+"/participate?eid="+groupid;
else{
	eventurl=eventurl+"/participate?eid="+groupid;				
}
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
eventurl=serveraddress+"/participate.jsp?eid="+groupid;
%>
<div class='memberbeelet-header'>Network Ticket Selling [<a href="javascript:popupwindow('<%=linkpath%>/networkticketselling.html','Tags','600','400')">?</a>]</div>
<table  class='portaltable' cellpadding="0" cellspacing="0" align="center" width="100%">
<form action="/portal/eventbeeticket/redirect.jsp" method="post">
<%
String foroperation=("yes".equalsIgnoreCase(status))?"edit":"add";
%>
<input type='hidden' name='GROUPID' value='<%=groupid%>'/>
<input type='hidden' name='UNITID' value='13579'/>
<input type='hidden' name='evtname' value='<%=evtname%>'/>
<input type='hidden' name='isnew' value='yes'/>
<input type='hidden' name='foroperation' value='<%=foroperation%>'/>
<input type='hidden' name='setid' value='<%=setid%>'/>
<input type='hidden' name='platform' value='<%=platform%>'/>

<tr  ><td class="evenbase" align="left" colspan='2'> Enabled: <%=status%></td>
<%
if ("Yes".equals(status)){
%>
<td class="evenbase"  align="right" >
<input type="submit" name="Submit" value="Disable"/>
</td></tr>

<%}else{
	ispowered="Yes".equalsIgnoreCase(EventTicketDB.getEventConfig(groupid, "event.poweredbyEB"));
	if(!ispowered){
		%><td align="right" class="evenbase"><a href="/portal/<%=URLBase%>/editPoweredBy.jsp?GROUPTYPE=Event&UNITID=13579&PS=eventmanage&evttype=event&GROUPID=<%=request.getParameter("GROUPID")%>">Power with Online Registration</a><br/></td>
	<%}else{%>
		<td align='right' colspan='2' class="evenbase">
		<input type="submit" name="Submit" value="Enable"/>
		</td>
		<tr>
		<td class="evenbase"  align="left" colspan='4'>
		<a href="/portal/<%=URLBase%>/settask.jsp?GROUPID=<%=groupid%>&setid=<%=setid%>&isnew=yes&foroperation=<%=foroperation%>&platform=<%=platform%>">Settings</a>
		| <a href="/portal/<%=URLBase%>/searchpartner.jsp?gid=<%=groupid%>&platform=<%=platform%>">Search Partner</a></td>
</tr>
	<%}
}%>
<%
if ("Yes".equals(status)){
%>

<tr>
<td class="evenbase"  align="left" colspan='4'>
<a href="/portal/<%=URLBase%>/settask.jsp?GROUPID=<%=groupid%>&setid=<%=setid%>&isnew=yes&foroperation=<%=foroperation%>&platform=<%=platform%>">Settings</a>
| <a href="/portal/<%=URLBase%>/searchpartner.jsp?gid=<%=groupid%>&platform=<%=platform%>">Search Partner</a></td>
</tr>
<%}
if ("No".equals(status)){
%>

<tr><td colspan='4' class="evenbase">Enable Eventbee Network Ticket Selling, and sell tickets through thousands
of events, blogs, photos, profiles, communities web pages.</td></tr>
<%}else if("Auto".equals(nts_approvaltype)){%>
<tr><td colspan='3' class="evenbase"><%=memcount%> partners are participating in selling your event tickets from <%=webpgs%>
events, blogs, photos, profiles and communities web pages</td></tr>

<%}else{%>
<tr><td colspan='3' class="evenbase"><a href="/portal/<%=URLBase%>/searchpartner.jsp?gid=<%=groupid%>&platform=<%=platform%>&filter=Approved">Approved Partners<a>
| <a href="/portal/<%=URLBase%>/searchpartner.jsp?gid=<%=groupid%>&platform=<%=platform%>&filter=Pending">Pending Partners<a> | 
<a href="/portal/<%=URLBase%>/searchpartner.jsp?gid=<%=groupid%>&platform=<%=platform%>&filter=Suspended">Suspended Partners<a></td></tr>
<%}%>
</form>
</table>
	

<%
	
	if ("Yes".equals(status)){
		if(v.size()>0){
%>
			<table  cellpadding="0" cellspacing="0" align="center" width="100%">
				<tr  width="150%">
					<td width="79%" class="colheader">Participants with Event Page</td>
					<td width="10%" class="colheader" align='left'>Status</td>
					<td width="10%" class="colheader"></td>
				</tr>
<%
			String base="oddbase";
			for(int i=0;i<v.size();i++){
				if(i%2==0)
					base="evenbase";
				else
					base="oddbase";
				HashMap hm=(HashMap)v.elementAt(i);
%>
				<tr > 
					<td class="<%=base%>" align="left" ><a href="/member/<%=GenUtil.getHMvalue(hm,"username","")%>/event?eventid=<%=request.getParameter("GROUPID")%>&participant=<%=GenUtil.getHMvalue(hm,"agentid","")%>"><%=GenUtil.getHMvalue(hm,"name","")%></a> </td>
<%
				String agentstatus=GenUtil.getHMvalue(hm,"status","");
				if ("Active".equalsIgnoreCase(agentstatus))
						agentstatus="Approved";
				if ("Pending".equalsIgnoreCase(agentstatus))
						agentstatus="Approval Waiting";
				if ("suspend".equalsIgnoreCase(agentstatus))
						agentstatus="Suspended";
%>
					<td  class="<%=base%>" width="30%"><a href="/portal/<%=URLBase%>/changestatus1.jsp?UNITID=13579&GROUPID=<%=request.getParameter("GROUPID")%>&agentid=<%=GenUtil.getHMvalue(hm,"agentid","")%>"><%=agentstatus%></a>
					<td  class="<%=base%>" align="right"><a href="/portal/<%=URLBase%>/registrations_selector.jsp?UNITID=<%=request.getParameter("UNITID")%>&GROUPID=<%=request.getParameter("GROUPID")%>&agentid=<%=GenUtil.getHMvalue(hm,"agentid","")%>&PS=eventmanage">Report</a></td>
<%			}

%>
				</td>
				<td></td>
			</tr>		

		</table>
<%		}
	}
%>
<%
String contenturl="";
if ("Yes".equals(status)){

if(!"ning".equals(platform)){%>

  <table  class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<tr ><td class="colheader" width="100%" colspan="2">Partner Signup URL</td></tr>
<tr ><td class="evenbase" colspan="2">Publish following URL on your Website, Blog and Emails to invite potential partners to participate in Network Ticket Selling:</td></tr>
<tr ><td class="evenbase" colspan="2"><textarea id='purl' name='purl' cols="30" rows="2" onClick='this.select()'><%=eventurl %></textarea></td></tr>
<tr ><td class="colheader" colspan="2">Partner Signup Buttons</td></tr>
<%
contenturl="/eventbeeticket/nwtImagesdisp.jsp?type=mgr&groupid="+groupid+"&t="+date.getTime();
%>
<tr ><td colspan='2' class="evenbase"><a href='<%=eventurl%>' target='_blank'><img border='0' src='/home/images/participate.jpg' width="150" height="60"/></a></td></tr>
		
<tr><td class="evenbase" colspan="2">Copy and paste the following code into your blog or website:</td></tr>
<tr><td class="evenbase" colspan="2"><textarea id="participate" name="participate" cols="35" rows="3" onClick='this.select()'>
<a href='<%=eventurl%>'><img src='<%=serveraddress%>/home/images/participate.jpg'></img></a></textarea></td></tr>
<tr ><td id="displayntmgrimages" class="evenbase" ></td><td class="evenbase"></td>
</tr>

<tr ><td class="evenbase" ><input type="button" name="addimage" value="Add Button Image" onclick="makeRequest('/eventbeeticket/nwtImagesadd.jsp?platform=<%=platform%>&type=mgr&groupid=<%=groupid%>&t=<%=date.getTime()%>','addmgrImages');"/></td>
<td class="evenbase"></td></tr>

</table>
<%}%>
<table  class='portaltable' cellpadding="0" cellspacing="0" align="center" width="100%">
	<tr ><td id="addmgrImages" class="evenbase" width="100%"></td><td class="evenbase"></td></tr>
</table>
<%}%>

<script>
makeRequest("<%=contenturl%>","displayntmgrimages");
</script>
