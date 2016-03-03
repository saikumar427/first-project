<%@ page import="java.util.*,java.io.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.customthemes.UserCustomThemeDB" %>

<%!

String GET_ALL_THEMES="select themeid,cssurl,content from user_customized_themes where module='event'";
String UPDATE_ALL_THEMES="update user_customized_themes set cssurl=?,content=?,updated_at=now() where themeid=?";
String THEMEINSERTQUERY="insert into user_customized_themes (userid,cssurl,content,module,themeid,themename,created_at,updated_at) values(?,?,?,?,?,?,now(),now())";

	Vector getThemes(){

		DBManager dbmanager=new DBManager();
		HashMap hm=null;
		Vector v=new Vector();
		StatusObj statobj=dbmanager.executeSelectQuery( GET_ALL_THEMES,null);
		int recount=0;
		if(statobj !=null && statobj.getStatus() && (recount=statobj.getCount())>0){
			for(int i=0;i<recount;i++){
				 hm=new HashMap();
					hm.put("themeid",dbmanager.getValue(i,"themeid",""));
					hm.put("cssurl",dbmanager.getValue(i,"cssurl",""));
					hm.put("content",dbmanager.getValue(i,"content",""));
					v.add(hm);
			}
		}
		
		return v;
	}


%>
<%
String filepath=EbeeConstantsF.get("usertheme.file.path","C:\\jboss-3.2.2\\server\\default\\deploy\\home.war\\userthemes\\");
Vector themevec=new Vector();
HashMap themehm=null;
String themeid="",cssfilename="",htmlfilename="",cssurl="",content="";
themevec=getThemes();

if(themevec!=null&&themevec.size()>0){
	
	for(int i=0;i<themevec.size();i++){
		themehm=new HashMap();
		themehm=(HashMap)themevec.elementAt(i);	
		
		themeid=(String)themehm.get("themeid");
		cssurl=(String)themehm.get("cssurl");
		content=(String)themehm.get("content");
		
		cssfilename=filepath+themeid+".css";
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"savethemesasfiles.jsp","css file name is"+cssfilename,"",null);
		
		BufferedWriter brcss = new BufferedWriter(new FileWriter(cssfilename));
		brcss.write(cssurl);
		brcss.close();
		
		htmlfilename=filepath+themeid+".html";
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"savethemesasfiles.jsp","html file name is"+htmlfilename,"",null);
		BufferedWriter brhtml = new BufferedWriter(new FileWriter(htmlfilename));
		brhtml.write(content);
		brhtml.close();
		StatusObj stobj=DbUtil.executeUpdateQuery(UPDATE_ALL_THEMES,new String[]{themeid+".css",themeid+".html",themeid},null);		
	}
}


//response.sendRedirect("done.jsp?UNITID="+request.getParameter("UNITID"));
%>
