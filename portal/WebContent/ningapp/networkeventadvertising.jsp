	<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.general.formatting.CurrencyFormat" %>
	<%@ page import="com.eventbee.f2f.F2FEventDB,com.eventbee.authentication.*"%>


<%!
	public  Vector	getAdvertisingEvents(Vector vec1,String userid){
		String query="select  b.eventname,b.eventid,sum(a.impressioncount) as imp,sum(a.total)  as imptotal,au.login_name as username from eventinfo b,impressions_summary a,authentication au "
						+" where a.refid=b.eventid and a.partnerid=(select partnerid from group_partner  where userid=? and status='Active') "
						+" and a.purpose='NETWORK_ADVERTISING' and au.user_id=b.mgr_id group by eventid, eventname ,login_name";			  
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{userid});
			if(statobj.getStatus()){
				String [] columnnames=dbmanager.getColumnNames();
					for(int i=0;i<statobj.getCount();i++){
						HashMap hm1=new HashMap();
						for(int j=0;j<columnnames.length;j++){
							hm1.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
						}
						vec1.add(hm1);
					}
			}
			
			return vec1;
		}




public  Vector	getAdvertisingcpcEvents(Vector vec1,String userid){


String query="select  b.eventname,b.eventid,sum(a.clickcount) as clk,sum(a.total)  as clktotal,au.login_name as username from eventinfo b,clicks_summary a,authentication au "
						+" where a.refid=b.eventid and a.partnerid=(select partnerid from group_partner  where userid=? and status='Active') "
						+" and a.purpose='NETWORK_ADVERTISING' and au.user_id=b.mgr_id  group by eventid, eventname,login_name";			  
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{userid});
			if(statobj.getStatus()){
				String [] columnnames=dbmanager.getColumnNames();
					for(int i=0;i<statobj.getCount();i++){
						HashMap hm1=new HashMap();
						for(int j=0;j<columnnames.length;j++){
							hm1.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
						}
						vec1.add(hm1);
					}
			}
			
			return vec1;
		}		
%>

<%
	String uid="";
	Authenticate auth=AuthUtil.getAuthData(pageContext);
	if(auth !=null){
		uid=auth.getUserID();
	}
	String serveraddre="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
	String url=serveraddre+"/home/links/Myearnings.html";
		
	String earning="";
    double total=0.0;
    double listtotal=0.0;
     double grandtotal=0.0;
	String listearning="";    
	 double cpmtotal=0;
	// String imptotal="0";
	double cpctotal=0;
    CurrencyFormat cfmt=new CurrencyFormat();		
	Vector advertisingvec=new Vector();	
	getAdvertisingEvents(advertisingvec,uid);
	
	
	Vector advertisingcpcvec=new Vector();
	getAdvertisingcpcEvents(advertisingcpcvec,uid);
		
		
	for(int i=0;i<advertisingvec.size();i++){				
					
					HashMap hmp=(HashMap)advertisingvec.elementAt(i);
					String patternserver=ShortUrlPattern.get((String)GenUtil.getHMvalue(hmp,"username",""));
		                        String impressioncount=(String)GenUtil.getHMvalue(hmp,"imp","");
					String imptotal=(String)GenUtil.getHMvalue(hmp,"imptotal","0");
                                         cpmtotal+=Double.parseDouble(imptotal); 
                                         
		
}

if(advertisingcpcvec!=null&&advertisingcpcvec.size()>0){		
for(int i=0;i<advertisingcpcvec.size();i++){				
HashMap hmp=(HashMap)advertisingcpcvec.elementAt(i);
String patternserver=ShortUrlPattern.get((String)GenUtil.getHMvalue(hmp,"username",""));
String Clicks=(String)GenUtil.getHMvalue(hmp,"clk","");
String clktotal=(String)GenUtil.getHMvalue(hmp,"clktotal","0");
cpctotal+=Double.parseDouble(clktotal); 

}
}


grandtotal=total+listtotal+cpmtotal+cpctotal;
String tot=grandtotal+"";		
%>

	
		<table cellpadding="0" cellspacing="0" align="center" width="100%">
		



<%		
	
if(advertisingvec!=null&&advertisingvec.size()>0){%>





<div class='memberbeelet-header'>Network Advertising</div>

 <tr><td  class='oddbase' colspan='3'><b>CPM Earnings</b></td></tr>

<%
String base="oddbase";
		for(int i=0;i<advertisingvec.size();i++){
			
			if(i%2==0)
				base="evenbase";
			else
				base="oddbase";
			HashMap hmp=(HashMap)advertisingvec.elementAt(i);
			String patternserver=ShortUrlPattern.get((String)GenUtil.getHMvalue(hmp,"username",""));
                        String impressioncount=(String)GenUtil.getHMvalue(hmp,"imp","");
			String imptotal=(String)GenUtil.getHMvalue(hmp,"total","");
                     
%>		
			<tr class="<%=base%>"> 
			<td align="left" class="<%=base%>" valign='top' ><a href="<%=patternserver%>/event?eventid=<%=GenUtil.getHMvalue(hmp,"eventid","")%>"><%= GenUtil.TruncateData(GenUtil.getHMvalue(hmp,"eventname",""),26)%></a></td>
			<td align="left"><%=cfmt.getCurrencyFormat("$",(String)GenUtil.getHMvalue(hmp,"imptotal",""),true)%></td>
			<td align="left"><%=impressioncount%> impressions </td>			
			
			</tr>
	
		<%
		}
		
		
		}
		
	if(advertisingcpcvec!=null&&advertisingcpcvec.size()>0){%>
		
		
		
		
		
		
		 <tr><td class='oddbase' colspan='3'><b>CPC Earnings</b></td></tr>
		
		          <%
		             String base="oddbase";
				for(int i=0;i<advertisingcpcvec.size();i++){
					
					if(i%2==0)
						base="evenbase";
					else
						base="oddbase";
					HashMap hmp=(HashMap)advertisingcpcvec.elementAt(i);
					String patternserver=ShortUrlPattern.get((String)GenUtil.getHMvalue(hmp,"username",""));
		                        String Clicks=(String)GenUtil.getHMvalue(hmp,"clk","");
					String clktotal=(String)GenUtil.getHMvalue(hmp,"clktotal","0");
		                       
		             %>		
					<tr class="<%=base%>"> 
					<td align="left" class="<%=base%>" valign='top' ><a href="<%=patternserver%>/event?eventid=<%=GenUtil.getHMvalue(hmp,"eventid","")%>"><%= GenUtil.TruncateData(GenUtil.getHMvalue(hmp,"eventname",""),26)%></a></td>
					<td align="left"><%=cfmt.getCurrencyFormat("$",(String)GenUtil.getHMvalue(hmp,"clktotal",""),true)%></td>
					<td align="left"><%=Clicks%> Clicks </td>			
					
					</tr>
			
				<%
				}
				
				
				}
		
		
		%>










	</table>	