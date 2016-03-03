function calcCCVal(){

var tickprice=document.getElementById("tickprice").value;

var tickcnt=document.getElementById("tickcpunt").value;
var ccfixedfee=document.getElementById("ccff").value;
var ccpf=document.getElementById("ccpf").value;
var ccamount=(tickcnt*tickprice*(ccpf/100))+(tickcnt*ccfixedfee);
var paypalamount=(tickcnt*tickprice*(2.5/100))+(tickcnt*0.30);
var googleamount=(tickcnt*tickprice*(2/100))+(tickcnt*0.20);
var ebeeamount=(tickcnt*tickprice*(4.95/100))+(tickcnt*0.50);
var googlesave=ccamount-googleamount;
var paypalsave=ccamount-paypalamount;
var ebeesave=ccamount-ebeeamount;
document.getElementById('showCCAmountInfo').innerHTML="You save approximately <font color='red'><b>$"+googlesave+"</b></font> with Google Checkout,  <font color='red'><b>$"+paypalsave+"</b></font> with PayPal in Credit Card Processing Fee by switching to Eventbee" ;

}

<%
StringBuffer stylecontent=new StringBuffer("");

StringBuffer streamercontent=new StringBuffer("");
stylecontent.append("<style type=\"text/css\">");
stylecontent.append(".subheader{ font-family: Times New Roman, Times, serif; font-size: 20px; font-weight: normal; padding-left: 5px; padding-right: 5px; padding-top: 2px; padding-bottom:2px; color: #3300FF;}");
stylecontent.append(".taskbox{ background-color: #ccff99; padding-top: 5px; padding-right: 5px; padding-bottom: 5px;padding-left: 5px}");
stylecontent.append(".smallfont { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #333333; font-weight: lighter}");
stylecontent.append(".inputvalue { padding-left: 5px; padding-right: 5px; padding-top: 2px; padding-bottom:2px}");

stylecontent.append("</style>");

streamercontent.append("<table align=\"left\"  class=\"taskbox\" width=\"100%\" height=\"40%\" cellpadding=\"0\" >");
streamercontent.append("<tr><td width=\"10%\" height=\"30\" class=\"subheader\">My credit card processing fee savings</td></tr>");
streamercontent.append("<tr><td width=\"10%\" height=\"40\" class=\"smallfont\">1. My average ticket price: $<input type=\"text\"  name=\"tickprice\" id=\"tickprice\" size=\"2\" value=\"100\"/>");
streamercontent.append("</td></tr>");
streamercontent.append("<tr><td width=\"10%\" height=\"40\" class=\"smallfont\">2. Number of tickets I sell per year: <input type=\"text\"  name=\"tickcpunt\" id=\"tickcpunt\" size=\"2\" value=\"1000\"/>");
streamercontent.append("</td></tr><tr><td height=\"40\" class=\"smallfont\" >3. I am currently paying Credit Card Processing Fee of <input type=\"text\"  name=\"ccpf\"  id=\"ccpf\" size=\"2\" value=\"5\"/>% +  $<input type=\"text\"  name=\"ccff\" id=\"ccff\" size=\"2\" value=\"0.50\"/>");
streamercontent.append("</td></tr>");
streamercontent.append("<tr><td align=\"center\">");

streamercontent.append("<input type=\"button\"  name=\"submit\" size=\"5\" value=\"Show me savings now!\" onClick=\"calcCCVal();\" />");
streamercontent.append("</td></tr><tr><td id=\"showCCAmountInfo\" height=\"40\" class=\"smallfont\"></td></tr></table>");
%>
document.write('<%=stylecontent%>');

document.write('<%=streamercontent%>')
