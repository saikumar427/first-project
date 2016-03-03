<%@ page import="com.eventbee.general.*"%>


<%
String groupid=request.getParameter("GROUPID");
String seltkt=request.getParameter("seltkt");
String couponExists="";

couponExists=DbUtil.getVal("select distinct 'yes' from coupon_master where groupid=? and coupontype='Member'",new String []{groupid});
if("yes".equals(couponExists)){
String desc=DbUtil.getVal("select description from coupon_master where groupid=? and coupontype='Member'",new String []{groupid});
%>
<table>
<input type='hidden' name='GROUPID' value='<%=groupid%>' />
<tr><td>Member Discount, enter  </td>
<td>user name <input type="text" name="username" id="username" size="12" value="" /></td>
<td>password <input type="password" name="password" id="password"  size="12" value="" /></td>
<td><input type="button" name="submit" value="Apply" onClick="validateCoupon('Member','isnew')"/></td>
</tr>
<% if(desc!=null&&!"".equals(desc)){%>
<tr><td><font class="smallestfont" >(<%=desc%>)</font></td></tr>
<%}
%>

</table>

<%}%>

