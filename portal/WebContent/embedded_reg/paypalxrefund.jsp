<%@page import="com.eventbee.general.*"%>
<%@page import="java.util.*"%>
<%@ page import="com.paypal.svcs.types.ap.*,com.paypal.svcs.services.*,src.paypalsamples.utils.*"%>
<%! 
public static final HashMap<String,String> refunstatusMap=new HashMap<String, String>();
static{
	refunstatusMap.put("REFUNDED","Success");
	refunstatusMap.put("REFUNDED_PENDING","Refund awaiting transfer of funds");
	refunstatusMap.put("NOT_PAID","Payment was never made; therefore, it cannot be refunded");
	refunstatusMap.put("ALREADY_REVERSED_OR_REFUNDED","Request rejected because the refund was already made, or the payment was reversed prior to this request");
	refunstatusMap.put("NO_API_ACCESS_TO_RECEIVER","Request cannot be completed because you do not have third-party access from the receiver to make the refund");
	refunstatusMap.put("REFUND_NOT_ALLOWED","Refund is not allowed");
	refunstatusMap.put("INSUFFICIENT_BALANCE","Request rejected because the receiver from which the refund is to be paid does not have sufficient funds or the funding source cannot be used to make a refund");
	refunstatusMap.put("AMOUNT_EXCEEDS_REFUNDABLE","Request rejected because you attempted to refund more than the remaining amount of the payment; call the PaymentDetails API operation to determine the amount already refunded");
	refunstatusMap.put("PREVIOUS_REFUND_PENDING","Request rejected because a refund is currently pending for this part of the payment");
	refunstatusMap.put("NOT_PROCESSED","Request rejected because it cannot be processed at this time");
	refunstatusMap.put("REFUND_ERROR","Request rejected because of an internal error");
	refunstatusMap.put("PREVIOUS_REFUND_ERROR","Request rejected because another part of this refund caused an internal error");
}

public StringBuffer processPaypalxRefund(HashMap<String,String> data){
	System.out.println("data::::::::: "+data);
	String ebee_paypal_mailid=EbeeConstantsF.get("eventbee.paypalx.account.email","satya_1320824537_biz@gmail.com");
	String currency=data.get("currency");
	String status="Fail";
	String tranid="";
	StringBuffer sbf=new StringBuffer();
	if(currency==null || "".equals(currency))currency="USD";
	System.out.println("currency: "+currency);
	try {
		double ebeefee= Double.parseDouble(data.get("ebeefee"));
		String paypalfeepayer="EACHRECEIVER";
		ReceiverList list = new ReceiverList();
		Receiver rec1 = new Receiver();
		rec1.setAmount(new java.math.BigDecimal(data.get("amount")));
		rec1.setEmail(data.get("email"));
		if("Full".equals(data.get("refundtype")) && ebeefee>0){
			rec1.setPrimary(new Boolean(true));
		}else 
			rec1.setPrimary(new Boolean(false));

		list.getReceiver().add(rec1);
		if("Full".equals(data.get("refundtype")) && ebeefee>0){
			System.out.println("chained");
			paypalfeepayer="PRIMARYRECEIVER";
			Receiver rec2 = new Receiver();
			rec2.setAmount(new java.math.BigDecimal(data.get("ebeefee")));
			System.out.println("ebee_paypal_mailid: "+ebee_paypal_mailid);
	        rec2.setEmail(ebee_paypal_mailid);
	        rec2.setPrimary(new Boolean(false));
	        list.getReceiver().add(rec2);
		}
		RefundRequest refreq=new RefundRequest();
		refreq.setCurrencyCode(currency);
	    refreq.setReceiverList(list);
	    //if("paypalx_chained".equalsIgnoreCase(data.get("paypal_payment_option")) && "Full".equals(data.get("refundtype"))){
	    	refreq.setPayKey(data.get("paykey"));
			tranid=(String)data.get("paykey");
		//}
	    /*else{
	    	refreq.setTransactionId(data.get("transactionId"));
			tranid=(String)data.get("transactionId");
		}*/
	    
	    refreq.setRequestEnvelope(ClientInfoUtil.getMyAppRequestEnvelope());

	    adaptivepayments.AdaptivePayments ap = new adaptivepayments.AdaptivePayments();
	    System.out.println("ap declared:");
	    RefundResponse refundresp=ap.refund(refreq);
	    System.out.println("corelationid:: "+refundresp.getResponseEnvelope().getCorrelationId());
	    //status=""+refundresp.getResponseEnvelope().getAck();
	    System.out.println("API Base ENDPOINT after pay: "+common.com.paypal.platform.sdk.CallerServices.getClientprops().getProperty("API_BASE_ENDPOINT"));
	    
	    RefundInfoList refundInfolist=refundresp.getRefundInfoList();
	    List<RefundInfo> infolist = refundInfolist.getRefundInfo();
	    //for(int i=0;i<infolist.size();i++){
	    	RefundInfo refundinfo = infolist.get(0);
	    	status=refunstatusMap.get(refundinfo.getRefundStatus());
			String refund_tid=refundinfo.getEncryptedRefundTransactionId();
			System.out.println("TransactionID: "+tranid+" getRefundStatus: "+refundinfo.getRefundStatus());
	    	System.out.println("TransactionID: "+tranid+" getReceiver: "+refundinfo.getReceiver().getEmail());
	    	System.out.println("TransactionID: "+tranid+" getRefundFeeAmount: "+refundinfo.getRefundFeeAmount());
	    	System.out.println("TransactionID: "+tranid+" getRefundNetAmount: "+refundinfo.getRefundNetAmount());
	    	System.out.println("TransactionID: "+tranid+" getRefundNetAmount: "+refundinfo.getRefundNetAmount());
	    	System.out.println("TransactionID: "+tranid+" isRefundHasBecomeFull: "+refundinfo.isRefundHasBecomeFull());
	    //}

		sbf.append("<Response>\n");
		 if("Success".equalsIgnoreCase(status)){
	    	 sbf.append("<Status>Success</Status>\n<TransactionID>"+tranid+"</TransactionID>");
	     }else{
	    	 sbf.append("<Status>Fail</Status>\n<TransactionID>"+tranid+"</TransactionID>\n<ErrorMsg>"+status+"</ErrorMsg>");
	     }
		 sbf.append("</Response>");
		 String insertquery="insert into refund_track(eventid,tid,amount,payment_type,response,refunded_at,reference_id,status) values(?,?,?,?,?,now(),?,?)";
		 StatusObj sb=DbUtil.executeUpdateQuery(insertquery,new String[]{(String)data.get("eid"),(String)data.get("tid"),(String)data.get("amount"),(String)data.get("payment_type"),sbf.toString(),refund_tid,status});
	}catch(Exception e){
		System.out.println("Exception while processing refund in paypalxrefund.jsp::"+e.getMessage());
}
return sbf;
}
%>
<%
	System.out.println("In paypalxrefund.jsp");

	String tid=request.getParameter("tid");

	String eid=request.getParameter("eid");
	String payment_type=request.getParameter("payment_type");
	String transactionId=request.getParameter("transactionId");
	String paykey=request.getParameter("paykey");
	String email=request.getParameter("email");
	String paypal_payment_option=request.getParameter("paypal_payment_option");
	String ebeefee=request.getParameter("ebeefee");
	String currency=request.getParameter("currency");
	String amount=request.getParameter("amount");
	String refundtype=request.getParameter("refundtype");
		HashMap data = new HashMap();
		data.put("amount",amount);
		data.put("ebeefee",ebeefee);
		data.put("paypal_payment_option",paypal_payment_option);  
		data.put("email",email);
		data.put("paykey",paykey);
		data.put("transactionId",transactionId);
		data.put("currency",currency);
		data.put("refundtype",refundtype);
		data.put("eid",eid);
		data.put("tid",tid);
		data.put("payment_type",payment_type);
		StringBuffer message=processPaypalxRefund(data);
		/*String insertquery="insert into refund_track(eventid,tid,amount,payment_type,response,created_at) values(?,?,?,?,?,now())";
		StatusObj sb=DbUtil.executeUpdateQuery(insertquery,new String[]{eid,tid,amount,payment_type,message.toString()});*/
		out.println(message);
%>
