<%@ page import="java.util.HashMap,com.eventbee.general.*" %>
	<%@ page import="com.eventbee.authentication.Authenticate"%>
<%@ page import="com.eventbeepartner.partnernetwork.PartnerDetails,com.eventbee.general.formatting.CurrencyFormat" %>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">



<%
CurrencyFormat cf=new CurrencyFormat();
	String userid="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
		userid=authData.getUserID();
	}
	
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
    	PartnerDetails pd=new PartnerDetails();
    HashMap amounthm=pd.getPartnerListingPrices(userid);
    if(amounthm!=null){%>
    
    <form name='form' id='amountupdate' action='/ntspartner/ajaxupdatepriceprocessor.jsp' method="post" onSubmit="submitamount();return false;">
    <table cellpadding="0" cellspacing="0" align="center" width="100%">
		<tr><td colspan='3'>
		<div class='memberbeelet-header'>My Network Event Listing Pricing</div>
		</td></tr>
		<tr><td class='colheader' ><b>Duration</b></td><td class='colheader'><b>Amount</b></td><td class='colheader'></td></tr>
		<tr><td id='errordisp' class='error' colspan='3'></td></tr>
		<tr ><td   class='evenbase'>1 Week </td><td  class='evenbase' id='editamount1' width='40%'><%=cf.getCurrencyFormat("$",GenUtil.getHMvalue(amounthm,"1_week","0"),true)%></td><td   class='evenbase' id='editlink1'><span style="cursor: pointer; text-decoration: underline" onclick="editprice('1','<%=(String)GenUtil.getHMvalue(amounthm,"1_week","0")%>')">Edit</span></td></tr>
		
		<tr ><td  class='oddbase'>2 Weeks </td><td class='oddbase' id='editamount2'  width='40%'><%=cf.getCurrencyFormat("$",GenUtil.getHMvalue(amounthm,"2_week","0"),true)%></td><td id='editlink2' class='oddbase'><span style="cursor: pointer; text-decoration: underline" onclick="editprice('2','<%=(String)GenUtil.getHMvalue(amounthm,"2_week","0")%>')">Edit</span></td></tr>
		<tr ><td  class='evenbase'>3 Weeks </td><td class='evenbase' id='editamount3'  width='40%'><%=cf.getCurrencyFormat("$",GenUtil.getHMvalue(amounthm,"3_week","0"),true)%></td><td class='evenbase' id='editlink3'><span style="cursor: pointer; text-decoration: underline" onclick="editprice('3','<%=(String)GenUtil.getHMvalue(amounthm,"3_week","0")%>')">Edit</span></td></tr>
		<tr ><td class='oddbase'>4 Weeks </td><td class='oddbase' id='editamount4'  width='40%'><%=cf.getCurrencyFormat("$",GenUtil.getHMvalue(amounthm,"4_week","0"),true)%></td><td class='oddbase' id='editlink4'><span style="cursor: pointer; text-decoration: underline" onclick="editprice('4','<%=(String)GenUtil.getHMvalue(amounthm,"4_week","0")%>')">Edit</span></td></tr>
    
        <tr ><td class='evenbase' >5 Weeks </td><td class='evenbase' id='editamount5' width='40%'><%=cf.getCurrencyFormat("$",GenUtil.getHMvalue(amounthm,"5_week","0"),true)%></td><td class='evenbase' id='editlink5'><span style="cursor: pointer; text-decoration: underline" onclick="editprice('5','<%=(String)GenUtil.getHMvalue(amounthm,"5_week","0")%>')">Edit</span></td></tr>
		<tr ><td class='oddbase' >6 Weeks </td><td class='oddbase' id='editamount6'  width='40%'><%=cf.getCurrencyFormat("$",GenUtil.getHMvalue(amounthm,"6_week","0"),true)%></td><td class='oddbase' id='editlink6'><span style="cursor: pointer; text-decoration: underline" onclick="editprice('6','<%=(String)GenUtil.getHMvalue(amounthm,"6_week","0")%>')">Edit</span></td></tr>
		<tr ><td class='evenbase' >7 Weeks </td><td class='evenbase' id='editamount7'  width='40%'><%=cf.getCurrencyFormat("$",GenUtil.getHMvalue(amounthm,"7_week","0"),true)%></td><td class='evenbase' id='editlink7'><span style="cursor: pointer; text-decoration: underline" onclick="editprice('7','<%=(String)GenUtil.getHMvalue(amounthm,"7_week","0")%>')">Edit</span></td></tr>
		<tr ><td class='oddbase'>8 Weeks </td><td class='oddbase' id='editamount8'  width='40%'><%=cf.getCurrencyFormat("$",GenUtil.getHMvalue(amounthm,"8_week","0"),true)%></td><td class='oddbase' id='editlink8'><span style="cursor: pointer; text-decoration: underline" onclick="editprice('8','<%=(String)GenUtil.getHMvalue(amounthm,"8_week","0")%>')">Edit</span></td></tr>
     		<tr><td class='evenbase' colspan='3'><font class='smallestfont'>
		NOTE: Enable listing option by editing price ($1 or more). Listing options
		with $0 price do not appear to end user.
		</font></td></tr>
         
    </table>
    <input type='hidden' name='userid' value='<%=userid%>'>
    </form>
   <% }



%>