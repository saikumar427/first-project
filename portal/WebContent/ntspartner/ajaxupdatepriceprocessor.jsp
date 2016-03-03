<%@ page import="com.eventbee.general.*" %>
<%!

String DELETE_PRICE="delete from partner_listing_price where partnerid =(select partnerid from group_partner where userid=? and status='Active') and purpose='NETWORK_EVENT_LISTING'"
                                  +" and duration=?";
String INSERT_PRICE="insert into partner_listing_price(userid,partnerid,duration,duration_type,amount,purpose) values (?,(select partnerid from group_partner where userid=? and status='Active'),?,'week',?,'NETWORK_EVENT_LISTING')";

%>

<%


String userid=request.getParameter("userid");
StatusObj sbobject=null;
String duration=request.getParameter("duration");

String edittext=request.getParameter("edittext");
sbobject=EventBeeValidations.isValidNumber(edittext,"Amount","Double");


if(!sbobject.getStatus() || Double.parseDouble(edittext)<0.1 ){

out.println("<status>Invalid</status>");

}else{
	DbUtil.executeUpdateQuery(DELETE_PRICE,new String[]{userid,duration});
	StatusObj sbj=DbUtil.executeUpdateQuery(INSERT_PRICE,new String[]{userid,userid,duration,edittext});
	
	if(sbj.getStatus())
	out.println("<status>Success</status>");
}

%>


