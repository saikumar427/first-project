<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.customattributes.*" %>
<%@ page import="com.eventbeepartner.partnernetwork.TransactionReports,com.eventbeepartner.partnernetwork.AttendeeListReports"%>
<%!

public Vector getTicketDetails(String groupid){
	Vector ticketsVector=new Vector();
	DBManager dbmanager=new DBManager();
	HashMap hm = null;
	StatusObj statobj=dbmanager.executeSelectQuery("select distinct ticketname,ticketid from transaction_tickets  where eventid=?",new String [] {groupid});
	if(statobj.getStatus()){
	        for(int k=0;k<statobj.getCount();k++){
			hm=new HashMap();
			hm.put("price_id",dbmanager.getValue(k,"ticketid",""));
			hm.put("ticket_name",dbmanager.getValue(k,"ticketname",""));
			ticketsVector.add(hm);
	}
	}
	 return ticketsVector;

		}

public List getAttributes(String setid){
	String RESPONSE_QUERY_FOR_ATTRIBUTE="select distinct attrib_name from custom_attrib_response a,custom_attrib_response_master b"
	  				   +" where a.responseid =b.responseid  and b.attrib_setid=?";

	DBManager dbmanager=new DBManager();
	List attribs_list=new ArrayList();
	StatusObj statobj=null;
	HashMap hm=new HashMap();
	statobj=dbmanager.executeSelectQuery(RESPONSE_QUERY_FOR_ATTRIBUTE,new String []{setid});
			int count1=statobj.getCount();
			if(statobj.getStatus()&&count1>0){
				for(int k=0;k<count1;k++){
                                   hm.put(dbmanager.getValue(k,"attrib_name",""),"y");

					attribs_list.add(dbmanager.getValue(k,"attrib_name",""));
				}
			}
	statobj=dbmanager.executeSelectQuery(RESPONSE_QUERY_FOR_ATTRIBUTE,new String []{setid});
	int count=statobj.getCount();
	if(statobj.getStatus()&&count>0){
		for(int k=0;k<count;k++){
			if(hm.get(dbmanager.getValue(k,"attrib_name",""))==null)
			attribs_list.add(dbmanager.getValue(k,"attrib_name",""));
		}
	}
	return attribs_list;
 }
%>

<% 
DbUtil.executeUpdateQuery("update event_reg_transactions set ccfee=0.00 where paymenttype<>'eventbee' and ccfee >0",null);	
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"attendeelist_selector.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
String platform = request.getParameter("platform");
String URLBase="mytasks";
    if("ning".equals(platform)){
	URLBase="ningapp/ticketing";	
    }
    String filter = request.getParameter("filter");
  TransactionReports reports=new TransactionReports();
   AttendeeListReports attendeereports=new AttendeeListReports();
 
  String groupid=request.getParameter("GROUPID");
  String groupname=request.getParameter("GROUPTYPE");
  String evtname=request.getParameter("evtname");  
  String custom_setid=CustomAttributesDB.getAttribSetID(groupid,"EVENT");
  Vector ticketsVector=getTicketDetails(groupid);
  List list=getAttributes(custom_setid);
  
  
  %>
  <script>
  function attendeereport(){
  options=document.attendeeform.displayFields;
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
  document.attendeeform.target = '_self';
  document.attendeeform.rtype.value = 'html';
  document.getElementById('attendeereportsdata').innerHTML='<span align="right">Loading .... Please wait</span>';
  advAJAX.submit(document.getElementById("attendeeform"), {
   	onSuccess : function(obj) {
   		var data=obj.responseText;   	
   		document.getElementById('attendeereportsdata').innerHTML=data;   	
   		},
   onError : function(obj) { alert("Error: " + obj.status); }
  });
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

 
 function generatePdf(ext,groupid){
	document.attendeeform.rtype.value = 'fo';
	document.attendeeform.target = '_blank';
 }
 
 function generateExcel(ext,groupid){ 
	document.attendeeform.rtype.value = 'excel';
	document.attendeeform.target = '_blank';
 }


function generateNameTags(groupid){
window.location.href='/portal/<%=URLBase%>/selecthw.jsp?groupid='+groupid;


}
function setTicketName(){
   sindex=document.attendeeform.FilterTicketID.selectedIndex;
   options=document.attendeeform.FilterTicketID.options;
   tname=options[sindex].text;
   document.attendeeform.tickettype.value = tname;
}
function addAttendeeAction(ext,groupid,platform){
window.location.href='/portal/<%=URLBase%>/bulkregistration.jsp?GROUPID='+groupid+'&platform='+platform;
}
</script>

<form method="post" action="/portal/listreport/attendeelist_report.jsp" name="attendeeform" id="attendeeform" >
<input type="hidden" name="groupid" value="<%=groupid%>"/>
<input type="hidden" name="groupname" value="<%=groupname%>"/>
<input type='hidden' name='evtname' value='<%=evtname %>'  />
<input type="hidden" name="landf" value="yes">
<input type="hidden" name="rtype" value="html">
<input type="hidden" name="tickettype" value="">
<input type="hidden" name="platform" value="<%=platform%>">
<input type="hidden" name="filter" value="<%=filter%>">

<table class="block" border="0" width='100%' >
<tr>
<td colspan="2" align="center">
<%if("yes".equals(request.getParameter("isdeleted"))){%>
	Requested Transaction is removed
<%}%>
</td>
<tr>
<tr>
<td colspan="2" align="left">
<%if("yes".equals(request.getParameter("attendeeadded"))){%>
	Attendee Added
<%}%>
</td>
<tr>
<td valign='top' width='50%'>
<table>
<tr>
<td align="left" colspan="2"> <b>Search Filter</b></td>
</tr>
<tr><td height="5"></td></tr>
<tr>
<td ><input type="radio" name="selindex" value="1" checked="true"/></td>
<td>All</td></tr> 
<tr>
<td ><input type="radio" name="selindex" value="2" /></td>
<td>Registered Online</td>
</tr>
<tr>
<td><input type="radio" name="selindex" value="3" /></td>
<td>Added Manually</td>
</tr>

<%
if (ticketsVector!=null&&ticketsVector.size()>0){

%>
<tr>
<td><input type="radio" name="selindex" value="4" /></td>
<td>Ticket Type</td>
<td><select name="FilterTicketID" onchange="setTicketName();">
<option  value="">Select Ticket Type</option>
<%
for(int i=0;i<ticketsVector.size();i++){		
	HashMap ticketsMap=(HashMap)ticketsVector.elementAt(i);
	String  price_id= (String)ticketsMap.get("price_id"); 
	String  ticket_name= (String)ticketsMap.get("ticket_name");	
%>
<option  value="<%=price_id%>"><%=ticket_name%></option>
<%}
%>
</select></td>
</tr>
<%}%>
<tr><td height="10" colspan="3"></td></tr>
</table>
<table>
<tr>
<td width="35%"> <b>Sort By</b> </td>
<td align="left">
<select name="sortby">
<option value="fn_az" selected>First Name A-Z</option>
<option value="fn_za">First Name Z-A</option>
<option value="ln_az">Last Name A-Z</option>
<option value="ln_za">Last Name Z-A</option>
<option value="bookdate_new">Transaction Date (New)</option>
<option value="bookdate_old">Transaction Date (Old)</option>
</select>
</td>
</tr>
</table>
</td>
<td valign='top' width='50%'>
<table >
<tr>
<td align="left" colspan="2"> <b>Display Fields Filter</b>&nbsp;&nbsp;  
<a href="#" name ="CheckAll" onClick="checkAll(document.attendeeform.displayFields)">Select All</a> | <a href="#" name ="UnCheckAll" onClick="uncheckAll(document.attendeeform.displayFields)">Clear All</a>
</td>
</tr>
<tr><td></td></tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Transaction ID" checked></input>Transaction ID</td>
<td><input type="checkbox" name="displayFields" value="Attendee Key" ></input>Attendee Key</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="First Name" checked></input>First Name</td>
<td><input type="checkbox" name="displayFields" value="Last Name" checked></input>Last Name</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Email" checked ></input>Email</td>
<td><input type="checkbox" name="displayFields" value="Phone" checked></input>Phone</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Ticket Name" ></input>Ticket Name</td>
<td><input type="checkbox" name="displayFields" value="Payment" ></input>Payment</td>
</tr>

<%

for(int k=0;k<list.size();k++){
String attribute=(String)list.get(k);
%>
<tr>
<td colspan="2"><input type="checkbox" name="displayFields" value="<%=attribute.replaceAll("\"","&quot;")%>" ></input><%=(String)list.get(k)%></td>
</tr>
<%
   
 }
%>

</table>
</td>
</tr>
<tr>
<td align="center" colspan="2">
<input type="button" name="sub" onClick="attendeereport();" value="Submit"/></td>
</tr>
</table>
<%if("ning".equals(platform)){%>
<div id="attendeereportsdata" align="center" STYLE=" height: 400px; width: 820px; font-size: 12px;"/></div>
<%}else{%>
<div id="attendeereportsdata" align="center" STYLE=" height: 400px; width: 820px; font-size: 12px; overflow: auto;"/></div>
<%}%>

<table align="center"><tr ><td align="center">
	<input type="button" name="submit" onClick="javascript:addAttendeeAction('add','<%=groupid%>','<%=platform%>');" value="Add Attendee"/>
        <!--<input type="submit" name="submit" onClick="javascript:generatePdf('.pdf','<%=groupid%>');" value="Export to PDF"/>-->
        <input type="submit" name="submit" onClick="javascript:generateExcel('.xsl','<%=groupid%>');" value="Export to Excel"/>
        <input type="button" name="submit" onClick="javascript:generateNameTags('<%=groupid%>');" value="Name Tags PDF"/></td>
        </tr></table>
<script>
attendeereport();
</script>
</form>
