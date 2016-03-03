<%@ page import="java.io.*, java.util.*,java.text.*,java.sql.*,com.eventbee.coupon.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ include file="/stylesheets/CoreRequestMap.jsp" %>
<%!
String CLASS_NAME="coupon/logic/CouponAddScreen2.jsp";

 
 
public  void insertCoupon(Map couponhash){
if(couponhash != null){
String query=""; 
StatusObj sb=null;
try{
query="select nextval('seq_couponid') as couponid";
String couponid=DbUtil.getVal(query,new String[]{});
query="insert into coupon_master(managerId,groupId,groupType,couponId,name,description,discount,activationDate,cutOffDate,created_by,created_at,updated_by,updated_at,discounttype,coupontype)"
+" values(?,?,?,?,?,?,?,?,?,'coupon',now(),'coupon',now(),?)";

try{
 sb=DbUtil.executeUpdateQuery(query,new String[]{(String)couponhash.get("manid"),(String)couponhash.get("GROUPID"),(String)couponhash.get("GROUPTYPE"),couponid,(String)couponhash.get("name")==null?"":((String)couponhash.get("name")).trim(),(String)couponhash.get("desc")==null?"":((String)couponhash.get("desc")).trim(),(String)couponhash.get("discount")==null?"0":((String)couponhash.get("discount")).trim(),null,null,"ABSOLUTE","Member"});
}
catch(Exception e){
System.out.println("Exception while inserting into couponmaster----"+e.getMessage());
}

String[] ticketarr=null;
if(couponhash.get("ticket") != null){
		if(couponhash.get("ticket") instanceof String)
		ticketarr=new String[]{(String)couponhash.get("ticket")};
		else
		ticketarr=(String[])couponhash.get("ticket");
}

if(ticketarr !=null){
try{
query="insert into coupon_ticket (couponId,price_id) values (?,?)";
for(int k=0;k<ticketarr.length;k++){
 sb=DbUtil.executeUpdateQuery(query,new String[]{couponid,ticketarr[k]});
}		
}
catch(Exception e){
System.out.println("Exception while inserting into couponticket----"+e.getMessage());
}
}

String[] communityarr=null;
if(couponhash.get("community") != null){
if(couponhash.get("community") instanceof String)
communityarr=new String[]{(String)couponhash.get("community")};
else
communityarr=(String[])couponhash.get("community");
}


if(communityarr !=null){
                try{
		query="insert into coupon_community (couponId,clubid) values (?,?)";
		for(int k=0;k<ticketarr.length;k++){
		 sb=DbUtil.executeUpdateQuery(query,new String[]{couponid,communityarr[k]});
		}		
}
catch(Exception e){
System.out.println("Exception while inserting into couponcommunity----"+e.getMessage());
}
}


}
catch(Exception ex){}

}


}
%>

<%


String platform = request.getParameter("platform");
String URLBase="mytasks";
if("ning".equals(platform)){
        URLBase="ningapp/ticketing";
}

com.eventbee.util.RequestSaver rsv=new com.eventbee.util.RequestSaver(pageContext,"MEMCOUPON_HASH","session",true);

Map couponhash=(Map)session.getAttribute("MEMCOUPON_HASH");
String UNITID=request.getParameter("UNITID");
String GROUPID=request.getParameter("GROUPID");
String GROUPTYPE=request.getParameter("GROUPTYPE");


StatusObj statobj=null;
Map memerrorMap=(Map)session.getAttribute("memerrorMap");
memerrorMap.clear();
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
if(!statobj.getStatus())memerrorMap.put("name",statobj);

String desc=request.getParameter("desc").trim();
String discount=request.getParameter("discount").trim();
statobj=EventBeeValidations.isValidNumber(discount,"Discount","double",0.0);
if(!statobj.getStatus()){
memerrorMap.put("discount",statobj);
}else{
discount=statobj.getData().toString();
}



String disctype="ABSOLUTE";


String[] ticketarr=new String[]{};
 ticketarr=request.getParameterValues("ticket");
if(ticketarr==null){
statobj=new StatusObj(false,"No ticket checked",null);
memerrorMap.put("ticket",statobj);
couponhash.put("ticket",new String[0]);
}

String[] communityarr=request.getParameterValues("community");
if(communityarr==null){
statobj=new StatusObj(false,"No community checked",null);
memerrorMap.put("community",statobj);
couponhash.put("community",new String[0]);
}

String act=null;

String cut=null;

if(!memerrorMap.isEmpty()){
response.sendRedirect(PageUtil.appendLinkWithGroup("/"+URLBase+"/MemCouponAddScreen1.jsp?groupid="+GROUPID+"&error=error",(HashMap)request.getAttribute("REQMAP")));
}else{
session.removeAttribute("memerrorMap");

       if(couponhash!=null){
	couponhash.put("manid",manid);
	couponhash.put("GROUPID",GROUPID);
	couponhash.put("coupontype","Member");
	couponhash.put("GROUPTYPE","Event");
	CouponDB.insertCoupon(couponhash);
	}
	session.setAttribute("message","coupon.add.done");
	session.setAttribute("title","Coupon");
	session.setAttribute("operation","Create");
	session.removeAttribute("MEMCOUPON_HASH");

	response.sendRedirect(PageUtil.appendLinkWithGroup("/"+URLBase+"/eventmanage.jsp?GROUPID="+GROUPID,(HashMap)request.getAttribute("REQMAP")));
}
	
%>

