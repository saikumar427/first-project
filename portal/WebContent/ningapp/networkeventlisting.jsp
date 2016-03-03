	<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.general.formatting.CurrencyFormat" %>
	<%@ page import="com.eventbee.f2f.F2FEventDB,com.eventbee.authentication.*"%>


<%!	public  Vector getListingEvents(Vector vec,String userid){			
			String query="select  b.eventname,b.eventid,a.amount,a.duration,a.duration_type from eventinfo b,partner_listing a "
						+" where a.refid=b.eventid and a.partnerid=(select partnerid from group_partner  where userid=? and status='Active') "
						+" order by  a.created_at desc";			  
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{userid});
			if(statobj.getStatus()){
				String [] columnnames=dbmanager.getColumnNames();
					for(int i=0;i<statobj.getCount();i++){
						HashMap hm=new HashMap();
						for(int j=0;j<columnnames.length;j++){
							hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
						}
						vec.add(hm);
					}
			}
			
			return vec;
		}		
%>
<%
	String userid="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
		userid=authData.getUserID();
	}
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");

	String agentid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});
	
    double listtotal=0.0;
    
	String listearning="";    
	
    CurrencyFormat cf=new CurrencyFormat();	
	
	
	Vector listingvec=new Vector();
	getListingEvents(listingvec,userid);	
		
		if(listingvec.size()>0){
			for(int i=0;i<listingvec.size();i++){
				HashMap hm=(HashMap)listingvec.elementAt(i);
				listearning=(String)GenUtil.getHMvalue(hm,"amount","0.0");
				listtotal+=Double.parseDouble(listearning); 
			}
		}	
%>
		<table cellpadding="0" cellspacing="0" align="center" width="100%">
<%		
	
	if(listingvec.size()>0){
%>	
<div class='memberbeelet-header'>Network Event Listing</div>
 <%	
 		String base="oddbase";
		for(int i=0;i<listingvec.size();i++){
			
			if(i%2==0)
				base="evenbase";
			else
				base="oddbase";
			HashMap hm=(HashMap)listingvec.elementAt(i);
			//String evturl=ShortUrlPattern.get((String)GenUtil.getHMvalue(hm,"username",""));
			String duration_type=(String)GenUtil.getHMvalue(hm,"duration_type","");
			String duration=(String)GenUtil.getHMvalue(hm,"duration","");
			if(!"1".equals(duration))
			duration_type+="s";
			
%>		
			<tr class="<%=base%>"> 
			<td align="left" class="<%=base%>" valign='top' ><a href="<%=serveraddress%>/eventdetails/event.jsp?eventid=<%=GenUtil.getHMvalue(hm,"eventid","")%>"><%= GenUtil.TruncateData(GenUtil.getHMvalue(hm,"eventname",""),26)%></a></td>
			<td align="left"><%=cf.getCurrencyFormat("$",(String)GenUtil.getHMvalue(hm,"amount",""),true)%></td>
			<td align="left"><%=duration%> <%=duration_type%></td>			
			</tr>
<%	
		}
}
%>
	</table>	