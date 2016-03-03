<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.photos.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>

<% java.util.Date date=new java.util.Date();%>
<%!
	
public Vector getUserPhoros(String userid){
	String GET_ALL_PHOTOS_USER="select encrypt_photoid,photoname,"
			//+" getPhotoCommentsCount(photo_id||'') as count, "
			+" photo_id,uploadurl ,caption ,status from"
			+" member_photos where user_id =?";		
	 DBManager dbmanager=new DBManager();
	 StatusObj stobj=dbmanager.executeSelectQuery(GET_ALL_PHOTOS_USER,new String[]{userid});
	 Vector v=new Vector();
		 if(stobj.getStatus()){
			for(int i=0;i<stobj.getCount();i++){
				HashMap hm=new HashMap();
				hm.put("encphotoid",dbmanager.getValue(i,"encrypt_photoid",""));
				hm.put("photoname",dbmanager.getValue(i,"photoname",""));
				hm.put("photo_id",dbmanager.getValue(i,"photo_id",""));
				hm.put("photo_id",dbmanager.getValue(i,"photo_id",""));
				hm.put("uploadurl",dbmanager.getValue(i,"uploadurl",""));
				hm.put("photo_id",dbmanager.getValue(i,"photo_id",""));
				
				v.add(hm);
			}			
		}
		
	return v;
	}

%>
<%
String platform = request.getParameter("platform");
 String imagedis=EbeeConstantsF.get("thumbnail.photo.image.webpath","")+"/";
 String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});

 String uploadurl="";
 String pimage="";
 String userid="";
 String encphotoid="";
 Authenticate authData=AuthUtil.getAuthData(pageContext);
 if(authData !=null){
	userid=authData.getUserID();
 }	
 Vector v= getUserPhoros(userid);
String type=request.getParameter("type");

if(type==null)
	type="";
%>
<% 
if("mgr".equals(type)){
	%>

<form name="nwtImagesMgrUpload" id="nwtImagesMgrUpload" method="post" action="/eventbeeticket/nwtImagesdisp.jsp" 
onsubmit="addnwtsellMgrImages('<%=groupid%>&t=<%=date.getTime()%>','<%=type %>'); return false;">
<%
}
else{%>
<form name="nwtImagesUpload" id="nwtImagesUpload" method="post" action="/eventbeeticket/nwtImagesdisp.jsp" 
onsubmit="addnwtsellImages('<%=groupid%>&t=<%=date.getTime()%>','<%=type %>','<%=request.getParameter("event_groupid")%>'); return false;">

<%
}
%>
<input type="hidden" name="isnwtImageUpload" value="yes" />
<input type="hidden" name="groupid" value="<%=groupid%>" />
<input type="hidden" name="event_groupid" value="<%=request.getParameter("event_groupid")%>" />

<input type="hidden" name="grouptype" value="event" />
<input type="hidden" name="type" value="<%=type%>" />
<table  id="eventhide_<%=type%>"  width="100%">
<tr class="evenbase"><td> &nbsp;<b>Select Image</b></td></tr>
<tr class="evenbase"><td >
<input type="radio" name="source_type" value="external" onclick="getExturl();"/>External URL</td>
<td class="evenbase"></td><td></td></tr>
<tr class="evenbase"><td id="exturl"  style="display:none"> 
<input type="text" name="url_source" size="40"/></td><td></td></tr>
<tr class="evenbase"><td ><input type="radio" name="source_type" value="inernal" onclick="getInternalPhotos();" checked/>My Eventbee Photos</td><td></td></tr>
<tr class="evenbase"><td >
<div STYLE=" height: 200px; width: 300px; font-size: 12px; overflow: auto;" id="internal_photos" >

<%

 if(v.size()>0){
 	for(int i=0;i<v.size();i++){
 		HashMap photosmap=(HashMap)v.get(i);
 		uploadurl=GenUtil.getHMvalue(photosmap,"uploadurl","");
 		encphotoid=GenUtil.getHMvalue(photosmap,"encphotoid","");
 		pimage=imagedis+uploadurl; 		
 	
 
%>
<input type="checkbox" name="nwtimage" value="<%=i%>" ><img border='0' src='<%=pimage%>' />
<input type="hidden" name="imageids" value="<%=encphotoid%>" >
<input type="hidden" name="urls" value="<%=pimage%>" >

<br/>
<%
		} 
 
 }

%>
</div>
</td></tr>

  
	<tr><td class="evenbase"  align="center">
		<input type="submit" name="addnwtImages" value="Add" />
<input type="button" name="cancelnwtImages" value="Cancel"
 onclick='document.getElementById("eventhide_<%=type%>").style.display="none"'/></td>

		<td class="evenbase"></td>
	</tr>
</table>
</form>
