function calcVal(){

var tktprice=document.getElementById("tktprice").value;

var tktcnt=document.getElementById("tktcpunt").value;
var fixedfee=document.getElementById("ff").value;
var pf=document.getElementById("pf").value;
var amount=(tktcnt*tktprice*(pf/100))+(tktcnt*fixedfee);
var eventbeeamt=tktcnt*1;
var savedamt=amount-eventbeeamt;
document.getElementById('showAmountInfo').innerHTML="You save <font color='red'><b>$"+savedamt+"</b></font> in Service Fee by switching to Eventbee Basic Ticketing!" ;

}

<%
StringBuffer stylecontent=new StringBuffer("");

StringBuffer streamercontent=new StringBuffer("");
stylecontent.append("<style type=\"text/css\">");
stylecontent.append(".subheader{ font-family: Times New Roman, Times, serif; font-size: 20px; font-weight: normal; padding-left: 5px; padding-right: 5px; padding-top: 2px; padding-bottom:2px; color: #3300FF;}");
stylecontent.append(".taskbox{padding-top: 5px; padding-right: 5px; padding-bottom: 5px;padding-left: 5px}");
stylecontent.append(".smallfont { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #333333; font-weight: lighter}");
stylecontent.append(".inputvalue { padding-left: 5px; padding-right: 5px; padding-top: 2px; padding-bottom:2px}");

stylecontent.append("</style>");

streamercontent.append("<table align=\"left\" width=\"100%\" height=\"40%\" cellpadding=\"0\" >");
streamercontent.append("<tr><td width=\"100%\"><table width=\"100%\">");
streamercontent.append("<tr><td height=\"40\">1. My average ticket price: $<input type=\"text\"  name=\"tktprice\" id=\"tktprice\" size=\"2\" value=\"100\"/>");
streamercontent.append("</td></tr>");
streamercontent.append("<tr><td height=\"40\">2. Number of tickets I sell per year: <input type=\"text\"  name=\"tktcpunt\" id=\"tktcpunt\" size=\"2\" value=\"1000\"/>");
streamercontent.append("</td></tr><tr><td height=\"40\">3. I am currently paying Service Fee of <input type=\"text\"  name=\"pf\"  id=\"pf\" size=\"2\" value=\"2.5\"/>% +  $<input type=\"text\"  name=\"ff\" id=\"ff\" size=\"2\" value=\"1\"/>");
streamercontent.append("</td></tr></table></td>");
streamercontent.append("<td valign=\"top\"><table width=\"100%\"><tr><td><img src=\"/main/images/home/savings_greybg.png\"></td></tr></table>");
streamercontent.append("</td></tr>");
streamercontent.append("<tr><td align=\"left\" width=\"100%\" colspan=\"2\">");

streamercontent.append("<table width=\"100%\"><tr><td align=\"left\" ><input type=\"button\"  name=\"submit\" size=\"5\" value=\"Show Me Savings\" onClick=\"calcVal();\" />");

streamercontent.append("</td><td id=\"showAmountInfo\"></td></tr></table></td></tr></table>");
%>
document.write('<%=stylecontent%>');

document.write('<%=streamercontent%>')
