<%@ page import="java.util.*,com.eventbee.general.*,java.io.*,org.json.*"%>
<%!
	String CLASSNAME = "getcontent.jsp";
	private HashMap getEventsCustomCode(String query){
		HashMap customcodeHMap=new HashMap();
		try{
			DBManager dbmanager=new DBManager();			
			StatusObj stobj=dbmanager.executeSelectQuery(query,new String[]{});
			if(stobj.getStatus()){
				for(int i=0;i<stobj.getCount();i++){
					customcodeHMap.put(dbmanager.getValue(i,"refid",""),dbmanager.getValue(i,"contenttocopy",""));
				}
			}
			return customcodeHMap;
		}catch(Exception e){
			EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASSNAME, "getEventsCustomCode() ", e.getMessage(), null) ;
		}
		return customcodeHMap;
	}
	public void deleteFiles(String dirPath) {
		try {
			File dir = new File(dirPath);
			String[] filelist =dir.list();
			for(int i=0;i<filelist.length;i++){
				File file = new File(dirPath+"/"+filelist[i]);
				file.delete();
			}
		} catch (Exception e) {
			EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASSNAME, "deleteFiles() ", e.getMessage(), null) ;
		}
	}
%>

<%
	JSONObject jsonobj = new JSONObject();
	int c=0;
	try{
	String directory = request.getParameter("dirpath");
	String query = request.getParameter("query");
	deleteFiles(directory);
	HashMap customcodeHMap = getEventsCustomCode(query);
	Set keys = customcodeHMap.keySet();
	Iterator iter = keys.iterator();
	while (iter.hasNext()) {
		String key = (String) iter.next();
		String value = (String) customcodeHMap.get(key);
		File dir =new File(directory);
		if(!dir.exists()){
			dir.mkdirs();
		}
		c++;
		File file = new File(directory+"/"+key+".txt");
		file.createNewFile();
		Writer output =  new BufferedWriter(new FileWriter(file));
		output.write(value);
		output.close();
	}
	}catch(Exception e){
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASSNAME, "scriptlet code ", e.getMessage(), null) ;
	}
	jsonobj.put("status","success");
	jsonobj.put("count",""+c);
	out.println(jsonobj);
	
%>