<%@page import="com.eventbee.authentication.*,java.util.*,com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>

<%!
  String GETUSERPHOTOS="select photoname, uploadurl, photo_id, caption from member_photos where user_id=? ";
  
  String SELECTEDPHOTO="select photoname, uploadurl, photo_id, caption from member_photos where photo_id=(select photo_id from member_photos_location  where user_id=? and location_code='slot2')";
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
	
	
	
	public Map getSelectedPhoto(String userid){
  		
  		Map selectedphotomap=new HashMap();
  		DBManager dbmanager=new DBManager();
  		StatusObj statobj=dbmanager.executeSelectQuery( SELECTEDPHOTO,new String[]{userid});
  		int recount=0;
  		if(statobj !=null && statobj.getStatus() && (recount=statobj.getCount())>0){
  		
    			String photoname="";
  				String uploadurl="";
				String photo_id="";
			
						for(int i=0;i<recount;i++){
						  	photoname=dbmanager.getValue(i,"photoname","");
							uploadurl=dbmanager.getValue(i,"uploadurl","");
							photo_id=dbmanager.getValue(i,"photo_id","");
			
						}
				selectedphotomap.put("photoname",photoname);
				selectedphotomap.put("uploadurl",uploadurl);
  				selectedphotomap.put("photo_id",photo_id);
  
  			
  		}
  		return selectedphotomap;
	}
	
%>





<script language = "Javascript">
var photourl='';
function UploadPhoto(){
window.opener.location.reload();
self.close(); 
} 

</script>


<%

	String userid="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
	userid=authData.getUserID();
	
	}
	String imagedis=EbeeConstantsF.get("thumbnail.photo.image.webpath","")+"/";
	Map selectedphoto=getSelectedPhoto(userid);
	Map pmap=getPhotos(userid);
	
	String photoname[]=(String [])pmap.get("photoname" );
	String uploadurl[]=(String [])pmap.get("uploadurl" );
	String photo_id[]=(String [])pmap.get("photo_id" );
	
	
	String imageval=(String)selectedphoto.get("uploadurl");
	

	
	%>


<table>
<tr><td>
<b>Current Photo:  </b></td><td></td>

<td >
<%if(imageval!=null){%>
<img src="<%=imagedis%>/<%=imageval%>" border='0' />
<%}else{%>
None
<%}%>
</td>

</tr>
<tr><td></td></tr>
</table>
<table width='100%'  class='block' cellspacing="0" cellpadding="0" align='center'>
<%
	if(pmap!=null&&pmap.size()>0){
%>
	
	<form name="photos1" method="post" action="/photoupload/snapshotphotodisplay.jsp"  >
	<input type='hidden' name="purpose" value="network"/>
	<tr><td><table align='center' width='100%'>
	
	<tr><td class="inputlabel"  colspan='2' >
	Click on the Add button to change Main Photo: </td></tr>
	
	<tr><td height='5'></td></tr>
	
	
	</table></td></tr>
	
	<tr><td height='10'></td></tr>
	
	<tr><td><table align='center' width='100%'>
	
<%
	
	for(int i=0;i<uploadurl.length;i++){%><tr><%
	
	  for(int j=0;j<5;j++){
	  	if(i>=uploadurl.length)break;
%>

		<td width='10%'>
		<img src="<%=imagedis%>/<%=uploadurl[i]%>" border='0' /><br/>
		<input type='submit' name='submit1' value='Add' onClick=javascript:document.photos1.photouploadurl.value='<%=uploadurl[i]%>'; />
		
		</td>

<% 
		if(j<4) i++;
	}
%>
	</tr><tr><td height='10'></td></tr>
<%}%>

	</table></td></tr>


	<tr><td align="center">
	
	<input type='hidden' name="photouploadurl">
	<!--input type='hidden' name="UNITID" value='13579'-->
	<input type='button' name='cancel' value='Cancel' onclick="javascript:window.history.back()" /></td></tr>
	</form>
	


<%}else{
	session.setAttribute("uploadphotos","true");
%>
	<form name="upload" method="post" action="/portal/mytasks/uploadphotos.jsp?isnew=yes&type=Photos" onSubmit="return UploadPhoto()" >
	<input type='hidden' name="purpose" value='event'>
	<tr align='center' ><td colspan='2' align='center'>You have no photos in your account, 
	click on Upload button to upload your photos. You can set your Main Photo after uploading photos to your account.
	</td></tr>
	<tr align='center' colspan='2'>
	<td>
	<input type="submit" value="Upload"/>
	<input type="button" name="Submit" value="Cancel" onClick="javascript:window.history.back();"/></td>
	</tr>
	</form>
<%
	}
%>

	</table>

