<%@ page import="com.eventbee.general.*" %>
<%
StringBuffer sb=new StringBuffer();
sb.append("<div style='margin-top:10px'>");
sb.append("<table width='800' border='0' cellpadding='0' cellspacing='0' align='center'>");
sb.append("<tr>");
sb.append("<td height='1' bgcolor='black' colspan='2'></td>");
sb.append("</tr>");
sb.append("<tr>");
sb.append("<td colspan='2' height='16'>");
sb.append("<div align='center'><font face='Verdana, Arial, Helvetica, sans-serif' size='-3'>");
sb.append("</font>");
sb.append("<div align='center'><a href=javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links/aboutus.html',''); STYLE='text-decoration: none'>");
sb.append("<span class='footertab'>About Us</span></a><span class='footertab'>");
sb.append("| </span><a href=javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links/privacystatement.html',''); STYLE='text-decoration: none'>");
sb.append("<span class='footertab'>Privacy Statement</span></a><span class='footertab'> | </span>");
sb.append("<a href=javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links/termsofservice.html',''); STYLE='text-decoration: none'>");
sb.append("<span class='footertab'>Terms of Service</span></a><span class='footertab'> | </span>");
sb.append("<a href=javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links/trademarks.html',''); STYLE='text-decoration: none'>");
sb.append("<span class='footertab'>Trade Marks</span></a><span class='footertab'> | </span>");
sb.append("<a href=javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links/contact.html',''); STYLE='text-decoration: none'>");
sb.append("<span class='footertab'>Contact</span></a></div>");
sb.append("</div>");
sb.append("</td>");
sb.append("</tr>");
sb.append("<tr>");
sb.append("<td colspan='2' height='18'>");
sb.append("<div align='center'><span class='footertab'>");
sb.append("Copyright 2004. "+EbeeConstantsF.get("application.name","")+". All Rights Reserved");

sb.append("</span></div>");
sb.append("</td>");
sb.append("</tr>");
sb.append("<tr>");
sb.append("<td height='19' valign='middle' align='center' width='841'>");
sb.append("<div align='right'></div>");

sb.append("</td>");
sb.append("<td height='19' valign='top' align='center' width='126'><a href='http://www.eventbee.com' target='_blank'>");

sb.append("<img src='/home/images/poweredby.jpg' border='0' /></a></td>");
sb.append("</tr>");
sb.append("</table>");

sb.append("</div>");
sb.append(" </td>");
sb.append("</tr>");
sb.append("</table>");

request.setAttribute("BASICEVENTFOOTER",sb.toString());
//out.println(sb.toString());

%>
