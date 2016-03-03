package com.eventbee.creditcard;

import com.eventbee.util.*;
import com.eventbee.general.*;
import com.eventbee.authentication.ProfileData;
import com.sun.net.ssl.*;
import javax.net.ssl.*;
import java.net.*;
import java.io.*;
import java.util.*;
import org.w3c.dom.*;

public class PaypalProcessing{


	private String CreditCardNumber="";
	private String CVVCode="";
	private String CreditCardType="";
	private String ExpMonth="0";
	private String ExpYear="0";
	private String PostalCode="";
	private String StateOrProvince="";
	private String Street1="";
	private String CountryName="";
	private String CityName="";
	private String PayerFirstName="";
	private String PayerLastName="";
	private String PayerEmail="";
	private String GrandTotal="";
	private String reponsedata=null;
    private String CurrencyCode=null;
    private String CurrencyID=null;
    private String internalref=null;
    private String softDesc=null;
	public PaypalProcessing(CreditCardInfo cci){

			try{
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PaypalProcessing.java","PaypalProcessing(CreditCardInfo cci)","initialization",null);
				ProfileData profiledata=cci.getProfileData("PAYPALPRO");
				CreditCardNumber=cci.getCC_number("PAYPALPRO");
				CVVCode=cci.getCCVcode("PAYPALPRO");
				CreditCardType=cci.getcardtype("PAYPALPRO");
				ExpMonth=cci.getCC_expmonth("PAYPALPRO");
				ExpYear=cci.getCC_expyear("PAYPALPRO");
				GrandTotal=cci.getgrand_total("PAYPALPRO");
                CurrencyCode=cci.getCurrencyCode("PAYPALPRO");
                internalref=cci.getInternalRef("PAYPALPRO");
                softDesc=cci.getSoftDesc();
				if(profiledata!=null){
					PostalCode=profiledata.getZip();
					StateOrProvince=profiledata.getState();
					Street1=profiledata.getStreet1();
					CountryName=profiledata.getCountry();
					CityName=profiledata.getCity();
					PayerFirstName=profiledata.getFirstName();
					PayerLastName=profiledata.getLastName();
					PayerEmail=profiledata.getEmail();

				}



			}
			catch(Exception e){
					EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "PaypalProcessing.java", "PaypalProcessing", e.getMessage(), e ) ;
			}
		}



	private Map fillParamMap(){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PaypalProcessing.java","fillParamMap()","parammap",null);
		Map paramMap=new HashMap();
			paramMap.put("CreditCardNumber",CreditCardNumber);
			paramMap.put("CVVCode",CVVCode);
			paramMap.put("CreditCardType",CreditCardType);
			paramMap.put("ExpMonth",ExpMonth);
			paramMap.put("ExpYear",ExpYear);
			paramMap.put("GrandTotal",GrandTotal);
			paramMap.put("PostalCode",PostalCode);
			paramMap.put("StateOrProvince",StateOrProvince);
			paramMap.put("Street1",Street1);
			paramMap.put("CountryName",CountryName);
			paramMap.put("CityName",CityName);
			paramMap.put("PayerFirstName",PayerFirstName);
			paramMap.put("PayerLastName",PayerLastName);
			paramMap.put("PayerEmail",PayerEmail);

			if(CurrencyCode==null||"".equals(CurrencyCode))
			CurrencyCode="USD";
            paramMap.put("CurrencyCode",CurrencyCode);
            String environment=EbeeConstantsF.get("PAYPAL_PRO_ENVIRONMENT","live");

            paramMap.put("Environment",environment);
            paramMap.put("InternalRef",internalref);
            paramMap.put("softdescriptor", softDesc);
		 return paramMap;
	}




	private Map getErrorCodesMap(){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PaypalProcessing.java","getErrorCodesMap()","errormap",null);
		Map errcodes=new HashMap();
			errcodes.put("10502","Card expired");
			errcodes.put("10503","Credit limit exceeded");
			errcodes.put("10504","Invalid CVV Code");
			errcodes.put("10505","AVS failed");
			errcodes.put("10508","Invalid expiration date");
			errcodes.put("10522","Invalid credit card number");
			errcodes.put("10510","Card type not supported");
			errcodes.put("10527","Invalid credit card");
			errcodes.put("10717","Invalid Zip");
			errcodes.put("10706","Invalid Zip");
			errcodes.put("10752","Please double check values entered on this page");
		return errcodes;
	}




	public String getResponseData(){
		String st=null;
		try{
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PaypalProcessing.java","getResponseData()","CoreConnector to connect to paypal.jsp",null);
			CoreConnector cc1=new CoreConnector(EbeeConstantsF.get("CONNECTING_PAYPAL_URL","http://192.168.0.177:8080/paypal/paypal.jsp"));
			cc1.setArguments(fillParamMap());
			cc1.setTimeout(30000);
			st=cc1.MGet();
		}
		catch(Exception e){
			EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "PaypalProcessing.java", "getResponseData", e.getMessage(), e ) ;
		}

		return st;
	}




	public ResponseObj processResposeData(){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PaypalProcessing.java","processResposeData()","Builds & returns response object",null);
		boolean paypalStatus=false;
		ResponseObj robj=new ResponseObj();
		robj.message="";
		String [] xmltags={"Ack","AVSCode","CVV2Code","TransactionID"};
		String [] xmlerrtags={"ErrorCode","ShortMsg"};
		String [] xmlresponsetag={"response"};
		Map resMap=new HashMap();
	      Map  responsemap=new HashMap();
		Vector errList=null;
        Vector errorcodes=new Vector();
			try{
				reponsedata=getResponseData();
				if(reponsedata!=null){


					Document doc=ProcessXMLData.getDocument(new StringBufferInputStream(reponsedata));
					doc.getDocumentElement ().normalize ();
					resMap=ProcessXMLData.getProcessedXMLData(doc,"DoDirectPaymentResponse",xmltags);
                    responsemap=ProcessXMLData.getProcessedXMLData(doc,"DoDirectPaymentResponse",xmlresponsetag);
                   // System.out.println("responsemap---"+responsemap);
					if("Success".equals((String)resMap.get("Ack"))){
						robj.status=true;
					//robj.setData(GenUtil.getHMvalue(resMap,"AVSCode",null),GenUtil.getHMvalue(resMap,"CVV2Code",null),GenUtil.getHMvalue(resMap,"CVV2Code",null),GenUtil.getHMvalue(resMap,"TransactionID",null),"PAYPALPRO");
                   robj.setData(GenUtil.getHMvalue(resMap,"AVSCode",null),GenUtil.getHMvalue(resMap,"CVV2Code",null),"Success",GenUtil.getHMvalue(resMap,"TransactionID",null),"PAYPALPRO");


					}
					else{
						errList=ProcessXMLData.getProcessedXMLList(doc,"Error",xmlerrtags);

						if(errList!=null&&errList.size()>0){

							for(int k=0;k<errList.size();k++){
								HashMap errorMap=(HashMap)errList.elementAt(k);

                              String value=(String)errorMap.get("ShortMsg");
								errorcodes.add(value);
							}
							robj.data=errorcodes;
						//robj.setData("","E","E","","PAYPALPRO");
						robj.setData("","E","Fail","","PAYPALPRO");
							robj.status=false;
						}
					}



					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PaypalProcessing.java","in processResposeData()","responseMap is :"+resMap+" & errorMap is :"+errList,null);


				}
				else
				robj.status=false;
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PaypalProcessing.java","in processResposeData()","ResponseObj status :"+robj.status,null);

			String responsePaypal=(String)responsemap.get("response");

			//StatusObj statobjn= DbUtil.executeUpdateQuery("insert into paypal_pro_responses (transactionid,response,date) values (?,?,now())",new String[]{internalref,responsePaypal});
			StatusObj statobjn= DbUtil.executeUpdateQuery("insert into paypal_pro_responses (transactionid,response,date) values (?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))",new String[]{internalref,responsePaypal,DateUtil.getCurrDBFormatDate()});


			}//try
			catch(Exception e){
				EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "PaypalProcessing.java", "getResponseData", e.getMessage(), e ) ;
			}

		return robj;

	}


}//class