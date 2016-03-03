
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.coupon.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ include file="/stylesheets/CoreRequestMap.jsp" %>
<%!
String CLASS_NAME="coupon/logic/CouponDel.jsp";
%>

<%
String platform = request.getParameter("platform");
String URLBase="mytasks";
if("ning".equals(platform)){
        URLBase="ningapp/ticketing";
}


String UNITID=request.getParameter("UNITID");
String GROUPID=request.getParameter("GROUPID");
String GROUPTYPE=request.getParameter("GROUPTYPE");

 String manid="";
 String groupid="";
 String grouptype=(String)session.getAttribute("grouptype");
Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
if (authData!=null){      
      	manid=authData.getUserID();	
	 groupid=(String)session.getAttribute(ContextConstants.SD_GROUP_ID);
}
String[] delop=(String[])session.getAttribute("delop");


CouponDB.deleteCoupons( delop,GROUPID);
session.setAttribute("delop",null);

	session.setAttribute("message","coupon.delete.done");
	session.setAttribute("title","Coupon");
	session.setAttribute("operation","Delete");
	response.sendRedirect(PageUtil.appendLinkWithGroup("/"+URLBase+"/eventmanage.jsp?GROUPID="+GROUPID,(HashMap)request.getAttribute("REQMAP")));
%>



</body>

</html>
