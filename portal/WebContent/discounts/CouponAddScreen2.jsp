
<%@ page import="java.io.*, java.util.*,java.text.*,java.sql.*,com.eventbee.coupon.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ include file="/stylesheets/CoreRequestMap.jsp" %>
<%!
String CLASS_NAME="coupon/logic/CouponAddScreen2.jsp";




%>

<%
String platform = request.getParameter("platform");
String URLBase="mytasks";
if("ning".equals(platform)){
        URLBase="ningapp/ticketing";
}

com.eventbee.util.RequestSaver rsv=new com.eventbee.util.RequestSaver(pageContext,"COUPON_HASH","session",true);
Map couponhash=(Map)session.getAttribute("COUPON_HASH");
String UNITID=request.getParameter("UNITID");
String GROUPID=request.getParameter("GROUPID");
String GROUPTYPE=request.getParameter("GROUPTYPE");


StatusObj statobj=null;
Map errorMap=(Map)session.getAttribute("errorMap");
errorMap.clear();
StringTokenizer st=null;
 String manid="";
 String groupid="";
 String grouptype=(String)session.getAttribute("grouptype");
Authenticate authData=AuthUtil.getAuthData(pageContext);
if (authData!=null){      
      	manid=authData.getUserID();	
	groupid=(String)session.getAttribute(ContextConstants.SD_GROUP_ID);
}


String name=request.getParameter("name").trim();
statobj=EventBeeValidations.isValidStr(name,"Name");
if(!statobj.getStatus())errorMap.put("name",statobj);

String desc=request.getParameter("desc").trim();
String discount=request.getParameter("discount").trim();

statobj=EventBeeValidations.isValidNumber(discount,"Discount","double",0.0);
//EventBeeValidations.getValiNum(discount);
if(!statobj.getStatus()){
errorMap.put("discount",statobj);
}else{
discount=statobj.getData().toString();
}
String count="";
String code_limittype=request.getParameter("code_limittype");
if("1".equals(code_limittype))
{
 count=request.getParameter("limit");

if(count==null||"".equals(count))
statobj=EventBeeValidations.isValidNumber(count,"Max Count","int",0);
if(!statobj.getStatus()){
errorMap.put("count",statobj);


}
}
int defcount=100000;

//String disctype="ABSOLUTE";

String codes=request.getParameter("codes").trim();
statobj=EventBeeValidations.isValidStr(codes,"Codes");


if(!statobj.getStatus())errorMap.put("codes",statobj);

String[] ticketarr=request.getParameterValues("ticket");
if(ticketarr==null){
statobj=new StatusObj(false,"No ticket checked",null);
errorMap.put("ticket",statobj);
couponhash.put("ticket",new String[0]);
}

String act=null;

String cut=null;




if(!errorMap.isEmpty()){
response.sendRedirect(PageUtil.appendLinkWithGroup("/"+URLBase+"/CouponAddScreen1.jsp;jsessionid="+session.getId()+"?groupid="+GROUPID+"&error=error",(HashMap)request.getAttribute("REQMAP")));
}else{

      
	if(couponhash!=null){
	couponhash.put("manid",manid);
	couponhash.put("GROUPID",GROUPID);
	couponhash.put("coupontype","General");
	couponhash.put("GROUPTYPE","Event");
	
	if("0".equals(code_limittype))
	couponhash.put("maxcount",defcount+"");
	else if("1".equals(code_limittype))
	couponhash.put("maxcount",count);
	
	String disctype="";
	String discounttype=(String)couponhash.get("discount_type");
	if("1".equals(discounttype))
	disctype="ABSOLUTE";
	else if("0".equals(discounttype))
	disctype="PERCENTAGE";
	if(disctype==null || "null".equalsIgnoreCase(disctype) || "".equals(disctype))
	disctype="ABSOLUTE";
	couponhash.put("disctype",disctype);
	CouponDB.insertCoupon(couponhash);
	
	/* String codes1=(String) couponhash.get("codes");
	String[] couponcodes=GenUtil.strToArrayStr(codes1,",");
	//String couponidsel="select  cc.couponid from  coupon_master cm ,coupon_codes cc where cc.couponid=cm.couponid and cm.groupid=? and cc.couponcode=?";
	String couponidsel="select  cm.couponid from  coupon_master cm  where cm.groupid=? order by created_at desc limit 1";
	String couponid=DbUtil.getVal(couponidsel,new String[]{GROUPID});
	DbUtil.executeUpdateQuery("update coupon_master set discounttype=?  where couponid=? and groupid=?",new String[]{disctype,couponid,GROUPID});
	*/
	}
	session.setAttribute("message","coupon.add.done");
	session.setAttribute("title","Coupon");
	session.setAttribute("operation","Create");
	session.removeAttribute("COUPON_HASH");
session.removeAttribute("errorMap");
	response.sendRedirect(PageUtil.appendLinkWithGroup("/"+URLBase+"/eventmanage.jsp;jsessionid="+session.getId()+"?GROUPID="+GROUPID,(HashMap)request.getAttribute("REQMAP")));
}
	
%>

