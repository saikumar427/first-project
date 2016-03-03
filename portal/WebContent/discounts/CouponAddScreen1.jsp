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
	 HashMap getTicketInfo(String eventid,String query){
	 DBManager dbmanager=new DBManager();
	 HashMap hm1=new HashMap();
	
	 StatusObj stobj=dbmanager.executeSelectQuery(query,new String[]{eventid});
	        Vector v=new Vector();
	        if(stobj.getStatus()){
	                        
				for(int i=0;i<stobj.getCount();i++){
				HashMap hm=new HashMap();
				hm.put("ticket_name",dbmanager.getValue(i,"ticket_name",""));
	                        hm.put("price_id",dbmanager.getValue(i,"price_id",""));
				hm.put("ticket_price",dbmanager.getValue(i,"ticket_price",""));
				hm1.put(dbmanager.getValue(i,"price_id",""),hm);
				
	                       }
	                       
	                       }
	                       return hm1;
	                       }

	
	Vector getGroupdetails(String groupid,String q){
	
	DBManager dbmanager=new DBManager();
	StatusObj stobj=dbmanager.executeSelectQuery(q,new String[]{groupid,groupid});
	Vector v1=new Vector();
	if(stobj.getStatus()){
	for(int i=0;i<stobj.getCount();i++){
	HashMap hm=new HashMap();
	hm.put("groupname",dbmanager.getValue(i,"groupname",""));
	hm.put("description",dbmanager.getValue(i,"description",""));
	hm.put("ticket_groupid",dbmanager.getValue(i,"ticket_groupid",""));
	hm.put(dbmanager.getValue(i,"ticket_groupid",""),getTickets(dbmanager.getValue(i,"ticket_groupid","")));
	v1.add(hm);
	}
	}
	return v1;
	}
	List getTickets(String groupticketid){
	DBManager dbmanager=new DBManager();
	
	String q="select gt.price_id  from group_tickets gt,price p where ticket_groupid=? "
		+" and (upper(coalesce(isdonation,'NO'))='NO') and "
		+" to_number(gt.price_id,'9999999999')=p.price_id order by gt.position";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(q,new String[]{groupticketid});
	List l=new ArrayList();
	for(int i=0;i<sb.getCount();i++){
	l.add(db.getValue(i,"price_id",""));
	
	}
	return l;
	}

String ShowTicketsData(HashMap ticketDataMap, String eventid,  HashMap couponhash, String grptktid){
String[] tkts=new String[]{"-1"};
	if(couponhash.get("ticket") != null){
		if(couponhash.get("ticket") instanceof String)
		tkts=new String[]{(String)couponhash.get("ticket")};
		else
		tkts=(String[])couponhash.get("ticket");
	}

StringBuffer ticketsDataString=new StringBuffer("");

ticketsDataString.append("<tr><td></td>");
ticketsDataString.append("<td align='left'>");
String price_id=(String)ticketDataMap.get("price_id");
String ticket_name=(String)ticketDataMap.get("ticket_name");
String ticket_price=(String)ticketDataMap.get("ticket_price");

ticketsDataString.append("<input type='checkbox'   id='"+grptktid+"_"+price_id+"' name='ticket' value='"+price_id+"'  "+GenUtil.isChecked(Arrays.asList(tkts), price_id)+"      />" );
//ticketsDataString.append("</td>");
//ticketsDataString.append("<td>");
ticketsDataString.append(GenUtil.getEncodedXML(ticket_name));
ticketsDataString.append("</td>");
ticketsDataString.append("</tr>");

return ticketsDataString.toString();


}


%>

<%
String platform = request.getParameter("platform");
String URLBase="mytasks";
if("ning".equals(platform)){
        URLBase="ningapp/ticketing";
}

String disctype="ABSOLUTE";
String UNITID=request.getParameter("UNITID");
String GROUPID=request.getParameter("groupid");
String GROUPTYPE=request.getParameter("GROUPTYPE");
Map couponhash=(Map)session.getAttribute("COUPON_HASH");
String limitchecked=null;
String discounttype="ABSOLUTE";

String query="select distinct groupname,etg.description,etg.ticket_groupid,etg.position from event_ticket_groups etg ,price p, group_tickets gt"
                 +" where etg.eventid=? and gt.ticket_groupid=etg.ticket_groupid and p.price_id=to_number(gt.price_id,'999999999') "
                 +" and p.evt_id=?  and (upper(coalesce(isdonation,'NO'))='NO') order by etg.position ";
 
String query1="select price_id,ticket_name,ticket_price from price where evt_id=? and (upper(coalesce(isdonation,'NO'))='NO')";

Vector groupdetails=getGroupdetails(GROUPID,query);
HashMap opttickets=getTicketInfo(GROUPID,query1);

 String currency=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{GROUPID});
         if(currency==null)
		currency="$";
if(couponhash!=null){
 limitchecked=(String)couponhash.get("code_limittype");
  discounttype=(String)couponhash.get("discount_type");
  if("1".equals(discounttype))
  discounttype="ABSOLUTE";
  else if("0".equals(discounttype))
  discounttype="PERCENTAGE";
  }
if(limitchecked==null)
limitchecked="0";
Map errorMap=(Map)session.getAttribute("errorMap");
if(errorMap==null){
errorMap=new HashMap();
session.setAttribute("errorMap",errorMap);
}
String error=request.getParameter("error");
if(error==null){
errorMap.clear();
couponhash=new HashMap();
}
String manid="";
 String groupid="";
 String grouptype=(String)session.getAttribute("grouptype");
Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
if (authData!=null){
      	manid=authData.getUserID();
	 groupid=(String)session.getAttribute(ContextConstants.SD_GROUP_ID);
}
String sub=request.getParameter("submit");
if(sub!=null){
	if(sub.equalsIgnoreCase("delete")){
	String[] delop=request.getParameterValues("del");
			if(delop==null){
			delop=new String[0];
		}
	session.setAttribute("delop",delop);
	//response.sendRedirect(PageUtil.appendLinkWithGroup("/discounts/CouponDel.jsp?GROUPID="+GROUPID,(HashMap)request.getAttribute("REQMAP")));
        GenUtil.Redirect(response,"/discounts/CouponDel.jsp;jsessionid="+session.getId()+"?GROUPID="+GROUPID+"&platform="+platform);   
	}
}
//CouponAddScreen2
  boolean ticketexist=false;
%>
<script>
 function checkAll(id)
 {
 
 for (i = 0; i < Tickets.length; i++){
      var t=Tickets[i];
      if(t.indexOf(id)>-1)
 
 	document.getElementById(t).checked = true ;
 	
 	}
 }
 function uncheckAll(id)
 {
 for (i = 0; i < Tickets.length; i++){
       var t=Tickets[i];
       if(t.indexOf(id)>-1)
  
  	document.getElementById(t).checked = false ;
  	
 	}
 }
function toggleDiscountType(){
var absdiscvar=document.getElementById('absdiscount');
var perdiscvar=document.getElementById('percentagediscount');
if(absdiscvar.checked){
document.getElementById('absdiscount').checked='true';
document.getElementById('disctype').value='ABSOLUTE';
document.getElementById('curlabel').style.display='block';
document.getElementById('perclabel').style.display='none';
var discprice=document.getElementById('discountprice').value;
document.getElementById('discount').value=discprice;
}
 if(perdiscvar.checked){
document.getElementById('percentagediscount').checked='true';
document.getElementById('disctype').value='PERCENTAGE';
document.getElementById('curlabel').style.display='none';
document.getElementById('perclabel').style.display='block';
var discperc=document.getElementById('discountperc').value;
document.getElementById('discount').value=discperc;
if(discperc>100){
alert("Invalid Discount");
document.getElementById('discountperc').value='';
return false;
}
 }
return true;
}
</script>
<form  action="/discounts/CouponAddScreen2.jsp;jsessionid=<%=session.getId()%>" method="post"  name="disc" >
<body onLoad="toggleDiscountType();">
<input type="hidden" name="GROUPID"   value="<%=GROUPID%>" >
<input type="hidden" name="UNITID"   value="13579" >
<input type="hidden" name="platform"   value="<%=platform%>" >
<input type="hidden" name="disctype" id="disctype"  >

<input type="hidden" name="discount" id="discount"  >

<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<table align="center" width="100%">
<tr><td ><font class="error"><%= showErrorMsg(errorMap,"name")%></font></td></tr>
<tr><td ><font class="error"><%= showErrorMsg(errorMap,"discount")%></font></td></tr>
<tr><td ><font class="error"><%= showErrorMsg(errorMap,"codes")%></font></td></tr>
<tr><td ><font class="error"><%= showErrorMsg(errorMap,"count")%></font></td></tr>

<tr><td ><font class="error"><%= showErrorMsg(errorMap,"ticket")%></font></td></tr>

</table>
<table align="center" width="100%">
<tr><td class="inputlabel" width="30%">Discount Name *</td><td class="inputvalue" width="70%"><input size="42" type="text" name="name" value="<%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"name")) %>"/></td></tr>
<tr><td class="inputlabel" >Description</td><td  class="inputvalue"><textarea name="desc" rows="5" cols="40" onfocus="this.value=(this.value==' ')?'':this.value"><%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"desc")).trim() %></textarea>
</td></tr>
<tr>
<td class="inputlabel" width="30%">Discount Type*</td>
<td class="inputlabel" width="30%">
<input type='radio' name='discount_type' id="absdiscount" value='1' <%=("ABSOLUTE".equalsIgnoreCase(discounttype))?"checked='checked'":""%>  onClick="toggleDiscountType()"/>Absolute
<input type='radio' name='discount_type' id="percentagediscount" value='0' <%=("PERCENTAGE".equalsIgnoreCase(discounttype))?"checked='checked'":""%> onClick="toggleDiscountType()"/ >Percentage
</td> 
</tr>
<tr><td class="inputlabel" >Discount *</td><td  class="inputvalue">
<span id="curlabel"><%=currency%><input type="text"  id="discountprice" size="6" value="<%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"discount")).trim() %>"/></span>
<span id="perclabel" style="display:none"><input type="text"  id="discountperc" size="6" value="<%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"discount")).trim() %>"/>%</span></td></tr>
<tr><td class="inputlabel" >Codes *<br/><font class='smallestfont'>(Enter comma seperated alphanumeric codes)</font></td>
<td  class="inputvalue">
<input type="text" name="codes" value="<%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"codes")).trim() %>" />
</td></tr>
<tr  width='100%'><td   class="inputlabel" >Limit Count *</td>
<td class="inputvalue"><input type='radio' name='code_limittype' value='0' <%=("0".equals(limitchecked))?"checked='checked'":""%> />No Limit<br/>
<input type='radio' name='code_limittype' value='1' <%=("1".equals(limitchecked))?"checked='checked'":""%>/ >Max  Count
<input type='text' name='limit' size='4' value='<%=GenUtil.getEncodedXML(getValuefromSess(couponhash,"limit")).trim() %>'/>
</td>
</tr>
     
	<tr><td class="inputlabel" >Valid for Tickets *</td><td  class="inputvalue">
	<table align="left">
	
	
	<script>
	var Tickets=new Array();
	</script>

	
<%
for(int k=0;k<groupdetails.size();k++){
HashMap ghm=(HashMap)groupdetails.elementAt(k);
String groupname=(String)ghm.get("groupname");
String grptktid=(String)ghm.get("ticket_groupid");
List l1=(List)ghm.get(grptktid);
if(!"".equals(groupname)){

%>
<tr><td><%=groupname%>
</td>
<td>   
<span style="cursor: pointer; text-decoration: underline" name="CheckAll"  onClick='checkAll(<%=grptktid%>)' >Select All</span>
 | <span style="cursor: pointer; text-decoration: underline" name="UnCheckAll"  onClick='uncheckAll(<%=grptktid%>)' >Clear All</span>
</td></tr>


<%
for(int grpTctIndex=0;grpTctIndex<l1.size();grpTctIndex++){





String ele=(String)l1.get(grpTctIndex);
HashMap hm=(HashMap)opttickets.get(ele);
String str=grptktid+"_"+(String)hm.get("price_id");

%>
<script>
Tickets.push('<%=str%>');

</script>


<%
if(hm!=null){
ticketexist=true;
%>
<tr><td>

</td>
<%=ShowTicketsData(hm,GROUPID,(HashMap)couponhash,grptktid)%>

<%
}

}
}else{
if(l1!=null && l1.size()>0){
String ele=(String)l1.get(0);
HashMap hm=(HashMap)opttickets.get(ele);
if(hm!=null){
ticketexist=true;
%>
<%=ShowTicketsData(hm,GROUPID, (HashMap)couponhash,grptktid)%>

<%
}
}
}
}
		
%>	
	</table>
	</td></tr>
	
<%
if(ticketexist){
%>
	<tr><td colspan="2" align="center"> <input type="submit" name="submit" value="Submit" onClick="return toggleDiscountType();"/> <input type="button" name="bbb" value="Cancel" onClick="javascript:history.back()" /> </td></tr>

<%
}
else{

     session.setAttribute("title","Coupon");
	session.setAttribute("message","No Tickets");
	session.setAttribute("operation","Add");
	response.sendRedirect(PageUtil.appendLinkWithGroup("/"+URLBase+"/Coupondone.jsp;jsessionid="+session.getId(),(HashMap)request.getAttribute("REQMAP")));

}
%>

</table>
</body>
</form>
