<%@ page import="java.util.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.hub.HubMaster" %>

<%@ include file="isDueMem.jsp" %>
<script>
function validateDiscount(memshipid,clubid,termfee){

var code=document.getElementById('discountcode').value;

advAJAX.get( {
			url   : '/portal/paidhubs/validaterenewdiscount.jsp?code='+code+'&GROUPID='+clubid+'&memshipid='+memshipid+'&termfee='+termfee,
		    onSuccess : function(obj) {
		    var data=obj.responseText;
		    var responsejsondata=eval('(' + data + ')');
	            var status=responsejsondata.status;
	            var discount=responsejsondata.discount;
		    var due=responsejsondata.due;
	            if(status=='Valid')
	            { 
	              var updateddue=responsejsondata.updateddue;
	          
	            document.getElementById('couponmsg').innerHTML='Applied';
	            document.getElementById('discount_amount').value=responsejsondata.discount;
	            document.getElementById('dueamt').innerHTML='<font color="red"><strike>$'+due+'</strike>  $'+updateddue+'</font>';
	             }else{
	            document.getElementById('couponmsg').innerHTML='Invalid code';
	            document.getElementById('dueamt').innerHTML='$'+due;
	            document.getElementById('discount_amount').value=0;
	          	}		
			},
			onError : function(obj) { 
			//alert("Error: " + obj.status); 
			}
	});
}




</script>

<%
String CLASS_NAME="hub/hubmemberdue.jsp";

String groupid=request.getParameter("GROUPID");
String authid=null;
String ddate=null;
String isDueMember=null;
HashMap duememberhash=null;
 String mshipname=null;
 String termfee="";
 String membershipid=null;
String iscouponexists=DbUtil.getVal("select 'yes' from coupon_master where groupid=? and coupontype=?",new String[]{groupid,"CLUB_SIGNUP"});

Authenticate au=(Authenticate)session.getAttribute("13579_TEMPauthData");
if(au!=null){
	authid=au.getUserID();
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Auth data is not null,authid is: "+authid,"",null);
	duememberhash=isDueHubMember(authid,groupid);
	   membershipid=(String)duememberhash.get("membershipid");
	   ddate=(String)duememberhash.get("duedate");
	  mshipname=(String)duememberhash.get("membership_name");
	  termfee=(String)duememberhash.get("tremfee");
	  
}

else{




}

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"duememberhash details are: "+duememberhash,"",null);

 if(duememberhash!=null&&duememberhash.size()>0&&"yes".equals((String)duememberhash.get("duemember"))){
	
	
%> 
		<table width="100%" align="center">

			<tr>
			<td align="center" width='13%'>
			You are due from </td><td><%=ddate%></td>
			</tr>
			<tr>
			<td align="center" width='13%'>
			 Due amount is</td><td id='dueamt' width='13%'>$<%=termfee%></td><td id='updateddue'></td>
			</tr>

<%if("yes".equals(iscouponexists)){%>

<table >
<div id="showadiscounterror" class="error" colspan='2'></div>
<tr ><td class='inputlabel' colspan='2'>Have a discount code, enter it here </td><td width="25"></td>
<td class='inputlabel'><input type="text" name="discountcode" id="discountcode" size="10" value="" /></td>
<input type="hidden" name="code" id="code"  value="" />
<td class='inputlabel'><input type="button" name="submit" value="Apply" onClick="validateDiscount('<%=membershipid%>','<%=groupid%>','<%=termfee%>')"/></td><td id='couponmsg'></td>
<td id="showadiscountstatus" class="error"></td>
</tr>
</table>

<%}%>


			<tr>
			<td align="center"><table><form id='frm' action='/portal/guesttasks/renewMembership.jsp?UNITID=13579&GROUPID=<%=groupid%>' method='post' />
			<tr><td>
			<input type='hidden' name='discount_amount' id='discount_amount' value='0' />
			</td></tr>
			<tr><td><input type='submit' name='submit' value='Continue' />
			</table></form>
			<!--<a href='/guesttasks/renewMembership.jsp?UNITID=13579&GROUPID=<%=groupid%>'>Renew Membership</a> -->
			</td>
			</tr>
		</table>

<%	
}		
else{   

            if(mshipname==null||Double.parseDouble(termfee)<=0.0)
            GenUtil.Redirect(response,"/portal/hub/clubview.jsp?GROUPID="+groupid);
            
      
           
    else{
    	GenUtil.Redirect(response,"/portal/hub/clubview.jsp?GROUPID="+groupid);

       %> <%-- <table  align="center">
	                        <tr height="30">
				<td align="left">
				 Your current membership name  is: <%=mshipname%></td>
	 			</tr>
	 			
	 			<tr><td></td></td></tr>
                                <tr><td></td></td></tr>
	 			<tr>
	 			<td align="left">
	 			Your subscription next due date is: <%=ddate%></td>
	 			</tr>
	                         <tr><td></td></td></tr>
                                  <tr><td></td></td></tr>
	 			<tr>
	 			<td align="center">
	 			<a href='/portal/hub/clubview.jsp?GROUPID=<%=groupid%>'>Community Home Page</a></td>
	 			</tr>
	 			<tr height="60"><td></td></td></tr>
                                <tr height="60"><td></td></td></tr>
	 			
	 			
		</table>--%>


	
<%	}
}
%>
	 	    