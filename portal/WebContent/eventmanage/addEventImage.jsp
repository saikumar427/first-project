<%@page import="com.eventbee.authentication.*,java.util.*,com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%!


  String GETUSERPHOTOS="select photoname, uploadurl, photo_id, caption from member_photos where user_id=? ";
  
  public Map getPhotos(String userid){
  		
  		Map photomap=new HashMap();
  		DBManager dbmanager=new DBManager();
  		StatusObj statobj=dbmanager.executeSelectQuery( GETUSERPHOTOS,new String[]{userid});
  		int recount=0;
  		if(statobj !=null && statobj.getStatus() && (recount=statobj.getCount())>0){
  		
    			String[] photoname=new String[recount];
  			String[] uploadurl=new String[recount];
			String[] photo_id=new String[recount];
			
						for(int i=0;i<recount;i++){
							photoname[i]=dbmanager.getValue(i,"photoname","");
							uploadurl[i]=dbmanager.getValue(i,"uploadurl","");
							photo_id[i]=dbmanager.getValue(i,"photo_id","");
			
						}
				photomap.put("photoname",photoname);
				photomap.put("uploadurl",uploadurl);
  				photomap.put("photo_id",photo_id);
  
  			
  		}
  		return photomap;
	}


%>
<%

String from=request.getParameter("from");


%>

<script language = "Javascript">
var photourl='';


function UploadPhoto(){
window.opener.location.reload();
//self.close(); 
} 




</script>


<%
	Presentation presentation=new Presentation(pageContext);
	presentation.includeStyles();
%>
<%


String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
userid=authData.getUserID();

}

String purpose=request.getParameter("purpose");
String partnerid=request.getParameter("partnerid");



Map pmap=getPhotos(userid);

String photoname[]=(String [])pmap.get("photoname" );
String uploadurl[]=(String [])pmap.get("uploadurl" );
String photo_id[]=(String [])pmap.get("photo_id" );%>


<table width='100%'  class='block' cellspacing="0" cellpadding="0" align='center'>
<%if(pmap!=null&&pmap.size()>0){
%>



<form name="photos1" method="post" action="snapshotphotodisplay.jsp"  >
<input type="hidden" name="purpose" value="<%=purpose%>"/>
<input type="hidden" name="partnerid" value="<%=partnerid%>"/>

<tr><td><table align='center' width='100%'>

<tr><td class="inputlabel"  colspan='2' >
Click on the Add button to change Main Photo: </td></tr>

<tr><td height='5'></td></tr>


</table></td></tr>

<tr><td height='10'></td></tr>

<tr><td><table align='center' width='100%'>
<input type='hidden' name='GROUPID' value='<%=request.getParameter("GROUPID")%>'/>
<%
String imagedis=EbeeConstantsF.get("thumbnail.photo.image.webpath","")+"/";
System.out.println(imagedis);
for(int i=0;i<uploadurl.length;i++){%><tr><%

  for(int j=0;j<5;j++){
  if(i>=uploadurl.length)break;
%>

<td width='10%'>
<img src="<%=imagedis%>/<%=uploadurl[i]%>" border='0' /><br/>
<input type='submit' name='submit1' value='Add' onClick=javascript:document.photos1.photouploadurl.value='<%=uploadurl[i]%>'; />

</td>

<% if(j<4) i++;}%></tr><tr><td height='10'></td></tr>
<%}%>

</table></td></tr>


<tr><td align="center">

<input type='hidden' name="photouploadurl">
<!--input type='hidden' name="UNITID" value='13579'-->
<input type="button" name="Submit" value="Cancel" onClick="javascript:window.close();"/></td></tr>
</form>



<%}else{
session.setAttribute("uploadphotos","true");

%>
<form name="upload" method="post" action="addphotoselected.jsp" onSubmit="return UploadPhoto()" >

<tr align='center' ><td colspan='2' align='center'>You have no photos in your account, 
click on Upload button to upload your photos. You can set your Main Photo after uploading photos to your account.
</td></tr>
<tr align='center' colspan='2'>
<td>
<input type="submit" value="Upload"/>
<input type="button" name="Submit" value="Close" onClick="javascript:window.close();"/></td>
</tr>
</form>
<%
}
%>

</table>