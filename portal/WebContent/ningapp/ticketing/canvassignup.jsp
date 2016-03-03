<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>


<script language="javascript" src="/home/js/ajax.js">
         function dummy12(){}
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>

<script>
sessionid='<%=session.getId()%>';
function ningsignup(appname,oid){

var url="/portal/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid="+sessionid;
if(appname=='nts'){
url="/portal/ningapp/ntstabview.jsp";
}
     document.getElementById('signuperrormsg').style.color='red';
	document.getElementById('signuperrormsg').innerHTML='Please wait.....';

    advAJAX.submit(document.getElementById("signupform"), {
	onSuccess : function(obj) {
      var data=obj.responseText;
      
     if(data.indexOf("Success")>-1){
		
	window.location.href=url;
		
		}	
		  
		   document.getElementById('signuperrormsg').innerHTML=data;
		
		
	
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}


</script>
















<%
HashMap hm=null;


if(!"yes".equals(request.getParameter("isnew"))){

	hm=(HashMap)session.getAttribute("USER_SIGN_HASH");
	
	
}else{
  session.removeAttribute("USER_SIGN_HASH");
  

   
    

 	
	
	
	Vector userdatavec=new Vector();
	String fbfirstname="";
	String fblastname="";
	String fbgender="";
	
	
	if(userdatavec.size()>0){
	hm=new HashMap();
	for(int i=0;i<userdatavec.size();i++){
	HashMap userdatahm=(HashMap)userdatavec.get(i);
	
	  
      hm.put("firstname",GenUtil.getHMvalue(userdatahm,"first_name",""));
	  hm.put("lastname",GenUtil.getHMvalue(userdatahm,"last_name",""));
	  hm.put("gender",GenUtil.getHMvalue(userdatahm,"sex",""));
	
	}

	}
  
    
  }
%>

<%

System.out.println("sessionid in Signup ScrrenScreen--"+session.getId());

%>

<table style="border: 1px solid #ddddff" align="center" width="90%">
<tr ><td>
<div align="center" ><b>New to Eventbee? Sign Up Now to become a member, it's FREE!</b></div>

<form name='signupform' id='signupform' method="POST"  action="/ningapp/ticketing/signupprocess.jsp;jsessionid=<%=session.getId()%>" >
<table width="100%"  cellspacing="2" >

<tr><td colspan="2"  id="signuperrormsg"/></tr>

<tr><td  width="36%"  height="30">Bee ID *<br>(4-20 alphanumeric characters)</td>
<td ><input description="User" length="10" type="text" name="uname"  id="name" value="<%=GenUtil.getHMvalue(hm,"name","")%>"/></td>
</tr>
<tr><td  width="36%"  height="30">Password *<br>(4-20 alphanumeric characters)</td>
<td >	<input description="Password" length="10" type="password" name="password"   id="profileKey"  value="<%=GenUtil.getHMvalue(hm,"profileKey","")%>"/></td>
</tr>


<tr>
<td  width="36%"  height="30" >First Name *</td>
<td ><input name="fname" type="textbox"   id="fname" value="<%=GenUtil.getHMvalue(hm,"firstname","")%>"/></td>
</tr>
<tr>
<td  width="36%"  height="30">Last Name *</td>
<td ><input name="lname" type="textbox"   id="lname" value="<%=GenUtil.getHMvalue(hm,"lastname","")%>"/></td>
</tr>

<tr>
<td  width="36%"  height="30"/>Email *</td>
<td ><input name="email" type="textbox"  id="email" value="<%=GenUtil.getHMvalue(hm,"email","")%>" size="35" /></td>
</tr>
<input  type='hidden' name='shareprofile' value="Yes">
<tr>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
<td align="center" colspan="2"><input value="Continue" name="submit" type="button" onClick="ningsignup('<%=appname%>','<%=oid%>');" />
</td>
</tr>
<tr>
	<td colspan="2" width="10" height="10" />
</tr>
<input type="hidden" name="task" value="signup" />
<input type="hidden" name="oid" value="<%=oid%>" />
<input type="hidden" name="appname" value="<%=appname%>" />
<input type="hidden" name="domain" value="<%=domain%>" />

</table>
</form>

</td></tr></table>





