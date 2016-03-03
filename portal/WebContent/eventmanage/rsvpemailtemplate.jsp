<%@ page import="com.eventbee.general.*"%>
<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>
<script>
function getTemplates(evtid,type){

	//alert(groupid);
		advAJAX.get( {			
		url : '/portal/eventmanage/getrsvpTemplate.jsp?groupid='+evtid+'&emailtype='+type,
		onSuccess : function(obj) {
		var data=obj.responseText;
		//data=testtrim(data);	
		//alert(data);
		document.getElementById('emailtemp').value=data;
		if(type=='reset')
		document.getElementById('html').checked=true;
		
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});




}
</script>
<script>


</script>
<div id="result" align="center">
<%

String groupid=request.getParameter("GROUPID");
String tempmsg="";
String type="";
EmailTemplate emailtemplate=null;
	String isformatexists=DbUtil.getVal("select 'yes' from email_templates where purpose='RSVP_CONFIRMATION' and groupid=?", new String []{groupid});
	
	
if("yes".equals(isformatexists)){

	emailtemplate=new EmailTemplate("13579","RSVP_CONFIRMATION",groupid);
	}else{

	emailtemplate=new EmailTemplate("100","RSVP_CONFIRMATION");
	}
	
if(emailtemplate!=null){
 tempmsg=emailtemplate.getHtmlFormat();
 type="html";
if(tempmsg==null||"".equals(tempmsg)){
tempmsg=emailtemplate.getTextFormat();
type="text";
}
}

if(tempmsg!=null)
tempmsg=tempmsg.trim();
else
tempmsg="";
%>
<form action="/portal/eventmanage/updatersvpTemplate.jsp" method="post" id="template"  ">
<table align="center" cellpadding ='10'>
 <tr height='5'></td></td></tr>
<tr><td colspan='2'><font class="medium">NOTE: Make sure to place Eventbee reserved words (start with $ sign) are placed at appropriate locations of the email template. These words are replaced with real values when confirmation email goes out to the attendee. To get original Eventbee templates, please click on Reset link.
 </font></td></tr>
 <tr height='5'></td></td></tr>
<tr>
<td>
<input type="radio" name="format" id='html' value="html" <%="html".equals(type)?"checked":""%> onClick="getTemplates('<%=groupid%>','Html')" />HTML
<input type="radio" name="format" id='text' value="text" <%="text".equals(type)?"checked":""%> onClick="getTemplates('<%=groupid%>','Text')"/>Text
<input type="hidden" name="groupid"  value="<%=groupid%>" />
</td><td>
<a href='#' onclick="getTemplates('<%=groupid%>','reset')">Reset</a>
</td></tr>
<tr><td colspan='2'>
<textarea id="emailtemp" name="emailtemp" rows="30" cols="75" ><%=tempmsg%></textarea>
</td></tr>
<tr>
<td id="subbtn" align='center' colspan='2' >
<input type="submit" value="Submit" />
<input type="button" name="Back" value="Cancel" onclick="javascript:history.back();"/>

</td></tr>
</table>
</from>
</div>



