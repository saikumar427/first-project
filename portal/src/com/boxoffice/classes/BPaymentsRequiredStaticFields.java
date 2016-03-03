package com.boxoffice.classes;

import java.util.ArrayList;
import java.util.HashMap;

public class BPaymentsRequiredStaticFields {
	
	public static HashMap<String,ArrayList<String>> paymentsMandatoryFields=null;
	public static HashMap<String,ArrayList<String>> managerSettingLevelFields=new HashMap<String,ArrayList<String>>();

    static
    {
    	paymentsMandatoryFields=new HashMap<String,ArrayList<String>>();
    	
    	/*paypal*/
       	ArrayList<String> paypalMandatoryFields=new ArrayList<String>();
    	//paypalMandatoryFields.add("card_number");
    	//paypalMandatoryFields.add("expiration_date");
    	paypalMandatoryFields.add("card_holder_name");
    	paypalMandatoryFields.add("street");
    	paypalMandatoryFields.add("city");
    	paypalMandatoryFields.add("state");
    	paypalMandatoryFields.add("country");
    	paypalMandatoryFields.add("zip_code");
    	paymentsMandatoryFields.put("paypal_pro", paypalMandatoryFields);    	
         	
    	//braintree*    	
    	ArrayList<String> braintreeMandatoryFields=new ArrayList<String>();    
    	braintreeMandatoryFields.add("card_holder_name");
    	paymentsMandatoryFields.put("braintree_manager", braintreeMandatoryFields);
    	
    	//authorize.net    	
    	ArrayList<String> authorizeDotNetMandatoryFields=new ArrayList<String>();
       	authorizeDotNetMandatoryFields.add("card_holder_name");
    	authorizeDotNetMandatoryFields.add("city");
    	authorizeDotNetMandatoryFields.add("state");
    	authorizeDotNetMandatoryFields.add("country");
    	paymentsMandatoryFields.put("authorize.net", authorizeDotNetMandatoryFields);  
    	
    	//stripe    	
    	ArrayList<String> stripeMandatoryFields=new ArrayList<String>();
    	stripeMandatoryFields.add("cvv");
    	paymentsMandatoryFields.put("stripe", stripeMandatoryFields);    
    }
    
}
