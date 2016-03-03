<%@page import="com.payu.sdk.model.TransactionResponse"%>
<%@page import="com.payu.sdk.PayUPayments"%>
<%@page import="com.payu.sdk.PayU"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%!
   public HashMap<String,String> refundPayuPayment(String tid,String amount,String eid,String payment_type){
	HashMap<String,String> resultMap=new HashMap<String,String>();
	HashMap<String,String> mapApiKey=new HashMap<String,String>();
	String api_key=null;
	String api_login=null;
	String transactionId=null;
	String orderId=null;
	String lang="";
	lang=language(eid);
	mapApiKey=getManagerAPIKey(eid,tid);
	api_key=mapApiKey.get("api_key");
	api_login=mapApiKey.get("api_login");
	transactionId=mapApiKey.get("transactionId");
	orderId=mapApiKey.get("orderId");
	Map<String, String> parameters = new HashMap<String, String>();
	parameters.put("language",lang);
	parameters.put("command","SUBMIT_TRANSACTION");
	parameters.put("type","REFUND");
	parameters.put(PayU.PARAMETERS.API_KEY,api_key);
	parameters.put(PayU.PARAMETERS.API_LOGIN,api_login);
	parameters.put(PayU.PARAMETERS.ORDER_ID,orderId);
	parameters.put(PayU.PARAMETERS.REASON,"");
	parameters.put(PayU.PARAMETERS.TRANSACTION_ID,transactionId);
	parameters.put(PayU.PARAMETERS.VALUE, "12");
	PayU.isTest = true; 
	PayU.apiKey="676k86ks53la6tni6clgd30jf6";
	PayU.apiLogin = "403ba744e9827f3";
	PayU.paymentsUrl = "https://stg.api.payulatam.com/payments-api/";
	PayU.reportsUrl = "https://stg.api.payulatam.com/reports-api/";
	
	try{
	TransactionResponse response = PayUPayments.doRefund(parameters);
	System.out.println("OrderId: "+response.getOrderId());
	System.out.println("State: "+response.getState());
	System.out.println("PendingReason: "+response.getPendingReason());
	System.out.println("ResponseMessage: "+response.getResponseMessage());
	if (response != null){
	    response.getOrderId();
	    response.getState();
	    response.getPendingReason();
	    response.getResponseMessage();
	}
	}
	catch(Exception e){
		System.out.println("Exception while refund payulatam: "+e);
	}
	System.out.println("resultMap : "+resultMap);
    return resultMap;
}
HashMap<String,String> getManagerAPIKey(String eid,String tid){
	String query="select mgr_api_details,data_response  from payulatam_payment_data where refid=? and tid=? and status='Success'";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query,new String[]{eid,tid});
	HashMap<String,String> apiMap=null;
	if(sb.getStatus()){
		apiMap=new HashMap<String,String>();
		String accoutDetails =  db.getValue(0,"mgr_api_details","");
		String response = db.getValue(0, "data_response", "");
		try{
			JSONObject details = new JSONObject(accoutDetails);
			JSONObject data = new JSONObject(response);
			apiMap.put("api_key",details.getString("api_key"));
			apiMap.put("api_login",details.getString("api_login"));
			apiMap.put("orderId",data.getString("orderId"));
			apiMap.put("transactionId",data.getString("transactionId"));
		}catch(Exception e){
			System.out.println("Exception "+e);
		}
	}
	return apiMap;
}
public String language(String eid){
	String language = null;
	String[] parts = null;
		language = DbUtil.getVal("select value from config where config_id= (select config_id from eventinfo where eventid=?::bigint) and name='event.i18n.lang';", new String[]{eid});
		parts = language.split("_");
	return  parts[0];
}
%>
<%
  String tid=request.getParameter("tid");
  System.out.println("In payurefund.jsp tid: "+tid);
  String amount=request.getParameter("amount");
  String eid=request.getParameter("eid");
  String payment_type=request.getParameter("payment_type");
  HashMap<String,String> resultMap=new HashMap<String,String>();
  resultMap=refundPayuPayment(tid,amount,eid,payment_type); 
  
  System.out.println("failuremessage is:"+resultMap.get("failuremessage")+" tid :: "+tid+" eid :: "+eid+" amount :: "+amount);
  if(!"".equals(resultMap.get("id")) && resultMap.get("id")!=null && resultMap.get("failuremessage")==null){
	  resultMap.put("status","Success");
  }else{
	 resultMap.put("status","failure");
  }
  StringBuffer sbf=new StringBuffer();
  sbf.append("<Response>\n");
  if("Success".equals(resultMap.get("status")))
	  sbf.append("<Status>Success</Status>\n<TransactionID>"+tid+"</TransactionID>\n<internalrefid>"+resultMap.get("chargeId")+"</internalrefid>\n");
  else
	  sbf.append("<Status>Fail</Status>\n<TransactionID>"+tid+"</TransactionID>\n<ErrorMsg>"+resultMap.get("failuremessage")+"</ErrorMsg>\n"); 
  sbf.append("</Response>");
  System.out.println("response is: "+sbf.toString());
 // String insertquery="insert into refund_track(eventid,tid,amount,payment_type,response,refunded_at,reference_id,status) values(?,?,?,?,?,now(),?,?)";
//	StatusObj sb=DbUtil.executeUpdateQuery(insertquery,new String[]{eid,tid,amount,payment_type,resultMap.get("responsejson"),resultMap.get("chargeId"),resultMap.get("status")});


out.println(sbf.toString());
%>
