<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.event.*"%>

<%
EventRegisterBean jBean=(EventRegisterBean)session.getAttribute("regEventBean");
String groupid=request.getParameter("GROUPID");

if(groupid==null)
groupid=request.getParameter("groupid");

String couponExists="";
String discountcode=request.getParameter("discountcode");
if(discountcode==null||"null".equals(discountcode)){
discountcode=(String)session.getAttribute("discountcode_"+groupid);

}
if(discountcode==null||"null".equals(discountcode))
discountcode="";
else
discountcode=discountcode.trim();
couponExists=DbUtil.getVal("select distinct 'yes' from coupon_master where groupid=? and coupontype='General'",new String []{groupid});

if("yes".equals(couponExists)){
%>
<table>
<tr><td>Have a discount code, enter it here
</td>
<td><input type="text" name="couponcode" id="couponcode" size="10" value="<%=discountcode%>" /></td>
<input type="hidden" name="couponprice" id="couponprice"  value="" />
<td><input type="button" name="submit" value="Apply" onClick="validateCoupon('General','isnew')"/></td>
</tr>
</table>

<%}%>


