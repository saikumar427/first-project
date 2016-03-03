<%@page import="com.boxoffice.classes.CheckAvailabilityAtPayment"%>
<%@page import="com.boxoffice.classes.BMakeEmptyProfileInfo"%>
<%@page import="com.paypal.soap.api.VendorHostedPictureType"%>
<%@ page import="org.json.*"%>
<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.creditcard.*,com.eventbee.event.*,com.eventregister.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ include file="BAuthorizeAIMPayment.jsp" %>
<%@ include file="BBraintreePayprocess.jsp" %>
<%@ include file="BStripePayment.jsp" %>

<%!boolean CheckIsAlreadySuccess(String transactionid){
boolean flag=false;
String ack=DbUtil.getVal("select 'yes' from event_reg_transactions where tid=?",new String[]{transactionid});
if("yes".equals(ack)){
flag=true;
}
return flag;
}

public String getEventName(String eid){
	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid =CAST(? AS BIGINT)",new String[]{eid});
		if(eventname==null) eventname="";
		String allowedChars[]={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
				"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"," "};
						List allowed=Arrays.asList(allowedChars);
		String neweventname="";
						for(int i=0;i<eventname.length();i++){
							String s=eventname.charAt(i)+"";
							if(allowed.contains(s))
							neweventname+=s;
						}
		if(neweventname.length()>10)
			neweventname=neweventname.substring(0,10);
	return neweventname;
}

public  Vector<String> boxOfficeCCValidaiton(CreditCardModel cm,String eid,String paymentType) throws JSONException{

	String query = "select mgr_id,attrib_1 from eventbee_manager_sellticket_settings where eventid=CAST(? as bigint)";
	DBManager dbManager=new DBManager();
	StatusObj status=dbManager.executeSelectQuery(query, new String[]{eid});
	String merchantKey="", managerId=""; 
	if(status.getStatus()){
		merchantKey=dbManager.getValue(0, "attrib_1", "");
		managerId=dbManager.getValue(0, "mgr_id", "");
	}	
	Vector<String> erros = new Vector<String>();
	String settingFeeldsQuery = "select  card_holder_name,cvv ,street ,city ,state ,country ,zip_code from ccpayment_setting_level_fields where vendor_type=? and merchant_key=? and mgr_id=?";
	StatusObj SettingFeldsStatusObj = dbManager
			.executeSelectQuery(settingFeeldsQuery, new String[] {
					paymentType,merchantKey, managerId });
	if (SettingFeldsStatusObj.getStatus()) {

		if ("y".equals(dbManager.getValue(0, "card_holder_name", ""))) {			
			if("".equals(cm.getProfiledata().getFirstName()+cm.getProfiledata().getLastName()))
					erros.add("Name required");
			
		}
		if ("y".equals(dbManager.getValue(0, "cvv", ""))) {
			if("".equals(cm.getCvvcode()))
					erros.add("Cvv required");
			
		}
		if ("y".equals(dbManager.getValue(0, "street", ""))) {
			if("".equals(cm.getProfiledata().getStreet1()+cm.getProfiledata().getStreet2()))
				erros.add("Street required");
			
		}
		if ("y".equals(dbManager.getValue(0, "city", ""))) {
			if("".equals(cm.getProfiledata().getCity()))
				erros.add("City required");
		}
		if ("y".equals(dbManager.getValue(0, "state", ""))) {
			if("".equals(cm.getProfiledata().getState()))
				erros.add("State required");
		}
		if ("y".equals(dbManager.getValue(0, "country", ""))) {
			if("".equals(cm.getProfiledata().getCountry()))
				erros.add("Country required");
		}
		if ("y".equals(dbManager.getValue(0, "zip_code", ""))) {
			if("".equals(cm.getProfiledata().getZip()))
				erros.add("zipcode required");
		}
		
	}
	System.out.println("errors::"+erros);
	return erros;
}



	public static String getConfigVal(String eid, String keyname,
			String defaultval) {
		if (eid == null || "".equals(eid))
			return defaultval;
		String configval = DbUtil
				.getVal("select value from config a,eventinfo b where a.config_id= b.config_id and b.eventid=CAST(? AS BIGINT) and a.name=?",
						new String[] { eid, keyname });
		if (configval == null)
			configval = defaultval;
		return configval;
	}

	public static boolean isRecurringEvent(String eid) {
		String recurring = getConfigVal(eid, "event.recurring", "");
		return "Y".equals(recurring);
	}%>

<%
	String orderSeq="";

System.out.println("Box office:: in Bccvalidateacion");
JSONObject object=new JSONObject();
CreditCardModel ccm=new CreditCardModel();
ProfileData m_ProfileData=new ProfileData();
HashMap hm=new HashMap();
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");

String edate = request.getParameter("edate");
String sellerId = request.getParameter("seller_id");
String profilesFilled=request.getParameter("profile_filled");
String seatingEnabled=request.getParameter("seating_enabled");
String api_key = request.getParameter("api_key");
String vendor=request.getParameter("vendor_pay"); 

if(vendor==null) vendor="paypal_pro";
if(edate==null)
	edate="";
if(seatingEnabled==null)
	seatingEnabled="n";
if(profilesFilled==null)
	profilesFilled="y";

if (eid == null || "".equals(eid) || tid == null || "".equals(tid)
|| api_key == null || "".equals(api_key) || sellerId == null
|| "".equals(sellerId)) {
JSONObject  responseObject= new JSONObject();
responseObject.put("status", "fail");
responseObject.put("reason", "required parameters missing");
out.println(responseObject.toString(2));
return;
}
CheckAvailabilityAtPayment instance=new CheckAvailabilityAtPayment();
String statusMessage=instance.paymentPageTicketAvailabilityCheck(eid, tid, "eventbee");

	if ("Timedout".equalsIgnoreCase(statusMessage)) {
		// {"errors":["The card number is incorrect"],"status":"error","order_num":"","tid":"RK7YEEBTHJ","eid":"121305643"}
		JSONArray errors = new JSONArray();
		errors.put("You have exceeded the time limit and your reservation has been released. Try with new transaction");
		out.println(new JSONObject().put("status", "error").put("errors", errors).toString(2));
		return;

	} else if ("maxqty".equalsIgnoreCase(statusMessage)) {
		JSONArray errors = new JSONArray();
		errors.put("You have exceeded the event maximum ticket quantity");
		out.println(new JSONObject().put("status", "error").put("errors", errors).toString(2));
		return;		
	}

	if ("n".equalsIgnoreCase(profilesFilled)) {
		if (isRecurringEvent(eid) && edate == "") {
			JSONObject responseObject = new JSONObject();
			responseObject.put("status", "fail");
			responseObject.put("reason", "required parameters missing");
			out.println(responseObject.toString(2));
			return;
		}
		BMakeEmptyProfileInfo emptyProFileEntries = new BMakeEmptyProfileInfo();
		emptyProFileEntries.makeEmptyProfileInfo(seatingEnabled, eid,
				edate, tid);
	}

	String m_cardamount = request.getParameter("totalamount");
	hm.put(CardConstants.INTERNAL_REF, tid);
	hm.put(CardConstants.REQUEST_APP, "EVENT_REGISTRATION");
	hm.put(CardConstants.TRANSACTION_TYPE, CardConstants.TRANS_ONE_TIME);
	hm.put(CardConstants.BASE_REF, "/card");
	hm.put(CardConstants.LOGO_URL, "");
	hm.put(CardConstants.AUTH_POLICY, "");
	hm.put(CardConstants.AUTH_URL, "");
	hm.put(CardConstants.AMOUNT, "" + m_cardamount);
	ccm.setParams(hm);
	ccm.setProfiledata(m_ProfileData);
	ccm.setCardtype(request.getParameter("cardtype"));
	ccm.setCardnumber(request.getParameter("cardnumber"));
	ccm.setCvvcode(request.getParameter("cvvcode"));
	ccm.setExpmonth(request.getParameter("expmonth"));
	ccm.setExpyear(request.getParameter("expyear"));

	ccm.getProfiledata()
			.setFirstName(request.getParameter("firstName"));
	ccm.getProfiledata().setLastName(request.getParameter("lastName"));
	ccm.getProfiledata().setEmail(request.getParameter("email"));
	ccm.getProfiledata().setCompany(request.getParameter("company"));
	ccm.getProfiledata().setStreet1(request.getParameter("street1"));
	ccm.getProfiledata().setStreet2(request.getParameter("street2"));
	ccm.getProfiledata().setCity(request.getParameter("city"));
	//if("US".equals(request.getParameter("country")))
	ccm.getProfiledata().setState(request.getParameter("state"));
	//else
	//ccm.getProfiledata().setState(request.getParameter("non_us_state"));

	if ("authorize.net".equals(request.getParameter("vendor_pay"))) {
		if ("US".equals(request.getParameter("country"))
				|| "CA".equals(request.getParameter("country")))
			ccm.getProfiledata()
					.setState(request.getParameter("state"));
		else
			ccm.getProfiledata().setState("default");
	}

	ccm.getProfiledata().setCountry(request.getParameter("country"));
	ccm.getProfiledata().setZip(request.getParameter("zip"));
	ccm.getProfiledata().setPhone(request.getParameter("phone"));

	String currencyformat1 = DbUtil.getVal(
			"select currency_code from event_currency where eventid=?",
			new String[] { eid });
	if (currencyformat1 == null)
		currencyformat1 = "USD";
	ccm.setCurrencyCode(currencyformat1);//4007000000027
	ccm.setSoftDesc(getEventName(eid));
	boolean isregistered = CheckIsAlreadySuccess(tid);

	if (eid == null && tid == null) {
		JSONArray arr = new JSONArray();
		arr.put("Transaction can not processed this time, please try bacl later");
		object.put("status", "error");

		object.put("errors", arr);
	} else if (isregistered) {
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,
				EventbeeLogger.INFO, "RegistrationProcessDB.java",
				"trying to submit for the second time transactionid---->"
						+ tid, "", null);
		object.put("status", "alreadyCompleted");
	} else {
		StatusObj sobj = null;
		Vector v = boxOfficeCCValidaiton(ccm, eid, vendor);

		String error = "";

		if (v == null || v.size() == 0) {
			if (!"authorize.net".equals(vendor)
					&& !vendor.contains("braintree")
					&& !vendor.contains("stripe")) {
				sobj = ccm.validate();
				if (sobj.getStatus()) {
					if (sobj.getData() instanceof Vector)
						v = (Vector) (sobj.getData());
					else if (sobj.getData() instanceof String) {
						error = (String) (sobj.getData());
						v.add("This transaction can not be processed at this time, please try back later");
					}
				}
			} else if ("authorize.net".equals(vendor)) {
				AuthorizeAIMPaymentProcess aimp = new AuthorizeAIMPaymentProcess();
				HashMap<String, String> apmap = aimp.processPayment(
						ccm, request);
				if (apmap != null
						&& !"Success".equals(apmap.get("status"))) {
					if (apmap.get("card_error") != null)
						v.add(apmap.get("Response Reason Text"));
					else
						v.add("This transaction can not be processed at this time, please try back later");
				} else if (apmap == null)
					v.add("This transaction can not be processed at this time, please try back later");
			} else if (vendor != null && vendor.contains("braintree")) {
				BraintreePayprocess brp = new BraintreePayprocess();
				HashMap brainmap = brp.payAmount(ccm, request,
						"braintree_mobile_app");
				System.out.println("volsat:::" + brainmap);
				if (brainmap != null
						&& (brainmap.get("status") == null || !"Success"
								.equals(brainmap.get("status"))))
					v.add(brainmap.get("shortmsg"));
				else if (brainmap == null)
					v.add("This transaction can not be processed at this time, please try back later");
			} else if (vendor != null && vendor.contains("stripe")) {
				System.out.println("Box Office INside Stripe");
				StripeGateWayProcessPayment sp = new StripeGateWayProcessPayment();
				HashMap<String, String> resultMap = sp
						.processStripePayment(ccm, request, "charge");
				if ("failure".equals(resultMap.get("status"))) {
					v.add(resultMap.get("failuremessage"));
				}

			}
		}

		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,
				EventbeeLogger.INFO, "ccvalidateaction.jsp",
				"validation results from credit card for  transactionid---->"
						+ tid + " is " + v, "", null);
		if (v == null || v.size() == 0) {
			/* StatusObj sb=DbUtil.executeUpdateQuery("update event_reg_details_temp set status='Completed',cc_vendor=?,selectedpaytype='eventbee' where tid=?",new String[]{vendor,tid});
			 if("authorize.net".contains(vendor) || "braintree_manager".contains(vendor) || "stripe".contains(vendor) )
			 DbUtil.executeUpdateQuery("update event_reg_details_temp set selectedpaytype=?,userid=? where tid=?",new String[]{"braintree_manager".equals(vendor)?"braintree":vendor,sellerId,tid}); */
			String selectdPayType = "eventbee";
			if ("authorize.net".equals(vendor)
					|| "braintree_manager".equals(vendor)
					|| "stripe".equals(vendor))
				selectdPayType = "braintree_manager".equals(vendor) ? "braintree"
						: vendor;
			DbUtil.executeUpdateQuery(
					"update event_reg_details_temp set selectedpaytype=?,status='Completed',cc_vendor=?,current_action='confirmation page' where tid=?",
					new String[] { selectdPayType, vendor, tid });

			BRegistrationProcessDB rgdb = new BRegistrationProcessDB();
			BRegistrationConfirmationEmail regconfirm = new BRegistrationConfirmationEmail();
			orderSeq = rgdb.insertRegistrationDb(tid, eid);
			DbUtil.executeUpdateQuery(
					"update event_reg_transactions set userid=? where tid=?",
					new String[] { sellerId, tid });
			int emailcount = regconfirm.sendRegistrationEmail(tid, eid);
			object.put("status", "success");
		} else {
			JSONArray errorsArray = new JSONArray();
			if (v != null && v.size() > 0) {
				for (int i = 0; i < v.size(); i++) {
					errorsArray.put(v.elementAt(i));
				}
			}
			object.put("status", "error");

			object.put("errors", errorsArray);
		}
	}
	object.put("tid", tid);
	object.put("eid", eid);
	object.put("order_num", orderSeq);

	System.out.println("resp::" + object.toString() + "::tid" + tid);
	out.println(object.toString());
%>



