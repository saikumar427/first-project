<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.nuser.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.general.formatting.*" %>

<%!

String RECENTPHOTODSQ="select encrypt_photoid,photoname,getPhotoCommentsCount(photo_id||'') as count,"
+" photo_id,uploadurl ,caption ,absoluteurl,onclickurl,height,width,privacylevel,tags "
+" from member_photos where "
+" privacylevel='public' and status='approve' order by created_at desc limit ? ";


void getRecentPhotos(String loc,String limit,Set popset){
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery( RECENTPHOTODSQ,new String[]{limit});
	int recordcounttodata=statobj.getCount();
	if(statobj!=null && statobj.getStatus() && recordcounttodata>0){
	
		for(int i=0;i<recordcounttodata;i++){
			Map popmap=new HashMap();
			popmap.put("encrypt_photoid", dbmanager.getValue(i,"encrypt_photoid","")   );
			popmap.put("photoname", dbmanager.getValue(i,"photoname","")   );
			popmap.put("count", dbmanager.getValue(i,"count","")   );
			popmap.put("photo_id", dbmanager.getValue(i,"photo_id","")   );
			popmap.put("uploadurl", dbmanager.getValue(i,"uploadurl","")   );
			popmap.put("caption", dbmanager.getValue(i,"caption","")   );
			popmap.put("absoluteurl", dbmanager.getValue(i,"absoluteurl","")   );
			popmap.put("onclickurl", dbmanager.getValue(i,"onclickurl","")   );
			popmap.put("height", dbmanager.getValue(i,"height","")   );
			popmap.put("width", dbmanager.getValue(i,"width","")   );
			popmap.put("privacylevel", dbmanager.getValue(i,"privacylevel","")   );
			popmap.put("tags", dbmanager.getValue(i,"tags","")   );
			popset.add(popmap);
		}//end for
	
	}//end if


}

%>
<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.desihub.com");
String imagedis=EbeeConstantsF.get("thumbnail.photo.image.webpath","")+"/";

 String location=request.getParameter("lid");
 String country=request.getParameter("cid");
 
 
 
 String loc="";
int count=0;

if("null".equals(location)&&"null".equals(country))
country="usa";

if(location!=null&&!"".equals(location)){
	loc=country+"_"+location;
	loc=loc.toLowerCase();
	}

if("null".equals(location)&&country!=null&&!"".equals(country)){
	loc=country;
	loc=loc.toLowerCase();
	
	
	}
	
	
	
	


Set popset=new HashSet();

getRecentPhotos(loc,"6",popset);

if(popset.size()<6){
	count=6-popset.size();
	loc="global";
	getRecentPhotos(loc,Integer.toString(count),popset);
}

%>




<%if(!popset.isEmpty()){%>
<table width="100%" align="center" class="portaltable" >
<tr><td><table>
<%

int i=0;
for(Iterator iter=popset.iterator();iter.hasNext();){
i++;
String htmltdclass=(i%2==0)?"oddbase":"evenbase";
Map photomap=(Map)iter.next();
%>


<tr >

<td align='center'><a href="/portal/photogallery/photodisplay.jsp?photo_id=<%=GenUtil.getHMvalue(photomap,"encrypt_photoid","",true)%>">
<img border='0' src='<%=imagedis+GenUtil.getHMvalue(photomap,"uploadurl","",true)%>' /><br/>
<font class='smallfont'><%=GenUtil.TruncateData(GenUtil.getHMvalue(photomap,"caption","",true),20)%></font></a>
<a href="/portal/photogallery/photodisplay.jsp?photo_id=<%=GenUtil.getHMvalue(photomap,"encrypt_photoid","",true)%>">
<font class='smallestfont'>(<%=GenUtil.getHMvalue(photomap,"count","0")%> comments)</font></td>


<td align='center'>


<%
if(iter.hasNext()){
photomap=(Map)iter.next();
%>

<a href="/portal/photogallery/photodisplay.jsp?photo_id=<%=GenUtil.getHMvalue(photomap,"encrypt_photoid","",true)%>">
<img border='0' src='<%=imagedis+GenUtil.getHMvalue(photomap,"uploadurl","",true)%>' /><br/>
<font class='smallfont'><%=GenUtil.TruncateData(GenUtil.getHMvalue(photomap,"caption","",true),20)%></font></a>
<a href="/portal/photogallery/photodisplay.jsp?photo_id=<%=GenUtil.getHMvalue(photomap,"encrypt_photoid","",true)%>">
<font class='smallestfont'>(<%=GenUtil.getHMvalue(photomap,"count","0")%> comments)</font>
<%
}
%>


</td>
</tr>


<%
}//end for
%>
</table></td></tr>
<tr  width="100%" align="center" >
	<td align="right" >
	&raquo;&nbsp;<a href="<%=PageUtil.appendLinkWithGroup("/portal/photogallery/photosview.jsp",(HashMap)request.getAttribute("REQMAP"))%>">All Photos</a>&nbsp;&nbsp;&nbsp;
	&raquo;&nbsp;<a href="/portal/auth/listauth.jsp?purpose=uploadphoto">Upload Photo</a>&nbsp;&nbsp;&nbsp;
	&raquo;&nbsp;<a href="/portal/helplinks/UploadaPhoto.jsp">Learn More</a>
	</td>
</tr>	

</table>

<%
}//end if
%>



