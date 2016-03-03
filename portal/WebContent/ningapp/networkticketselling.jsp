	<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.general.formatting.CurrencyFormat" %>
	<%@ page import="com.eventbee.f2f.F2FEventDB,com.eventbee.authentication.*"%>


<%!

public  Vector getEarningEventsInfo(String agentid){
	Vector v=new Vector();
			String query="select distinct b.eventname,b.eventid"
                                      +"  from eventinfo b,transaction d, partner_transactions c" 
                                      +"  where  b.eventid=cast(d.refid as integer) and d.agentid=? and c.agentid=d.agentid "
                                      +"  and d.transactionid=c.transactionid and agentcommission>0";
                                       
	  
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{agentid});
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

	public  HashMap getEarningsInfo(String statusType, String agentid){
		HashMap earningsMap=new HashMap();
		String query="select d.refid, sum(agentcommission) as agentcommission"
                                      +"  from transaction d, partner_transactions c" 
                                      +"  where  d.agentid=? and c.agentid=d.agentid "
                                      +"  and d.transactionid=c.transactionid"
                                      +"  and paymentstatus=? and agentcommission>0 "
                                       +" group by refid";
                                       
	  
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{agentid,statusType});
			if(statobj.getStatus()){
				
					for(int i=0;i<statobj.getCount();i++){
						
						
						earningsMap.put(dbmanager.getValue(i,"refid",""),dbmanager.getValue(i,"agentcommission","0"));
						
						
					}
			}
			return earningsMap;
		}
		
		
		
		
		%>




	

<% 

double creditedearningtotal=0.0;
	double waitforcreditearningtotal=0.0;
	String creditedearning="";
	String waitforcreditearning="";
	String userid="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
		userid=authData.getUserID();
	}
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
	String agentid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});
	String pattserver="";
	
    CurrencyFormat cf=new CurrencyFormat();	
	Vector eventsList=new Vector();
	if(agentid==null || "".equals(agentid))
	{} else
		eventsList=getEarningEventsInfo(agentid);
	HashMap creditedEarningsMap=null;
	HashMap waitforcreditEarningsMap=null;
	if(eventsList.size()>0){
		creditedEarningsMap=getEarningsInfo("credited", agentid);
		waitforcreditEarningsMap=getEarningsInfo("waiting for credit", agentid);
	
	}
	
%>
<script> 
 function reports(){ 
	document.myform.submit(); 
 } 
 </script>
 <form  name='myform' method='post'  action='/portal/ningapp/partner_reports.jsp'>

	
		<table cellpadding="0" cellspacing="0" align="center" width="100%">
		

<tr><td colspan='3'>
		<div class='memberbeelet-header'>Network Ticket Selling</div>
		</td></tr>


<%		
	if(eventsList.size()>0){
%>	
		


<%		String base="oddbase";
for(int i=0;i<eventsList.size();i++){
	HashMap hm=(HashMap)eventsList.elementAt(i);

	    String eid=GenUtil.getHMvalue(hm,"eventid","");
		creditedearning=GenUtil.getHMvalue(creditedEarningsMap,eid,"0");
		waitforcreditearning=GenUtil.getHMvalue(waitforcreditEarningsMap,eid,"0");
		creditedearningtotal+=Double.parseDouble(creditedearning);
		waitforcreditearningtotal+=Double.parseDouble(waitforcreditearning);
		
		
	if(i%2==0)
		base="evenbase";
	else
		base="oddbase";


			
%>		
	<tr > 
	<td align="left" class="<%=base%>" valign='top' colspan='3'><a href="<%=serveraddress%>/eventdetails/event.jsp?eventid=<%=eid%>" target="_blank"><%= GenUtil.TruncateData(GenUtil.getHMvalue(hm,"eventname",""),26)%></a>
	</td>
		
	</tr>
<tr > 
<td align="left" class="<%=base%>"><%=cf.getCurrencyFormat("$",creditedearning,true)%> (credited)</td>
<td align="left" class="<%=base%>"><%=cf.getCurrencyFormat("$",waitforcreditearning,true)%> (waiting for credit)</td>
<input type='hidden' name='UNITID' value='13579' />
<input type='hidden' name='GROUPID' value='<%=GenUtil.getHMvalue(hm,"eventid","")%>' />
<input type='hidden' name='agentid' value='<%=agentid%>' />

<td class="<%=base%>" align="center"><a href="#" onclick="javascript:reports();">Report</a></td>
</tr>
<%	
		}
		
}	
else{
	
%>

<tr><td class="evenbase" colspan="4">No Events Found.</td></tr>

<%}%>	

	</table>	