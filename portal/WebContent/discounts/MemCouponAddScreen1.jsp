
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.coupon.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%!
	String CLASS_NAME="coupon/logic/CouponAddScreen1.jsp";
	
	String getValuefromSess(Map couponhash,String name){
		String val="";
		if(couponhash==null)return val;
		if(couponhash.isEmpty()){
			return val;
		}else{
			val=(String)couponhash.get(name);
			if(val==null)return "";
		}
		return GenUtil.getEncodedXML(val);
	}//end of sessio

	String showErrorMsg(Map errorMap,String name){
		String msg="";
        	if(!errorMap.isEmpty()){
		StatusObj statobj=(StatusObj)errorMap.get(name);
		if(statobj!=null) msg=statobj.getErrorMsg();
		}
		return GenUtil.getEncodedXML(msg);
		
	}


      public Vector  getCommunities(String userid){
       Vector v=new Vector();
       HashMap hm=null;
       String que="select clubname,c.clubid from clubinfo c,club_member b where c.clubid=b.clubid and b.userid=?";
       DBManager db=new DBManager();
       StatusObj sb=db.executeSelectQuery(que, new String[] {userid});
      if(sb.getStatus())
      {
       for(int i=0;i<sb.getCount();i++)
       {
       hm=new HashMap();
       hm.put("clubname",db.getValue(i,"clubname",""));
       hm.put("clubid",db.getValue(i,"clubid",""));
       v.add(hm);
       }}
      return v;
}


%>
<%
request.setAttribute("tasktitle","Coupon");
request.setAttribute("tasksubtitle","Create");
request.setAttribute("tabtype","events");
%>

<%
String platform = request.getParameter("platform");
String URLBase="mytasks";
if("ning".equals(platform)){
        URLBase="ningapp/ticketing";
}

String UNITID=request.getParameter("UNITID");
String GROUPID=request.getParameter("groupid");
String GROUPTYPE=request.getParameter("GROUPTYPE");
Map couponhash=(Map)session.getAttribute("MEMCOUPON_HASH");
Map memerrorMap=(Map)session.getAttribute("memerrorMap");
if(memerrorMap==null){
memerrorMap=new HashMap();
session.setAttribute("memerrorMap",memerrorMap);
}
String error=request.getParameter("error");
if(error==null){
memerrorMap.clear();
couponhash=new HashMap();
}
String manid="";
 String groupid="";
 String clubname="";
 String clubid="";
 String grouptype=(String)session.getAttribute("grouptype");
Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
if (authData!=null){
      	manid=authData.getUserID();
	 groupid=(String)session.getAttribute(ContextConstants.SD_GROUP_ID);
}
Vector v1= getCommunities(manid);
//System.out.println("v1----------------"+v1);
String sub=request.getParameter("submit");
if(sub!=null){
	if(sub.equalsIgnoreCase("delete")){
	String[] delop=request.getParameterValues("del");
			if(delop==null){
			delop=new String[0];
		}
	session.setAttribute("delop",delop);
	//response.sendRedirect(PageUtil.appendLinkWithGroup("/discounts/CouponDel.jsp?GROUPID="+GROUPID,(HashMap)request.getAttribute("REQMAP")));
        GenUtil.Redirect(response,"/discounts/CouponDel.jsp?GROUPID="+GROUPID+"&platform="+platform);   
	}
}
//CouponAddScreen2
  boolean ticketexist=false;
%>

<form  action="/discounts/MemCouponAddScreen2.jsp" method="post"   >
<input type="hidden" name="GROUPID"   value="<%=GROUPID%>" >
<input type="hidden" name="UNITID"   value="13579" >
<input type="hidden" name="platform"   value="<%=platform%>" >

<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<table align="center" width="100%">
<tr><td ><font class="error"><%= showErrorMsg(memerrorMap,"name")%></font></td></tr>
<tr><td ><font class="error"><%= showErrorMsg(memerrorMap,"discount")%></font></td></tr>
<tr><td ><font class="error"><%= showErrorMsg(memerrorMap,"codes")%></font></td></tr>
<tr><td ><font class="error"><%= showErrorMsg(memerrorMap,"ticket")%></font></td></tr>
<tr><td ><font class="error"><%= showErrorMsg(memerrorMap,"community")%></font></td></tr>
</table>
<table align="center" width="100%">
	<tr><td class="inputlabel" width="30%">Discount Name *</td><td class="inputvalue" width="70%"><input size="42" type="text" name="name" value="<%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"name")) %>"/></td></tr>
	<tr><td class="inputlabel" >Description</td><td  class="inputvalue">
	<textarea name="desc" rows="10" cols="40" onfocus="this.value=(this.value==' ')?'':this.value"><%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"desc")).trim() %></textarea>
	</td></tr>
	<tr><td class="inputlabel" >Discount *</td><td  class="inputvalue">
	$ <input type="text" name="discount"  size="6" value="<%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"discount")).trim() %>"/></td></tr>
	<tr><td class="inputlabel" >Communities *<br/>(Select communities to which
	Discount is applicable)</td>
	<td>
	
	<%if(v1!=null&&v1.size()>0){
	
	for(int k=0;k<v1.size();k++){
	HashMap commmap=(HashMap)v1.elementAt(k);
	clubid=(String)commmap.get("clubid");
	clubname=(String)commmap.get("clubname");
	
	
	String[] clubs=new String[]{ };
if(couponhash.get("community") != null){
if(couponhash.get("community") instanceof String)
clubs=new String[]{(String)couponhash.get("community")};
else
clubs=(String[])couponhash.get("community");

}
		
if(k%2==0){%>
<table  >
<tr>
<%}%>
	
<td align='left' class="inputvalue">
<input type="checkbox" name="community" value=<%=clubid%> <%=GenUtil.isChecked(Arrays.asList(clubs), clubid)%> /> <%=clubname%>
</td>
<%}}%></table></td></tr>
	
	
	<tr><td></td></tr>
	<tr><td></td></tr>
	<tr><td></td></tr>
	<tr><td class="inputlabel" >Valid for Tickets *</td><td  class="inputvalue"><table align="left">
<%
		StatusObj stobj3=CouponDB.getTicketsHtml( GROUPID, (HashMap)couponhash);
		if(stobj3.getStatus()){
			ticketexist=true;
			out.println(stobj3.getData().toString());
			
		}
		
%>	
	</table>
	</td></tr>
	
<%
if(ticketexist){
%>
	<tr><td colspan="2" align="center"><input type="submit" name="submit" value="Submit"/>  <input type="button" name="bbb" value="Cancel" onClick="javascript:history.back()" /></td></tr>

<%
}
else{
	session.setAttribute("title","Coupon");
	session.setAttribute("message","No Tickets");
	session.setAttribute("operation","Add");
	response.sendRedirect(PageUtil.appendLinkWithGroup("/mytasks/Coupondone.jsp",(HashMap)request.getAttribute("REQMAP")));

}
%>

</table>

</form>
