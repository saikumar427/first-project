
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.coupon.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>

<%!
	String CLASS_NAME="coupon/CouponEdit.jsp";
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

String UNITID=request.getParameter("UNITID");
String GROUPID=request.getParameter("GROUPID");
String GROUPTYPE=request.getParameter("GROUPTYPE");
String manid="";
String groupid="";
String grouptype=((grouptype=(String)session.getAttribute("grouptype"))==null)?"Event":grouptype;
Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
if (authData!=null){
      	manid=authData.getUserID();	
	 groupid=(String)session.getAttribute(ContextConstants.SD_GROUP_ID);
}




Map couponhash=(Map)session.getAttribute("COUPON_HASH");
if(couponhash==null)couponhash=new HashMap();

Map errorMap=(Map)session.getAttribute("errorMap");
if(errorMap==null){
errorMap=new HashMap();
session.setAttribute("errorMap",errorMap);
}


 String clubname="";
 String clubid="";
String codes="";
String disctype=null;
java.sql.Connection con=null;
java.sql.PreparedStatement pstmt=null;
String couponid=null;
Vector codesvector=null;
Vector ticketsvector=null;

CouponInfo oinfo=(CouponInfo)session.getAttribute("cinfo");
couponid=request.getParameter("couponid");
if(couponid !=null){

errorMap.clear(); 

	couponhash.put("couponid",couponid);
	couponhash.put("GROUPID",GROUPID);
	couponhash.put("GROUPTYPE",GROUPTYPE);
	couponhash.put("UNITID",UNITID);
	CouponDB.getCouponInfo( couponhash);
	
}//end of onfo==null
    
    boolean ticketexist=false;
%>
<form  action="/discounts/CouponEdit.jsp" method="post">
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<input type="hidden" name="disctype" value="ABSOLUTE" />
<input type="hidden" name="GROUPID" value="<%=GROUPID%>" />
<input type="hidden" name="coupontype" value="Member"/>
<input type="hidden" name="couponid" value="<%=couponid%>"/>
<input type="hidden" name="platform"   value="<%=platform%>" >

<table align="center" width="100%">
<tr><td ><font class="error"><%= showErrorMsg(errorMap,"name")%></font></td></tr>
	<tr><td ><font class="error"><%= showErrorMsg(errorMap,"discount")%></font></td></tr>
	<tr><td ><font class="error"><%= showErrorMsg(errorMap,"codes")%></font></td></tr>
	<tr><td ><font class="error"><%= showErrorMsg(errorMap,"ticket")%></font></td></tr>
	<tr><td ><font class="error"><%= showErrorMsg(errorMap,"community")%></font></td></tr>
</table>

<table align="center" width="100%">
	<tr><td class="inputlabel" width="30%">Discount Name *</td><td class="inputvalue"  width="70%"><input type="text" size="42" name="name" value="<%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"name")).trim() %>" /></td></tr>
	
	<tr><td class="inputlabel" >Description</td><td  class="inputvalue"><textarea name="desc" rows="10" cols="40" onfocus="this.value=(this.value==' ')?'':this.value"><%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"desc")).trim() %> </textarea></td></tr>
	<tr><td class="inputlabel" >Discount *</td><td  class="inputvalue">
	
	$ <input type="text" size="6" name="discount"  value="<%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"discount")).trim() %>"/></td></tr>

	<tr><td class="inputlabel" >Communities *<br/>(Select communities to which
		Discount is applicable)</td>
		<td>
		
		<%
		Vector v1= getCommunities(manid);
		if(v1!=null&&v1.size()>0){
		for(int k=0;k<v1.size();k++){
		HashMap commmap=(HashMap)v1.elementAt(k);
		clubname=(String)commmap.get("clubname");
                clubid=(String)commmap.get("clubid");






String[] clubs=new String[]{"-1"};
					if(couponhash.get("community") != null){
						if(couponhash.get("community") instanceof String)
						clubs=new String[]{(String)couponhash.get("community")};
						else
						clubs=(String[])couponhash.get("community");
						
						}
						
						
			
		if(k%2==0){
		
		
		
		%>
		<table  >
	         <tr>
	         <%}%>
		
		<td align='left' class="inputvalue">
		<input type="checkbox" name="community" value=<%=clubid%>    <%=GenUtil.isChecked(Arrays.asList(clubs), clubid)%>/> <%=clubname%>
		</td>
		<%}}%></table></td></tr>
	

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
	<tr><td colspan="2" align="center">
	  <input type="submit" name="submit"  value="Submit"/> <input type="button" name="bbb" value="Cancel" onClick="javascript:history.back()" /></td></tr>
<%
}else{
	session.setAttribute("title","Coupon");
	session.setAttribute("message","No Tickets");
	session.setAttribute("operation","No Tickets");
	response.sendRedirect("done");

}
%>
</table>
</form>
