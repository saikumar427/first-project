<%@ page import="com.eventbee.general.*" %>
<%!

String DELETE_PRICE="delete from partner_friends_commission where partnerid =? and eventid=? ";
String INSERT_PRICE="insert into partner_friends_commission(eventid,otherscommision ,partnerid,friendscommission) values (?,?,?,?)";

%>

<%
String eventid=request.getParameter("userid");
String edittext=null;
String edittext1=null;
String partnerid=request.getParameter("partnerid");
StatusObj sbobject=null;
StatusObj sbobject1=null;
try
{
 edittext=request.getParameter("others");
 edittext1=request.getParameter("friends");

if(Integer.parseInt(edittext)<0||Integer.parseInt(edittext1)<0)
	out.println("Invalid");
else
{
sbobject=EventBeeValidations.isValidNumber(edittext,"Amount","Double");
sbobject=EventBeeValidations.isValidNumber(edittext,"Amount","Float");
sbobject1=EventBeeValidations.isValidNumber(edittext1,"Amount","Double");
sbobject1=EventBeeValidations.isValidNumber(edittext1,"Amount","Float");
}
if(Integer.parseInt(edittext)<0||Integer.parseInt(edittext1)<0)
	out.println("Invalid");
else{
	DbUtil.executeUpdateQuery(DELETE_PRICE,new String[]{partnerid,eventid});
	StatusObj sbj=DbUtil.executeUpdateQuery(INSERT_PRICE,new String[]{eventid,edittext,partnerid,edittext1});
	
	if(sbj.getStatus())
	out.println("Success");
}

}
catch(Exception e)
{out.println("Invalid");

}

%>

	