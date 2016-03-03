<%
StringBuffer sb=new StringBuffer();
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.eventbee.com");
String continueurl=null;

sb.append("<?xml version='1.0' encoding='UTF-8'?>");

sb.append("<checkout-shopping-cart xmlns='http://checkout.google.com/schema/2'>");
  sb.append("<shopping-cart>");
    sb.append("<items>");
      sb.append("<item>");
        sb.append("<item-name>"+GenUtil.AllXMLEncode(eventname)+" - Event Registration Charges</item-name>");
        sb.append("<item-description></item-description>");
        sb.append("<unit-price currency='USD'>"+grandtotal+"</unit-price>");
        sb.append("<quantity>1</quantity>");
      sb.append("</item>");
    sb.append("</items>");
    sb.append("<merchant-private-data>");
                     sb.append(xmldata);
                           
        sb.append("</merchant-private-data>");
  sb.append("</shopping-cart>");
  sb.append("<checkout-flow-support>");
    sb.append("<merchant-checkout-flow-support>");
    //sb.append("<merchant-calculations-url>http://test.eventbee.com:9090/eventregister/reg/googlenotification.jsp</merchant-calculations-url>");
    if("yes".equals(request.getParameter("fbcontext"))){
    	sb.append("<continue-shopping-url>");
        	sb.append("http://apps.facebook.com/"+EbeeConstantsF.get("fbapp.eventregapp.name","eventregistration")+"/registerdone?id="+ebee_transactionid+"&amp;source=Google&amp;fbcontext=yes&amp;GROUPID="+jBean.getEventId());
        sb.append("</continue-shopping-url>");
        sb.append("<edit-cart-url>http://apps.facebook.com/"+EbeeConstantsF.get("fbapp.eventregapp.name","eventregistration")+"/ticketedit?Gid="+jBean.getEventId()+"&amp;context=FB</edit-cart-url>");
    }else{
      sb.append("<continue-shopping-url>");
        sb.append(serveraddress+"/portal/guesttasks/processdata.jsp?id="+ebee_transactionid+"&amp;source=Google&amp;GROUPID="+jBean.getEventId());
      sb.append("</continue-shopping-url>");
      sb.append("<edit-cart-url>"+serveraddress+"/guesttasks/regticket.jsp?GROUPID="+jBean.getEventId()+"</edit-cart-url>");
      }
      
    sb.append("</merchant-checkout-flow-support>");
  sb.append("</checkout-flow-support>");
sb.append("</checkout-shopping-cart>");

request.setAttribute("GOOGLE_XML_DATA",sb.toString());

%>