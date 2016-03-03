<%@ page import="java.io.IOException,java.util.*,com.eventbee.proxysignup.ProxySignupDB"%>
<%@ page import="com.eventbee.authentication.*,com.eventbee.context.ContextConstants,com.eventbee.general.*"%>
<%@ page import="com.eventbee.coupon.*,com.eventbee.event.BeeletController,com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbee.event.EventDB" %>
<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function dummy1() { }
</script>


<script>




function getUrlBlock(code,evtid,i){
if(document.getElementById('url'+i).innerHTML!=''){
document.getElementById('url'+i).innerHTML='';

}
else{
advAJAX.get( {

	url : '/portal/discounts/geturlblock.jsp?code='+code+'&GROUPID='+evtid,
    onSuccess : function(obj) {
    	document.getElementById('url'+i).innerHTML=obj.responseText;
	
	},
	onError : function(obj) { alert("Error: " + obj.status); }
});


}





}

</script>
<%!
public  List getCouponOfGroup(String groupid){
			
	
	String query="select name,cm.couponId,description from coupon_master cm,coupon_community cc where cc.couponid=cm.couponid and cm.groupid=? and ";

	DBManager dbmanager=new DBManager();
	StatusObj sb=dbmanager.executeSelectQuery(query,new String []{groupid});
	List couponlist=null;

	if(sb.getStatus()){
	couponlist=new ArrayList();
	for(int i=0;i<sb.getCount();i++){
			CouponInfo oinfo=new CouponInfo();

			oinfo.setGroupId(dbmanager.getValue(i,"groupId",""));
			oinfo.setGroupType(dbmanager.getValue(i,"groupType",""));
			oinfo.setCouponId(dbmanager.getValue(i,"couponId",""));
			oinfo.setName(dbmanager.getValue(i,"name",""));
			oinfo.setDescription(dbmanager.getValue(i,"description",""));
			oinfo.setDiscount(dbmanager.getValue(i,"discount",""));

			couponlist.add(oinfo);

	}}
	return couponlist;
	}






HashMap getCodes(String couponid){
DBManager db=new DBManager();
HashMap hm=new HashMap();
String query="select couponcode from coupon_codes where couponid=?";
StatusObj sb=db.executeSelectQuery(query,new String[]{couponid});
if(sb.getStatus())
{
for(int i=0;i<sb.getCount();i++){
hm.put("couponcode"+i,db.getValue(i,"couponcode",""));
}
}
return hm;
}


String community="";
HashMap gm=null;
HashMap getHubs(String couponid){
DBManager db1=new DBManager();
HashMap hm1=new HashMap();
String query1="select clubname from clubinfo where clubid in(select clubid from coupon_community where couponid=?)";
StatusObj sb=db1.executeSelectQuery(query1,new String[]{couponid});
if(sb.getStatus())
{
for(int i=0;i<sb.getCount();i++){
hm1.put("clubname"+i,db1.getValue(i,"clubname",""));
}
}
return hm1;
}

%>

<%

 
List cmshiplist=null;
HashMap gh=null;
String manid=null;
String groupid=null;
String grouptype=null;
String unitid=null;
String code="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if (authData!=null){
manid=authData.getUserID();
 unitid=authData.getUnitID();

}
HashMap hm=(HashMap)session.getAttribute("groupinfo");

if(hm != null){
groupid=(String)hm.get("groupid");

}
groupid=request.getParameter("GROUPID");
grouptype=((grouptype=(String)session.getAttribute("grouptype"))==null)?"event":grouptype;
 String currency=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{groupid});
         if(currency==null)
		currency="$";

HashMap newhm=(HashMap)session.getAttribute("groupinfo");
boolean isbeeletdisplay=("Yes".equalsIgnoreCase(EventTicketDB.getEventConfig(groupid, "event.poweredbyEB")));


	if(isbeeletdisplay){
%>

<%

String platform = request.getParameter("platform");
String URLBase="mytasks";
if("ning".equals(platform)){
        URLBase="ningapp/ticketing";
}


String eventurl="";
List mshiplist =CouponDB.getCouponOfGroup(groupid,"General");
String htmltdclass="evenbase";
%>
<table class="portaltable" align="center" cellspacing="0" cellpadding="5" width="100%" valign="top">

<form action="/<%=URLBase%>/CouponAddScreen1.jsp;jsessionid=<%=session.getId()%>"  name='frm1' method='post'>

<tr><td class='memberbeelet-header' colspan="4" width="100%">Discounts</td></tr>

<tr ><td class='colheader' colspan="4" width="100%">Discount Codes</td></tr>	



<input type="hidden" name="groupid" value="<%=groupid%>">
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>


<%


	if(mshiplist != null){
		if(!mshiplist.isEmpty()){
%>
		<tr >
			<td width="20%" class="colheader" align="center">
			<input type="submit" name="submit" value="Delete"></td>
			<td width="38%" class="colheader">Name</td>
			<td width="30%"  class="colheader" align="center">Codes</td>
			<td width="12%" class="colheader"></td>

		</tr></table>
		
	
<%
	Iterator iter = mshiplist.iterator();
	int i=0;
	while(iter.hasNext()){
	htmltdclass="evenbase";
	CouponInfo oinfo1=(CouponInfo)iter.next();
	String perc="";
	String currency1=currency;
	String disctype=DbUtil.getVal("select discounttype from coupon_master where couponid=? and groupid=?",new String[]{oinfo1.getCouponId(),groupid});
	if("PERCENTAGE".equalsIgnoreCase(disctype)){
	currency1="";
	 perc="%";
	}
	else
	{
	currency1=currency;
	}
	if(i%2==0)htmltdclass="oddbase";
	i++;
%>
<table class="portaltable" align="center" cellspacing="0" cellpadding="1.3" width="100%" valign="top">

<tr class="<%=htmltdclass%>">
<td width="20%" align="center"><input type="checkbox" name="del" value="<%=oinfo1.getCouponId()%>"></td>
<td width="38%">
<a href="<%=PageUtil.appendLinkWithGroup("/"+URLBase+"/CouponEditScreen1.jsp;jsessionid="+session.getId()+"?couponid="+oinfo1.getCouponId()+"&GROUPID="+groupid,(HashMap)request.getAttribute("REQMAP"))%>"><%=currency1%><%=oinfo1.getDiscount()%><%=perc%> - <%=oinfo1.getName()%></a>
</td>
<td width="30%" align="center">
<%
String codesstr="";
gh=getCodes(oinfo1.getCouponId());
System.out.println("oinfo1.getDiscType()"+oinfo1.getDiscType());
for(int k=0;k<gh.size();k++){
code=(String)gh.get("couponcode"+k);
if(!"".equals(codesstr))
codesstr=codesstr+", "+code; 
else
codesstr=code;
}

%>
<%=codesstr%>


</td><td width="12%" align="center"><span style="cursor: pointer; text-decoration: underline" onClick="getUrlBlock('<%=(String)gh.get("couponcode0")%>','<%=groupid%>','<%=i%>');">URL</span></td>

</tr></table>
<table width='100%' class="<%=htmltdclass%>"><tr><td  colspan='4' class="<%=htmltdclass%>"><div id='url<%=i%>' ></div></td></tr> </table>                                                        

		
<%
}//end of while
}else{
%>
<tr>
<td COLSPAN="4"	ALIGN="LEFT" >
Click on Add button to create Discount Codes
	</td>
</tr></table>
<%   }
	}else{
	//end of list null
%>
	<tr class="evenbase">
	<td COLSPAN="4"  ALIGN="LEFT"	>
	Click on Add button to create Discount Codes
	</td>
</tr></table>
<%	} %>
<table class="portaltable" align="center" cellspacing="0" cellpadding="1.3" width="100%" valign="top">

<tr>
<td COLSPAN="4" ALIGN="CENTER" class="evenbase">
<input type="submit" name="submit" value="Add">
</td>
</tr>

</form>
</table>
<%if(!"ning".equals(platform)){%>
<table class="portaltable" align="center" cellspacing="0" cellpadding="5" width="100%" valign="top">


<tr  ><td class='colheader' colspan="4">Member Discounts </td></tr>
<form action="/<%=URLBase%>/MemCouponAddScreen1.jsp;jsessionid=<%=session.getId()%>" method='post'>
<input type="hidden" name="groupid" value="<%=groupid%>">
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>

	
<%      cmshiplist=CouponDB.getCouponOfGroup(groupid,"Member");
	if(cmshiplist != null){
		if(!cmshiplist.isEmpty()){
%>
		<tr >
			<td width="10%" class="colheader">
			<input type="submit" name="submit" value="Delete"></td>
			<td width="40%" class="colheader">Name</td>
			<td width="50%" class="colheader" colspan='2'>Communities</td>
		</tr>
		
		
	
<%
	Iterator iter = cmshiplist.iterator();
	int i=0;
	while(iter.hasNext()){
	htmltdclass="evenbase";
	CouponInfo oinfo2=(CouponInfo)iter.next();
	if(i%2==0)htmltdclass="oddbase";
	i++;
%>

<tr >
<td width="10%" class="<%=htmltdclass%>"><input type="checkbox" name="del" value="<%=oinfo2.getCouponId()%>"></td>
<td width="40%" class="<%=htmltdclass%>">
<a href="<%=PageUtil.appendLinkWithGroup("/"+URLBase+"/MemCouponEditScreen1.jsp;jsessionid="+session.getId()+"?couponid="+oinfo2.getCouponId()+"&GROUPID="+groupid,(HashMap)request.getAttribute("REQMAP"))%>"><%=currency%><%=oinfo2.getDiscount()%> - <%=oinfo2.getName()%></a>
</td>
<td class="<%=htmltdclass%>">
<%
gm=getHubs(oinfo2.getCouponId());
for(int j=0;j<gm.size();j++){
community=(String)gm.get("clubname"+j);
%>
<%=community%>

<%}%>
</td>
<td class="<%=htmltdclass%>"></td>
</tr>

<%
}//end of while
}else{
%>
<tr>
<td COLSPAN="4"	ALIGN="LEFT">
Click on Add button to create Member Discount codes
	</td>
</tr>
<%   }
	}else{
	//end of list null
%>
	<tr >
	<td COLSPAN="4"  ALIGN="LEFT"	class="evenbase">
	Click on Add button to create Member Discount codes
	</td>
</tr>
<%	} %>
<%if(cmshiplist==null){%>
<tr>
<td COLSPAN="4" ALIGN="CENTER" class="evenbase">
<input type="submit" name="submit" value="Add">
</td>
</tr>
<%}
else{%>
<tr>
<td COLSPAN="4" ALIGN="CENTER" class="evenbase">
<input type="submit" name="submit" value="Add" disabled>
</td>
</tr>
<%}%>


</form>
</table>
		
<%

}
}
%>








