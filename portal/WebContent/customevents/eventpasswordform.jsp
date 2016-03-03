<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
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
function validatedata(groupid){
    advAJAX.submit(document.getElementById("pwd"), {			
    onSuccess : function(obj) {
	var data=obj.responseText;
	data=testtrim(data);  	  
    if(data.indexOf("Success")>-1){		
    	window.location.href = "/customevents/eventhandler.jsp?<%=request.getQueryString()%>";
	}
	else 
		document.getElementById('pwdprotect').innerHTML='<font color="red">Enter valid password</font>';
				
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}

</script>
<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","groupid","GROUPID"});
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=CAST(? AS BIGINT)",new String[]{groupid});
%>

<form id="pwd" name="validatepwd" method="POST" action="/portal/customevents/validatepwd.jsp?groupid=<%=groupid%>" onSubmit="validatedata('<%=groupid%>'); return false;">

<table cellspacing="0" class="inputvalue"  valign="top" border="0" align="center">
<tr>
<td height="30" align="center" class="large"><%=evtname %></td>
</tr>
<tr>
	<td class="inputlabel" width="36%"  height="30" align="center">This event is password protected, enter password to visit the event page</td>
</tr>
<tr>
	<td id="pwdprotect" align="center"></td></tr>
<tr>
	<td class="inputvalue" align="center">	<input description="Password" id="upassword" length="10" type="password" name="upassword" /></td>
</tr>
<tr>
	<td align="center" ><input value="Continue" name="submit" type="submit" /></td>
</tr>
</table>
</form>


