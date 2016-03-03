<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page errorPage="error.jsp"%>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"registrations_selector.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
    String groupid=null;
    String groupname=null;
    String currentdate=null;
    int year=0;
    groupid=request.getParameter("groupid");
    if(groupid==null)
         groupid=request.getParameter("GROUPID");
    groupname=GenUtil.getEncodedXML((String)request.getParameter("groupname"));
    java.util.Date d=new java.util.Date();
    year=d.getYear()+1900;
    Date date=new Date();	
    SimpleDateFormat format=new SimpleDateFormat("MM/dd/yyyy");
    currentdate=format.format(date);

%>
<%
String platform = request.getParameter("platform");
String URLBase="mytasks";
    if("ning".equals(platform)){
	URLBase="ningapp";	
    }
    String filter = request.getParameter("filter");


String agentid=request.getParameter("agentid");
if(agentid!=null)
         request.setAttribute("subtabtype","My Pages");
String ps=request.getParameter("PS");
String evttype=request.getParameter("evttype");
if(ps!=null || (agentid!=null && "event".equals(evttype)))
request.setAttribute("subtabtype","My Pages");
%>
<script type="text/javascript" language="JavaScript" src="/home/js/calendar.js">
        function dummy(){ }
</script>
<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>
<script>
function generatePdf(ext,groupid){
	document.frm.rtype.value = 'fo';
}
function generateExcel(ext,groupid){ 
	document.frm.rtype.value = 'excel';
}
function checkAll(field)
 {
 for (i = 0; i < field.length; i++)
 	field[i].checked = true ;
 }
 function uncheckAll(field)
 {
 for (i = 0; i < field.length; i++)
 	field[i].checked = false ;
 }
</script>
<script>
function registrationreport(){
 options=document.frm.displayFields;
     var value=0;
     var count=0;
     for(i=0;i<options.length;i++){
        	if(options[i].checked){
     		value=options[i].value;
     		count++;
     	}
     }
     if(value==0){
     	alert('Select Atleast One Display Fields Filter');
    	 return false;
   }
document.getElementById('reports').innerHTML='<span align="right">Loading .... Please wait</span>';
document.frm.rtype.value = 'html';
 advAJAX.submit(document.getElementById("regreport"), {
   onSuccess : function(obj) {
   	var data=obj.responseText;   
   	document.getElementById('reports').innerHTML=data;			
   	
   	},
   onError : function(obj) { alert("Error: " + obj.status); }
 });
}
</script>
<form method="post" action="/portal/listreport/registrations_report.jsp" name="frm" id="regreport" >
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<input type="hidden" name="groupid" value="<%=groupid%>"/>
<input type="hidden" name="groupname" value="<%=groupname%>"/>
<input type='hidden' name='evtname' value='<%=request.getParameter("evtname") %>'  />
<input type='hidden' name='evttype' value='<%=request.getParameter("evttype") %>'  />
<input type="hidden" name="agentid" value="<%=agentid%>"/>
<input type="hidden" name="landf" value="yes">
<input type="hidden" name="rtype" value="html">
<input type="hidden" name="platform" value="<%=platform%>">
<input type="hidden" name="filter" value="<%=filter%>">

<%if(request.getParameter("agentid")!=null){%>
<input type="hidden" name="agentid" value="<%=request.getParameter("agentid")%>">
<%}%>

<table class="block" border="0" width='100%' >
<tr>
<td valign='top' width='50%'>
<table>
<tr>
<td align="left" colspan="2"> <b>Search Filter</b></td>
</tr>
<tr><td height="5"></td></tr>
<tr>
<td align="right"><input type="radio" name="selindex" value="1" checked="true"/></td>
<td>All</td></tr> 
<tr>
<td align="right"><input type="radio" name="selindex" value="3" /></td>
<td class="inform">Transaction ID &nbsp;&nbsp;<input type="textbox" name="key" size="15"/></td>
</tr>
<tr>
<td align="right"><input type="radio" name="selindex" value="4" /></td>
<td class="inform">Attendee Name &nbsp;<input type="textbox" name="attendee" size="15"/></td>
</tr>
<tr>
<td align="right" ><input type="radio" name="selindex" value="2"/></td><td>Start Date
<%=EventbeeStrings.getMonthHtml("","startMonth","","")%>
<%=EventbeeStrings.getDayHtml("","startDay","","")%>
<%=EventbeeStrings.getYearHtml(year-1,2,0,"startYear","","")%>
<!--<a href="#" onClick="return CalanderPop(document.forms[0].elements['startMonth'], document.forms[0].elements['startDay'], document.forms[0].elements['startYear'],'No','Yes');"><img src="/home/images/calendar.gif" width="26" height="19" alt="" border="0" class="button"/></a>-->
</td>
</tr>
<tr>
<td align="left"></td><td>End Date &nbsp;
<%=EventbeeStrings.getMonthHtml("","endMonth","","")%>
<%=EventbeeStrings.getDayHtml("","endDay","","")%>
<%=EventbeeStrings.getYearHtml(year-1, 2,0,"endYear","","")%>
<!--<a href="#" onClick="return CalanderPop(document.forms[0].elements['endMonth'], document.forms[0].elements['endDay'], document.forms[0].elements['endYear'],'No','Yes');"><img src="/home/images/calendar.gif" width="26" height="19" alt="" border="0" class="button"/></a>-->
</td>
</tr>
<tr>
<td align="right"><input type="radio" name="selindex" value="5" /></td>
<td class="inform">Payment Status &nbsp;&nbsp;<select name='paymentstaus'>
<option value='Denied' >Rejected</option>
<option value='CANCELLED'> Refunded</option>
</select></td>
</tr>

</table>
</td>
<td valign='top' width='50%'>
<table >
<tr>
<td align="left" colspan="2"> <b>Display Fields Filter</b>&nbsp;&nbsp;
<a href="#" name ="CheckAll" onClick="checkAll(document.frm.displayFields)">Select All</a> | <a href="#" name ="UnCheckAll" onClick="uncheckAll(document.frm.displayFields)">Clear All</a>
</td>
</tr>
<tr><td></td></tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Book Date" checked></input>Booking Date</td>
<td><input type="checkbox" name="displayFields" value="Transaction ID" checked></input>Transaction ID</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="First Name" ></input>First Name</td>
<td><input type="checkbox" name="displayFields" value="Last Name" ></input>Last Name</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Ticket Name" ></input>Ticket Name</td>
<td><input type="checkbox" name="displayFields" value="Ticket Price" ></input>Ticket Price</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Tickets Count" ></input>Tickets Count</td>
<td><input type="checkbox" name="displayFields" value="Discount" checked></input>Discount</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Discount Code" ></input>Discount Code</td>
<td><input type="checkbox" name="displayFields" value="Tickets Total" checked></input>Tickets Total Cost</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Service Fee" checked></input>Service Fee</td>
<td><input type="checkbox" name="displayFields" value="CC Processing Fee" checked></input>CC Processing Fee</td>
</tr>
<tr>
<td ><input type="checkbox" name="displayFields" value="Net" checked ></input>Net Amount</td>
<td><input type="checkbox" name="displayFields" value="Status"  ></input>Payment Status</td></tr>

<%
String iseventf2fenabled = DbUtil.getVal("select enablenetworkticketing from group_agent_settings where groupid=? ",new String [] {groupid});
if("Yes".equalsIgnoreCase(iseventf2fenabled)){
%>
<%
}
%>
<tr><td><input type="checkbox" name="displayFields" value="NTS Commission" checked></input>NTS Commission</td>
<td></td></tr>

<tr>
<td><input type="checkbox" name="displayFields" value="Total Net" checked></input>Total (After Commission)</td>
<td></td>
</tr>
</table>
</td>
</tr>
<tr>
<td colspan="2" align="center"><input type="button" name="sub" onClick="registrationreport();" value="Submit"/></td>
</tr>
</table>
<div STYLE=" height: 400px; width: 820px; font-size: 12px; overflow: auto;" id="reports" align="center">

</div>
<table align="center"><tr ><td align="center">
	       <input type="submit" onClick="javascript:generatePdf('.pdf','<%=groupid%>');" value="Export to PDF"/>
	       <input type="submit" onClick="javascript:generateExcel('.xsl','<%=groupid%>');" value="Export to Excel"/></td>
</tr></table>
<script>
registrationreport();
</script>
</form>