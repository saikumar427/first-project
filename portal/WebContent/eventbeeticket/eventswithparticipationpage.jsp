<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.f2f.F2FEventDB"%>
<%@ page import="com.eventbee.pagenating.*"%>




<script language="javascript" src="/home/js/advajax.js" >
dummy23456=888111;
</script>

<script language="javascript" src="/home/js/ajax.js" >
dummy2335256=532567;
</script>
<%!


 Vector getEventsInfo(Vector v,String query){
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,null);
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









%>


<%
 String MYF2FINFO_QUERY= "select to_char(b.created_at,'MM/DD/YYYY')"
			 +" as created_at,c.settingid,b.eventname,b.eventid,au.login_name as username,c.settingid "
			 +" from eventinfo b,group_agent_settings c,authentication au where  b.eventid=c.groupid "
			 +" and b.mgr_id=au.user_id and listtype='PBL' and c.enableparticipant='Yes' and b.status='ACTIVE' "
			 +" order by b.created_at desc";

String query1="select c.settingid from group_agent c,group_partner d"  
		+" where c.agentid=d.partnerid and d.userid=?"
		+" and customised='Yes'";

String maxcommission=" ";
String mincommission=" ";

String serveraddress=(String)session.getAttribute("HTTP_SERVER_ADDRESS");
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
	userid=authData.getUserID();
}
CurrencyFormat cf=new CurrencyFormat();	


Vector v=new Vector();
String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});
v=getEventsInfo(v,MYF2FINFO_QUERY);
List l=DbUtil.getValues(query1,new String[]{userid});
if(v.size()>0){
		%>
	
	
	<table cellpadding="5"  cellspacing="0" align="center" width="100%">

	<%
	String base="oddbase";%>
	
	
	<tr class="colheader">
	
	<td width='30%'>Commission</td>
	<td  width='55%%'>Event</td>
	<td>Status</td>
	
	</tr>
	
	
	
	
	<%
	
	
	String url="";
	for(int i=0;i<v.size();i++){
		if(i%2==0)
			base="evenbase";
		else
			base="oddbase";
		HashMap hm=(HashMap)v.elementAt(i);
		String pattserver=ShortUrlPattern.get((String)GenUtil.getHMvalue(hm,"username",""));
		String truncatedata=GenUtil.TruncateData((String)GenUtil.getHMvalue(hm,"eventname",""),22);
		HashMap cm=new HashMap();
		cm=getcommdetails(GenUtil.getHMvalue(hm,"eventid",""));
			if(cm!=null&&cm.size()>0){
				if(cm.size()>1){
				
				maxcommission=max(cm);
				
				mincommission=min(cm);
				}
				else{
				
				maxcommission=(String)cm.get("priceval0");
				mincommission="0.0";
				}}
				else {
				
				maxcommission=".50";
		  }
		 
		url="/portal/eventbeeticket/commissiondetails.jsp?GROUPID="+GenUtil.getHMvalue(hm,"eventid","");
		%>
		<tr ><td id="mypopup<%=i%>" class="<%=base%>" colspan="4"></td></tr>
                
	<tr class="<%=base%>"> 
	
	 <%
	
  if(("0.0".equals(mincommission))||(mincommission.equals(maxcommission))){
 %>
  <td  id='commissionInfo'  class="<%=base%>" valign='top'><span style="cursor: pointer; text-decoration: underline" onclick="getdetails('<%=GenUtil.getHMvalue(hm,"eventid","")%>','<%=i%>');"><%=cf.getCurrencyFormat("$",maxcommission,true)%></span>
	</td><%} else{
	%>
	<td  id='commissionInfo'  class="<%=base%>" valign='top'><span style="cursor: pointer; text-decoration: underline" onclick="getdetails('<%=GenUtil.getHMvalue(hm,"eventid","")%>','<%=i%>');"><%=cf.getCurrencyFormat("$",mincommission,true)%>-<%=cf.getCurrencyFormat("$",maxcommission,true)%></span>
	</td>
	<%}%>
	        
	</td>
	
	<td class="<%=base%>" valign='top' ><a href='<%=pattserver%>/event?eventid=<%=GenUtil.getHMvalue(hm,"eventid","")%>&participant=<%=partnerid%>'><%=truncatedata%></a>
	<br>(<%=GenUtil.getHMvalue(hm,"created_at","")%>)
	</td>
	
		<%
		String agentstatus=GenUtil.getHMvalue(hm,"status","");
		if ("Active".equalsIgnoreCase(agentstatus))
			agentstatus="Approved";
		if ("Pending".equalsIgnoreCase(agentstatus))
			agentstatus="Approval Waiting";
		if ("suspend".equalsIgnoreCase(agentstatus))
			agentstatus="Suspended";
		%>
		<td><%=agentstatus%>
			<br><a href="/portal/mytasks/partner_reports.jsp?UNITID=13579&GROUPID=<%=GenUtil.getHMvalue(hm,"eventid","")%>&agentid=<%=partnerid%>">Report </a>
		</td>
		
		<%
		String eventinfo= pattserver+"/event?eventid="+GenUtil.getHMvalue(hm,"eventid","")+"&participant="+partnerid;
		%>
			
		</tr>
		
		
		
		
		<tr><td colspan="4">
		<a href='#' onclick=getAuthdata('<%=GenUtil.getHMvalue(hm,"eventid","")%>','/portal/fbauth/authdatacheck.jsp');>Settings & Integration Links</a>
		</td></tr>		
		<%	
		String settingid=GenUtil.getHMvalue(hm,"settingid","");
		if(l.contains(settingid)){%>
			
			<tr  class="<%=base%>" ><td class="<%=base%>" colspan="4" >Custom Participation Page: Updated <a href='/portal/mytasks/agentcomm.jsp?UNITID=13579&GROUPID=<%=GenUtil.getHMvalue(hm,"eventid","")%>&agentid=<%=partnerid%>&setid=<%=GenUtil.getHMvalue(hm,"settingid","")%>&foroperation=edit&isnew=yes'>Edit</a></td></tr>
		
	
		<%if("Approved".equals(agentstatus)){%>
			<tr  class="<%=base%>" ><td class="<%=base%>" colspan="4" >Copy and paste the following code (displays Goal/Sales amount graph) into
your blog or website. <br/> <a href="/portal/mytasks/nwticketstreamer.jsp?GROUPID=<%=GenUtil.getHMvalue(hm,"eventid","")%>&participant=<%=partnerid%>">Click here to customize look and feel</a>.<br/><br/>
			
			<jsp:include page="/eventstreamer/getStreamCode.jsp">
			<jsp:param name="cols" value="36"/>
			<jsp:param name="rows" value="4"/>
			<jsp:param name="GROUPID" value="<%=GenUtil.getHMvalue(hm,"eventid","")%>"/>
			<jsp:param name="participant" value="<%=GenUtil.getHMvalue(hm,"agentid","")%>"/>
			<jsp:param name='Dummy_ph' value='' /></jsp:include>
			</td></tr>
			<%}
			}else{%>
		
		         	<tr  class="<%=base%>"><td class="<%=base%>" colspan="4" >Custom Participation Page: <a href='/portal/mytasks/loginevent.jsp?UNITID=13579&setid=<%=GenUtil.getHMvalue(hm,"settingid","")%>&GROUPID=<%=GenUtil.getHMvalue(hm,"eventid","")%>&foroperation=create'>Create</a></td></tr>
		<%	}
		
	}%>
<%

}%>
</table>