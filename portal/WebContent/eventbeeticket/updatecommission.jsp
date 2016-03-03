<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%

HashMap hm=null;
String position=request.getParameter("val");
String valueToSet=request.getParameter("price");
String purpose = request.getParameter("purpose");
String Message=("comission".equals(purpose))?"Commission is invalid":"Ticket count is invalid";
Vector vec=(Vector)session.getAttribute("NetworkCommission");
String numberType= ("comission".equals(purpose))?"Double":"Integer";
String keyToSet= ("comission".equals(purpose))?"commission":"partnerlimit";
boolean valid=false;
		
if("".equals(valueToSet)){
	Message=("comission".equals(purpose))?"Commission is empty":"Ticket count is empty";
}else{
	StatusObj status=EventBeeValidations.isValidNumber(valueToSet,purpose,numberType);
	if(status.getStatus()){
		valid= (Double.parseDouble(valueToSet)>=0);
	}
}
if(vec==null || vec.size()<Integer.parseInt(position)){
	valid=false;
	Message="There is an error in updating data";
}
if(valid){
	hm=(HashMap)vec.elementAt(Integer.parseInt(position)-1);
	if("ticketcount".equals(purpose)){
  		int maxcount=Integer.parseInt((String)hm.get("maxcount"));
  		if(maxcount<Integer.parseInt(valueToSet)){
			valid=false;
			Message="Ticket count is more than maximum permitted tickets for sale";
  		}  		
  	}else{
  		double ticketPrice =Double.parseDouble((String)hm.get("ticket_price"));
		if(ticketPrice<Double.parseDouble(valueToSet)){
			valid=false;
			Message="Commission is more than ticket price.";
  		}  	
  	}
  	
}
if(valid){
	hm.put(keyToSet,valueToSet);
	vec.setElementAt(hm,Integer.parseInt(position)-1);
	session.setAttribute("NetworkCommission",vec);
	out.print("<status>Success</status>");
}
else{
	out.print("<span>"+Message+"</span>");
	
}

%>






