<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*,com.eventregister.*"%>
<%@ page import="org.eventbee.sitemap.util.Presentation"%>
<%!Vector gettrackingURLsDetails(String trackcode, String groupid, String secretcode) {
		Vector trackingdetailsvector = new Vector();
		DBManager dbmanager = new DBManager();
		HashMap trackurlhashmap = null;
		StatusObj statobj = dbmanager.executeSelectQuery("select password, message, photo, status, secretcode from trackURLs where eventid=? and lower(trackingcode)=? and secretcode=?",
						new String[] { groupid, trackcode, secretcode });
		if (statobj.getStatus()) {
			for (int k = 0; k < statobj.getCount(); k++) {
				trackurlhashmap = new HashMap();
				trackurlhashmap.put("password", dbmanager.getValue(k,"password", ""));
				trackurlhashmap.put("message", dbmanager.getValue(k, "message", ""));
				trackurlhashmap.put("photo", dbmanager.getValue(k, "photo", ""));
				trackurlhashmap.put("status", dbmanager.getValue(k, "status", ""));
				trackurlhashmap.put("secretcode", dbmanager.getValue(k, "secretcode", ""));
				trackingdetailsvector.add(trackurlhashmap);
			}
		}
		return trackingdetailsvector;
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
	function inserttrackingpwd(groupid,trackcode){	
		var password=document.getElementById('password').value;	
		password=encodeURIComponent(password);	    
		advAJAX.get( {			
			url : '/portal/eventmanage/trackingpasswordprotection.jsp?groupid='+groupid+'&password='+password+'&trackcode='+trackcode,
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
		}else if('image'==msg){
			document.getElementById('photo').style.display="none";
		}
		else
			document.getElementById('pwdprotect').style.display="none";
	}
	function addmessage(){	
		document.getElementById('msgdiv').style.display="none";	
		document.getElementById('custmsg').style.display="block";		
	}
	function inserttrackmmsg(groupid,trackcode){	
		var message=encodeURIComponent(document.getElementById('message').value);	
		message.replace("\r","");
		message.replace("\n","\r\n");
		advAJAX.post( {			
			url : '/portal/eventmanage/inserttrackingmessage.jsp?groupid='+groupid+'&trackcode='+trackcode+'&message='+message,
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
	function inserttrackingimage(groupid,trackcode){	
		var image=document.getElementById('image').value;	
		advAJAX.get( {			
			url : '/portal/eventmanage/inserttrackingimage.jsp?groupid='+groupid+'&trackcode='+trackcode+'&image='+image,
			onSuccess : function(obj) {
				var data=obj.responseText;
				data=testtrim(data);		
				document.getElementById('photo').style.display="none";
				window.location.reload(true);
			},
			onError : function(obj) { alert("Error: " + obj.status); }
		});
	}
	function changestatus(trackcode,groupid,status){
		var urlstr='/portal/eventmanage/trackingstatus.jsp?eventid='+groupid+'&trackcode='+trackcode+'&status='+status;
		advAJAX.get( {
			url : urlstr,
			onSuccess : function(obj) {
				var data=obj.responseText;
				window.location.reload(true);	
			},
			onError : function(obj) { alert("Error: " + obj.status); }
		});
}
</script>
<%
        String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");

	String groupid = Presentation.GetRequestParam(request, new String[] { "eid", "eventid", "id", "GROUPID", "groupid", "gid" });
	String trackcode = request.getParameter("trackcode");
	String trackcodetolower = trackcode.toLowerCase();
	String secretcode = request.getParameter("secretcode");
	String from = request.getParameter("from");
	String eventurl = DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[] { groupid });
	if (eventurl != null)
		eventurl = eventurl + "/t/" + trackcode + "/manage";
	else
		eventurl = serveraddress+"/event?eid="+groupid+"&track="+trackcode+"&manage=manage";
	Vector trackinginfo = new Vector();
	String isValid = DbUtil.getVal(
					"select count(*) from trackurls where eventid=? and lower(trackingcode)=? and secretcode=?",
					new String[] { groupid, trackcodetolower,secretcode });
	if (!"0".equals(isValid)) {
		trackinginfo = gettrackingURLsDetails(trackcodetolower, groupid, secretcode);
		if (trackinginfo != null && trackinginfo.size() > 0) {
			for (int i = 0; i < trackinginfo.size(); i++) {
				HashMap hmt = (HashMap) trackinginfo.elementAt(i);
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
					status = "Active";
%>
<script type="text/javascript" language="JavaScript"
	src="/home/js/advajax.js">
        function dummy1() { }
</script>
<table class='portaltable' cellpadding="0" cellspacing="0" width="100%"	id="container" align="center">
	<%
		if ("manager".equals(from)) {
	%>
	<tr>
		<td align="left" colspan="2">&nbsp;&raquo;&nbsp;<B>Status</B>: <%=status%> 
			<%
 				if ("Suspended".equals(status)) {
 			%>
			<input type="button" value="Activate" onclick="changestatus('<%=trackcode%>',<%=groupid%>,'Approved');" />
			<%
				} else {
			%> 
			<input type="button" value="Suspend"	onclick="changestatus('<%=trackcode%>',<%=groupid%>,'Suspended');" />
			<%
				}
			%>
		</td>
	</tr>
	<tr>
		<td align="left" colspan="2">
			<span class="smallestfont">Suspending
			tracking URL redirects all traffic to the main URL, resulting no
			visits and ticket sales credited to the tracking URL
			</span>
		</td>
	</tr>
	<%
		}
	%>
	<tr>
		<td height="15" colspan="2"></td>
	</tr>
	<tr>
		<td align="left" colspan="2">&nbsp;&raquo;&nbsp;<B>Manage URL</B>: <%=eventurl%>&nbsp;&nbsp;
			<input type="button" value="Password" onclick="trackpwd();" />
		</td>
	</tr>
	<tr>
		<td align="left" colspan="2">
			<div id="pwdprotect" style="display: none">
				<input type="text" name="password" id="password" value="<%=password %>" />
				<input type="button" name="button" value="Submit" onclick="inserttrackingpwd(<%=groupid %>,'<%=trackcode%>');" />
				<input type="button" value="Cancel" onclick="back()" />
			</div>
		</td>
	</tr>
	<tr>
		<td align="left" colspan="2">&nbsp;&nbsp;&nbsp;
			<span class="smallestfont">Partners/Affiliates
			can visit this URL to view reports, set photo, and post message. You
			can protect this page with password, and share it with
			Partner/Affiliate
		 	</span>
		 </td>
	</tr>
	<tr>
			<td height="15" colspan="2"></td>
		</tr>
		<tr>
			<td align="left" colspan="2">&nbsp;&raquo;&nbsp;<B>Widget Code</B>:&nbsp;&nbsp;</td></tr>
			<tr><td colspan="2"><textarea cols="80" rows="5" onClick="this.select()"><script type='text/javascript' language='JavaScript' src='<%=serveraddress%>/home/js/widget/eventregistration.js'></script><iframe  id='_EbeeIFrame' name='_EbeeIFrame'  src='<%=serveraddress%>/eregister?eid=<%=groupid%>&track=<%=trackcode%>&viewType=iframe;resizeIFrame=true&context=web'  height='0' width='700'></iframe>
			</textarea></tr>
			</td>
		</tr>
	
	<tr>
		<td height="15" colspan="2"></td>
	</tr>
	<tr>
		<td align="left" colspan="2">&nbsp;&raquo;&nbsp;<B>Photo</B>:&nbsp;&nbsp;
			<input type="button" value="Add/Change" onclick="addphoto();" />
		</td>
	</tr>
	<tr>
		<td id="photo" style="display: none" align="left" colspan="2">
			<span class="smallestfont">Enter photo URL here, for best result make sure photo width is 200</span>
			<br>
			<input type="text" name="image" id="image" value="<%=imageurl%>" size="60" />
		 	<input type="button" name="button" value="Submit" onclick="inserttrackingimage(<%=groupid %>,'<%=trackcode%>');" />
			<input type="button" value="Cancel" onclick="back('image')" />
		</td>
	</tr>
	<%
		if (imageurl != "" && !"".equals(imageurl)) {
	%>
	<tr>
		<td align="left" colspan="2">&nbsp;&nbsp;<img src="<%=imageurl%>" width="200"></td>
	</tr>
	<%
		}
	%>
	<tr>
		<td height="15" colspan="2"></td>
	</tr>
	<tr>
		<td align="left" colspan="2">&nbsp;&raquo;&nbsp;<B>Message</B>:&nbsp;&nbsp;
			<input type="button" value="Add/Change" onclick="addmessage();" />
		</td>
	</tr>
	<tr>
		<td id="custmsg" style="display: none" align="left" colspan="2">
			<textarea name="message" id="message" rows="5" cols="40"><%=message%></textarea>
			<br>
			<input type="button" name="button" value="Submit" onclick="inserttrackmmsg(<%=groupid%>,'<%=trackcode%>');" />
			<input	type="button" value="Cancel" onclick="back('msg')" />
		</td>
	</tr>
	<%
		if (message != "") {
	%>
	<tr>
		<td align="left" colspan="2">&nbsp;&nbsp;&nbsp;<div id="msgdiv"><pre><%=message%></pre></div></td>
	</tr>
	<%
		}
	%>
	<tr>
		<td height="15" colspan="2"></td>
	</tr>
	<tr>
		<%
			if ("manager".equals(from)) {
		%>
		<td align="left">&nbsp;&raquo;&nbsp;<B>Report</B>:&nbsp;&nbsp;
			<a href='/mytasks/trackreport.jsp?landf=yes&filter=manager&gid=<%=groupid%>&trackcode=<%=trackcode%>&secretcode=<%=secretcode%>'>Report</a>
			<%
				} else {
			%>
		</td>
		<td align="left">&nbsp;&raquo;&nbsp;<B>Report</B>:&nbsp;&nbsp;<a href='/guesttasks/trackreport.jsp?landf=yes&gid=<%=groupid%>&trackcode=<%=trackcode%>&secretcode=<%=secretcode%>'>Report</a>
		<%
			}
		%>
		</td>
	</tr>
	<tr>
		<td height="15" colspan="2"></td>
	</tr>
</table>
<%
	}
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