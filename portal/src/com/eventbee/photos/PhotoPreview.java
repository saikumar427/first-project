package com.eventbee.photos;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.io.*;
import java.util.*;
import com.eventbee.general.*;
import com.eventbee.general.formatting.*;
import com.eventbee.authentication.*;
import java.awt.*;
import java.awt.image.*;
import com.sun.image.codec.jpeg.*;
import com.eventbee.photos.*;
import com.drew.metadata.*;
import com.drew.metadata.exif.*;
import com.drew.metadata.iptc.*;
import com.drew.imaging.jpeg.*;
import org.apache.struts.action.*;

public class PhotoPreview extends Action {




String INSERT_MEMBER_PHOTO=
" insert into member_photos(encrypt_photoid,photoname,user_id,photo_id,uploadurl "
+" ,caption ,absoluteurl ,onclickurl  ,height,width, "
+" created_by  ,created_at  ,updated_by  ,updated_at,privacylevel,tags,status) "
+" values(?,?,?, ?, ?, ?, ?, ?, ?, ?,'memberphotos', now(), 'memberphot0s', now(),?,?,'pending')" ;


String INSERT_PHOTO_TAGS="insert into photo_tags(photoid,tags) values(?,?)";


boolean createImages(int width,int height,String imgname,String imagedirpath, String directoryseperator){
 boolean flag=true;
	String dirPath=EbeeConstantsF.get("profile.image.path","/mnt/desihub/pics/photo");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PhotoPreview.java","photo.image.path",dirPath,null);
	try{
	Image image = Toolkit.getDefaultToolkit().getImage(dirPath +directoryseperator+imgname );
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PhotoPreview.java","image.dir.path",imagedirpath,null);
	MediaTracker mediaTracker = new MediaTracker(new Panel());
	mediaTracker.addImage(image, 0);
	mediaTracker.waitForID(0);
	int imageWidth = image.getWidth(null);
	int imageHeight = image.getHeight(null);
	int smallWidth = width;
    	int smallHeight = height;
		double smallRatio = (double)smallWidth / (double)smallHeight;
    			double imageRatio1 = (double)imageWidth / (double)imageHeight;
    			if (smallRatio < imageRatio1) {
      				smallHeight = (int)(smallWidth / imageRatio1);
    			} else {
      				smallWidth = (int)(smallHeight * imageRatio1);
    			}
			BufferedImage smallImage = new BufferedImage(smallWidth,
      				smallHeight, BufferedImage.TYPE_INT_RGB);
    			Graphics2D graphics2D_1 = smallImage.createGraphics();
    			graphics2D_1.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
	      			RenderingHints.VALUE_INTERPOLATION_BILINEAR);
    			graphics2D_1.drawImage(image, 0, 0, smallWidth, smallHeight, null);
			BufferedOutputStream bfout1 = new BufferedOutputStream(new FileOutputStream(imagedirpath+directoryseperator+imgname));
    			JPEGImageEncoder encoder1 = JPEGCodec.createJPEGEncoder(bfout1);
    			JPEGEncodeParam param1 = encoder1.getDefaultJPEGEncodeParam(smallImage);
    			int quality1 = 100;
    			quality1 = Math.max(0, Math.min(quality1, 100));
    			param1.setQuality((float)quality1 / 100.0f, false);
    			encoder1.setJPEGEncodeParam(param1);
    			encoder1.encode(smallImage);
			}catch(Exception e){
				EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,"photopreviw.jsp", "createImages()", e.getMessage(), e);
			}

	return flag;
}
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



 public ActionForward execute(ActionMapping actionmapping, ActionForm actionform, HttpServletRequest request, HttpServletResponse response) throws Exception
   {



    try {

HttpSession session = request.getSession();
ArrayList photoarray=new ArrayList();
Authenticate authData=(Authenticate)session.getAttribute("authData");
Map requestmap=(HashMap)request.getAttribute("FORM_PARAMS");

if(authData!=null){
HashMap errorMap=new HashMap();
HashMap attribMap=new HashMap();
HashMap imageAttribMap=null;
boolean flag=false;
boolean hasimages=false;
String myimage="";
String imagedis="";
String imageheight="";
String imagewidth="";
String caption="";
String imagesize="";
String serveradd=EbeeConstantsF.get("serveraddress","");


String [] clubids=(String [])request.getAttribute("CLUBIDS");


String albumid="";
String appname="portal";

String contextadd=(String)session.getAttribute("HTTP_SERVER_ADDRESS");

String privacysetting=(String)requestmap.get("photopref");
String showfriends=(String)requestmap.get("showfriends");

String tags=(String)requestmap.get("tags");
if(tags==null) tags=" ";
String privacylevel="public";
String photoname="";
StatusObj statobj=null;
String img1uploaded=null;

String imglocation=EbeeConstantsF.get("profile.image.path","/mnt/desihub/pics/photo");
String [] tagarray=null;
DBQueryObj [] dbquery=null;
String photo_id=null;
String encodeid=null;
String command ="";
Process child;
int [] sizearray={50,100,500};
String directoryseperator=EbeeConstantsF.get("system.directory.path.seperator","/");
String [] imgstorlocation={EbeeConstantsF.get("smallthumbnail.photo.image.path","/mnt/desihub/pics/photo"),EbeeConstantsF.get("thumbnail.photo.image.path","/mnt/desihub/pics/photo"),EbeeConstantsF.get("big.photo.image.path","/mnt/desihub/pics/photo")};
/*
String no_of_photos=request.getParameter("NUMBER_OF_FILES");
int no_photos=Integer.parseInt(no_of_photos);

*/
String no_of_photos=(String)request.getAttribute("NO_OF_PHOTOS");
int no_photos=Integer.parseInt(no_of_photos);



for(int i=0;i<no_photos;i++){

	img1uploaded=(String)request.getAttribute("uploads["+i+"]");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PhotoPreview.java","img1uploaded====: "+img1uploaded,"img1uploaded",null);
	caption=(String)requestmap.get("caption"+(i+1));
	if(caption==null)caption="";
	if(img1uploaded !=null){

		attribMap=(HashMap)request.getAttribute(img1uploaded);
		if(attribMap!=null){
			photoname=GenUtil.getHMvalue(attribMap,"uploadname","");
		}

		hasimages=true;
		ImageHandlerNew imghnd=new ImageHandlerNew( img1uploaded,"profile",null);
		statobj =imghnd.processFile();
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PhotoPreview.java","statobj: "+statobj.getStatus(),"attribMap is null",null);

		if(!statobj.getStatus()){
			flag=true;
			errorMap.put("uploads["+i+"]",statobj);
		}else{
			imageAttribMap=(HashMap)statobj.getData();
			imageAttribMap.put("caption",caption);
			imageAttribMap.put("photoname",photoname);
			photoarray.add(imageAttribMap);
		}
	}
	errorMap.put("caption"+(i+1),caption);
}
errorMap.put("privacylevel",privacysetting);
errorMap.put("showfriends",showfriends);
if("private".equals(privacysetting)&&"showfriends".equals(showfriends)){
	privacylevel="protected";
}else if("private".equals(privacysetting)){
	privacylevel="private";
}
errorMap.put("tags",tags);
if(flag||!hasimages){
	if(!hasimages){
		errorMap.put("Noimages","Select a photo to upload");
	}else{
		errorMap.put("Noimages","");
	}
	session.setAttribute("UPLOAD_errorMap",errorMap);
	request.setAttribute("no_photos",no_of_photos);
	return actionmapping.findForward("error");
}else{
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PhotoPreview.java","photoarray====: "+photoarray,"photoarray",null);
        if(photoarray!=null&&photoarray.size()>0){
        int j=0;
	tagarray=null;
        if(tags!=null&&!"".equals(tags.trim())){
		tagarray=GenUtil.strToArrayStr(tags,",");
		dbquery=new DBQueryObj [tagarray.length*photoarray.size()];
     	}
	for(int i=0;i<photoarray.size();i++){
		photo_id=DbUtil.getVal("select nextval('seq_imageid') as photoid",null);
		encodeid=EncodeNum.encodeNum(photo_id);
  		imageAttribMap=(HashMap)photoarray.get(i);
  		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PhotoPreview.java","imageAttribMap====: "+imageAttribMap,"imageAttribMap",null);
		if(imageAttribMap!=null){
			myimage=imageAttribMap.get("imagename").toString();
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PhotoPreview.java","myimage====: "+myimage,"myimage",null);
			imageheight=imageAttribMap.get("imageheight").toString();
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PhotoPreview.java","imageheight====: "+imageheight,"imageheight",null);
			imagewidth=imageAttribMap.get("imagewidth").toString();
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PhotoPreview.java","imagewidth====: "+imagewidth,"imagewidth",null);
			imagesize=imageAttribMap.get("imagesize").toString();
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PhotoPreview.java","imagesize====: "+imagesize,"imagesize",null);
			caption=imageAttribMap.get("caption").toString();
			photoname=imageAttribMap.get("photoname").toString();
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PhotoPreview.java","photoname====: "+photoname,"photoname",null);
			int length=photoname.lastIndexOf('.');
			photoname=photoname.substring(0,length);
			String [] insertrecord=new String[]{encodeid,photoname,authData.getUserID(),photo_id,myimage,caption,null,null,imageheight,imagewidth,privacylevel,tags};
			DbUtil.executeUpdateQuery(INSERT_MEMBER_PHOTO,insertrecord);
			HashMap photoAttributes=getPhotoAttributes(myimage,directoryseperator);
			if(photoAttributes!=null&&photoAttributes.size()>0){


			Set set=photoAttributes.entrySet();
			for( Iterator iter=set.iterator();iter.hasNext();){
			Map.Entry me=(Map.Entry)iter.next();
			String key=me.getKey().toString();
			String val=me.getValue().toString();
			DbUtil.executeUpdateQuery("insert into photo_attributes(photoid,name,value) values(?,?,?)",new String [] {photo_id,key,val});
			}

			}
			if(tagarray!=null){
			for(int k=0;k<tagarray.length;k++){
				dbquery[j++]=new DBQueryObj(INSERT_PHOTO_TAGS,new String [] {photo_id,(tagarray[k].trim()).toLowerCase()});
			}
			}
			try{
			for(int k=0;k<sizearray.length;k++){
			Thread.sleep(30);
				if(Integer.parseInt(imagewidth)>sizearray[k]){
					createImages(sizearray[k],sizearray[k],myimage,imgstorlocation[k],directoryseperator);
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"photopreview.jsp","photo.image.path","small thumbnail image created",null);
				}else{

				command="cp "+imglocation+directoryseperator+myimage+" "+imgstorlocation[k]+directoryseperator+myimage;
				if("WINDOWS".equals(EbeeConstantsF.get("OS","LINUX"))){
					command = "cmd /c copy  "+imglocation+directoryseperator+myimage+" "+imgstorlocation[k]+directoryseperator+myimage;
				}
					child = Runtime.getRuntime().exec(command);
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"photopreview.jsp","photo.image.path","image copied to "+sizearray[k]+" size",null);
				}
			}
			}catch(Exception exp){
				EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,"photopreview.jsp", "exception: ", exp.getMessage(), exp);
			}



			 try
				 			{
				 			if(clubids!=null&&clubids.length>0)
				 			{
				 				for(int l=0;l<clubids.length;l++)
				 				{
				 					 albumid=DbUtil.getVal("select albumid from group_album_master where groupid=CAST(? AS INTEGER)",new String[]{clubids[l]});
				 					 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"photopreview.jsp"," ","albumid==================== "+albumid,null);
				 					 String hubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{clubids[l]});
				 					 if(albumid==null||"".equals(albumid))
				 					 {
				 					 albumid=DbUtil.getVal("select nextval('seq_imageid') as photoid",null);
				 					 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"photopreview.jsp"," ","albumid==================== "+albumid,null);
				 					 albumid=EncodeNum.encodeNum(albumid);
				 					 StatusObj stobj1=DbUtil.executeUpdateQuery("insert into group_album_master(groupid,isdefault,grouptype,albumid,created_at) values(CAST(? AS INTEGER),?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))",new String[]{(String)clubids[l],"yes","HUB",albumid,DateUtil.getCurrDBFormatDate()});
				 					      stobj1=DbUtil.executeUpdateQuery("insert into album_master(userid,privacylevel,created_at,albumid,name,status)  values(?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,'pending')",new String[]{authData.getUserID(),DateUtil.getCurrDBFormatDate(),"public",albumid,hubname});

				 					 }
				 					 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"photopreview.jsp"," ","photoid==================== "+encodeid,null);
				 					StatusObj sobj=DbUtil.executeUpdateQuery("insert into album_photos (photoid,albumid) values(?,?)",new String[]{encodeid,albumid});
				 					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"photopreview.jsp"," ","status of the inserting photos into album_photos is==================== "+sobj.getStatus(),null);

				 							 sobj=	DbUtil.executeUpdateQuery("update album_master set photourl=(select uploadurl from member_photos where encrypt_photoid=?) where albumid=?",new String[]{encodeid,albumid});
				 				              EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"photopreview.jsp"," ","status of the updating album_master is==================== "+sobj.getStatus(),null);

				 				}
				 				//session.removeAttribute("CLUBIDS");
				 			}
				 		}
				 		catch(Exception e)
				 		{
				 		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,"photopreview.jsp", "exception: ", e.getMessage(), e);
				 		}







		}






	}

if(dbquery!=null&&dbquery.length>0){
statobj=DbUtil.executeUpdateQueries(dbquery);
}
}
String purpose=(String)session.getAttribute("purpose1");
session.removeAttribute("purpose1");
return actionmapping.findForward("success");
}
}else{
        //if (true) {
        return actionmapping.findForward("nologin");

      //}

}


    } catch (Exception exception) {

		throw new ServletException(exception);

    }
  }
}
