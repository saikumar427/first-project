<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="org.eventbee.sitemap.util.Presentation"%>
<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>
<script type="text/javascript" language="JavaScript"
	src="/home/js/advajax.js">
        function dummy() { }
</script>
<script>

function testtrim(str){
	var temp='';
	temp=new String(str);
	temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');
	return temp;
}
function validatedata(userid,secretcode,trackcode){
    advAJAX.submit(document.getElementById("checkpwdform") , {		
    	onSuccess : function(obj) {
			var data=obj.responseText;
			data=testtrim(data);  
    		if(data.indexOf("Success")>-1){
  		    	window.location.href = "/portal/guesttasks/manageacctleveltrackingurls.jsp?userid="+userid+"&trackcode="+trackcode+"&secretcode="+secretcode;
 			}
			else{ 
				document.getElementById('pwdprotect').innerHTML='<font color="red">Invalid password, enter valid password. Forgot your Tracking URL password? Please contact your Event Manager.</font>';
			}		
		},
    	onError : function(obj) { alert("Error: " + obj.status); }
	});
}
</script>

<%
	String userid = "";
	String trackcode = "";
	try {
		String user = Presentation.GetRequestParam(request,	new String[] { "userid", "mgrId", "id", "mgrid" });
		userid = DbUtil.getVal("select user_id from authentication where lower(login_name)=?",new String[] { user });
		if(userid==null){
			request.setAttribute("javax.servlet.error.exception_type",new Object());
			config.getServletContext().getRequestDispatcher("/guesttasks/invalidrequesthandler.jsp").forward(request, response);
			return;
		}
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "trackpasswordform.jsp", "","userid: " + userid + " for user:  " + user, null);
		trackcode = request.getParameter("trackcode");
	}catch (NullPointerException e) {
		System.out.println("Null pointer exception");
	}
	String trackcodecheck = trackcode.toLowerCase();
	String secretcode = DbUtil.getVal("select scode from accountlevel_track_partners where userid=CAST(? as BIGINT) and lower(trackname)=?",new String[] { userid, trackcodecheck });
%>

<form id="checkpwdform" name="validatepwd" method="POST" action="/portal/acctleveltracking/validatetrackingpwd.jsp?userid=<%=userid%>&trackcode=<%=trackcode%>"	onSubmit="validatedata('<%=userid%>','<%=secretcode%>','<%=trackcode%>'); return false;">
	<table cellspacing="0" class="inputvalue" valign="top" border="0" align="center" id="container">
		<tr>
			<td height="20"></td>
		</tr>
		<tr>
			<td height="30" align="center" class="large"><br><%=trackcode%>	- Tracking URL</td>
		</tr>
		<tr>
			<td class="inputlabel" width="36%" height="30" align="center">This
			page is password protected, enter password to visit the page</td>
		</tr>
		<tr>
			<td id="pwdprotect" align="center"></td>
		</tr>
		<tr>
			<td class="inputvalue" align="center">
				<input	description="Password" id="password" length="10" type="text" name="password" />
			</td>
		</tr>
		<tr>
			<td height="5"></td>
		</tr>
		<tr>
			<td align="center"><input value="Continue" name="submit" type="submit" /></td>
		</tr>
		<tr>
			<td height="110"></td>
		</tr>
	</table>
</form>
