<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*,com.eventregister.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.creditcard.PaymentTypes"%>
<%@include file="precheck.jsp"%>
<%
com.eventregister.PaymentDataDetails paydetails=new com.eventregister.PaymentDataDetails();
double grandtotal=0;
String eventid=request.getParameter("eid");
String ebee_transactionid=newTrnId;
HashMap amounts=paydetails.getAmounts(ebee_transactionid);
try{
grandtotal=Double.parseDouble((String)amounts.get("grandtotal"));
}
catch(Exception e){
grandtotal=0;
}
HashMap attrinmap=PaymentTypes.getPaymentTypeInfo(eventid,"Event","google");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=to_number(?,'99999999999999999999')",new String[]{eventid});
%>
<%@ include file="googlexmlcontent.jsp"%>
<%      
paydetails.updateGooglePaymentData(ebee_transactionid,eventid,attrinmap);
HashMap googleDataMap=paydetails.googlerquestData(attrinmap,(String)request.getAttribute("GOOGLE_XML_DATA"));
%>
<body>
<form method="POST" name='googleform' id='googleform'  action="<%=GenUtil.getHMvalue(googleDataMap,"google_form_url","0")%>/<%=GenUtil.getHMvalue(attrinmap,"attrib_1","0")%>" accept-charset="utf-8">

<input type="hidden" name="cart" value="<%=GenUtil.getHMvalue(googleDataMap,"base64_xml_data","0")%>">
<input type="hidden" name="signature" value="<%=GenUtil.getHMvalue(googleDataMap,"base64_hmca_sig_string","0")%>">

</form>
<script>
document.getElementById('googleform').submit();	
</script>
</body>