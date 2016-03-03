<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="org.eventbee.sitemap.util.Presentation"%>

<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>

<script>
function testtrim(str){
	var temp='';
	temp=new String(str);
	temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');
	return temp;
}

function validatedata(groupid,trackpwd,secretcode,trackcode){
    advAJAX.submit(document.getElementById("pwd"), {			
   		onSuccess : function(obj) {
			var data=obj.responseText;
			data=testtrim(data);  	  
   			if(data.indexOf("Success")>-1){
    			if(trackpwd=="yes"){ 
    				window.location.href = "/guesttasks/trackreport.jsp?eid="+groupid+"&trackcode="+trackcode+"&secretcode="+secretcode;
    			}else{
    				window.location.href = "/guesttasks/managetrackingurls.jsp?eid="+groupid+"&trackcode="+trackcode+"&secretcode="+secretcode;
     			}
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
	String groupid = Presentation.GetRequestParam(request, new String[] { "eid", "eventid", "id", "groupid" });
	if(groupid==null){
		request.setAttribute("javax.servlet.error.exception_type",new Object());
		config.getServletContext().getRequestDispatcher("/guesttasks/invalidrequesthandler.jsp").forward(request, response);
		return;
	}
	String trackcode = request.getParameter("trackcode");
	String evtname = DbUtil.getVal("select eventname from eventinfo where eventid=to_number(?,'9999999999')", new String[] { groupid });
	String trackcodecheck = trackcode.toLowerCase();
	String isexist = DbUtil.getVal("select 'Yes' from trackurls where eventid=? and lower(trackingcode)=?",	new String[] { groupid, trackcodecheck });
	String trackpwd = request.getParameter("trackpwd");
	String secretcode = DbUtil.getVal("select secretcode from trackurls where eventid=? and lower(trackingcode)=?", new String[] { groupid, trackcodecheck });
%>
<style>
#bodycontainer {
background:#F8F8F8;
margin:0 auto;
}
#container {
background: transparent;
}
</style>
<div id="bodycontainer">

  <div id="singledatacol">
   <div id="maincontent">

<form id="pwd" name="validatepwd" method="POST"	action="/portal/eventmanage/validatetrackingpwd.jsp?groupid=<%=groupid%>&trackcode=<%=trackcode%>" onSubmit="validatedata('<%=groupid%>','<%=trackpwd%>','<%=secretcode%>','<%=trackcode%>'); return false;">
	<table cellspacing="0" cellpadding="0" class="inputvalue" valign="top" border="0" align="center" id="container">
		<tr>
			<td height="20"></td>
		</tr>
		<tr>
			<td height="30" align="center" class="large">
				<b><%=evtname%></b><br><%=trackcode%>- Tracking URL
			</td>
		</tr>
		<tr>
			<td class="inputlabel" width="36%" height="30" align="center">This
			page is password protected, enter password to visit the page
		</td>
		</tr>
		<tr>
			<td id="pwdprotect" align="center"></td>
		</tr>
		<tr>
			<td class="inputvalue" align="center">
				<input	description="Password" id="password" length="10" type="password" name="password" />
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
 </div>
  </div>
 </div>



