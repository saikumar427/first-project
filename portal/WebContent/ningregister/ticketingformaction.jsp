<%@ page import="org.json.JSONObject,org.json.JSONArray"%>
<%@ page import="java.util.HashMap,java.util.ArrayList"%>
<%@ include file="TicketingManager.jsp" %>
<%@ include file="ProfileManager.jsp" %>
<%@ include file="DiscountsManager.jsp" %>
<%@ include file="TicketsJsonBuilder.jsp" %>
<%!
HashMap processSelectedTickets(HashMap discountedTicketsMap,HttpServletRequest req,String ticketid){
HashMap ticketHash=new HashMap();
String ticketname=DbUtil.getVal("select ticket_name  from price where price_id=?",new String[]{ticketid});
ticketHash.put("qty",req.getParameter("ticketqty_"+ticketid));
ticketHash.put("price",req.getParameter("price_"+ticketid));
ticketHash.put("ticketname",ticketname);
ticketHash.put("processfee",req.getParameter("processfee_"+ticketid));
ticketHash.put("finalprice",req.getParameter("price_"+ticketid));
ticketHash.put("finalprocessfee",req.getParameter("processfee_"+ticketid));
if("Y".equals(req.getParameter("submitdiscount"))){
if(discountedTicketsMap.containsKey(ticketid)){
HashMap discountHash=(HashMap)discountedTicketsMap.get(ticketid);
String isdonation=(String)discountHash.get("isdonation");
if(!"Yes".equals(isdonation)){
ticketHash.put("discount",discountHash.get("discount"));
ticketHash.put("finalprice",discountHash.get("final_price"));
}
String finalprice=(String)discountHash.get("final_price");


try{
if(Double.parseDouble(finalprice)==0)
ticketHash.put("finalprocessfee","0.00");
}catch(Exception e){
ticketHash.put("finalprocessfee","0.00");
}
}else{
ticketHash.put("discount","0.00");
}
}else{
ticketHash.put("discount",req.getParameter("discount_"+ticketid));
ticketHash.put("finalprice",req.getParameter("finalprice_"+ticketid));
ticketHash.put("finalprocessfee",req.getParameter("finalprocessfee_"+ticketid));
}

return ticketHash;
}
%>
<%
String tid=request.getParameter("tid");
String eventid=request.getParameter("eid");
TicketingManager ticketingManager = new TicketingManager();
JSONObject jsonresponseobj=new JSONObject();
HashMap discountedTicketsMap=new HashMap();
try{
ticketingManager.clearOldTickets(tid);
if("Y".equals(request.getParameter("submitdiscount"))){
	String discountcode=request.getParameter("discountcode");
	JSONObject discountsMsgObject=new JSONObject();
	JSONArray discountsArray=new JSONArray();
	DiscountsManager discountsManager = new DiscountsManager();
	HashMap discountinfomap=discountsManager.getDiscountInfo(discountcode, eventid, tid);
	String discountMsg=(String)discountinfomap.get("message");
	ArrayList eventTickets=(ArrayList)discountinfomap.get("discountedtickets");
	if(eventTickets!=null&&eventTickets.size()>0){
		for(int i=0;i<eventTickets.size();i++){
		JSONObject DiscounMap =new JSONObject();
		HashMap hm=(HashMap)eventTickets.get(i);
		discountedTicketsMap.put((String)hm.get("ticketid"),hm);
		DiscounMap.put("ticketid",(String)hm.get("ticketid"));
		DiscounMap.put("final_price",(String)hm.get("final_price"));
		DiscounMap.put("discount",(String)hm.get("discount"));
		DiscounMap.put("price",(String)hm.get("price"));
		DiscounMap.put("isdonation",(String)hm.get("isdonation"));
		discountsArray.put(DiscounMap);
		}
	}
	discountsMsgObject.put("IsCouponsExists","Y");
	discountsMsgObject.put("discountapplied","Y");
	discountsMsgObject.put("discountmsg",discountMsg);
	discountsMsgObject.put("discountcode",discountcode);
	jsonresponseobj.put("discountedprices",discountsArray);
	jsonresponseobj.put("discounts",discountsMsgObject);
}
//--------------Required ticket processing----------------------------//
String ticketid=request.getParameter("ticketSelect");
if(ticketid!=null){
HashMap ticketHash=processSelectedTickets(discountedTicketsMap, request,ticketid);
ticketingManager.insertTicketInfo(tid,  ticketid, ticketHash, "required");
}
//--------------Optional tickets processing----------------------------//
String selectedOptTickets [] =request.getParameterValues("optTicketSelect");
if(selectedOptTickets!=null&&selectedOptTickets.length>0){
for(int i=0;i<selectedOptTickets.length;i++){
ticketid=selectedOptTickets[i];
HashMap ticketHash=processSelectedTickets(discountedTicketsMap, request,ticketid);
ticketingManager.insertTicketInfo(tid,  ticketid, ticketHash, "optional");
}
}
ticketingManager.setTransactionAmounts(eventid, tid);
TicketsJsonBuilder ticketJsonBuilder=new TicketsJsonBuilder();
ticketJsonBuilder.fillAmountDetails(ticketingManager.getRegTotalAmounts(tid),jsonresponseobj);
if("Y".equals(request.getParameter("submitprofile"))){
	ProfileManager profileManager = new ProfileManager();
	boolean profilestatus=profileManager.insertAttendeeProfile(request);
	if(!profilestatus) jsonresponseobj.put("profilestatus","error");
}
}catch(Exception e){
jsonresponseobj.put("status","error");
}
out.print(jsonresponseobj.toString());
%>
