<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.f2f.F2FEventDB"%>
<%@ page import="com.eventbee.pagenating.*"%>

<%!
 Vector getnotenabledEventsInfo(Vector v,String query,String no_records,String starts_from,String eventname){
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{"%"+eventname+"%", no_records,starts_from});
	if(statobj.getStatus()){
		String [] columnnames=dbmanager.getColumnNames();
			for(int i=0;i<statobj.getCount();i++){
			HashMap hm=new HashMap();
			for(int j=0;j<columnnames.length;j++){
			hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
			}
			v.add(hm);
		}
	}
	return v;
}

HashMap getcommdetails(String eventid)	{

HashMap hm=new HashMap();
String query="select networkcommission from price where evt_id=?";
DBManager dbmanager=new DBManager();
StatusObj stob=dbmanager.executeSelectQuery(query, new String []{eventid});

if(stob.getStatus()){

for(int i=0;i<stob.getCount();i++){
hm.put("priceval"+i,dbmanager.getValue(i,"networkcommission",""));
}
}

return(hm);

}
String max(HashMap  hm){
int l=hm.size();
String temp=" ";
String first="";
String sec="";
String result="";
for(int i=0;i<l-1;i++){
first=(String)hm.get("priceval"+i);
sec=(String)hm.get("priceval"+(i+1));
if((!"".equals(first))&&(!"".equals(first))){
if(Double.parseDouble(first)>Double.parseDouble(sec)){

hm.put("priceval"+i,sec);
hm.put("priceval"+(i+1),first);
result=(String)hm.get("priceval"+(i+1));
}

else{
hm.put("priceval"+i,first);
hm.put("priceval"+(i+1),sec);
result=(String)hm.get("priceval"+(i+1));
}
}
}
return(result);
}

String min(HashMap  hm){
int l=hm.size();
String temp=" ";
String first="";
String sec="";
String result="";
for(int i=0;i<l-1;i++){
first=(String)hm.get("priceval"+i);
sec=(String)hm.get("priceval"+(i+1));
if((!"".equals(first))&&(!"".equals(first))){
if(Double.parseDouble(first)<Double.parseDouble(sec)){
hm.put("priceval"+i,sec);
hm.put("priceval"+(i+1),first);
result=(String)hm.get("priceval"+(i+1));
}

else{
hm.put("priceval"+i,first);
hm.put("priceval"+(i+1),sec);
result=(String)hm.get("priceval"+(i+1));
}
}

}
return(result);
}





	
	
int getRecordCount(String eventname){
	String query="select count(*) from eventinfo b,group_agent_settings c where  b.eventid=c.groupid "
			+" and listtype='PBL'  and c.enablenetworkticketing ='Yes'  and b.status='ACTIVE' "
			+" and upper(eventname) like upper(?)";
	String count=DbUtil.getVal(query,new String[] {"%"+eventname+"%"});
	return Integer.parseInt(count);
}



%>
<script language="javascript" src="/home/js/advajax.js" >
dummy23456=888111;

</script>

<script language="javascript" src="/home/js/ajax.js" >
dummy2335256=532567;

</script>

<script>




</script>




<%
String eventname=request.getParameter("eventname");

if(eventname==null) eventname="";

eventname=eventname;

String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
	userid=authData.getUserID();
}

String Query=" select status,eventid from manual_nts_events where partnerid=(select partnerid from group_partner where userid=?)";

HashMap eventstatusmap=new HashMap();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(Query,new String[]{userid});
String status="";
String eventid="";
if(stobj.getStatus())
{
	for(int k=0;k<stobj.getCount();k++)
	{			
	eventstatusmap.put(dbmanager.getValue(k,"eventid",""),dbmanager.getValue(k,"status",""));
	}
}

String query1="select c.nts_approvaltype,b.eventname,b.eventid"
		+" from eventinfo b,group_agent_settings c where  b.eventid=c.groupid "
		+" and listtype='PBL'  and c.enablenetworkticketing ='Yes'  and b.status='ACTIVE' "
		+" and upper(eventname) like upper(?)"
		+" order by b.created_at desc limit ? offset ?";
		
String serveradd="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
	
String pattserver="";
String truncatedata="";
String maxcommission="";
String mincommission="";

String serveraddress=(String)session.getAttribute("HTTP_SERVER_ADDRESS");


	int pageIndex=1;
	String page_records=EbeeConstantsF.get("network.notenabled.page.records","5");
	int no_of_records=Integer.parseInt(page_records);
	int recordcount=0;
	String contenturl="";
	boolean displayevents=false;
	boolean pageNatingException=false;
    CurrencyFormat cf=new CurrencyFormat();	



	try{
			pageIndex=Integer.parseInt(request.getParameter(".pageIndex"));

		}catch(Exception e){pageIndex=1;}
	request.setAttribute("PAGEINDEX",java.lang.Integer.toString(pageIndex));
	String starts_from=(((pageIndex-1)*no_of_records))+"";
	String no_records=Integer.toString(no_of_records);
	
	Vector v=new Vector();
	v=getnotenabledEventsInfo(v,query1,no_records,starts_from,eventname);
	int totalrecords=getRecordCount(eventname);
	pageNating pageNav=new pageNating();

   
	if(v!=null&& v.size()>0){
		contenturl="/mytasks/networkticketsellingpage.jsp?x=y&eventname="+java.net.URLEncoder.encode(eventname);

		try{
			pageNav.setLink(PageUtil.appendLinkWithGroup(contenturl,(HashMap)request.getAttribute("REQMAP")));

		

			pageNav.getPagenatingElements(0,pageIndex,no_of_records,totalrecords,v.size());
				displayevents=true;
				pageNav.setNo_Of_PageIndex(10);
				request.setAttribute("PAGENAV",pageNav);
			}catch(Exception e){
				System.out.println(e);
				displayevents=false;pageNatingException=true;
			}

		}


%>



<%
String evtnamesrchPlsHld="Enter Event Name";
String evtdisplay=eventname;
String evtdisplayclass="stdstyle";
if("".equals(eventname)){
	evtdisplay=evtnamesrchPlsHld;
	evtdisplayclass="greystyle";
}
String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});
int vcount=v.size();
String base="oddbase";
%>
<style>
.greystyle {
	color: gray;
	
}
.stdstyle {
	color: black;
	
}
</style>
<script>
function searchevents() {
	clearPlaceholderContent(document.getElementById('eventname'),'<%=evtnamesrchPlsHld%>');
document.searchform.submit();  
	}
function resetevents(){
window.location.href='/portal/mytasks/networkticketsellingpage.jsp';
}


function showPlaceholderContent(textbox, placeholdertext) {
    if(textbox.value == ''){
    	textbox.value = placeholdertext;
    	textbox.className='greystyle';
    }
}
function clearPlaceholderContent(textbox, placeholdertext) {

    if(textbox.value == placeholdertext){   
   	textbox.value = '';
   	textbox.className='stdstyle';
   }
}
</script>
<div class='memberbeelet-header'>My Network Ticket Selling Participation</div>
<form name="searchform" method="post" action="/portal/mytasks/networkticketsellingpage.jsp" >

<table cellpadding="5"  cellspacing="0" align="center" width="100%">
<tr>
<td class="<%=base%>" colspan="4">
<input type="text" class="<%=evtdisplayclass%>" value="<%=evtdisplay%>" onfocus="clearPlaceholderContent(this,'<%=evtnamesrchPlsHld%>');" onblur="showPlaceholderContent(this,'<%=evtnamesrchPlsHld%>');"  name="eventname" id="eventname"> 
<input type="button" value="Search"  onclick="javascript:searchevents();">
<a href="/portal/mytasks/networkticketsellingpage.jsp" >Reset</a>
</td></tr>
<%
if(displayevents){
%>
	<tr >
	
<td align="left" colspan="4" class='colheader' ><%=pageNav.showRecordPosition()%>&nbsp;&nbsp;&nbsp;
<%=pageNav.pageNavigatorWithPageIndexs()%></td>
				</tr>
	
	<%
	for(int i=0;i<vcount;i++){
		if(i%2==0)
			base="evenbase";
		else
			base="oddbase";
		HashMap hm=(HashMap)v.elementAt(i);
		HashMap cm=new HashMap();
		cm=getcommdetails(GenUtil.getHMvalue(hm,"eventid",""));
		if(cm!=null&&cm.size()>0){
		if(cm.size()>1){

		//maxcommission=max(cm);

		//mincommission=min(cm);
		}
		else{

		maxcommission=(String)cm.get("priceval0");
		mincommission="0.0";
		}}
		else {

		maxcommission=".50";
		mincommission="0.0";
		  }
		pattserver=ShortUrlPattern.get((String)GenUtil.getHMvalue(hm,"username",""));
		truncatedata=(String)GenUtil.getHMvalue(hm,"eventname","");
		
		%>
	<tr ><td id="popup<%=i%>" class="<%=base%>" colspan="4"></td></tr>
	
	<tr > 
	<%--
	  if(("0.0".equals(mincommission))||(mincommission.equals(maxcommission))){
	 %>
	  <td  id='commissionInfo'  class="<%=base%>" valign='top'><span style="cursor: pointer; text-decoration: underline" onclick="getdetails1('<%=GenUtil.getHMvalue(hm,"eventid","")%>','<%=i%>');"><%=cf.getCurrencyFormat("$",maxcommission,true)%></span>
		</td><%}
		else{%>
		<td  id='commissionInfo'  class="<%=base%>" valign='top'><span style="cursor: pointer; text-decoration: underline" onclick="getdetails1('<%=GenUtil.getHMvalue(hm,"eventid","")%>','<%=i%>');"><%=cf.getCurrencyFormat("$",mincommission,true)%>-<%=cf.getCurrencyFormat("$",maxcommission,true)%></span>
		</td>
		<%}--%>
		        
	
	<td  colspan="4" class="<%=base%>" valign='top' ><a href='<%=serveradd%>/eventdetails/event.jsp?eventid=<%=GenUtil.getHMvalue(hm,"eventid","")%>&participant=<%=partnerid%>'><%=truncatedata%></a>
	
	
	</td></tr>

		<%
		
		String agentstatus=(String)GenUtil.getHMvalue(eventstatusmap,GenUtil.getHMvalue(hm,"eventid",""),"");
		
		if ("".equalsIgnoreCase(agentstatus)){
		String apprvstatus=GenUtil.getHMvalue(hm,"nts_approvaltype","");
		if("Auto".equals(apprvstatus))
			agentstatus="Approved";		
		else
			agentstatus="Need Approval";
		}
		%>
		<tr><td class="<%=base%>" colspan="4">Status: <%=agentstatus%>
		<%
		String eventinfo= serveradd+"/eventdetails/event.jsp?eventid="+GenUtil.getHMvalue(hm,"eventid","")+"&participant="+partnerid;
		%>
			
		  <%if("Need Approval".equals(agentstatus)){ %>            
		 &raquo; <a href='/portal/mytasks/getntsapproval.jsp?groupid=<%=GenUtil.getHMvalue(hm,"eventid","")%>' >Get Approval</a>
		 <%}
		 else if("Approved".equals(agentstatus)){
		 %>
		 &raquo; <a href='/portal/mytasks/partnerlinks.jsp?groupid=<%=GenUtil.getHMvalue(hm,"eventid","")%>' >Manage</a>
		 <%}%>
		</td></tr>
<%	
	}
}else{
	
%>

<tr><td class="evenbase" colspan="4">No Events Found.</td></tr>
<%}%>
</table>
</form>
