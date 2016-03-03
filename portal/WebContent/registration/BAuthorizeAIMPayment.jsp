<%@page import="java.util.Hashtable"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.DateUtil"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="java.net.URL"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@page import="com.eventbee.creditcard.CreditCardModel"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>

<%!
String[] responseFields={"Response Code","Response Subcode","Response Reason Code","Response Reason Text"
		,"Authorization	Code","AVS Response","Transaction ID","Invoice Number","Description","Amount",
		"Method","Transaction Type","Customer ID","First Name","Last Name","Company","Address","City"
		,"State","ZIP Code","Country","Phone","Fax","Email Address","Ship To First Name","Ship To Last Name",
		"Ship To Company","Ship To Address","Ship To City","Ship To State","Ship To ZIP Code","Ship To Country","Tax","Duty",
		"Freight","Tax Exempt","Purchase Order Number","MD5 Hash","Card Code Response",
		"Cardholder Authentication Verification	Response","","","","","","","","","","","Account Number","Card Type","Split Tender ID",
		"Requested Amount","Balance On Card"};
HashMap<String,String> responseCodeFormats=new HashMap<String,String>(){{
	put("1","Success");
	put("2","Declined");
	put("3","Error");
	put("4","Held for Review");
}};
List<String> card_errorcodes = Arrays.asList("5","6","7","8","17","33","37","78");

public class AuthorizeAIMPaymentProcess
{
	HashMap<String,String> processPayment(CreditCardModel ccm,HttpServletRequest request){
		// for real accounts: https://secure.authorize.net/gateway/transact.dll
		String gatewayURL=EbeeConstantsF.get("AUTHORIZE.NET.GATEWAY.URL","https://test.authorize.net/gateway/transact.dll");
		HashMap<String,String> responseMap=new HashMap<String,String>();
		String eid=request.getParameter("eid");
		String tid=request.getParameter("tid");
		try{
		URL post_url = new URL(gatewayURL);
		Hashtable<String,String> post_values = new Hashtable<String,String>();
		//Acquiring API Details from DB
		HashMap<String,String> apiDetails=getAPIDetails(eid)  ;
		//Filling required CC Data
		post_values.put ("x_login", apiDetails.get("loginId"));
		post_values.put ("x_tran_key", apiDetails.get("transactionKey"));
		  
		post_values.put ("x_version", "3.1");
		post_values.put ("x_delim_data", "TRUE");
		post_values.put ("x_delim_char", "|");
		post_values.put ("x_relay_response", "FALSE");

		post_values.put ("x_type", "AUTH_CAPTURE");
		post_values.put ("x_method", "CC");
		post_values.put ("x_card_num", request.getParameter("cardnumber"));
		System.out.println("cvvcode::"+request.getParameter("cvvcode"));
		post_values.put ("x_card_code",request.getParameter("cvvcode"));
		post_values.put ("x_exp_date", request.getParameter("expmonth")+request.getParameter("expyear").substring(2));
		post_values.put ("x_cust_id",tid);
		post_values.put ("x_Currency_Code",ccm.getCurrencyCode());
		String customerIp=request.getHeader("x-forwarded-for");
		if(customerIp==null || "".equals(customerIp)) customerIp=request.getRemoteAddr();
		post_values.put ("x_customer_ip",customerIp);
		post_values.put ("x_amount", ccm.getGrandtotal());
		post_values.put ("x_description", "");
		post_values.put ("x_first_name", request.getParameter("firstName"));
		post_values.put ("x_last_name", request.getParameter("lastName"));
		post_values.put ("x_address", request.getParameter("street1"));
		post_values.put ("x_state", request.getParameter("state"));
		post_values.put ("x_country", request.getParameter("country"));
		post_values.put ("x_city", request.getParameter("city"));
		post_values.put ("x_zip", request.getParameter("zip"));

		StringBuffer post_string = new StringBuffer();
		Enumeration<String> keys = post_values.keys();
		while( keys.hasMoreElements() ) {
		  String key = URLEncoder.encode(keys.nextElement(),"UTF-8");
		  String value = URLEncoder.encode(post_values.get(key),"UTF-8");
		  post_string.append(key + "=" + value + "&");
		}	
		URLConnection connection = post_url.openConnection();
		connection.setDoOutput(true);
		connection.setUseCaches(false);

		// this line is not necessarily required but fixes a bug with some servers
		connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");

		// submit the post_string and close the connection
		DataOutputStream requestObject = new DataOutputStream( connection.getOutputStream() );
		requestObject.write(post_string.toString().getBytes());
		requestObject.flush();
		requestObject.close();

		// process and read the gateway response
		BufferedReader rawResponse = new BufferedReader(new InputStreamReader(connection.getInputStream()));
		String responseData = rawResponse.readLine();
		System.out.println("Actual Response: "+responseData);
		rawResponse.close();	                     // no more data
		
		// split the response into an array
		String [] responses = responseData.split("\\|");
		for(int i=0;i<responses.length;i++){
			if(responses[i]!=null && !"".equals(responses[i].trim())){
				responseMap.put(responseFields[i],responses[i]);
				if(i==0) responseMap.put("status",responseCodeFormats.get(responses[i]));
			}
		}
		//Storing Actual Response in key value format
		String query="INSERT INTO autorizenet_payment_data("+
        "refid, tid, data_sent, data_response, mgr_api_login, mgr_api_transactionkey,"+ 
        "date, status) VALUES (?::BIGINT, ?, ?, ?, ?, ?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'), ?);";
        post_values.remove("x_card_code");
        if(responseMap.get("Account Number")!=null)
        post_values.put("x_card_num",responseMap.get("Account Number"));
        post_values.put("ExpMonth",request.getParameter("expmonth"));
        post_values.put("ExpYear",request.getParameter("expyear"));
    	DbUtil.executeUpdateQuery(query,new String[]{
    	eid,tid,post_values.toString(),responseMap.toString(), apiDetails.get("loginId"), apiDetails.get("transactionKey"),	
    	 DateUtil.getCurrDBFormatDate(),responseMap.get("status")	
    	}); 
    	//Inserting more details in card transactions
    	setResultToDb(responseMap, post_values);
		}
		catch(Exception e){
			return null;
		}
		if(card_errorcodes.contains(responseMap.get("Response Reason Code")))
			responseMap.put("card_error","present");
		return responseMap;
	}
	HashMap<String,String> getAPIDetails(String eid){
		
		String query="select attrib_1,attrib_2 from eventbee_manager_sellticket_settings where eventid=cast(? as bigint) and vendor_type='authorize.net'";
		HashMap<String,String> apiMap=null;
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(query,new String[]{eid});		
		if(sb.getStatus()&&sb.getCount()>0){
			apiMap=new HashMap<String,String>();
			apiMap.put("loginId",db.getValue(0,"attrib_1",""));
			apiMap.put("transactionKey",db.getValue(0,"attrib_2",""));
		}else{
			 query="select attrib_2,attrib_3 from payment_types where refid=? and paytype='eventbee' and attrib_5='authorize.net'";
			  sb=db.executeSelectQuery(query,new String[]{eid});
			  if(sb.getStatus()&&sb.getCount()>0){
					apiMap=new HashMap<String,String>();
					apiMap.put("loginId",db.getValue(0,"attrib_2",""));
					apiMap.put("transactionKey",db.getValue(0,"attrib_3",""));
			   }
		}
		System.out.println("apmap"+apiMap);
		return apiMap;
	}

	public void setResultToDb(HashMap<String,String> result, Hashtable<String,String> paydet)
	 {String resquery="insert into cardtransaction( "
						    +" transactionid,process_vendor,transaction_date,app_name,internal_ref,cardtype,cardmm,cardyy,cardnum,amount,proces_status,transaction_type,response_id,response_status,response_scode) "
		 				    +" values (CAST(? AS INTEGER),?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,?,CAST(? AS INTEGER),CAST(? AS INTEGER),?,CAST(? AS FLOAT),?,?,?,?,?)";
	String TRANSACTION_ID_GET="select nextval('seq_cardtransaction_id') as transactionid";
	String CreditCardNumber=(String)paydet.get("x_card_num") ;
	if(CreditCardNumber!=null)
	CreditCardNumber=CreditCardNumber.subSequence(CreditCardNumber.length()-4,CreditCardNumber.length())+"";
	 String rec_id="";
	  try{
	  rec_id=DbUtil.getVal(TRANSACTION_ID_GET,null);
	   String[] params={rec_id,
		    		  			"AUTHORIZE.NET",
		    		  			 DateUtil.getCurrDBFormatDate(),
		    		  			"EVENT_REGISTRATION",
		    		  			paydet.get("x_cust_id"),
		    		  			result.get("Card Type"),
		    		  			paydet.get("ExpMonth"),
		    		  			paydet.get("ExpYear"),
		    		  			CreditCardNumber,
		    		  			paydet.get("x_amount"),
		    		  			result.get("status"),
								"AD",
		    		  			result.get("Transaction ID"),
								result.get("status"),
								result.get("Response Code"),
	                               };
		DbUtil.executeUpdateQuery(resquery,params);
	 }
	 catch(Exception e){System.out.println("Exeception while set to db in authorize.net::"+e.getMessage());}
	 }
}
%>
