<%@ page import="com.eventbee.general.*,org.json.JSONObject,adaptivepayments.AdaptivePayments,com.eventregister.RegistrationTiketingManager"%>
<%@ page import="common.com.paypal.platform.sdk.utils.*"%>
<%@ page import="com.paypal.svcs.types.ap.*"%>
<%@ page import="common.com.paypal.platform.sdk.exceptions.*"%>
<%@ page import="com.paypal.svcs.types.common.*"%>
<%@ page import="common.com.paypal.platform.sdk.utils.*"%>
<%@ page import="com.paypal.svcs.services.*"%>
<%@ page import="java.util.*"%>

 
 <%
 JSONObject obj=new JSONObject();
    String status=null;
	String tid=request.getParameter("tid");
try {
    String payKey=DbUtil.getVal("select paykey from paypal_payment_data where ebee_tran_id=?",new String[]{tid});
	String tracking_id=DbUtil.getVal("select tracking_id from paypal_payment_data where ebee_tran_id=?",new String[]{tid});
	PaymentDetailsRequest paydetailReq = new PaymentDetailsRequest();
	RequestEnvelope en = new RequestEnvelope();
	en.setErrorLanguage("en_US");
	if(tracking_id==null && payKey!=null)
		paydetailReq.setPayKey(payKey);
	else if(tracking_id!=null)
		paydetailReq.setTrackingId(tracking_id);
	else 
		{String trnid=DbUtil.getVal("select paypal_tran_id   from paypal_payment_backup_data where ebee_tran_id=?",new String[]{tid});
		paydetailReq.setTransactionId(trnid);
		}
	
	paydetailReq.setRequestEnvelope(en);
	AdaptivePayments ap = new AdaptivePayments();
	PaymentDetailsResponse paydetailsResp =	 ap.paymentDetails(paydetailReq);	
	ConvertCurrencyRequest concovreq=new ConvertCurrencyRequest();
	CurrencyList cl=new CurrencyList();
	List ls=cl.getCurrency();
	System.out.println("ls size: "+ls.size());
	status=paydetailsResp.getStatus();
	out.println("Status: <b>"+status+"</b>");
	out.println("<br>");
	out.println("Currency Code: "+paydetailsResp.getCurrencyCode());
	out.println("<br>");
	out.println("FeesPayer: "+paydetailsResp.getFeesPayer());
	out.println("<br>");
	out.println("Sender Email: "+paydetailsResp.getSenderEmail());
	out.println("<br>");
	out.println("Tracking Id: "+paydetailsResp.getTrackingId());	
	out.println("<br>");
	out.println("isReverseAllParallelPaymentsOnError: "+paydetailsResp.isReverseAllParallelPaymentsOnError());
	out.println("<br>");	
	PaymentInfoList payinfolist=paydetailsResp.getPaymentInfoList();
	ArrayList<PaymentInfo> paylist=(ArrayList<PaymentInfo>) payinfolist.getPaymentInfo();
	for(int i=0;i<paylist.size();i++){
					out.println("<b>Payment Info "+i+"</b>");
					out.println("<br>");
					out.println("transactionId: "+paylist.get(i).getTransactionId());
						out.println("<br>");
					out.println("transaction status: "+paylist.get(i).getTransactionStatus());
						out.println("<br>");
					out.println("Refunded Amount: "+paylist.get(i).getRefundedAmount());
						out.println("<br>");
					out.println("Pending Refund: "+paylist.get(i).isPendingRefund());
						out.println("<br>");
					out.println("Sender Transaction ID: "+paylist.get(i).getSenderTransactionId());
						out.println("<br>");
					out.println("Sender Transaction Status: "+paylist.get(i).getSenderTransactionStatus());
						out.println("<br>");
					out.println("Pending Reason: "+paylist.get(i).getPendingReason());
						out.println("<br>");
					Receiver receiver=paylist.get(i).getReceiver();
					out.println("Receiver amount: "+receiver.getAmount());
						out.println("<br>");
					out.println("Receiver email: "+receiver.getEmail());
						out.println("<br>");
					out.println("Receiver phone: "+receiver.getPhone());
						out.println("<br>");
					out.println("Receiver invoiceId: "+receiver.getInvoiceId());
						out.println("<br>");
					out.println("Receiver paymenttype: "+receiver.getPaymentType());
						out.println("<br>");
		}
	
}
	catch (PPFaultMessage e) {
	out.println("in PPFaultMessage: "+e);
	session.setAttribute("exception", e);
	} catch (Exception e) {
	out.println("in Exception: "+e);
	session.setAttribute("exception", e);
	}
	
	

%>