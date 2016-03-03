<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="org.eventbee.sitemap.util.Presentation"%>
<%!
	HashMap gettrackingURLsDetails(String trackcode, String secretcode) {
		DBManager dbmanager = new DBManager();
		HashMap trackurlhashmap = null;
		StatusObj statobj = dbmanager
				.executeSelectQuery(
						"select password, message, photourl, status, scode from accountlevel_track_partners where lower(trackname)=? and scode=?",
						new String[] { trackcode, secretcode });
		if (statobj.getStatus()) {
			for (int k = 0; k < statobj.getCount(); k++) {
				trackurlhashmap = new HashMap();
				trackurlhashmap.put("password", dbmanager.getValue(k,"password", ""));
				trackurlhashmap.put("message", dbmanager.getValue(k, "message",	""));
				trackurlhashmap.put("photo", dbmanager.getValue(k, "photourl", ""));
				trackurlhashmap.put("status", dbmanager.getValue(k, "status", ""));
				trackurlhashmap.put("secretcode", dbmanager.getValue(k,"scode", ""));

			}
		}
		return trackurlhashmap;
	}

	Vector getPartnerEvents(String trackcode, String secretcode) {
		Vector partnereventsvector = new Vector();
		DBManager dbmanager = new DBManager();
		HashMap eventhashmap = null;
		/*StatusObj statobj = dbmanager.executeSelectQuery("select eventname, b.eventid, b.status,url from event_custom_urls c ,trackurls b,eventinfo a where lower(trackingcode)=? and secretcode=? and a.eventid=CAST(b.eventid as int) and c.eventid=b.eventid",
						new String[] { trackcode, secretcode });*/
		StatusObj statobj = dbmanager.executeSelectQuery("select a.eventname, b.eventid, b.status, b.count from trackurls b,eventinfo a where lower(b.trackingcode)=? and b.secretcode=? and a.eventid=CAST(b.eventid as int)",
						new String[] { trackcode, secretcode });
		if (statobj.getStatus()) {
			for (int k = 0; k < statobj.getCount(); k++) {
				eventhashmap = new HashMap();
				eventhashmap.put("eventname", dbmanager.getValue(k, "eventname", ""));
				eventhashmap.put("status", dbmanager.getValue(k, "status", "Approved"));
				eventhashmap.put("eventid", dbmanager.getValue(k, "eventid", ""));
				//eventhashmap.put("eventurl", dbmanager.getValue(k, "url", ""));
				eventhashmap.put("count", dbmanager.getValue(k, "count", "0"));
				partnereventsvector.add(eventhashmap);
			}
		}
		return partnereventsvector;
	}
	
	HashMap getEventCustomURLs(String userid) {
		DBManager dbmanager = new DBManager();
		HashMap eventurlhashmap = new HashMap();
		StatusObj statobj = dbmanager.executeSelectQuery("select eventid,url from event_custom_urls where eventid::integer in (select eventid from eventinfo where mgr_id=CAST(? AS INTEGER))",
						new String[] { userid });
		if (statobj.getStatus()) {
			for (int k = 0; k < statobj.getCount(); k++) {
				eventurlhashmap.put(dbmanager.getValue(k,"eventid", ""), dbmanager.getValue(k,"url", ""));
			}
		}
		return eventurlhashmap;
	}
	
	HashMap getEventRegCount(String trackcode) {
		DBManager dbmanager = new DBManager();
		HashMap eventregcountmap = new HashMap();
		StatusObj statobj = dbmanager
				.executeSelectQuery(
						"select eventid,count(*) from event_reg_transactions where trackpartner=? group by eventid",
						new String[] { trackcode });
		if (statobj.getStatus()) {
			for (int k = 0; k < statobj.getCount(); k++) {
				eventregcountmap.put(dbmanager.getValue(k,"eventid", ""), dbmanager.getValue(k,"count", ""));
			}
		}
		return eventregcountmap;
	}
%>

<script>
	function trackpwd(){
		document.getElementById('pwdprotect').style.display="block";
	}
	function testtrim(str){
		var temp='';
		temp=new String(str);
		temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');
		return temp;
	}

	function inserttrackingpwd(userid,trackcode){	
		var password=document.getElementById('password').value;	
		password=encodeURIComponent(password);	    
		advAJAX.get( {				
			url : '/portal/acctleveltracking/trackingpasswordprotection.jsp?userid='+userid+'&password='+password+'&trackcode='+trackcode,
			onSuccess : function(obj) {
				var data=obj.responseText;
				data=testtrim(data);	
				document.getElementById('pwdprotect').style.display="none";			
			},
		onError : function(obj) { alert("Error: " + obj.status); }
		});

	}
	function back(msg){
		if('msg'==msg){
		document.getElementById('msgdiv').style.display="block";
		document.getElementById('custmsg').style.display="none";
		}else
			 if('image'==msg){
				document.getElementById('photo').style.display="none";
			}
			else
				document.getElementById('pwdprotect').style.display="none";
	}
	function addmessage()
	{	
		document.getElementById('msgdiv').style.display="none";		
		document.getElementById('custmsg').style.display="block";		
	
	}
	function inserttrackmmsg(userid,trackcode){	
		var message=encodeURIComponent(document.getElementById('message').value);	
		message.replace("\r","");
		message.replace("\n","\r\n");
		advAJAX.post( {			
			url : '/portal/acctleveltracking/inserttrackingmessage.jsp?userid='+userid+'&trackcode='+trackcode+'&message='+message,
			onSuccess : function(obj) {
				var data=obj.responseText;
				data=testtrim(data);		
				document.getElementById('custmsg').style.display="none";
				document.getElementById('msgdiv').style.display="block";		
				window.location.reload(true);
			},
			onError : function(obj) { alert("Error: " + obj.status); }
		});

	}
	function addphoto(){	
		document.getElementById('photo').style.display="block";	
	}
	function inserttrackingimage(userid,trackcode){	
		var image=document.getElementById('image').value;	
		advAJAX.post( {			
			url : '/portal/acctleveltracking/inserttrackingimage.jsp?userid='+userid+'&trackcode='+trackcode+'&image='+image,
			onSuccess : function(obj) {
				var data=obj.responseText;
				data=testtrim(data);		
				document.getElementById('photo').style.display="none";
				window.location.reload(true);
			},
			onError : function(obj) { alert("Error: " + obj.status); }
		});

	}
</script>

<%
	String trackcode = request.getParameter("trackcode");
	String userid = request.getParameter("userid");
	String trackcodetolower = trackcode.toLowerCase();
	String secretcode = request.getParameter("secretcode");
	String isValid = DbUtil.getVal(
					"select count(*) from accountlevel_track_partners where userid=CAST(? as BIGINT) and lower(trackname)=? and scode=?",
					new String[] { userid, trackcodetolower, secretcode });
	if (!"0".equals(isValid)) {
		HashMap hmt = gettrackingURLsDetails(trackcodetolower, secretcode);
		if (hmt != null) {
			String first_name = (String) hmt.get("first_name");
			String password = (String) hmt.get("password");
			if (password == null)
				password = "";
			String message = (String) hmt.get("message");
			if (message == null)
				message = "";
			String imageurl = (String) hmt.get("photo");
			if (imageurl == null)
				imageurl = "";
			String status = (String) hmt.get("status");
			if (status == "")
				status = "Approved";
%>
<script type="text/javascript" language="JavaScript"
	src="/home/js/advajax.js">
        function dummy1() { }
</script>

<table class='portaltable' cellpadding="0" cellspacing="0" border="0"
	width="100%" id="container" align="center">

	<tr>
		<td height="15"></td>
	</tr>
	<tr>
		<td align="left">&nbsp;&raquo;&nbsp;<B>Password</B>: &nbsp;&nbsp;
			<input	type="button" value="Add/Change" onclick="trackpwd();" />
		</td>
	</tr>
	<tr>
		<td align="left">
			<div id="pwdprotect" style="display: none">
				<input type="text"	name="password" id="password" value="<%=password %>" />
				<input type="button" name="button" value="Submit"	onclick="inserttrackingpwd(<%=userid %>,'<%=trackcode%>');" /> 
				<input type="button" value="Cancel" onclick="back()" />
			</div>
		</td>
	</tr>
	<tr>
		<td height="15" colspan="2"></td>
	</tr>
	<tr>
		<td align="left">&nbsp;&raquo;&nbsp;<B>Photo</B>:&nbsp;&nbsp;
			<input	type="button" value="Add/Change" onclick="addphoto();" />
		</td>
	</tr>
	<tr>
		<td id="photo" style="display: none" align="left">
			<span class="smallestfont">Enter photo URL here, for best result make sure photo width is 200</span>
			<br>
			<input type="text" name="image" id="image" value="<%=imageurl%>" size="60" />
			<input type="button" name="button" value="Submit" onclick="inserttrackingimage(<%=userid %>,'<%=trackcode%>');" />
			<input type="button" value="Cancel" onclick="back('image')" />
		</td>
	</tr>
	<%
		if (imageurl != "" && !"".equals(imageurl)) {
	%>
	<tr>
		<td align="left">&nbsp;&nbsp;<img src="<%=imageurl%>" width="200"></td>
	</tr>
	<%
		}
	%>

	<tr>
		<td height="15" colspan="2"></td>
	</tr>

	<tr>
		<td align="left">&nbsp;&raquo;&nbsp;<B>Message</B>:&nbsp;&nbsp;
			<input type="button" value="Add/Change" onclick="addmessage();" />
		</td>
	</tr>
	<tr>
		<td id="custmsg" style="display: none" align="left">
			<textarea name="message" id="message" rows="5" cols="40"><%=message%></textarea>
			<br>
			<input type="button" name="button" value="Submit" onclick="inserttrackmmsg(<%=userid%>,'<%=trackcode%>');" />
			<input type="button" value="Cancel" onclick="back('msg')" />
		</td>
	</tr>
	<%
		if (message != "") {
	%>
	<tr>
		<td align="left">&nbsp;&nbsp;&nbsp;<div id="msgdiv"><pre><%=message%></pre></div></td>
	</tr>
	<%
		}
	%>
	<tr>
		<td height="15" colspan="2"></td>
	</tr>
	<tr>
		<td align="left">&nbsp;&raquo;&nbsp;<B>My Events</B>:&nbsp;&nbsp;
		<br>
		<ul>
			<%
				String eventurl="";
				String regcount="0";
				HashMap eventUrlsmap = getEventCustomURLs(userid);
				HashMap eventregmap = getEventRegCount(trackcodetolower);
				Vector myeventsvector = getPartnerEvents(trackcodetolower,	secretcode);
						if (myeventsvector.size() == 0) {
			%>
			<li>No events</li>
			<%
				} else {
							for (int i = 0; i < myeventsvector.size(); i++) {
								HashMap event = (HashMap) myeventsvector.get(i);
								if(eventUrlsmap!=null && eventUrlsmap.containsKey(event.get("eventid")))
									eventurl=eventUrlsmap.get(event.get("eventid"))+"/t/"+trackcode;
								else
								    eventurl="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/event?eid="+event.get("eventid")+"&track="+trackcode;
								if(eventregmap!=null && eventregmap.containsKey(event.get("eventid")))
									regcount=(String)eventregmap.get(event.get("eventid"));
								else
									regcount="0";
								
			%>
			<li><%=event.get("eventname")%> <br>
				Status: <%=event.get("status")%> <br>
				URL: <%=eventurl%> <br>
				<a	href="/guesttasks/managetrackingurls.jsp?eid=<%=event.get("eventid")%>&trackcode=<%=trackcode%>&secretcode=<%=secretcode%>">Manage</a>  |  <a href="/guesttasks/trackreport.jsp?landf=yes&gid=<%=event.get("eventid")%>&trackcode=<%=trackcode%>&secretcode=<%=secretcode%>">Report</a> [Visits: <%=event.get("count")%>, Registrations: <%=regcount%>]
			</li>
			<%
				}
						}
			%>
		</ul>
		</td>
	</tr>
	<tr>
		<td height="15" colspan="2"></td>
	</tr>

</table>

<%
	}
	} else {
%>
<table align="left">
	<tr>
		<td align="left">Unauthorized Access</td>
	</tr>
</table>
<%
	}
%>