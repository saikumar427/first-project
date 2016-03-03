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
sb.append("<ebee-trans-id>"+ebee_transactionid+"</ebee-trans-id>");
sb.append("</merchant-private-data>");
sb.append("</shopping-cart>");
sb.append("<checkout-flow-support>");
sb.append("<merchant-checkout-flow-support>");
sb.append("<continue-shopping-url>");
sb.append(serveraddress+"/embedded_reg/googlesuccessreturn.jsp?tid="+ebee_transactionid+"&amp;eid="+eventid);
sb.append("</continue-shopping-url>");
sb.append("<edit-cart-url>"+serveraddress+"/embedded_reg/googlecancelreturn.jsp?eid="+eventid+"&amp;tid="+ebee_transactionid+"</edit-cart-url>");
sb.append("</merchant-checkout-flow-support>");
sb.append("</checkout-flow-support>");
sb.append("</checkout-shopping-cart>");
request.setAttribute("GOOGLE_XML_DATA",sb.toString());

%>