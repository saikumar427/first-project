<%@ page import="com.eventbee.creditcard.CreditCardModel" %>
<%@ page  import="com.eventbee.util.ProcessXMLData,org.w3c.dom.Document,com.eventbee.util.CoreConnector"%>
<%@ page  import="java.io.StringBufferInputStream" %>
<%@ page import="org.json.*"%>
<%@ page import="java.util.*,com.eventbee.general.*" %>
 
 <%!
 public class BraintreePayprocess
 {
 
 HashMap  payAmount(CreditCardModel ccm,HttpServletRequest hreq,String process)
 {       
         CoreConnector cc1=null;
         Map resMap=null;
		 String data="";
         HashMap paydet=new HashMap();
         HashMap result=new HashMap(); 
         paydet.put("CreditCardNumber",hreq.getParameter("cardnumber"));
	     paydet.put("CreditCardType",hreq.getParameter("cardtype"));
		 paydet.put("CVVCode",hreq.getParameter("cvvcode"));
	     paydet.put("ExpMonth",hreq.getParameter("expmonth"));
	     paydet.put("ExpYear",hreq.getParameter("expyear"));
	     paydet.put("PostalCode",hreq.getParameter("zip"));
	     paydet.put("Street1",hreq.getParameter("street1"));
	     paydet.put("CountryName",hreq.getParameter("country"));
	     paydet.put("CityName",hreq.getParameter("city"));
	     paydet.put("PayerFirstName",hreq.getParameter("firstName"));
	     paydet.put("PayerLastName",hreq.getParameter("lastName"));
	     paydet.put("PayerEmail",hreq.getParameter("email"));
	     paydet.put("GrandTotal",ccm.getGrandtotal());
		 paydet.put("internalrefid",hreq.getParameter("tid"));
         paydet.put("ref_id",hreq.getParameter("eid"));
		 paydet.put("purpose","Event_Reg");
		 paydet.put("paytype","direct");
         paydet.put("vaultflag","false");
		 paydet.put("paypro",process);

         
		     try{
			 cc1=new CoreConnector(EbeeConstantsF.get("CONNECTING_BRAINTREE_URL","http://www.eventbee.com/main/payments/braintree/BraintreePayment.jsp"));
			 cc1.setArguments(paydet);
	       	 cc1.setTimeout(50000);
		     data=cc1.MGet();
	         String [] xmltags={"Status","TransactionID","VaultId"};
	         Document doc=ProcessXMLData.getDocument(new StringBufferInputStream(data));
		     doc.getDocumentElement ().normalize ();
	         resMap=ProcessXMLData.getProcessedXMLData(doc,"Response",xmltags);
	         System.out.println("resMap::g::"+resMap);
			 
			 if("success".equalsIgnoreCase((String)resMap.get("Status")))
        	  { 
			  result.put("status","Success");
			  result.put("status_code","s");
			  result.put("tid",(String)resMap.get("TransactionID"));
			  result.put("vaultid",(String)resMap.get("VaultId"));
        	  }
         else{
        	 String[] errorxmltags={"ErrorCode","ShortMsg"};
        	 Document doc1=ProcessXMLData.getDocument(new StringBufferInputStream(data));
		     doc1.getDocumentElement ().normalize ();
	         resMap=ProcessXMLData.getProcessedXMLData(doc1,"Response",errorxmltags);
        	 System.out.println("resMap is:"+resMap);
	         String errorcode=(String)resMap.get("ErrorCode");
			 String shortmsg=(String)resMap.get("ShortMsg");
			 if(shortmsg==null)
             shortmsg="Card declined for this payment. Make sure all details are valid.";
			 System.out.println("errorcode is:"+errorcode);
        	 result.put("errorcode",errorcode);
			 result.put("status","fail");
			 result.put("status_code","F");
		     result.put("shortmsg",shortmsg);
        	}
		    setResultToDb(result,paydet);		
		   }catch(Exception e){
		    System.out.println("Error While Processing payment::"+e.getMessage());
		    result.put("status","fail");
    		result.put("errorcode","505");
			result.put("status_code","F");
			result.put("shortmsg","This transaction can not be processed at this time, please try back later.");
		   }
		   
		   
		 
		return result; 
		 
		 
 }
 public void setResultToDb(HashMap result, HashMap paydet)
 {String resquery="insert into cardtransaction( "
					    +" transactionid,process_vendor,transaction_date,app_name,internal_ref,cardtype,cardmm,cardyy,cardnum,amount,proces_status,transaction_type,response_id,response_status,response_scode,response_fcode,vaultid) "
	 				    +" values (CAST(? AS INTEGER),?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,?,CAST(? AS INTEGER),CAST(? AS INTEGER),?,CAST(? AS FLOAT),?,?,?,?,?,?,?)";
String TRANSACTION_ID_GET="select nextval('seq_cardtransaction_id') as transactionid";
String CreditCardNumber=(String)paydet.get("CreditCardNumber") ;
if(CreditCardNumber!=null)
CreditCardNumber=CreditCardNumber.subSequence(CreditCardNumber.length()-4,CreditCardNumber.length())+"";
 
 String rec_id="";
  try{
  rec_id=DbUtil.getVal(TRANSACTION_ID_GET,null);
   String[] params={rec_id,
	    		  			"BRAINTREE-DIRECT",
	    		  			 DateUtil.getCurrDBFormatDate(),
	    		  			"EVENT_REGISTRATION",
	    		  			(String)paydet.get("internalrefid"),
	    		  			(String)paydet.get("CreditCardType"),
	    		  			(String)paydet.get("ExpMonth"),
	    		  			(String)paydet.get("ExpYear"),
	    		  			 CreditCardNumber,
	    		  			(String)paydet.get("GrandTotal"),
	    		  			(String)result.get("status"),
							"AD",
	    		  			(String)result.get("tid"),
							(String)result.get("status"),
							(String)result.get("status_code"),
	    		  			(String)result.get("errorcode"),
	    		  			(String)result.get("vaultid")
                               };
							
							
	
       
		StatusObj sob=DbUtil.executeUpdateQuery(resquery,params);
 }
 catch(Exception e){System.out.println("Exeception Wheile set to db in braintreee::"+e.getMessage());}
 }
 }
 %>