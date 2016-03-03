<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.eventbee.sitemap.util.Presentation,com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page errorPage="error.jsp"%>
<%!
static String GET_ALL_TRACKING_CODES="select trackingcode from trackurls where eventid=?";

public Vector getTrackDetails(String eventid){
Vector v= new Vector();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(GET_ALL_TRACKING_CODES,new String[]{eventid});
	if(stobj.getStatus()){
		for(int i=0;i<stobj.getCount();i++){
			HashMap hm=new HashMap();			
			hm.put("trackingcode",dbmanager.getValue(i,"trackingcode",""));
			v.addElement(hm);			
		}
	}
	return v;
}
%>
<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"reg_reports.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
int year=0;
DbUtil.executeUpdateQuery("update event_reg_transactions set ccfee=0.00 where paymenttype<>'eventbee' and ccfee >0",null);	
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
java.util.Date d=new java.util.Date();
year=d.getYear()+1900;
Date date=new Date();	
SimpleDateFormat format=new SimpleDateFormat("MM/dd/yyyy");
String platform = request.getParameter("platform");
String URLBase="mytasks";
    if("ning".equals(platform)){
	URLBase="ningapp";	
    }
    String filter = request.getParameter("filter");
 String tokenid=request.getParameter("tokenid");
  if(tokenid==null || "null".equals(tokenid)) tokenid="";

String agentid=request.getParameter("agentid");
if(agentid!=null)
         request.setAttribute("subtabtype","My Pages");
String ps=request.getParameter("PS");
String evttype=request.getParameter("evttype");
if(ps!=null || (agentid!=null && "event".equals(evttype)))
request.setAttribute("subtabtype","My Pages");
Vector trackingcodesvector=getTrackDetails(groupid);
String mgrtokenid = request.getParameter("mgrtokenid");
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
document.getElementById('reports').innerHTML='<span align="right">Loading .... please wait</span>';
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
<form method="post" action="/portal/listreport/transaction_reports.jsp" name="frm" id="regreport" >
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<input type="hidden" name="groupid" value="<%=groupid%>"/>
<input type='hidden' name='evtname' value='<%=request.getParameter("evtname") %>'  />
<input type='hidden' name='evttype' value='<%=request.getParameter("evttype") %>'  />
<input type="hidden" name="agentid" value="<%=agentid%>"/>
<input type="hidden" name="landf" value="yes">
<input type="hidden" name="rtype" value="html">
<input type="hidden" name="platform" value="<%=platform%>">
<input type="hidden" name="filter" value="<%=filter%>">
<input type="hidden" name="tokenid" value="<%=tokenid%>">
<input type="hidden" name="mgrtokenid" value="<%=mgrtokenid%>">

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
<tr><td height="5" colspan="2"></td></tr>
<tr>
<td align="right"><input type="radio" name="selindex" value="1" checked="true"/></td>
<td align="left">All Active Transactions</td></tr> 
<tr>
<td align="right"><input type="radio" name="selindex" value="3" /></td>
<td align="left">Transaction ID &nbsp;&nbsp;<input type="textbox" name="key" size="15"/></td>
</tr>
<tr>
<td align="right"><input type="radio" name="selindex" value="6" /></td>
<td align="left">Order Number &nbsp;<input type="textbox" name="ordernumber" size="15"/></td>
</tr>
<tr>
<td align="right"><input type="radio" name="selindex" value="4" /></td>
<td align="left">Attendee Name &nbsp;<input type="textbox" name="attendee" size="15"/></td>
</tr>
<tr>
<td align="right" ><input type="radio" name="selindex" value="2"/></td>
<td align="left">Start Date
<%=EventbeeStrings.getMonthHtml("","startMonth","","")%>
<%=EventbeeStrings.getDayHtml("","startDay","","")%>
<%=EventbeeStrings.getYearHtml(year-1,2,0,"startYear","","")%>
</td>
</tr>
<tr>
<td align="left"></td>
<td>End Date &nbsp;
<%=EventbeeStrings.getMonthHtml("","endMonth","","")%>
<%=EventbeeStrings.getDayHtml("","endDay","","")%>
<%=EventbeeStrings.getYearHtml(year-1, 3,0,"endYear","","")%>
</td>
</tr>
<tr>
<td align="left"><input type="radio" name="selindex" value="5" /></td>
<td class="inform">Transaction Status &nbsp;&nbsp;<select name='paymentstaus'>
<option value='Denied' >Rejected</option>
<option value='Cancelled'>Deleted</option>
</select></td>
</tr>


<tr>
<td><input type="radio" name="selindex" value="7" /></td>
<td>Booking Source &nbsp;&nbsp;&nbsp;<select name="source">
<option  value="">Select Source</option>
<option  value="direct">Direct</option>
<option  value="nts">NTS</option>
<option  value="alltrackcodes">All Tracking URLs</option>

<%
if (trackingcodesvector!=null&&trackingcodesvector.size()>0){

for(int i=0;i<trackingcodesvector.size();i++){		
	HashMap trackMap=(HashMap)trackingcodesvector.elementAt(i);
	String  trackingcode= (String)trackMap.get("trackingcode"); 	
%>

<option  value="<%=trackingcode%>">Track URL: <%=trackingcode%></option>
<%}
}
%>
</select></td>
</tr>
<tr>

<td colspan="2">&nbsp;&nbsp;<b>Sort By</b>&nbsp;&nbsp;
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
<a href="#" name ="CheckAll" onClick="checkAll(document.frm.displayFields)">Select All</a> | <a href="#" name ="UnCheckAll" onClick="uncheckAll(document.frm.displayFields)">Clear All</a>
</td>
</tr>
<tr><td></td></tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Transaction ID" checked></input>Transaction ID</td>
<td><input type="checkbox" name="displayFields" value="Order Number" checked></input>Order Number</td>

</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Book Date" checked></input>Booking Date</td>
<td><input type="checkbox" name="displayFields" value="Status"  ></input>Status</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="First Name" ></input>First Name</td>
<td><input type="checkbox" name="displayFields" value="Last Name" ></input>Last Name</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Tracking URL" ></input>Tracking URL</td>
<td><input type="checkbox" name="displayFields" value="Source" ></input>Source</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Email" ></input>Email</td>
<td><input type="checkbox" name="displayFields" value="Discount" ></input>Discount</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Discount Code" ></input>Discount Code</td>
<td><input type="checkbox" name="displayFields" value="Ticket Name" ></input>Ticket Name</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Ticket Price" ></input>Ticket Price</td>
<td><input type="checkbox" name="displayFields" value="Tickets Count" ></input>Tickets Count</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Service Fee" checked></input>Service Fee</td>
<td><input type="checkbox" name="displayFields" value="CC Processing Fee" checked></input>CC Processing Fee</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="Tickets Total" checked></input>Tickets Total Cost</td>
<td ><input type="checkbox" name="displayFields" value="Net" checked ></input>Net Amount</td>
</tr>
<tr>
<td><input type="checkbox" name="displayFields" value="NTS Commission" checked></input>NTS Commission</td>
<td><input type="checkbox" name="displayFields" value="Total Net" checked></input>Total (After Commission)</td>
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

</form>
