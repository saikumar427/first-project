<%@ page import="java.io.*, java.util.*,java.text.*,java.sql.*,com.eventbee.coupon.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%!
String CLASS_NAME="coupon/logic/CouponEdit.jsp";
%>
<%
request.setAttribute("tasktitle","Coupon");
request.setAttribute("tasksubtitle","Edit");
request.setAttribute("tabtype","events");
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
String coupontype=request.getParameter("coupontype");
StatusObj statobj=null;
Map errorMap=(Map)session.getAttribute("errorMap");
errorMap.clear();

String couponid=request.getParameter("couponid");
couponhash.put("couponid",couponid);

StringTokenizer st=null;
 String manid="";
 String groupid="";
 String grouptype=(String)session.getAttribute("grouptype");

Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
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

String disctype=request.getParameter("disctype");
String count="";
String code_limittype=null;
int defcount=100000;

if("General".equals(coupontype)){
String codes=request.getParameter("codes");
statobj=EventBeeValidations.isValidStr(codes,"Codes");
if(!statobj.getStatus())
errorMap.put("codes",statobj);
 code_limittype=request.getParameter("code_limittype");
 couponhash.put("code_limittype",code_limittype);

if("1".equals(code_limittype))
{
 count=request.getParameter("limit");

if(count==null||"".equals(count))
statobj=EventBeeValidations.isValidNumber(count,"Max Count","int",0);
if(!statobj.getStatus()){
errorMap.put("count",statobj);
}

}
}
else
{
String[] clubarr=request.getParameterValues("community");
if(clubarr==null){
statobj=new StatusObj(false,"No community checked",null);
errorMap.put("community",statobj);

couponhash.put("community",new String[0]);
}
}
String[] ticketarr=request.getParameterValues("ticket");
if(ticketarr==null){
statobj=new StatusObj(false,"No ticket checked",null);
errorMap.put("ticket",statobj);
couponhash.put("ticket",new String[0]);
}
couponhash.put("coupontype",coupontype);
String act=null;

String cut=null;

if(!errorMap.isEmpty()&&"General".equals(coupontype)){
response.sendRedirect(PageUtil.appendLinkWithGroup("/"+URLBase+"/CouponEditScreen1.jsp;jsessionid="+session.getId()+"?GROUPID="+GROUPID,(HashMap)request.getAttribute("REQMAP")));
}

else if(!errorMap.isEmpty()&&"Member".equals(coupontype)){
response.sendRedirect(PageUtil.appendLinkWithGroup("/"+URLBase+"/MemCouponEditScreen1.jsp;jsessionid="+session.getId()+"?GROUPID="+GROUPID,(HashMap)request.getAttribute("REQMAP")));
}
else{
if("0".equals(code_limittype))
	couponhash.put("maxcount",defcount+"");
	else if("1".equals(code_limittype))
	couponhash.put("maxcount",count);
//	System.out.println("couponhash"+couponhash);
CouponDB.updateCoupon(couponhash);
disctype=(String) couponhash.get("disctype");
//StatusObj sb=DbUtil.executeUpdateQuery("update coupon_master set discounttype=?  where couponid=? and groupid=?",new String[]{disctype,couponid,GROUPID});
	session.setAttribute("message","coupon.edit.done");
	session.setAttribute("title","Coupon");
	session.setAttribute("operation","Edit");
	session.removeAttribute("COUPON_HASH");
       session.removeAttribute("errorMap");

	response.sendRedirect(PageUtil.appendLinkWithGroup("/"+URLBase+"/eventmanage.jsp;jsessionid="+session.getId()+"?GROUPID="+GROUPID,(HashMap)request.getAttribute("REQMAP")));

}

%>

