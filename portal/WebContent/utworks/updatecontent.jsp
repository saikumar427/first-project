<%@ page import="java.util.*,com.eventbee.general.*,java.io.*,org.json.*"%>
<%!
	String CLASSNAME = "updatecontent.jsp";
	
	private String updateEventsCustomCode(String dirPath,String query){
		int c=0;
		try{
		File dir = new File(dirPath);
		String[] filelist =dir.list();
		for(int i=0;i<filelist.length;i++){
			String data = readFile(dirPath,filelist[i]);
			String[] eventid = filelist[i].split(".txt");
			StatusObj stobj = DbUtil.executeUpdateQuery(query,new String[]{data,eventid[0]});
			if(stobj.getStatus()){
				c++;
			}
		}
		}catch(Exception e){
			EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASSNAME, "updateEventsCustomCode() ", e.getMessage(), null) ;
		}
		return ""+c;
	}
	
	public String readFile(String dirPath,String filename) {
		String filePath = dirPath+"/"+filename;
		StringBuffer fileContent = new StringBuffer();
		try {
			File file = new File(filePath);
			BufferedReader reader = new BufferedReader(new FileReader(file));
			String line;
			while ((line = reader.readLine()) != null) {
				fileContent.append(line);
				fileContent.append("\r\n");
				
			}
			reader.close();
			file.delete();
		} catch (IOException e) {
			EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASSNAME, "readFile()", e.getMessage(), null) ;
		}
		return fileContent.toString();
	}
%>

<%
	JSONObject jsonobj = new JSONObject();
	String directory = request.getParameter("dirpath");
	String query = request.getParameter("query");
	String count = updateEventsCustomCode(directory,query);
	jsonobj.put("status","success");
	jsonobj.put("count",count);
	out.println(jsonobj);
	
%>