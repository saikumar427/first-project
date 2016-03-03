<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="com.boxoffice.classes.BPaymentsRequiredStaticFields"%>
<%
	//Author: Venkat Reddy
	//Version: 0.1
	//File: getRequiredPaymentFields.jsp 
	//Created: 2/06/2014 
	//Modified: 2/06/2014 by venkat reddy*/
%>

<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page trimDirectiveWhitespaces="true"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	<%!
	private  ArrayList<JSONObject> getRequiredFields(String payType){
		ArrayList<JSONObject> settingLevelFields = new ArrayList<JSONObject>();
		try{
			if("paypal_pro".equalsIgnoreCase(payType)){
				settingLevelFields.add(new JSONObject().put("key", "firstName").put("title","First Name") );
				settingLevelFields.add(new JSONObject().put("key","lastName").put("title", "Last Name") );		
				settingLevelFields.add(new JSONObject().put("key", "cvvcode").put("title", "Cvv Code"));
				settingLevelFields.add(new JSONObject().put("key", "street1").put("title", "Street"));
				settingLevelFields.add(new JSONObject().put("key", "city").put("title", "City"));
				settingLevelFields.add(new JSONObject().put("key", "state").put("title", "State"));
				settingLevelFields.add(new JSONObject().put("key", "country").put("title", "Country"));
				settingLevelFields.add(new JSONObject().put("key", "zip").put("title", "ZIP Code"));
			}
			else if("stripe".equalsIgnoreCase(payType)){
				settingLevelFields.add(new JSONObject().put("key", "cvvcode").put("title", "Cvv Code"));
			}
			else if("braintree_manager".equalsIgnoreCase(payType)){
				settingLevelFields.add(new JSONObject().put("key", "firstName").put("title","First Name") );
				settingLevelFields.add(new JSONObject().put("key","lastName").put("title", "Last Name") );
				settingLevelFields.add(new JSONObject().put("key", "cvvcode").put("title", "Cvv Code"));
			}
			else if("authorize.net".equalsIgnoreCase(payType)){
				settingLevelFields.add(new JSONObject().put("key", "firstName").put("title","First Name") );
				settingLevelFields.add(new JSONObject().put("key","lastName").put("title", "Last Name") );
				settingLevelFields.add(new JSONObject().put("key", "city").put("title", "City"));
				settingLevelFields.add(new JSONObject().put("key", "cvvcode").put("title", "Cvv Code"));
				settingLevelFields.add(new JSONObject().put("key", "state").put("title", "State"));
				settingLevelFields.add(new JSONObject().put("key", "country").put("title", "Country"));				
			}
		}catch(Exception e){
			
		}
		return settingLevelFields;		
	}	
	
	%>

<%
	String eid = request.getParameter("event_id");
	String apiKey = request.getParameter("api_key");
	JSONObject responseObject = new JSONObject();
	if (eid == null || "".equals(eid) || apiKey == null
			|| "".equals(apiKey)) {
		responseObject.put("status", "fail");
		responseObject.put("reason", "required params missing");
		out.println(responseObject.toString(2));
		return;
	}
	DBManager dbManager = new DBManager();
	
	String paymentType = "";
	String merchantKey="";
	StatusObj sObj = dbManager
			.executeSelectQuery("select vendor_type,mgr_id,attrib_1 from  eventbee_manager_sellticket_settings  where eventid=cast(? as integer)",
					new String[] { eid });
	if(sObj.getStatus()&&sObj.getCount()>0){
		paymentType=dbManager.getValue(0, "vendor_type","");
		merchantKey=dbManager.getValue(0, "attrib_1","");
	}
	else {		
		String paymentTypeQuery="select paytype,attrib_5,attrib_2 from payment_types  where refid=? and status='Enabled'";		
		String processingGateWay="";		

		StatusObj statusObj=dbManager.executeSelectQuery(paymentTypeQuery, new String[]{eid});

		if(statusObj.getStatus()){
			for(int i=0;i<statusObj.getCount();i++){
				if("eventbee".equals(dbManager.getValue(i, "paytype", ""))){
					processingGateWay=dbManager.getValue(i, "attrib_5", "");					
					break;
				}
			}
		}if("".equalsIgnoreCase(processingGateWay)){
			    processingGateWay="paypal_pro";				
				responseObject.put("fields", getRequiredFields("paypal_pro"));		      
		}
		responseObject.put("status", "success");				
		responseObject.put("vendor_pay",processingGateWay);
		responseObject.put("fields", getRequiredFields(processingGateWay));
		out.println(responseObject.toString(2));
		return;
	}

	
	ArrayList<JSONObject> settingLevelFields = new ArrayList<JSONObject>();
	if("paypal_pro".equalsIgnoreCase(paymentType)){
		    settingLevelFields.addAll(getRequiredFields("paypal_pro"));	
		
	}else{
		String settingFeeldsQuery = "select  card_holder_name,cvv ,street ,city ,state ,country ,zip_code from ccpayment_setting_level_fields where vendor_type=? and merchant_key=?";
		StatusObj SettingFeldsStatusObj = dbManager
				.executeSelectQuery(settingFeeldsQuery, new String[] {
						paymentType, merchantKey });
		if (SettingFeldsStatusObj.getStatus()&&SettingFeldsStatusObj.getCount()>0) {
			if ("y".equals(dbManager.getValue(0, "card_holder_name", ""))) {			
				settingLevelFields.add(new JSONObject().put("key", "firstName").put("title","First Name") );
				settingLevelFields.add(new JSONObject().put("key","lastName").put("title", "Last Name") );			
			}
			//if ("y".equals(dbManager.getValue(0, "cvv", ""))) {
				settingLevelFields.add(new JSONObject().put("key", "cvvcode").put("title", "Cvv Code"));				
			//}
			if ("y".equals(dbManager.getValue(0, "street", ""))) {
				settingLevelFields.add(new JSONObject().put("key", "street1").put("title", "Street"));				
			}
			if ("y".equals(dbManager.getValue(0, "city", ""))) {
				settingLevelFields.add(new JSONObject().put("key", "city").put("title", "City"));
			}
			if ("y".equals(dbManager.getValue(0, "state", ""))) {
				settingLevelFields.add(new JSONObject().put("key", "state").put("title", "State"));
			}
			if ("y".equals(dbManager.getValue(0, "country", ""))) {
				settingLevelFields.add(new JSONObject().put("key", "country").put("title", "Country"));
			}
			if ("y".equals(dbManager.getValue(0, "zip_code", ""))) {
				settingLevelFields.add(new JSONObject().put("key", "zip").put("title", "ZIP Code"));
			}
	
		} else {
			System.out.println("in status fail of getting required fields " + merchantKey);
			 settingLevelFields.addAll(getRequiredFields(paymentType));
		}
	}
	responseObject.put("status", "success");
	responseObject.put("fields", settingLevelFields);
	responseObject.put("vendor_pay",paymentType);
	out.println(responseObject.toString(2));
%>



