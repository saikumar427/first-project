<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.general.formatting.CurrencyFormat" %>
<%@ page import="com.eventbee.f2f.F2FEventDB,com.eventbee.authentication.*"%>
<%@ page import="com.eventbeepartner.partnernetwork.EarningDetails" %>

<%
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	String userid=(authData !=null)?authData.getUserID():""; 	
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
	String url=serveraddress+"/home/links/Myearnings.html";
	String agentid=(String)session.getAttribute(userid+"_partnerid");	
	String earning="";
   	double total=0.0;
    	double listtotal=0.0;
    	String listearning="";    
	String platform = request.getParameter("platform");
	String linktarget="_self";
	String URLBase="mytasks";
	if("ning".equals(platform)){
		linktarget="_blank";
		URLBase="ningapp";
	}
   	CurrencyFormat cf=new CurrencyFormat();
   	EarningDetails earningdet=new EarningDetails();
   	Vector advertisingvec=new Vector();	
	Vector getAdvertisingEvents=earningdet.getAdvertisingEvents(advertisingvec,userid);	
	Vector advertisingcpcvec=new Vector();
	Vector getAdvertisingcpcEvents=earningdet.getAdvertisingcpcEvents(advertisingcpcvec,userid);		
	
	
		
%>
<table cellpadding="0" cellspacing="0" align="center" width="100%" valign="top">
	<tr><td class='memberbeelet-header' colspan='3'>Network Advertising</td></tr>
</table>
<div  STYLE=" height: 500px; overflow: auto;">
 	
	<table cellpadding="0" cellspacing="0" align="center" width="100%">
	
<%		
	if(advertisingvec!=null&&advertisingvec.size()>0){
%>
	
	<tr><td  class='oddbase' colspan='3'><b>CPM Earnings</b></td></tr>

<%
		for(int i=0;i<advertisingvec.size();i++){
			String base=(i%2==0)?"evenbase":"oddbase";		
			HashMap hmp=(HashMap)advertisingvec.elementAt(i);
			String impressioncount=(String)GenUtil.getHMvalue(hmp,"imp","");
			String imptotal=(String)GenUtil.getHMvalue(hmp,"total","");
			String eventurl= serveraddress+"/event?eid="+GenUtil.getHMvalue(hmp,"eventid","");
%>		
			<tr class="<%=base%>"> 
			<td align="left" class="<%=base%>" valign='top' ><a href="<%=eventurl%>" target='<%=linktarget%>'><%= GenUtil.TruncateData(GenUtil.getHMvalue(hmp,"eventname",""),26)%></a></td>
			<td align="left"><%=cf.getCurrencyFormat("$",(String)GenUtil.getHMvalue(hmp,"imptotal",""),true)%></td>
			<td align="left"><%=impressioncount%> impressions </td>	
			</tr>	
<%
		}		
	}		
	if(advertisingcpcvec!=null&&advertisingcpcvec.size()>0){
%>		
		 	<tr><td class='oddbase' colspan='3'><b>CPC Earnings</b></td></tr>		
<%		       
			for(int i=0;i<advertisingcpcvec.size();i++){
				String base=(i%2==0)?"evenbase":"oddbase";
				HashMap hmp=(HashMap)advertisingcpcvec.elementAt(i);
				String eventurl= serveraddress+"/event?eid="+GenUtil.getHMvalue(hmp,"eventid","");
				String Clicks=(String)GenUtil.getHMvalue(hmp,"clk","");
				String clktotal=(String)GenUtil.getHMvalue(hmp,"clktotal","0");
 %>		
			<tr class="<%=base%>"> 
			<td align="left" class="<%=base%>" valign='top' ><a href="<%=eventurl%>" target='<%=linktarget%>'><%= GenUtil.TruncateData(GenUtil.getHMvalue(hmp,"eventname",""),26)%></a></td>
			<td align="left"><%=cf.getCurrencyFormat("$",(String)GenUtil.getHMvalue(hmp,"clktotal",""),true)%></td>
			<td align="left"><%=Clicks%> Clicks </td>			

			</tr>

<%
			}			
	}
%>
	</table></div>	