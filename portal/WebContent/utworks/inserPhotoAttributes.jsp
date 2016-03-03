<%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*,java.awt.*,java.awt.image.*,com.sun.image.codec.jpeg.*" %>
<%@ page import="com.eventbee.photos.*" %>
<%@ page import="com.drew.metadata.*" %>
<%@ page import="com.drew.metadata.exif.*" %>
<%@ page import="com.drew.metadata.iptc.*" %>
<%@ page import="com.drew.imaging.jpeg.*" %>
<%!
HashMap getPhotoAttributes(String filename,String directoryseperator){

HashMap hm=new HashMap();
try{
String dirPath=EbeeConstantsF.get("profile.image.path","/mnt/desihub/pics/photo");
File jpegFile = new File(dirPath + directoryseperator+filename);
Metadata metadata = JpegMetadataReader.readMetadata(jpegFile);
Directory exifDirectory = metadata.getDirectory(ExifDirectory.class);
String cameraMake = exifDirectory.getString(ExifDirectory.TAG_MAKE);
String cameraModel = exifDirectory.getString(ExifDirectory.TAG_MODEL);
String date = exifDirectory.getString(ExifDirectory.TAG_DATETIME);
String copyright = exifDirectory.getString(ExifDirectory.TAG_COPYRIGHT);
Directory iptcDirectory = metadata.getDirectory(IptcDirectory.class);
String caption = iptcDirectory.getString(IptcDirectory.TAG_CAPTION);
if(cameraMake!=null)hm.put("cameraMake",cameraMake);
if(cameraModel!=null)hm.put("cameraModel",cameraModel);
if(date!=null)hm.put("date",date);
if(copyright!=null)hm.put("copyright",copyright);
if(caption!=null)hm.put("caption",caption);
}catch(Exception e){
System.out.println("Exception in getPhotoAttributes"+e.getMessage());
}
return hm;
}
%>
<%
/* upload url is to retrived using this query*/
String query="select uploadurl from member_photos order by created_at desc ";
java.util.List list=DbUtil.getValues(query,null);

/* list has all upload urls in database*/

StatusObj sobj=null;
if(list!=null&&list.size()>0){
out.println("Total number of photos to be created: "+list.size());

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"Total number of photos to be created:",list.size()+"","",null);

	for(int i=0;i<list.size();i++){
		String url=(String)list.get(i);
		HashMap photoAttributes=getPhotoAttributes(url,"/");
		if(photoAttributes!=null&&photoAttributes.size()>0){
					
			
			Set set=photoAttributes.entrySet();
			for( Iterator iter=set.iterator();iter.hasNext();){
				Map.Entry me=(Map.Entry)iter.next();
				String key=me.getKey().toString();
				String val=me.getValue().toString();
				DbUtil.executeUpdateQuery("insert into photo_attributes(photoid,name,value) select photo_id,?,? from member_photos where uploadurl=? ",new String [] {key,val,url});
			}
		}
	}
}
%>
