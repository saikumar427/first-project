<%@ page import="java.util.Vector,java.util.HashMap,com.eventbee.general.EbeeConstantsF,com.eventbee.general.formatting.CurrencyFormat" %>
<%@ page import="com.eventbee.f2f.F2FEventDB,com.eventbee.authentication.Authenticate"%>
<%@ page import="com.eventbeepartner.partnernetwork.EarningDetails" %>
<%@ page import="com.eventbee.general.AuthUtil,com.eventbee.general.GenUtil"%>
<%	
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	String userid=(authData !=null)?authData.getUserID():""; 	
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");	
	String agentid=(String)session.getAttribute(userid+"_partnerid");
	Vector listingvec=new Vector();	
	EarningDetails earningdet=new EarningDetails();	
	Vector getListingEvents=earningdet.getListingEvents(listingvec,userid);
    	double listtotal=0.0;    
	String listearning="";	
    	CurrencyFormat cf=new CurrencyFormat();
    	String platform = request.getParameter("platform");
		String linktarget="_self";
		String URLBase="mytasks";
		if("ning".equals(platform)){
			linktarget="_blank";
			URLBase="ningapp";
		}

	
%>
	
  
<%		
	if(listingvec.size()>0){
%>
<table cellpadding="0" cellspacing="0" align="center" width="100%">
	<tr><td  class='memberbeelet-header'>Network Event Listing</td></tr>
	</table>
	<div STYLE=" height: 210px;  overflow: auto;">
	  <table cellpadding="0" cellspacing="0" width="100%" >
<%
	for(int i=0;i<listingvec.size();i++){			
		String base=(i%2==0)?"evenbase":"oddbase";	
		HashMap hm=(HashMap)listingvec.elementAt(i);
		String duration_type=(String)GenUtil.getHMvalue(hm,"duration_type","");
		String duration=(String)GenUtil.getHMvalue(hm,"duration","");
		if(!"1".equals(duration)) duration_type+="s";		
%>		
		<tr class="<%=base%>"> 
		<td align="left" class="<%=base%>" valign='top' ><a href="<%=serveraddress%>/event?eid=<%=GenUtil.getHMvalue(hm,"eventid","")%>" target="<%=linktarget%>"><%= GenUtil.TruncateData(GenUtil.getHMvalue(hm,"eventname",""),26)%></a></td>
		<td align="left"><%=cf.getCurrencyFormat("$",(String)GenUtil.getHMvalue(hm,"amount","0.0"),true)%></td>
		<td align="left"><%=duration%> <%=duration_type%></td>			
		</tr>
<%	
		}
	%>
	</table>	
	</div>
<%	}
%>
	