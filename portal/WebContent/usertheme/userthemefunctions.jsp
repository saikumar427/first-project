<%@ page import="java.util.*,java.sql.*,com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.event.EventDB,com.eventbee.event.*,com.eventbee.classifieds.*" %>

<%!

String [] attributes={"THEME_NAME","BACKGROUND","BACKGROUND_COLOR","BACKGROUND_IMAGE","BIGGER_TEXT_COLOR","BIGGER_FONT_TYPE","BIGGER_FONT_SIZE","MEDIUM_TEXT_COLOR","MEDIUM_FONT_TYPE","MEDIUM_FONT_SIZE","SMALL_TEXT_COLOR","SMALL_FONT_TYPE","SMALL_FONT_SIZE"};


Map getStremingAttributes(String userid,String purpose,String refid){
	Map hm=new HashMap();
	String query="select stream_attribute, attrib_value,streamid from streaming_attributes where streamid=(select streamid from streaming_details where userid=? and purpose=? and refid=?)";
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String []{userid,purpose,refid});
	int recordcount=statobj.getCount();
	if(recordcount>0){
		for(int i=0;i<recordcount;i++){
			hm.put(dbmanager.getValue(i,"stream_attribute",""),dbmanager.getValue(i,"attrib_value",""));
		}
		hm.put("streamid",dbmanager.getValue(0,"streamid",""));
	}
	return hm;
}




void insertStreamingAttributes(HttpServletRequest req,String streamid){
	StatusObj statobj=null;
	List dbquery=new ArrayList();
	String query="insert into streaming_attributes(streamid,stream_attribute,attrib_value) values(?,?,?)";
	//dbquery.add(new DBQueryObj("delete from streaming_attributes where streamid=?",new String [] {streamid}));
	for(int i=0;i<attributes.length;i++){
		dbquery.add(new DBQueryObj(query,new String [] {streamid,attributes[i],req.getParameter(attributes[i])}));
	}
	if(dbquery!=null&&dbquery.size()>0)
	  	statobj=DbUtil.executeUpdateQueries((DBQueryObj [])dbquery.toArray(new DBQueryObj [dbquery.size()]));
}




String insertStreamingDetails(String userid,String purpose,String refid){
	
	String query="insert into streaming_details(streamid,userid,purpose,refid) values(?,?,?,?)";
	String streamid=DbUtil.getVal("select nextval('streaming_id')",null);
	StatusObj statobj=DbUtil.executeUpdateQuery(query,new String[]{streamid,userid,purpose,refid});
	return streamid;
}


%>
