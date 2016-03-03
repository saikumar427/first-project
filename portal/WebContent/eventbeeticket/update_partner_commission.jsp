<%@ page import="com.eventbee.general.*" %>
<%!

String DELETE_PRICE="delete from partner_ticket_commision where	price_id  =? and eventid=? and partnerid=?";
String INSERT_PRICE="insert into partner_ticket_commision(eventid,commision,partnerlimit,price_id,partnerid) values (?,?,?,?,?)";

%>

<%
String eventid=request.getParameter("userid");
String priceid=request.getParameter("priceid");
String partnerid=request.getParameter("partnerid");
String purpose=request.getParameter("purpose");
System.out.println(purpose);
String edittext="";
String editcount="";
boolean valid=true;
StatusObj sbobject=null;
if("comission".equals(purpose)){
	edittext=request.getParameter("edittext");
	editcount=request.getParameter("partnerlimit");
	sbobject=EventBeeValidations.isValidNumber(edittext,"Amount","Double");
	if(!sbobject.getStatus() || (Double.parseDouble(edittext)<0)){
	          valid=false;
		out.println("<span>Invalid commission</span>");
		
	}else{
	String tiketprice=DbUtil.getVal("select ticket_price  from price a where price_id=?", new String[]{priceid});
	if(Double.parseDouble(tiketprice)<Double.parseDouble(edittext)){
		valid=false;
	        out.println("<span>Commission is more than price</span>");
		}
	}
}else{
	edittext=request.getParameter("commission");
	editcount=request.getParameter("editcount");
	sbobject=EventBeeValidations.isValidNumber(editcount,"Limit","Integer");
	if(!sbobject.getStatus() ||  Integer.parseInt(editcount)<0){
		valid=false;
		out.println("<span>Invalid ticket count</span>");
	}else{
		String maxTickets=DbUtil.getVal("select max_ticket from price where price_id=?", new String[]{priceid});
		if(Integer.parseInt(maxTickets)<Integer.parseInt(editcount)){
			valid=false;
			out.println("<span>Ticket count is more than maximum permitted tickets for sale</span>");
		}
	}
}

if(valid){
	DbUtil.executeUpdateQuery(DELETE_PRICE,new String[]{priceid,eventid,partnerid});
	StatusObj sbj=DbUtil.executeUpdateQuery(INSERT_PRICE,new String[]{eventid,edittext,editcount,priceid,partnerid});
	out.println("<status>Success</status>");
}
%>


