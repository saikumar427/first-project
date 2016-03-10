<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.creditcard.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.general.EbeeConstantsF" %>
<%@ page import="com.eventbee.general.DbUtil" %>
<%@ include file='/xfhelpers/xffunc.jsp' %>
<%@ include file='creditcardcountries.jsp' %>
<%@ include file='/globalprops.jsp' %>
<%
String eventid=request.getParameter("GROUPID");
%>
<%!
	String YEARS[]=new String[]{"2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027"};
%>
<%
	String vendorqry="select attrib_5 from payment_types where refid=? and  paytype='eventbee' limit 1";			
	String vendor=DbUtil.getVal(vendorqry,new String[]{eventid});
	
	if(vendor==null || "".equals(vendor)) vendor="paypal_pro";
String currencyformat1=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code in (select currency_code from event_currency where eventid=?)",new String[]{eventid});
if(currencyformat1==null)
currencyformat1="$";
	
	if(request.getAttribute("ccm")!=null){
	CreditCardModel ccm=(CreditCardModel)request.getAttribute("ccm");
	String grandtotal=ccm.getGrandtotal();
			CurrencyFormat cf=new CurrencyFormat();
			grandtotal=cf.getCurrency2decimal(grandtotal);
			grandtotal=currencyformat1+grandtotal;
			try{
			if("paypal_pro".equals(vendor) && Double.parseDouble(ccm.getGrandtotal())>9000){vendor="braintree_eventbee";}
			}catch(Exception e){}
			System.out.println("vendorvendor:vendor::"+vendor);
%>
<script>
var selectbox='',textbox='';
function changeCountry(obj){
var vend='<%=vendor%>';
		if (vend != '' && vend == 'authorize.net') {
			changeStates();
			if ((obj.value == 'US' || obj.value == 'CA'))
				document.getElementById('st_prv').style.display = '';
			else
				document.getElementById('st_prv').style.display = 'none';
		}

		if (vend != '' && vend == 'paypal_pro') {
			if (selectbox=='' )
				selectbox = document.getElementById('st_prv').innerHTML;
			//changeStates();
			if ((obj.value == 'US' || obj.value == 'CA')) {
				document.getElementById('st_prv').style.display = '';
				document.getElementById('st_prv').innerHTML=selectbox;				
				changeStates();
			} else 
				document.getElementById('st_prv').innerHTML = '<td>State/Province *</td><td><input type="text" name="state" size="10" ></td>';
			
		}

	}
</script>

<input type='hidden' name='vendor_pay' id='vendor_pay' value='<%=vendor%>'>
  <table width='100%' cellpading='0' cellspacing='0' ><tr><td>Amount: <%=grandtotal%>
  <%if(!"authorize.net".equals(vendor)&& !"braintree_manager".equals(vendor) && !"stripe".equals(vendor)){%>
	<br/><span class='small'><%=getPropValue("ccs.note",eventid) %></span><%}%></td></tr>
 </table>
  <table width='100%' valign='top' cellpadding="0" cellspacing="0">
  <tr><td valign='top'>   
		   <table valign='top' cellpadding="0" cellspacing="0">
		    <tr>
		    <%
		    String[] cardtypes=null;
		    String[] carddisplaytypes=null;
		    if("braintree_manager".equals(vendor) && "AU$".equals(currencyformat1)){
		    	cardtypes=new String[]{"","Visa","Mastercard","Discover"};
		    	carddisplaytypes=new String[]{"-- Select Card Type --","Visa","Mastercard","Discover"};

		    }else{
		    	cardtypes=EventbeeStrings.cardtypes;
		    	carddisplaytypes=EventbeeStrings.carddisplaytypes;	
		    }
		    %>
		    <td height='30' class="bigfont" ><%=getPropValue("ccs.card.type",eventid) %> *</td><td height='25'><%=getXfSelectOneCombo("cardtype",cardtypes,carddisplaytypes, ccm.getCardtype() )%></td> 
			</tr>	
			<tr>
			<td height='30' class="bigfont" ><%=getPropValue("ccs.card.nmbr",eventid) %> *</td>
		        <td height='30'><%=getXfTextBox("cardnumber",GenUtil.getEncodedXML(ccm.getCardnumber() ),"25")%></td>
		    </tr>
		    <tr>
		    <td height='30' class="bigfont"><%=getPropValue("ccs.cvv.nmbr",eventid)%> *&nbsp;<img id='cvv' src='/main/images/questionMark.gif'onMouseOver="showimg();" onMouseout="hideimg();"><div id='cvvimg'><img width="250px" border="0" src="/home/images/cvv.jpg"></div></td>
		        <td height='30'><%=getXfTextBox("cvvcode",GenUtil.getEncodedXML(ccm.getCvvcode() ),"25")%></td>
		    </tr>
		    <tr>
		       <td height='30' class="bigfont" ><%=getPropValue("ccs.exp",eventid)%> *&nbsp;</td>
		       <td height='30'><%=getXfSelectOneCombo("expmonth",EventbeeStrings.monthvals,EventbeeStrings.months, GenUtil.getEncodedXML(ccm.getExpmonth()))%>&nbsp;<%=getXfSelectOneCombo("expyear",YEARS,YEARS, GenUtil.getEncodedXML(ccm.getExpyear()))%></td>
		    </tr>
		    </table>
    </td>
    <td align="left" valign="top" >
        <table align="left">
         <tr>
         <td><img src="/main/images/amex.png" border="0" width="40px"> <img src="/main/images/mastercard.png" border="0" width="40px" > <img src="/main/images/discover.png" border="0" width="40px" > <img src="/main/images/visa.png" border="0" width="40px" ></td></tr>
       <tr>
    <td height='15px'>
    </td>
     </tr>
        <tr>
    <td>
<span id="siteseal"><script type="text/javascript"
src="https://seal.godaddy.com/getSeal?sealID=NVWu6PFkDsxAjkyLnVuI60pWgpqh4SRo3mlfoHSPjcEHprez8Nf5vp"></script></span>
    </td>
     </tr>
        </table>
    </td>
    </tr>
 </table>
  <table cellpadding="0" cellspacing="0">
    <tr>
    <td height='30' class="bigfont"><b><%=getPropValue("ccs.cc.address",eventid)%></b></td>
    </tr>
  </table>
  <table width="100%"  cellspacing="0" align="left">
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" align="left" >
			    <tr>
			        <td height='30'class="bigfont"><%=getPropValue("ccs.card.holder",eventid)%> *</td>
			        <td height='30' >
						<table  cellpadding="0"  cellspacing="0" align="left">
							<tr>
								<td colspan="2">
								<table cellpadding="0" cellspacing="0"><tr>
								<td style="padding-bottom:5px;">
						            <font class="smallestfont"><%=getPropValue("ccs.fname",eventid)%></font><br><input type="text" name="firstName" id="fname" size="25" placeholder="First Name" value=<%=ccm.getProfiledata().getFirstName()%> >
								</td>
								<td height='30' style='padding-left:3px;padding-bottom:5px;' >
								<font class="smallestfont"><%=getPropValue("ccs.lname",eventid)%></font><br/>
									<input type="text" name="lastName" id="lname" size="25"  placeholder="Last Name" value=<%=ccm.getProfiledata().getLastName()%> >
								</td></tr>
								</table>
								</td>
			                </tr>
			            </table>
			        </td>
		        </tr>

				<% if (vendor != null && "payulatam".equals(vendor)) { %>
					<input type="hidden" name="email" id="email" size="25" placeholder="Email" value=<%=ccm.getProfiledata().getEmail()%> />
				<%}%>


				<%if(vendor!=null &&  ("authorize.net".equals(vendor) || vendor.contains("braintree") || "stripe".equals(vendor) || "payulatam".equals(vendor))){%>				
				<tr><%if(!"authorize.net".equals(vendor)){ %>
				  <input type='hidden' name='state' id='state' value='default'>
				  <input type='hidden' name='non_us_state' id='non_us_state' value='default'>
				  <%}%>
				  	<td height='30' class="bigfont"><%=getPropValue("ccs.country",eventid)%> *</td> 
					<td height='30'><%=getXfSelectListBox("country",BrainCountryNames,BrainCountryCodes,""," onChange='changeCountry(this)'")%></td>
				</tr>
				<%}else{%>				
				<tr>
					<%--  <td height='30' class="bigfont">Country *</td> 
					<td height='30'><%=getXfSelectListBox("country",CountryNames,CountryCodes,GenUtil.getEncodedXML(ccm.getProfiledata().getCountry() )," onChange='changeStates();'")%></td>  --%>
					
					 <td height='30' class="bigfont"><%=getPropValue("ccs.country",eventid)%> *</td> 
					<td height='30'><%=getXfSelectListBox("country",BrainCountryNames,BrainCountryCodes,""," onChange='changeCountry(this)'")%></td> 
					
				</tr>
				<%}%>
				<tr>
					<td height='30' class="bigfont"><%=getPropValue("ccs.street",eventid)%> *</td>
				    <td height='30'  > <%=getXfTextBox("street1",GenUtil.getEncodedXML(ccm.getProfiledata().getStreet1() ),"35")%></td>
				</tr>
				<tr>
					<td height='30' class="bigfont"><%=getPropValue("ccs.apt",eventid)%> </td>
				    <td height='30'  > <%=getXfTextBox("street2",GenUtil.getEncodedXML(ccm.getProfiledata().getStreet2() ),"35")%></td>
				</tr>
				<tr>
					<td height='30' class="bigfont"><%=getPropValue("ccs.city",eventid)%> *</td> 
					<td height='30'><%=getXfTextBox("city",GenUtil.getEncodedXML(ccm.getProfiledata().getCity() ),"25")%></td>
				</tr>
			  <%if(vendor !=null &&   (vendor.contains("braintree") || "stripe".equals(vendor) || "payulatam".equals(vendor))){}else{%>	
				<tr id='st_prv'>
					<td height='30' class="bigfont"><%=getPropValue("ccs.state",eventid)%> *</td> 
					<td height='30'><%=getXfSelectListBox("state",EventbeeStrings.getUSStateCodes(),EventbeeStrings.getUSStateNames(),  GenUtil.getEncodedXML(ccm.getProfiledata().getState()))%>
					<div id='sstate' style='display:none'><%=getXfTextBox("non_us_state",GenUtil.getEncodedXML(ccm.getProfiledata().getState() ),"25")%></div>
					</td>
				</tr>
				<%}%>
				<tr>
					<td height='30' class="bigfont"  ><%=getPropValue("ccs.zip",eventid)%> *</td> 
                    <td height='30'><%=getXfTextBox("zip",GenUtil.getEncodedXML(ccm.getProfiledata().getZip() ),"10")%></td>
                </tr>
			</table> 
		</td>
	</tr>
 </table> 
<%}%>
<script>
document.getElementsByName('country')[0].selectedIndex=0;
</script>

