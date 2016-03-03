<%@ page import="java.util.ArrayList,java.util.HashMap,org.json.*,com.eventregister.*,com.event.dbhelpers.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%
String eid=request.getParameter("eid");
String code=request.getParameter("code");
String discountcode=request.getParameter("code");
	JSONObject discountsMsgObject=new JSONObject();
	JSONObject jsonresponseobj=new JSONObject();
	JSONArray discountsArray=new JSONArray();
	DiscountsManager discountsManager = new DiscountsManager();
	HashMap DiscountLabels=DisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
	HashMap discountinfomap=discountsManager.getDiscountInfo(code, eid, "NO",DiscountLabels);
	String discountMsg=(String)discountinfomap.get("message");
	ArrayList eventTickets=(ArrayList)discountinfomap.get("discountedtickets");
	discountsMsgObject.put("validdiscount","N");
	if(eventTickets!=null&&eventTickets.size()>0){
		for(int i=0;i<eventTickets.size();i++){
		JSONObject DiscounMap =new JSONObject();
		HashMap hm=(HashMap)eventTickets.get(i);
		DiscounMap.put("ticketid",(String)hm.get("ticketid"));
		DiscounMap.put("final_price",(String)hm.get("final_price"));
		DiscounMap.put("discount",(String)hm.get("discount"));
		DiscounMap.put("price",(String)hm.get("price"));
		DiscounMap.put("isdonation",(String)hm.get("isdonation"));
		DiscounMap.put("haveDiscount",(String)hm.get("haveDiscount"));
		discountsArray.put(DiscounMap);
	       }
	discountsMsgObject.put("validdiscount","Y");
	}
	discountsMsgObject.put("IsCouponsExists","Y");
	discountsMsgObject.put("discountapplied","Y");
	discountsMsgObject.put("discountmsg",discountMsg);
	discountsMsgObject.put("discountcode",code);
	jsonresponseobj.put("discountedprices",discountsArray);
	jsonresponseobj.put("discounts",discountsMsgObject);
out.println(jsonresponseobj.toString());	
	
%>