<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.useraccount.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*,java.awt.*,java.awt.image.*,com.sun.image.codec.jpeg.*" %>
<%@ page import="com.eventbee.photos.*" %>

<%!
class imageprocessor{

	int createImages(int width,int height,String imgname,String imagedirpath,String imgname1){
		int i=0;
		String dirPath=EbeeConstantsF.get("profile.image.path","/mnt/desihub/pics/photo");
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"photopreview.jsp","photo.image.path",dirPath,null);
			try{
			File file=new File(dirPath +"/"+imgname);
			if(file.exists()){
			Image image = Toolkit.getDefaultToolkit().getImage(dirPath +"/"+imgname );
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"photopreview.jsp","photo.image.path",dirPath,null);
			MediaTracker mediaTracker = new MediaTracker(new Panel());
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"photopreview.jsp","photo.image.path",dirPath,null);
			mediaTracker.addImage(image, 0);
			mediaTracker.waitForID(0);
			int imageWidth = image.getWidth(null);
			int imageHeight = image.getHeight(null);
			int smallWidth = width;
			int smallHeight = height;
			/* creates images if the width of the image is larger than our specified length*/
				if(smallWidth>width){
				i=1;
				}else{
						log("smallWidth width/height = " + smallWidth + "/" + smallHeight);
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
						BufferedOutputStream bfout1 = new BufferedOutputStream(new FileOutputStream(imagedirpath+"/"+imgname1));
						JPEGImageEncoder encoder1 = JPEGCodec.createJPEGEncoder(bfout1);
						JPEGEncodeParam param1 = encoder1.getDefaultJPEGEncodeParam(smallImage);
						int quality1 = 100;
						quality1 = Math.max(0, Math.min(quality1, 100));
						param1.setQuality((float)quality1 / 100.0f, false);
						encoder1.setJPEGEncodeParam(param1);
						encoder1.encode(smallImage);
						i=2;
				}
			}
			}catch(Exception e){
						EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,"photopreviw.jsp", "createImages()", e.getMessage(), e);
			}
	return i;
	}
void processedData(){
	
	String imglocation=EbeeConstantsF.get("profile.image.path","/mnt/desihub/pics/photo");
	
	/* location where images created are to be placed*/
	
	String bigimglocation=EbeeConstantsF.get("big.photo.image.path","/mnt/desihub/pics/photo");
	String smallimglocation=EbeeConstantsF.get("smallthumbnail.photo.image.path","/mnt/desihub/pics/photo");
	String thumbimglocation=EbeeConstantsF.get("thumbnail.photo.image.path","/mnt/desihub/pics/photo");
	
	
	/* upload url is to retrived using this query*/
	String query="select uploadurl from member_photos order by created_at desc ";
	java.util.List list=DbUtil.getValues(query,null);
	
	/* list has all upload urls in database*/
	
	
	StatusObj sobj=null;
	if(list!=null&&list.size()>0){
	//list.clear();
		//out.println("Total number of photos to be created: "+list.size());
		
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"Total number of photos to be created:",list.size()+"","",null);
		
		for(int i=0;i<list.size();i++){
		
			//out.println("Total number of photos to be created for: "+i+" images");
			//Thread.sleep(60);
			String uploadurl=(String)list.get(i);
			
			/* part of the uploadurl string before '.' file format extension */
			
			String photo_id=uploadurl.substring(0,uploadurl.indexOf("."));
			
			/* extension of the uploadurl string from  '.' file format extension */
			
			String extension=uploadurl.substring(uploadurl.indexOf("."));
			
			
			//out.println("uploadurl: "+uploadurl+", "+"encrypted upload url: "+uploadurl1);
			
			/* encrypt uploadid*/
			
			String encodeid=EncodeNum.encodeNum(photo_id);
			
			/* encrypted file name of the existing upload url */
			
			String uploadurl1=encodeid+extension;
			
			//out.println("uploadurl: "+uploadurl+", "+"encrypted upload url: "+uploadurl1);
			
			/* update uploadurl with new encrypted url */
			
			sobj=DbUtil.executeUpdateQuery("update member_photos set uploadurl=?, encrypt_photoid=?  where uploadurl=?",new String [] {uploadurl1,encodeid,uploadurl});
			sobj=DbUtil.executeUpdateQuery("update user_profile set photourl=? where photourl=?",new String [] {uploadurl1,uploadurl});
			sobj=DbUtil.executeUpdateQuery("update classifieds set photourl=? where photourl=?",new String [] {uploadurl1,uploadurl});
			sobj=DbUtil.executeUpdateQuery("update eventinfo set photourl=? where photourl=?",new String [] {uploadurl1,uploadurl});
			sobj=DbUtil.executeUpdateQuery("update service_master set photourl=? where photourl=?",new String [] {uploadurl1,uploadurl});
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,uploadurl+": "+"uploadurl1","updated record",""+sobj,null);
			
			/* this is for creating images with various sizes*/
			
			Process child;
						boolean isbigger=false;
						int ck=0;
						String command="";
						try{
							/* creates if create images returns true*/
							
							/* creates if create small thumbnail images */
							Thread.sleep(60);
							ck=createImages(50,50,uploadurl,EbeeConstantsF.get("smallthumbnail.photo.image.path","/mnt/desihub/pics/photo"),uploadurl1);
							
							EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,uploadurl+": "+"uploadurl1","photo.image.path","image created at "+smallimglocation+" location",null);
							//out.println("successfully created for uploadurl: "+uploadurl+", "+"encrypted upload url: "+uploadurl1+", at location "+smallimglocation);
							
							
							if(ck==1){
								command="cp "+imglocation+"/"+uploadurl+" "+EbeeConstantsF.get("smallthumbnail.photo.image.path","/mnt/desihub/pics/photo")+"/"+uploadurl1;
								child = Runtime.getRuntime().exec(command);
								
								EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,uploadurl+": "+"uploadurl1","photo.image.path","image copied into "+smallimglocation+" location",null);
								//out.println("successfully copied for uploadurl: "+uploadurl+", "+"encrypted upload url: "+uploadurl1+", at location "+smallimglocation);
							}
							if(ck==0){
							sobj=DbUtil.executeUpdateQuery("delete from member_photos where uploadurl=?",new String [] {uploadurl1});
							
							}else{
							/* creates if create thumbnail images */
							isbigger=false;
							Thread.sleep(60);
							ck=createImages(100,100,uploadurl,EbeeConstantsF.get("thumbnail.photo.image.path","/mnt/desihub/pics/photo"),uploadurl1);
							
							//out.println("successfully created for uploadurl: "+uploadurl+", "+"encrypted upload url: "+uploadurl1+", at location "+thumbimglocation);
							EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,uploadurl+": "+"uploadurl1","photo.image.path","image created at" +thumbimglocation+" location",null);
							
							if(ck==1){
								command="cp "+imglocation+"/"+uploadurl+" "+EbeeConstantsF.get("thumbnail.photo.image.path","/mnt/desihub/pics/photo")+"/"+uploadurl1;
								child = Runtime.getRuntime().exec(command);
								
								EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,uploadurl+": "+"uploadurl1","photo.image.path","image copied into "+thumbimglocation+" location",null);
								//out.println("successfully copied for uploadurl: "+uploadurl+", encrypted upload url: "+uploadurl1+", at location "+thumbimglocation);
							}
							/* creates if create big images */
							isbigger=false;
							Thread.sleep(60);
							ck=createImages(500,500,uploadurl,EbeeConstantsF.get("big.photo.image.path","/mnt/desihub/pics/photo"),uploadurl1);
							
							EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,uploadurl+": "+"uploadurl1","photo.image.path","image created at "+bigimglocation+" location",null);
							//out.println("successfully created for uploadurl: "+uploadurl+", "+"encrypted upload url: "+uploadurl1+", at location "+bigimglocation);
							
							if(ck==1){
								command="cp "+imglocation+"/"+uploadurl+" "+EbeeConstantsF.get("big.photo.image.path","/mnt/desihub/pics/photo")+"/"+uploadurl1;
								child = Runtime.getRuntime().exec(command);
								
								EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,uploadurl+": "+"uploadurl1","photo.image.path","image copied into "+bigimglocation+" location",null);
								//out.println("successfully copied for uploadurl: "+uploadurl+", "+"encrypted upload url: "+uploadurl1+", at location "+bigimglocation);
							}
							
							
							/* after creating all the images original file content is moved to new encrtted file */
							
							command="mv "+imglocation+"/"+uploadurl+" "+imglocation+"/"+uploadurl1;
							child = Runtime.getRuntime().exec(command);
							}
							EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,uploadurl+": "+"uploadurl1","photo.image.path","image copied into into encrypted file",null);
							//out.println("successfully copied for uploadurl: "+uploadurl+", "+"encrypted upload url: "+uploadurl1+", at location "+imglocation);
						}catch(Exception exp){
							EventbeeLogger.log(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,uploadurl+", "+"encrypted upload url: "+uploadurl1,"photo.image.path","Exception "+exp.getMessage(),null);
						
						}
		
		}//end for each image
	}
}
}
%>
<%
imageprocessor imgproc=new imageprocessor();
imgproc.processedData();
out.println("suceesfully done");
%>


