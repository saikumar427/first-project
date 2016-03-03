<%@ page import="java.io.*"%>
<%!
String filepath=EbeeConstantsF.get("usertheme.file.path","/opt/jboss3.2.2/jboss-3.2.2/server/default/deploy/home.war/userthemes/");
		
void readNCreateFiles(String filename,String themeid,String ext){
	try{		
		
		String newfilename=filepath+filename;
		String content="";
		String str=null;
		

		File fobj=new File(newfilename);
		if(fobj.exists()){
			
			StringBuffer sb=new StringBuffer(); 
			BufferedReader bufreader = new BufferedReader(new FileReader(fobj));
			while((str=bufreader.readLine())!=null)
				sb.append(str);
		
			content=sb.toString();
			
		}
		
		
		BufferedWriter bwfile = new BufferedWriter(new FileWriter(filepath+themeid+ext));
		bwfile.write(content);
		bwfile.close();
	
		
	}
	catch(Exception e){
		
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "/customevents/themefilefunctions.jsp", "exception in readNCreateFiles", e.getMessage(), e ) ;
	}
	
	finally{
				try{
	
				if(bufreader!=null)
			      bufreader.close();
			     }
	
			 catch(Exception e){
				System.out.println("Exception occured in themes reader "+e.getMessage());
			 }
	 }
	
	
}





void createFiles(String content,String themeid,String ext){
	try{
		
		String filename=filepath+themeid+ext;
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"savethemesasfiles.jsp"," file name is"+filename,"",null);
		BufferedWriter bwfile = new BufferedWriter(new FileWriter(filename));
		bwfile.write(content);
		bwfile.close();
				
	}
	catch(Exception e){
	
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "/customevents/themefilefunctions.jsp", "exception in createFiles", e.getMessage(), e ) ;
	}
		
}

String readFilesNReturnContent(String filename){
	String content="";		
	try{
		
		String str=null;
		String sysfilename=filepath+filename;
		
				
		File fobj=new File(sysfilename);
		if(fobj.exists()){
			StringBuffer sb=new StringBuffer(); 
			BufferedReader bufreader = new BufferedReader(new FileReader(fobj));
			while((str=bufreader.readLine())!=null){
				sb.append(str);
				sb.append("\n");
				}
			content=sb.toString();
		}
		
		
		
	}
	catch(Exception e){
		
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "/customevents/themefilefunctions.jsp", "exception in readFilesNReturnContent", e.getMessage(), e ) ;

	}
	
	finally{
					try{
		
					if(bufreader!=null)
				      bufreader.close();
				     }
		
				 catch(Exception e){
					System.out.println("Exception occured in themes reader "+e.getMessage());
				 }
		 }
	
	
	
	return content;
	
}

%>