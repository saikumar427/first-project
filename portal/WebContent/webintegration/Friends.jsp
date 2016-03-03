<%@ page import="java.util.*" %>
<%@ page import="java.util.StringTokenizer.*"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*" %>

<%!
   static boolean x1=true;
   Vector getPhotoDetails( String userid)
   {
	   Vector v3 = new Vector();
	   DBManager dbm=new DBManager();
	   HashMap hm=null;
	   int x=Integer.parseInt(userid);	   
	   StatusObj statobj=dbm.executeSelectQuery("select uploadurl,photo_size,caption,b.location_code from member_photos a,member_photos_location b where a.user_id=? and a.photo_id=b.photo_id and status not in ('decline')", new String[] {userid});
	   if(statobj.getStatus())
	   {
		for(int k=0;k<statobj.getCount();k++)
		 {
			hm = new HashMap();	
			hm.put("uploadurl",dbm.getValue(k,"uploadurl",""));	
			v3.add(hm);
		 }
	   }
	   else
	   {
		   x1=statobj.getStatus();					
	   }
	   return v3;
   }

  Vector getFriendslist(String userid)
	{
		Vector v= new Vector();
		DBManager dbm =new DBManager();
		HashMap hm= null;		
		String s=
				"select  a.user2 as userid,b.email, b.first_name||'  '||b.last_name as name from user_profile b, user_network_request a where a.status='A' and a.user2=b.user_id  and a.user1=?  union  select  a.user1 as userid,b.email,b.first_name||'  '||b.last_name as name from user_profile b, user_network_request a where a.status='A' and a.user1=b.user_id  and a.user2=?"; 
		StatusObj statobj=dbm.executeSelectQuery(s,new String[] {userid,userid});
		if(statobj.getStatus())
		{
			for(int k=0;k<statobj.getCount();k++)
			{
				hm =new HashMap();
				hm.put("lname",dbm.getValue(k,"userid",""));
				hm.put("fname",dbm.getValue(k,"name",""));
				hm.put("email",dbm.getValue(k,"email",""));
				v.add(hm);
			}
			
		}
		else 
			System.out.println("statusobject status isssss:"+statobj.getStatus());
		return v;
	}
	%>
	<html>
	<form action="/portal/webintegration/getemails.jsp" method="post" id="mails" name="myform" onSubmit="getmailonsubmit('<%=request.getParameter("groupid")%>'); return false;">
	<table align="center" width="100%" valign='top'>	
	<span id="error"></span>
	<tr><td colspan="2" align='center' >
	<a href="#" onclick="showPlaxoABChooser('emailsString', '/home/links/addressimport.html'); return false">
	<img src="/home/images/wizard_button.gif" alt="Add from my address book"  border='0'/></a></td> </tr>	
	<tr><td class="inputlabel">Friends Email IDs <br/><span class="smallestfont" >(comma separated)</span></td>
	<td>
	<textarea id="emailsString"name="email" style="display: none;"></textarea>
	<textarea id="toheader" name="emailsString" rows='10' cols='50' onfocus="this.value=(this.value==' ')?'':this.value"> </textarea>
	</td>
	</tr>
	<%
	String serveraddress=EbeeConstantsF.get("serveraddress","www.eventbee.com");
		if(serveraddress!=null){
		if(!serveraddress.startsWith("http://")){
			serveraddress="http://"+serveraddress;
		}
	}
String domain=(String)session.getAttribute("domain");
if(domain==null)
 domain=request.getParameter("domain");

String platform=request.getParameter("platform");

Authenticate auth=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
String uid=(auth!=null)?auth.getUserID():null;
String oid=(String)session.getAttribute("oid");
	String groupid=request.getParameter("groupid");	
	String partnerid=request.getParameter("partnerid");	
	Vector v1=null;
	String eventURL=null;
	if(eventURL==null){
		String mgrname=DbUtil.getVal("select login_name from authentication where user_id=(select mgr_id::varchar from eventinfo where eventid=CAST(? AS INTEGER))",new String[]{groupid});
		if(mgrname!=null){
			eventURL=ShortUrlPattern.get(mgrname)+"/event?eid="+groupid+"&pid="+partnerid+"&fid=1";
		}
	}else{
		eventURL=eventURL+"/discount?fid=1&pid="+partnerid;				
	}
	
	if("ning".equals(platform)){
	eventURL=""+serveraddress+"/token?oid="+oid+"&eid="+groupid+"&pid="+partnerid+"&d="+domain+"&fid=1";
	}
	
	//String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
		
	String userid="",name="",lastname="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData!=null){
	 userid= authData.getUserID();
	 name=(String)authData.UserInfo.get("FirstName");
	 lastname=(String)authData.UserInfo.get("LastName");
	}	
	v1=getFriendslist(userid);
	 HashMap h = new HashMap();
	 StringBuffer names = new StringBuffer();
	 StringBuffer photos =new StringBuffer();
	 String url ="";
	 photos.append(url);
	 
	 if(v1!=null&&v1.size()>0)
	   {	
		   for(int i=0;i<v1.size();i++)
	       {
			   HashMap hmt=(HashMap)v1.elementAt(i);
			   String fname=(String)hmt.get("fname");
			   names.append(fname);
               String lname=(String)hmt.get("lname");
               String email=(String)hmt.get("email");
			   Vector v2=null;
			   v2=getPhotoDetails(lname);
			   HashMap hm3= new HashMap();				
					if((v2!=null)&&(v2.size()>=0))
					{
						for(int j=0;j<v2.size();j++)
						{
							HashMap hmt1=(HashMap)v2.elementAt(j);
							url = (String)hm3.put("j",hmt1.get("uploadurl"));								
							if(url==null)
							photos.append( "http://swemat01.sweblend.se/smallpics/default.jpg");
							else
							photos.append(url);
							photos.append(" ");							
						}
					}
%>
	<input type="hidden" name="email1" value="<%=email%>">
<% if(i==0){%>
<tr><td >Friends</td><td><table>
<tr><td>
<a href="#" name ="CheckAll" onClick="checkAll(document.myform.chxbox)">Select All</a> | <a href="#" name ="UnCheckAll" onClick="uncheckAll(document.myform.chxbox)">Clear All</a>

</td></tr><tr>
<%} else if(i%3==0){%>


</tr><tr>
<%} %>
	<td width="40%">	
	<img width=40 height=40 src="/home/images/thumbnail/<%=url%>" align ='centre'></img>
	<br><input type='checkbox' name='chxbox' value="<%=email%>"><%=fname%>
</td>
	
 <%   }	   %>
		   </tr></table></td></tr>
<%

	   }
		   String words= photos.toString();
		   for(int i=0;i<words.length();i++)
		   {
			   if (words.charAt(i)==' ')
			   {				  
				   words =words.substring(i);
				   break;
			   }
		   }

%>
<tr><td>Personal Message</td>
<td>
<textarea id="message" name="message" rows='10' cols='50' onfocus="this.value=(this.value==' ')?'':this.value">
Hi,

I thought you might be interested in '<%=eventname%>' event.

Here is the listing URL: 
<%=eventURL%>

You might even get friend discount, please click on the Event URL to see the discount.

Thanks.
</textarea></td></tr>
<tr>
<input type="hidden" name="groupid" value=<%=groupid%>/><td></td>
<td align="center">
<input type="submit" name="submit" value="Submit" />
<input type="button" name="bbb" value="Cancel" onClick="hide();"></td>
</tr>
</table>
</form>
