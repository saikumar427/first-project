<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URL"%>
<%@page language="java" trimDirectiveWhitespaces="true"%>
<%
String code = request.getParameter("code");
String fileName = request.getParameter("fileName");
String extension = request.getParameter("extension");
try{
		if(".png".equals(extension) || ".gif".equals(extension) || ".jpg".equals(extension) || ".jpeg".equals(extension) || ".bmp".equals(extension))
		{
			System.out.println("image file");
			String location=EbeeConstantsF.get("filewidget.upload.webpath","http://localhost/home/images/photos/tempupload");
			location+="buyer_"+code+extension;
			System.out.println("the Location is ::- "+location);
			URL url = new URL(location);
			response.setContentType("application/x-download"); 
			fileName = fileName.replace(" ","_");
            response.setHeader("Content-Disposition", "attachment; filename="+fileName+extension);
            System.out.println("Download file name with extension : "+fileName+extension);
            URLConnection connection = url.openConnection();
            InputStream stream = connection.getInputStream();
            BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
            int len;
            byte[] buf = new byte[1024];
            while ((len = stream.read(buf)) > 0) {
                outs.write(buf, 0, len);
            }
            outs.close();
		}else{
			System.out.println("other file");
			String location=EbeeConstantsF.get("filewidget.upload.filepath","C:\\uploads");
			location+="buyer_"+code+extension;
			System.out.println("the Location is ::- "+location);
			response.setContentType("application/x-download"); 
			fileName = fileName.replace(" ","_");
	        response.setHeader("Content-Disposition", "attachment; filename="+fileName+extension);
	      	System.out.println("Download file name with extension : "+fileName+extension);
	        FileInputStream fileInputStream = new FileInputStream(location);
	        BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
	        
	        int i;   
	        while ((i=fileInputStream.read()) != -1) {  
	        	outs.write(i);   
	        }   
	        fileInputStream.close();   
	        outs.close();
		}
}catch(Exception e){
System.out.println("Exception Occured while downloading  file:"+e.getMessage());	
}
 %>