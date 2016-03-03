<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.eventsponsors.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.google.checkout.util.Base64Coder" %>
<%@ page import="com.eventbee.creditcard.PaymentTypes"%>


<%


EventRegisterBean jBean= (EventRegisterBean)session.getAttribute("regEventBean");
double taxrate=0;
double grandtotal=jBean.getGrandTotal();
double tax=jBean.getTaxAmount();
String taxpercent=jBean.getTaxPercentage();
if(taxpercent!=null&&!"".equals(taxpercent))
taxrate=Double.parseDouble(taxpercent)*100;
double amount=grandtotal-tax;
String totamount=CurrencyFormat.getCurrencyFormat("",amount+"",true);
double grandAmount=Double.parseDouble(totamount);
String eventid=jBean.getEventId();
String merchant_id="";
String merchant_key="";
String ebee_transactionid=jBean.getTransactionId();
HashMap attrinmap=PaymentTypes.getPaymentTypeInfo(eventid,"Event","google");
String eventname=jBean.getEventName();

jBean.setContextUnitid("13579");

        
String xmldata=EventRegisterManager.writeDatatoXml(jBean);        
        
  %>
  
  <%@ include file="googlexmlcontent.jsp"%>
  <%      

	if(attrinmap!=null){
		merchant_id=(String)attrinmap.get("attrib_1");
		merchant_key=(String)attrinmap.get("attrib_2");
	
	}

%>


<%

StatusObj statobjn=null;
String ebee_tran_id=DbUtil.getVal("select ebee_tran_id from google_payment_data where ebee_tran_id=?", new String []{jBean.getTransactionId()});
if(ebee_tran_id==null)
	statobjn= DbUtil.executeUpdateQuery("insert into google_payment_data (ebee_tran_id,ebee_to_google_xml,ebee_to_google_time,refid,ref_type) values(?,?,now(),?,?)", new String []{jBean.getTransactionId(),(String)request.getAttribute("GOOGLE_XML_DATA"),eventid,"EVENT"});
else
	statobjn= DbUtil.executeUpdateQuery("update google_payment_data set ebee_to_google_xml=?,ebee_to_google_time=now() where ebee_tran_id=?", new String []{(String)request.getAttribute("GOOGLE_XML_DATA"),jBean.getTransactionId()});


%>


<%
	byte[] hmca_sig=null;
	char[] base64_hmca_sig_char=null;
	String base64_hmca_sig_string="";
	String base64_xml_data=null;
	
	String google_form_url=EbeeConstantsF.get("google.form.url","https://sandbox.google.com/checkout/api/checkout/v2/checkout/Merchant");
	
	hmca_sig=Signature.calculateRFC2104HMAC((String)request.getAttribute("GOOGLE_XML_DATA"),merchant_key);
	
	base64_hmca_sig_char=Base64Coder.encode(hmca_sig);
	base64_xml_data=Base64Coder.encode((String)request.getAttribute("GOOGLE_XML_DATA"));
	
	for(int i=0;i<base64_hmca_sig_char.length; i++){
		base64_hmca_sig_string+=base64_hmca_sig_char[i];
	}
	
%>

<form method="POST" name='paytypeform' action="<%=google_form_url%>/<%=merchant_id%>" accept-charset="utf-8">

 	<input type="hidden" name="cart" value="<%=base64_xml_data%>">
    <input type="hidden" name="signature" value="<%=base64_hmca_sig_string%>">
 
</form>