<%@page import="com.payu.sdk.model.PaymentMethodApi"%>
<%@page import="com.eventbee.general.DateUtil"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@page import="com.eventbee.general.EncodeNum"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="javax.swing.JScrollBar"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="com.eventbee.general.formatting.CurrencyFormat"%>
<%@page import="com.eventbee.creditcard.CreditCardModel"%>
<%@page import="com.payu.sdk.PayUPayments"%>
<%@page import="com.payu.sdk.model.TransactionResponse"%>
<%@page import="com.payu.sdk.model.PaymentCountry"%>
<%@page import="com.payu.sdk.model.Currency"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.payu.sdk.PayU"%>

<%!

String env=EbeeConstantsF.get("BRAINTREE_ENVIRONMENT","SANDBOX");

String paymentsUrl=EbeeConstantsF.get("payulatam.payments.url","https://stg.api.payulatam.com/payments-api/");
String reportsUrl = EbeeConstantsF.get("payulatam.reports.url","https://stg.api.payulatam.com/reports-api/");
String apiKey= EbeeConstantsF.get("payulatam.ebee.apikey","676k86ks53la6tni6clgd30jf6"); // eventbee API key
String apiLogin = EbeeConstantsF.get("payulatam.ebee.apilogin","403ba744e9827f3"); // eventbee API login

HashMap<String,String> responseCodeMessageMap=new HashMap<String,String>(){{
	put("ERROR","There was a general error.");
	//put("APPROVED","The transaction was approved.");
	put("ANTIFRAUD_REJECTED","The transaction was rejected by the anti-fraud system.");
	put("PAYMENT_NETWORK_REJECTED","The financial network rejected the transaction.");
	put("ENTITY_DECLINED","The transaction was declined by the bank or financial network because of an error.");
	put("INTERNAL_PAYMENT_PROVIDER_ERROR","An error occurred in the system trying to process the payment.");
	put("INACTIVE_PAYMENT_PROVIDER","The payment provider was not active.");
	put("DIGITAL_CERTIFICATE_NOT_FOUND","The financial network reported an authentication error.");
	put("INVALID_EXPIRATION_DATE_OR_SECURITY_CODE","The security code or expiration date was invalid.");
	put("INVALID_RESPONSE_PARTIAL_APPROVAL","Invalid response type. The entity response is a partial approval and should be automatically canceled by the system.");
	put("INSUFFICIENT_FUNDS","The account had insufficient funds.");
	put("CREDIT_CARD_NOT_AUTHORIZED_FOR_INTERNET_TRANSACTIONS","The credit card was not authorized for internet transactions.");
	put("INVALID_TRANSACTION","The financial network reported that the transaction was invalid.");
	put("INVALID_CARD","The card is invalid.");
	put("EXPIRED_CARD","The card has expired.");
	put("RESTRICTED_CARD","The card has a restriction.");
	put("CONTACT_THE_ENTITY","You should contact the bank.");
	put("REPEAT_TRANSACTION","You must repeat the transaction.");
	put("ENTITY_MESSAGING_ERROR","The financial network reported a communication error with the bank.");
	put("BANK_UNREACHABLE","The bank was not available.");
	put("EXCEEDED_AMOUNT","The transaction exceeds the amount set by the bank.");
	put("NOT_ACCEPTED_TRANSACTION","The transaction was not accepted by the bank for some reason.");
	put("ERROR_CONVERTING_TRANSACTION_AMOUNTS","An error occurred converting the amounts to the payment currency.");
	put("EXPIRED_TRANSACTION","The transaction expired.");
	put("PENDING_TRANSACTION_REVIEW","The transaction was stopped and must be revised, this can occur because of security filters.");
	put("PENDING_TRANSACTION_CONFIRMATION","The transaction is subject to confirmation.");
	put("PENDING_TRANSACTION_TRANSMISSION","The transaction is subject to be transmitted to the financial network. This usually applies to transactions with cash payment means.");
	put("PAYMENT_NETWORK_BAD_RESPONSE","The message returned by the financial network is inconsistent.");
	put("PAYMENT_NETWORK_NO_CONNECTION","Could not connect to the financial network.");
	put("PAYMENT_NETWORK_NO_RESPONSE","Financial Network did not respond.");
}};
HashMap<String,String> resultFailureMessageMap=new HashMap<String,String>(){{
	put("INVALID_EXPIRATION_DATE_OR_SECURITY_CODE","The security code or expiration date was invalid.");
	put("INSUFFICIENT_FUNDS","The account had insufficient funds.");
	put("CREDIT_CARD_NOT_AUTHORIZED_FOR_INTERNET_TRANSACTIONS","The credit card was not authorized for internet transactions.");
	put("INVALID_CARD","The card is invalid.");
	put("EXPIRED_CARD","The card has expired.");
	put("EXCEEDED_AMOUNT","The transaction exceeds the amount set by the bank.");
}};
public class PayULatamPayProcess{
	public HashMap<String,String> processPayuPayment(CreditCardModel ccm,HttpServletRequest request,String token){
		String payuresponse="";
		HashMap<String,String> resultMap=new HashMap<String,String>();
		HashMap<String,String> responseMap=new HashMap<String,String>();
		String fname="", lname="", name=null, address1=null, address2=null, city=null, state=null, country=null, zipcode=null, cardExpYear = null, cardExpMonth=null,email =null,cardnumber=null,cvvcode=null,cardtype=null;
		try{
			 if(!"".equals(ccm.getCardnumber()))cardnumber=ccm.getCardnumber()+"";
			 if(!"".equals(ccm.getCvvcode()))cvvcode=ccm.getCvvcode()+"";
			 if(!"".equals(ccm.getExpmonth()))cardExpMonth=ccm.getExpmonth()+"";
			 if(!"".equals(ccm.getExpyear()))cardExpYear=ccm.getExpyear()+"";
			 if(!"".equals(ccm.getCardtype()))cardtype=ccm.getCardtype()+"";
			if(!"".equals(ccm.getProfiledata().getFirstName()))fname=ccm.getProfiledata().getFirstName()+"";
			if(!"".equals(ccm.getProfiledata().getLastName()))lname=ccm.getProfiledata().getLastName()+"";
			name=fname+" "+lname;
			if(!"".equals(ccm.getProfiledata().getStreet1()))address1=ccm.getProfiledata().getStreet1()+"";
			if(!"".equals(ccm.getProfiledata().getStreet2()))address2=ccm.getProfiledata().getStreet2()+"";
			if(!"".equals(ccm.getProfiledata().getCity()))city=ccm.getProfiledata().getCity()+"";
			//if(!"".equals(ccm.getProfiledata().getState()))state=ccm.getProfiledata().getState()+"";
			state="";
			if(!"".equals(ccm.getProfiledata().getCountry()))country=ccm.getProfiledata().getCountry()+"";
			if(!"".equals(ccm.getProfiledata().getZip()))zipcode=ccm.getProfiledata().getZip()+"";
			if(!"".equals(ccm.getProfiledata().getEmail()))email=ccm.getProfiledata().getEmail()+"";
			String currencyCode = null;
			String buyerId = null;
			
			//String env=EbeeConstantsF.get("BRAINTREE_ENVIRONMENT","SANDBOX");
			
			PayU.paymentsUrl = paymentsUrl;
			PayU.reportsUrl = reportsUrl;
			PayU.apiKey = apiKey;
			PayU.apiLogin = apiLogin;
			
			if("SANDBOX".equalsIgnoreCase(env)) //in live it should be false.
				PayU.isTest = true; 
			else 
				PayU.isTest = false;  
			
			if(!"".equals(ccm.getCurrencyCode()))currencyCode=ccm.getCurrencyCode()+"";
			String cc_exp=cardExpYear+"/"+cardExpMonth;
			
			String eid=request.getParameter("eid");
			String reference =request.getParameter("tid"); // Eventbee transaction ID
			String value=CurrencyFormat.getCurrencyFormat("",Double.parseDouble(ccm.getGrandtotal())+"",false);	 
			Map<String, String> parameters = new HashMap<String, String>();
			
			HashMap<String,String> apiDetails=getAPIDetails(eid) ;
			parameters.put(PayU.PARAMETERS.API_KEY, apiDetails.get("api_key")); //manager api key
			parameters.put(PayU.PARAMETERS.API_LOGIN,apiDetails.get("api_login")); //manager api login
			parameters.put(PayU.PARAMETERS.ACCOUNT_ID, apiDetails.get("account_id")); //manager account id
			parameters.put(PayU.PARAMETERS.MARCHANT_ID, apiDetails.get("marchant_id")); //manager marchent id
			parameters.put(PayU.PARAMETERS.REFERENCE_CODE, ""+reference); //tid
			parameters.put(PayU.PARAMETERS.DESCRIPTION, "Charge for Eventbee Transaction");
			
			String language = DbUtil.getVal("select value from config where config_id= (select config_id from eventinfo where eventid=?::bigint) and name='event.i18n.lang';", new String[]{eid});
			String[] parts = language.split("_");
			String lang = parts[0]; 
			parameters.put(PayU.PARAMETERS.LANGUAGE, lang); 
			parameters.put(PayU.PARAMETERS.VALUE, ""+value);
			parameters.put(PayU.PARAMETERS.CURRENCY, currencyCode);
			/* String seq_payu_buyer=DbUtil.getVal("select nextval('seq_payu_buyer')", new String[] {});
			buyerId= "PU"+EncodeNum.encodeNum (seq_payu_buyer).toUpperCase(); */
			
			// - Buyer -
			//parameters.put(PayU.PARAMETERS.BUYER_ID, "1");
			parameters.put(PayU.PARAMETERS.BUYER_NAME, name);
			parameters.put(PayU.PARAMETERS.BUYER_EMAIL,email);
			//parameters.put(PayU.PARAMETERS.BUYER_CONTACT_PHONE, "7563126");
			//parameters.put(PayU.PARAMETERS.BUYER_DNI, "5415668464654");
			parameters.put(PayU.PARAMETERS.BUYER_STREET, address1);
			parameters.put(PayU.PARAMETERS.BUYER_STREET_2, address2);
			parameters.put(PayU.PARAMETERS.BUYER_CITY, city);
			parameters.put(PayU.PARAMETERS.BUYER_STATE, state);
			parameters.put(PayU.PARAMETERS.BUYER_COUNTRY, country);
			parameters.put(PayU.PARAMETERS.BUYER_POSTAL_CODE, zipcode);
			//parameters.put(PayU.PARAMETERS.BUYER_PHONE, "7563126"); //
			
			// - Payer -
			String payerName=name;
			if("SANDBOX".equalsIgnoreCase(env)) payerName = "APPROVED";
			
			//parameters.put(PayU.PARAMETERS.PAYER_ID, "1");
			parameters.put(PayU.PARAMETERS.PAYER_NAME, payerName); //for test case payer name should be "APPROVED"
			parameters.put(PayU.PARAMETERS.PAYER_EMAIL, email);
			//parameters.put(PayU.PARAMETERS.PAYER_CONTACT_PHONE, "7563126");
			//parameters.put(PayU.PARAMETERS.PAYER_DNI, "5415668464654");
			parameters.put(PayU.PARAMETERS.PAYER_STREET, address1);
			parameters.put(PayU.PARAMETERS.PAYER_STREET_2, address2);
			parameters.put(PayU.PARAMETERS.PAYER_CITY, city);
			parameters.put(PayU.PARAMETERS.PAYER_STATE, state);
			parameters.put(PayU.PARAMETERS.PAYER_COUNTRY, country);
			parameters.put(PayU.PARAMETERS.PAYER_POSTAL_CODE, zipcode);
			//parameters.put(PayU.PARAMETERS.PAYER_PHONE, "7563126");

			// - Credit card data -
			parameters.put(PayU.PARAMETERS.CREDIT_CARD_NUMBER, cardnumber);
			parameters.put(PayU.PARAMETERS.CREDIT_CARD_EXPIRATION_DATE, cc_exp);
			parameters.put(PayU.PARAMETERS.CREDIT_CARD_SECURITY_CODE, cvvcode);
			parameters.put(PayU.PARAMETERS.PAYMENT_METHOD, cardtype.toUpperCase());
			parameters.put(PayU.PARAMETERS.INSTALLMENTS_NUMBER, "1");
			parameters.put(PayU.PARAMETERS.COUNTRY, country);//PaymentCountry.CO.name()
			
			String sessionId = request.getSession().getId();
			String deviceSessId=getMD5(sessionId);
			String ipAdd = request.getRemoteAddr();
			String userAgent = request.getHeader("User-Agent");
			parameters.put(PayU.PARAMETERS.DEVICE_SESSION_ID, deviceSessId);
			parameters.put(PayU.PARAMETERS.IP_ADDRESS, ipAdd);
			//parameters.put(PayU.PARAMETERS.COOKIE, "pt1t38347bs6jc9ruv2ecpv7o2");
			parameters.put(PayU.PARAMETERS.USER_AGENT, userAgent);
			
			// Authorization and capture request
			String responseFailureMsg="",resultFailureMsg="";
			try{
				TransactionResponse payResponse = PayUPayments.doAuthorizationAndCapture(parameters);
				if(payResponse != null){
					responseMap=PrepareResponseMap(payResponse);
					if(payResponse.getOrderId() !=null && "APPROVED".equalsIgnoreCase(payResponse.getState()+"") 
							&& "APPROVED".equalsIgnoreCase(payResponse.getResponseCode()+"")){
						resultMap.put("status","Success");
						responseMap.put("status","Success");
					}else{
						
						if(responseCodeMessageMap.containsKey(payResponse.getResponseCode()))
							responseFailureMsg=responseCodeMessageMap.get(payResponse.getResponseCode());
						else
							responseFailureMsg="No error given";
						
						if(resultFailureMessageMap.containsKey(payResponse.getResponseCode()))
							resultFailureMsg=resultFailureMessageMap.get(payResponse.getResponseCode());
						else
							resultFailureMsg="This transaction can not be processed at this time, please try back later";
									
						resultMap.put("status","failure");
						resultMap.put("failuremessage",resultFailureMsg);
						responseMap.put("status","failure");
						responseMap.put("failuremessage",responseFailureMsg);
					}
				} 
				System.out.println("responseMap: "+responseMap); 
			}catch(com.payu.sdk.exceptions.PayUException e){
				System.out.println("PayUException ERROR: "+e.getMessage());
				resultFailureMsg=e.getMessage();
				resultMap.put("status","failure");
				resultMap.put("failuremessage", resultFailureMsg);
				responseMap.put("status","failure");
				responseMap.put("failuremessage",resultFailureMsg);
				e.printStackTrace();
			}catch(com.payu.sdk.exceptions.InvalidParametersException e){
				System.out.println("InvalidParametersException ERROR: "+e.getMessage());
				resultFailureMsg=e.getMessage();
				resultMap.put("status","failure");
				resultMap.put("failuremessage", resultFailureMsg);
				responseMap.put("status","failure");
				responseMap.put("failuremessage",resultFailureMsg);
				e.printStackTrace();
			}catch(com.payu.sdk.exceptions.ConnectionException e){
				System.out.println("ConnectionException ERROR: "+e.getMessage());
				resultFailureMsg=e.getMessage();
				resultMap.put("status","failure");
				resultMap.put("failuremessage", resultFailureMsg);
				responseMap.put("status","failure");
				responseMap.put("failuremessage",resultFailureMsg);
				e.printStackTrace();
			}catch(Exception e){
				System.out.println("Exception ERROR: "+e.getMessage());
				resultFailureMsg=e.getMessage();
				resultMap.put("status","failure");
				resultMap.put("failuremessage", resultFailureMsg);
				responseMap.put("status","failure");
				responseMap.put("failuremessage",resultFailureMsg);
				e.printStackTrace();
			}
			
			try{
				if(!"".equals(cardnumber) && cardnumber!=null)
					cardnumber=cardnumber.substring(cardnumber.length()-4, cardnumber.length());
				parameters.put(PayU.PARAMETERS.CREDIT_CARD_NUMBER, cardnumber);
			}catch(Exception e){}
			
			insertpayulatam(eid,reference,parameters,responseMap,apiDetails);			
			insertCardTransactionData(eid,reference,parameters,responseMap);
		}catch(Exception e){
			resultMap.put("status","failure");
			resultMap.put("failuremessage","This transaction can not be processed at this time, please try back later");
		}
	return resultMap;
	}
	
	public HashMap<String,String> PrepareResponseMap(TransactionResponse payResponse){
		HashMap<String,String> responseMap=new HashMap<String,String>(); 
		 try{
			 responseMap.put("orderId",payResponse.getOrderId()+"");
		     responseMap.put("transactionId",payResponse.getTransactionId());
		     responseMap.put("state",payResponse.getState()+"");
		     responseMap.put("pendingReason",payResponse.getPendingReason()+"");
		     responseMap.put("paymentNetworkResponseCode",payResponse.getPaymentNetworkResponseCode());
		     responseMap.put("paymentNetworkResponseErrorMessage",payResponse.getPaymentNetworkResponseErrorMessage());
		     responseMap.put("trazabilityCode",payResponse.getTrazabilityCode());
		     responseMap.put("authorizationCode",payResponse.getAuthorizationCode());
		     responseMap.put("responseCode",payResponse.getResponseCode()+"");
		     responseMap.put("responseMessage",payResponse.getResponseMessage());
		     responseMap.put("errorCode",payResponse.getErrorCode()+"");
		     responseMap.put("transactionDate",payResponse.getTransactionDate());
		     responseMap.put("transactionTime",payResponse.getTransactionTime());
		     responseMap.put("operationDate",payResponse.getOperationDate()+"");
		     responseMap.put("extraParameters",payResponse.getExtraParameters()+"");
	     }catch(Exception e){
			 System.out.println("Exception occured at PrepareResponseMap payulatampayment ERROR:"+e.getMessage());
		 }
	     return responseMap;
	}
	
	public void insertpayulatam(String eventid, String tid,Map<String,String> datsentmap,HashMap<String,String> responseMap, HashMap<String,String> apidetails){
		try{
			String insertPayU = "insert into payulatam_payment_data(refid, tid, data_sent, data_response, mgr_api_details,status,date) "+
					"values(CAST(? as BIGINT),?,?,?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))";
						DbUtil.executeUpdateQuery(insertPayU,new String[]{eventid,tid,new JSONObject(datsentmap).toString(),new JSONObject(responseMap).toString(),new JSONObject(apidetails).toString(),responseMap.get("status"),DateUtil.getCurrDBFormatDate()});
		}catch(Exception e){
			System.out.println("Exception insert payulatam ERROR: "+e);
		}
	}
	
	public void insertCardTransactionData(String eventid,String tid, Map<String,String> inputdatamap,HashMap<String,String> resultMap){
		String resquery="insert into cardtransaction( "
			    +" transactionid,process_vendor,transaction_date,app_name,internal_ref,cardtype,cardmm,cardyy,cardnum,amount,proces_status,transaction_type,response_id,response_status) "
				    +" values (CAST(? as INTEGER),?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,?,CAST(? as INTEGER),CAST(? as INTEGER),?,CAST(? as FLOAT),?,?,?,?)";
	    String TRANSACTION_ID_GET="select nextval('seq_cardtransaction_id') as transactionid";
	    String CreditCardNumber=(String)inputdatamap.get("creditCardNumber");
	    /* if(CreditCardNumber!=null)
	      CreditCardNumber=CreditCardNumber.subSequence(CreditCardNumber.length()-4,CreditCardNumber.length())+""; */
	    String cardtranid="",amount="0",cardtype="",expmonth="0",expyear="0",status="",id="";
	    try{
	    	if(inputdatamap.get("value")!=null && !"".equals(inputdatamap.get("value"))){
		    	amount=CurrencyFormat.getCurrencyFormat("",inputdatamap.get("value"),true);
	    	}
	    	if(inputdatamap.get("paymentMethod")!=null) cardtype=inputdatamap.get("paymentMethod");//2017/01
	    	String expdate=inputdatamap.get("creditCardExpirationDate");
	    	String [] expMonthAndYear=expdate.split("/");
	    	expyear=expMonthAndYear[0];
	    	expmonth=expMonthAndYear[1];
	    	if(resultMap.get("status")!=null) status=resultMap.get("status");
	    	if(resultMap.get("orderId")!=null) id=resultMap.get("orderId");
	    	
	    	cardtranid=DbUtil.getVal(TRANSACTION_ID_GET,null);
	    	DbUtil.executeUpdateQuery(resquery, new String[]{cardtranid,"PAYULATAM - AUTHORIZATION_AND_CAPTURE",DateUtil.getCurrDBFormatDate(),"EVENT_REGISTRATION",
	    			tid,cardtype,expmonth,expyear,CreditCardNumber,amount,status,"AD",id,status});
	    	
	    }catch(Exception e){
	    	System.out.println("Exception occured in insertCardTransactionData payulatam: eventid: "+eventid+" tid: "+tid+" "+e.getMessage());
	    }
	}
	
	HashMap<String,String> getAPIDetails(String eid){
		String query="select attrib_2,attrib_3,attrib_4 from payment_types where refid=? and paytype='eventbee' and attrib_5='payulatam'";
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(query,new String[]{eid});
		HashMap<String,String> apiMap=null;
		if(sb.getStatus()){
			apiMap=new HashMap<String,String>();
			apiMap.put("api_key",db.getValue(0,"attrib_2",""));
			apiMap.put("api_login",db.getValue(0,"attrib_3",""));
			String accoutDetails =  db.getValue(0,"attrib_4","");
			try{
				JSONObject details = new JSONObject(accoutDetails);
				apiMap.put("account_id",details.getString("account_id"));
				apiMap.put("marchant_id",details.getString("marchant_id"));
			}catch(Exception e){
				System.out.println("Exception "+e);
			}
		}
		return apiMap;
	}
	
	public String getMD5(String id){
		try{
				long millis = System.currentTimeMillis() % 1000;
				id=id+millis;
				MessageDigest md = MessageDigest.getInstance("MD5");
				byte[] messageDigest = md.digest(id.getBytes());
				BigInteger number = new BigInteger(1, messageDigest);
				String hashtext = number.toString(16);
				return hashtext;
			}
			catch(Exception e){
				System.out.println(e);
				return id;
			}
	}
	
	public HashMap<String, String> validatePayUdetails(HashMap<String,String> dataMap){
		System.out.println(dataMap);
		JSONObject result = new JSONObject();
		HashMap<String, String> resultMap=new HashMap<String, String>();
		PayU.paymentsUrl = paymentsUrl;
		PayU.reportsUrl = reportsUrl;
		PayU.apiKey = apiKey;
		PayU.apiLogin = apiLogin;
		
		Map<String, String> parameters = new HashMap<String, String>();
		
		String language = DbUtil.getVal("select value from config where config_id= (select config_id from eventinfo where eventid=?::bigint) and name='event.i18n.lang';", new String[]{dataMap.get("eid")});
		String[] parts = language.split("_");
		String lang = parts[0]; 
		
		parameters.put(PayU.PARAMETERS.LANGUAGE, lang);
		parameters.put(PayU.PARAMETERS.API_KEY, dataMap.get("payUapikey")); //manager api key
		parameters.put(PayU.PARAMETERS.API_LOGIN,dataMap.get("payUapilogin")); //manager api login
		
		if("SANDBOX".equalsIgnoreCase(env)) //in live it should be false.
			PayU.isTest = true; 
		else 
			PayU.isTest = false; 
		
		String responseFailureMsg="",resultFailureMsg="";
		try{
			PaymentMethodApi paymentmethod = PayUPayments.getCustomPaymentMethodAvailabilityFromAPI("VISA", parameters);
			if(paymentmethod.getName()!=null){
				resultMap.put("status","success");
			}else{
				resultMap.put("status","fail");
				resultMap.put("errmsg","Please check the apikeys");
			}
				
			System.out.println("paymentmethod: "+paymentmethod); //paymentmethod: PaymentMethodApi [name=VISA, type=CREDIT_CARD]
		}catch(com.payu.sdk.exceptions.PayUException e){
			System.out.println("validatePayUdetails PayUException eventid: "+dataMap.get("eid")+" ERROR: "+e.getMessage());
			resultMap.put("status","fail");
			resultMap.put("errmsg",e.getMessage());
			//e.printStackTrace();
		}catch(com.payu.sdk.exceptions.ConnectionException e){
			System.out.println("validatePayUdetails ConnectionException eventid: "+dataMap.get("eid")+" ERROR: "+e.getMessage());
			resultMap.put("status","fail");
			resultMap.put("errmsg",e.getMessage());
			//e.printStackTrace();
		}catch(Exception e){
			System.out.println("validatePayUdetails Exception eventid: "+dataMap.get("eid")+" ERROR: "+e.getMessage());
			resultMap.put("status","fail");
			resultMap.put("errmsg",e.getMessage());
			//e.printStackTrace();
		}
		
		return resultMap;
	} 

}
%>