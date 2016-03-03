<%@ page import="com.eventbee.clubmember.*"%>
<%@ page import="com.eventbee.creditcard.*,com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="java.util.*,com.eventbee.creditcard.*" %>
<%@ page import="com.eventbee.useraccount.AuthInfo" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ include file='/xfhelpers/xffunc.jsp' %>
<jsp:include page="/stylesheets/CoreRequestMap.jsp" />
<%!

boolean CheckIsAlreadySuccess(String transactionid){
boolean flag=false;
String ack=DbUtil.getVal("select 'yes' from event_reg_transactions where tid=?",new String[]{transactionid});
if("yes".equals(ack)){
flag=true;
}
return flag;
}



%>


<%
String contextpath="/manager".equals( request.getContextPath() )?"/manager":"/portal";
Authenticate authData=AuthUtil.getAuthData(pageContext);
   //CreditCardProcessingBean jBean=(CreditCardProcessingBean)session.getAttribute("CreditCardProcessingBean");
   EventRegisterBean jBean= (EventRegisterBean)session.getAttribute("regEventBean");
if(jBean!=null){
    String currencycode=DbUtil.getVal("select currency_code from event_currency where eventid=?",new String[]{jBean.getEventId()});
   if(currencycode==null)
   currencycode="USD";
   jBean.setContextUnitid("13579");
   CreditCardModel ccm=(CreditCardModel) jBean.getCard() ;
   com.eventbee.util.RequestSaver rsv=new com.eventbee.util.RequestSaver(pageContext);
	Map reqMap=rsv.getReqMap();
	String BASE_REF=GenUtil.getHMvalue(reqMap,"BASE_REF");
	ccm.setCardtype(GenUtil.getHMvalue(reqMap,BASE_REF+"/cardtype"));
	ccm.setCardnumber(GenUtil.getHMvalue(reqMap,BASE_REF+"/cardnumber"));
	ccm.setCvvcode(GenUtil.getHMvalue(reqMap,BASE_REF+"/cvvcode",""));
	ccm.setExpmonth(GenUtil.getHMvalue(reqMap,BASE_REF+"/expmonth"));
	ccm.setExpyear(GenUtil.getHMvalue(reqMap,BASE_REF+"/expyear"));
	ccm.getProfiledata().setFirstName(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/firstName"));
	ccm.getProfiledata().setLastName(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/lastName"));
	ccm.getProfiledata().setEmail(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/email"));
	ccm.getProfiledata().setCompany(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/company"));
	ccm.getProfiledata().setStreet1(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/street1"));
	ccm.getProfiledata().setStreet2(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/street2"));
	ccm.getProfiledata().setCity(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/city"));
	if("US".equals(GenUtil.getHMvalue(reqMap,"country")))
		ccm.getProfiledata().setState(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/state"));
		else
	ccm.getProfiledata().setState(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/non_us_state"));
	ccm.getProfiledata().setCountry(GenUtil.getHMvalue(reqMap,"country"));
	ccm.getProfiledata().setZip(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/zip"));
	ccm.getProfiledata().setPhone(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/phone"));
	ccm.setCurrencyCode(currencycode);
	jBean.setCard(ccm);
	
	boolean isregistered=CheckIsAlreadySuccess(jBean.getTransactionId());
	
	if(isregistered){
	 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"trying to submit second time","TRANSACTION ID---"+jBean.getTransactionId(),"",null);
				
	     response.sendRedirect(response.encodeURL(com.eventbee.general.PageUtil.appendLinkWithGroup(contextpath+"/guesttasks/regend.jsp?isreload=yes",(HashMap) request.getAttribute("REQMAP"))));
	    return; 
	}
	StatusObj sobj= jBean.localValidateCard();
       
	Vector v=new Vector();
	if(sobj.getStatus()){
	  	v=(Vector)(sobj.getData());
	} 
	if(v==null || v.size()==0){
		session.setAttribute("regerrors",null);
		sobj=jBean.registerEvent();
		DbUtil.executeUpdateQuery("delete from trackurl_transaction where trackingcode is null", new String []{});
		String trackingCode=DbUtil.getVal("select trackingcode from trackurl_transaction where transactionid=?  and trackingcode is not null", new String []{jBean.getTransactionId()}); 
		if(trackingCode!=null){
		DbUtil.executeUpdateQuery("update event_reg_transactions set trackpartner=? where tid=?", new String []{trackingCode,jBean.getTransactionId()});
		}
		jBean.setObject("insertedentry", "Y");
			if(!(sobj.getStatus())){
		
		     response.sendRedirect(response.encodeURL(com.eventbee.general.PageUtil.appendLinkWithGroup(contextpath+"/guesttasks/regerror.jsp",(HashMap) request.getAttribute("REQMAP"))));
		}else{
		
		
		
		
			sobj=jBean.ExtValidateCard();
			if(!(sobj.getStatus())){
			    /* Commented 1/5/2008. Now using RegistrationEmail.java for registraion flow email sending.*/
				//jBean.SendEmail(jBean.getProxy());
				StatusObj statob=DbUtil.executeUpdateQuery("update transaction set payment_status=? where transactionid=?", new String []{"Completed",jBean.getTransactionId()});

				if("FB".equals(request.getParameter("context"))){
					response.sendRedirect(response.encodeURL(com.eventbee.general.PageUtil.appendLinkWithGroup(contextpath+"/guesttasks/regend.jsp?isreload=yes&context=FB",(HashMap) request.getAttribute("REQMAP"))));
					return;
				}else{
				
				  String paltform=(String)session.getAttribute("platform");
				 
				  String domain=(String)session.getAttribute("domain");
				   String oid=(String)session.getAttribute("ningoid");
				
				
				
				if("ning".equals(paltform))
				{
				
				%>
				<script>
				top.location.href='http://<%=domain%>/opensocial/application/show?appUrl=http%3A%2F%2Fwww.eventbee.com%2Fhome%2Fning%2Feventregister.xml%3Fning-app-status%3Dnetwork&owner=<%=oid%>&view_eventid=<%=jBean.getEventId()%>&view_purpose=regdone';
				</script>
				<%

				return;
				}
				
				
				
				
					response.sendRedirect(response.encodeURL(com.eventbee.general.PageUtil.appendLinkWithGroup(contextpath+"/guesttasks/regend.jsp?isreload=yes",(HashMap) request.getAttribute("REQMAP"))));
					return;
				}
			}else{
				 jBean.setObject("insertedentry", null);
				 jBean.removeRegFromDB();
				 DbUtil.executeUpdateQuery("delete from event_reg_transactions where tid=?", new String []{jBean.getTransactionId()});
				 DbUtil.executeUpdateQuery("delete from transaction_tickets where tid=?", new String []{jBean.getTransactionId()});
				 if(sobj.getData() instanceof Vector)
					v =(Vector)(sobj.getData());
				 else if(sobj.getData() instanceof String){
				
					response.sendRedirect(response.encodeURL(com.eventbee.general.PageUtil.appendLinkWithGroup(contextpath+"/guesttasks/regerror.jsp",(HashMap) request.getAttribute("REQMAP"))));
				}
			}
		}
	}
	if(v!=null && v.size()>0){
		session.setAttribute("regerrors",v);
		session.setAttribute("regEventBean",jBean);
		if("FB".equals(request.getParameter("context"))){
			response.sendRedirect(response.encodeURL(com.eventbee.general.PageUtil.appendLinkWithGroup((String)session.getAttribute("HTTPS_SERVER_ADDRESS")+contextpath+"/guesttasks/regpayment.jsp?context=FB",(HashMap) request.getAttribute("REQMAP"))));
			return;
		}else{
			response.sendRedirect(response.encodeURL(com.eventbee.general.PageUtil.appendLinkWithGroup((String)session.getAttribute("HTTPS_SERVER_ADDRESS")+contextpath+"/guesttasks/regpayment.jsp",(HashMap) request.getAttribute("REQMAP"))));
			return;
		}
	}
}

%>

