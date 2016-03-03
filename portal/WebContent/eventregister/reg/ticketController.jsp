<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.general.GenUtil"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>





<%

      Authenticate au=null;
	String partnerid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
	String pfriendid=Presentation.GetRequestParam(request,  new String []{"fid","friendid"});
	EventRegisterBean jBean=(EventRegisterBean)session.getAttribute("regEventBean");
	if(jBean==null){
		response.sendRedirect("/guesttasks/regerror.jsp");
		return;
	}
	if("Y".equals((String)jBean.getObject("insertedentry"))){
			response.sendRedirect("/guesttasks/regend.jsp?GROUPID="+jBean.getEventId());
			return;
	}
	EventTicket evt=new EventTicket();

String command=request.getParameter("submit");
String ticketid=request.getParameter("ticketSelect");
String discount=request.getParameter("discount_"+ticketid);
String code=request.getParameter("discountcode");
String paytype=request.getParameter("/selectPayType");
String taxAmount=request.getParameter("taxAmount");
String memberlogin=request.getParameter("memberTicket");
String selectedtkt=request.getParameter("onlyonereq");
if(memberlogin==null||"".equals(memberlogin))
jBean.setCommunityLoginStatus(" ");
else
jBean.setCommunityLoginStatus(memberlogin);


double tax=0.0;
if(taxAmount!=null&&!"".equals(taxAmount))
tax=Double.parseDouble(CurrencyFormat.getCurrencyFormat("",taxAmount,true));

jBean.setTaxAmount(tax);
double dis=0.0;

if(discount!=null&&!"".equals(discount.trim())){
dis=Double.parseDouble(discount);
}

//For Special partner price


if((jBean.getAgentId()!=null && !"".equals(jBean.getAgentId()) && !"null".equals(jBean.getAgentId()))){
	if(dis>0){
	code="Partner Discount(Web)";
	}
	if((jBean.getFriendId()!=null && !"".equals(jBean.getFriendId()) &&!"null".equals(jBean.getFriendId()))){
      if(dis>0){
	
       code="Partner Discount(Friend)";
       }
       }
	
}
// End of Special partner price

if(paytype==null)
	paytype="eventbee";

if(ticketid==null||"null".equals(ticketid))ticketid="";
session.setAttribute("regerrors",null);
jBean.setTicketSelect(ticketid);
String selectqty=null;
EventTicket [] publictickets=jBean.getPublicTickets();
if(publictickets!=null){
	for(int i=0;i<publictickets.length;i++){
		EventTicket ticket=publictickets[i];
		int j=i+1;
		
		selectqty=request.getParameter("/publicTickets["+j+"]/ticketQty");
		String updateprice=request.getParameter("discost_"+ticketid);
		
		if(!"".equals(updateprice)&&updateprice!=null&&Double.parseDouble(updateprice)==0){
                jBean.getPublicTickets()[i].setTicketPrice(updateprice);
	         jBean.getPublicTickets()[i].setTicketProcessFee(updateprice);
	      
		
	        }
		if(discount!=null&&!"".equals(discount)){
		
	        jBean.getPublicTickets()[i].setSelDiscount(dis);
	        jBean.getPublicTickets()[i].setDiscount(discount);
	        }
	        else
	        {
	        jBean.getPublicTickets()[i].setSelDiscount(0.0);
		jBean.getPublicTickets()[i].setDiscount("");
	        }
	        
		jBean.getPublicTickets()[i].setTicketQty(selectqty);
		if(code!=null&&!"".equals(code.trim()))
		jBean.getPublicTickets()[i].setCouponCode(code);
		
	}
}

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"TicketController.jsp",null,"#####################SELECTED OPTIONAL TICKETS#####################"+GenUtil.stringArrayToStr(request.getParameterValues("optTicketsSelect"),","),null);

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"TicketController.jsp",null,"#####################SELECTED REQUIRED TICKETS#####################"+ticketid,null);
						
jBean.setOptTicketsSelect(request.getParameterValues("optTicketsSelect"));


EventTicket [] optionaltickets=jBean.getOptTickets();
HashMap hm1=new HashMap();
if(optionaltickets!=null){

	for(int i=0;i<optionaltickets.length;i++){
		EventTicket ticket=optionaltickets[i];
		int j=i+1;
		dis=0.0;
		selectqty=request.getParameter("/optTickets["+j+"]/ticketQty");
		 ticketid=optionaltickets[i].getTicketId();
		
		 String donation=request.getParameter("donation_"+ticketid);
		 
		 String process=request.getParameter("processfeeOptional"+i);
		 String updateprice=request.getParameter("discost_"+ticketid);
		 		if(!"".equals(updateprice)&&updateprice!=null&&Double.parseDouble(updateprice)==0){
		                jBean.getOptTickets()[i].setTicketPrice(updateprice);
		 	         jBean.getOptTickets()[i].setTicketProcessFee(updateprice);
		 	       
	         }
	          if(donation!=null&&!"0".equals(donation)&&!"".equals(donation)){
	         jBean.getOptTickets()[i].setTicketPrice(donation);
	         jBean.getOptTickets()[i].setTicketDisplayPrice(donation);
	         }
	          if(donation!=null&&!"0".equals(donation)&&!"".equals(donation)){
	           jBean.getOptTickets()[i].setTicketQty("1");
	        }
	        jBean.getOptTickets()[i].setTicketQty(selectqty);
		if(request.getParameter("discount_"+ticketid)!=null&&!"".equals(request.getParameter("discount_"+ticketid))){
		discount=request.getParameter("discount_"+ticketid);
		
		if(discount!=null&&!"".equals(discount.trim())){
		dis=Double.parseDouble(discount);
}               
              
		jBean.getOptTickets()[i].setSelDiscount(dis);
		jBean.getOptTickets()[i].setDiscount(discount);
		 
		}
		else{
		
		jBean.getOptTickets()[i].setSelDiscount(0.0);
		jBean.getOptTickets()[i].setDiscount("");
		}
		
		if(code!=null&&!"".equals(code.trim()))
		jBean.getOptTickets()[i].setCouponCode(code);
		 
	}
	
}
       
        
      StatusObj sobj=jBean.validateRegTickets();
String str="";
	if(sobj.getStatus()){
		HashMap hm=(HashMap)sobj.getData();
		if(hm!=null&&hm.size()>0){
		Set keys=hm.keySet();
		
		Iterator it=keys.iterator();
		str="<table>";
		while(it.hasNext())
		
		{
		String s=(String)it.next();
		str=str+"<tr><td>"+hm.get(s)+"</td></tr>";
		}
		str=str+"</table>";
		
	}
	else
	str="<data>Ticketsuccess</data>";
	}else{
	
		if(jBean!=null){
		if(!jBean.getUpgradeRegStatus())
                 jBean.initProfile(1);
	
			str="<data>Ticketsuccess</data>";
		}else{
			str="<data>Ticketerror</data>";
		}
	
	}	
	
	
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"TicketController.jsp",null,"#####################SELECTED PAYMENT TYPE IS#####################--"+paytype,null);
	
	out.print(str);
	jBean.setSelectPayType(paytype);
	
%>
