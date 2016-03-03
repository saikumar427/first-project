<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.clubs.*,com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.useraccount.AccountDB" %>

<%!
  private String stripHTMLTags( String message ) {
    StringBuffer returnMessage = new StringBuffer(message);
    int startPosition = message.indexOf("&lt;"); // encountered the first opening brace
    int endPosition = message.indexOf(">"); // encountered the first closing braces
    while( startPosition != -1 ) {
      returnMessage.delete( startPosition, endPosition+1 ); // remove the tag
      startPosition = (returnMessage.toString()).indexOf("&lt;"); // look for the next opening brace
      endPosition = (returnMessage.toString()).indexOf(">"); // look for the next closing brace
    }
    return returnMessage.toString();
  }



%>


<%
String clubname=request.getParameter("clubname");
if(clubname!=null)
clubname=java.net.URLEncoder.encode(clubname);
String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
Authenticate authData=AuthUtil.getAuthData(pageContext);
HashMap hm=(HashMap)session.getAttribute("groupinfo");
  String groupid=GenUtil.getHMvalue(hm,"GROUPID");
  if(groupid==null)
   groupid=request.getParameter("GROUPID");
    HashMap clubinfo=AccountDB.getClubInfo(groupid);
   String description=GenUtil.getEncodedXML(GenUtil.getHMvalue(clubinfo,"description"));
   String noHTMLString = stripHTMLTags(description);        
    String truncatedata=GenUtil.TruncateData(noHTMLString,20);
    if("".equals(description))
    truncatedata="Description";
  
  String clubdetlink="/portal/hub/clubview.jsp?GROUPID="+groupid;
  String clubpagelink="/portal/portalhome/clubpreview/homeportal?groupid="+groupid+"&amp;entryunitid="+authData.getUnitID();
%>


<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy1() { }
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/messagevalidate.js">
   function dummy(){ }
</script>
<script>
var refid=<%=groupid%>;

function getCustomJoinButton() {
	advAJAX.get( {
		url : '/portal/hub/logic/customjoinbutton.jsp?GROUPID='+refid,
		onSuccess : function(obj) {document.getElementById('changeHubButton').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}


function emptyThisTextBox(attribname){
	if(attribname.value=='Join Hub')
	{
		attribname.value=""
	}


}
function editHubButton() {

var buttonname=document.custombuttonform.customjoinbutton.value;
buttonname=buttonname.replace("'","&#39;");
document.getElementById('HubButton').innerHTML='';
document.getElementById('HubButton').innerHTML=""
+" <input type='text' name='hubjoinbutton' value='"+buttonname+"' onfocus='emptyThisTextBox(this)'/>"
+" &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='submit' name='go'  value='Submit' >"
;

                                                                                     
}


function submitHubButton(){
	advAJAX.submit(document.getElementById("custombuttonform"), {
	onSuccess : function(obj) {

	var data=obj.responseText;
		if(data.indexOf("Success")>-1){
		getCustomJoinButton();
		}
	
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}



</script>



<html title="Configure Community" sub-title="">
<body>

<div class='memberbeelet-header'>Configure</div>
<table class="portaltable" align="center" cellpadding="5" cellspacing="0" width="100%" border='0'>
<tr ><td class="colheader" align="left">Description/Content</td></tr>
<tr ><td class="evenbase" width="100%" >
<a href='<%=PageUtil.appendLinkWithGroup("/portal/mytasks/editclubdesc.jsp?isnew=yes&clubid="+groupid,(HashMap)session.getAttribute("groupinfo") ) %>'><%=truncatedata%></a>
</td></tr>
<tr ><td class="colheader" align="left">Look and Feel</td></tr>
<tr ><td class="evenbase" colspan='3' align="left">
<a href='<%=PageUtil.appendLinkWithGroup("/portal/mytasks/enterlnfinfo.jsp?type=COMMUNITY_HUBID",(HashMap)session.getAttribute("groupinfo") ) %>'>Header/Footer Setting</a>
</td></tr>

<tr ><td class="oddbase">
	<table cellpadding='0' cellspacing='0' align='left' >
	<tr><td >
	<a href="/portal/mytasks/gethubtheme.jsp?type=Community&GROUPID=<%=groupid%>" >Theme</a>&nbsp;|&nbsp;
	</td>
	<td >
	<a href="/portal/mytasks/hubtemplates.jsp?type=Community&GROUPID=<%=groupid%>" > Theme Templates</a>&nbsp;|&nbsp;
	</td><td>
	<a href="javascript:popupwindow('/portal/hub/clubview.jsp?GROUPID=<%=groupid%>','Email','850','500');">Theme Preview</a></td>
	</td>
	</tr>
	</table>
	
</td></tr>

<tr >
<td class="colheader" align="left">Join button custom name</td>
</tr>
<tr ><td class="oddbase" align="left"><div id="changeHubButton"></div>
</td></tr>
</table>

		
		<script>
		getCustomJoinButton();
		</script>

