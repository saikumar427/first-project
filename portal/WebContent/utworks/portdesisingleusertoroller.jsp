<%@ page import="java.util.*,java.sql.*,javax.naming.*" %>
<%@ page import="java.util.*,java.sql.*,com.eventbee.general.*,com.eventbee.util.*" %>
<%!


/*

This is the utility provided for dumping portal user into rollerdb

*/



	java.sql.Connection getRollerConnection() throws Exception{
				
						Context ctx = new InitialContext();
						javax.sql.DataSource ds = (javax.sql.DataSource)ctx.lookup("java:/RollerDb");
						java.sql.Connection con = ds.getConnection();
						return con;
				
				
	}//end of getconnection
	
	
	String users_query="select up.first_name,up.last_name,up.email,up.user_id,a.login_name,acct_status  from user_profile up,authentication a where  a.acct_status=1 and role_id=-100 and a.user_id=up.user_id and a.login_name=?"; 
	
	
	
%>





<%

List userlist =new ArrayList();




DBManager dbmanager=new DBManager();


String usernameofportal=request.getParameter("username");
if(usernameofportal ==null)usernameofportal="";

if(!"".equals(usernameofportal) ){
StatusObj statobj=dbmanager.executeSelectQuery( users_query,new String[]{usernameofportal});
int recordcounttodata1=statobj.getCount();

if(statobj !=null && statobj.getStatus()){
	String [] defaultthemes=GenUtil.strToArrayStr(EbeeConstantsF.get("accounts.basic.blogs.themes","india_zilla,tajmahal,wuhan,rin,india_sahyadri,orangesky,india_fastcricket,india_vande_mataram"),",",false);
	//String [] defaultthemes=GenUtil.strToArrayStr("india_zilla",",",false);
	int length=0;
	if(defaultthemes!=null)length=defaultthemes.length;
	int position=0;
	List rolleruserlist=new ArrayList();
	try{
		
				java.sql.Connection rolercon=getRollerConnection();
				java.sql.Statement rollpstmt=rolercon.createStatement();
				
				java.sql.ResultSet rs= rollpstmt.executeQuery("select username from rolleruser");
				if(rs.next()){
					do{
						rolleruserlist.add( rs.getString(1) );
					}while(rs.next());
				
				}
				
				rs.close();
				rollpstmt.close();
				rolercon.close();
	
	}catch(Exception exp){
				System.out.println(exp.getMessage());
	}
				
	for(int i=0;i<recordcounttodata1;i++){
		if(position==length)position=0;
		
		String portaluser=dbmanager.getValue(i,"login_name","").trim();
		
		
		if(!"".equals(portaluser)){
			if(!rolleruserlist.contains(portaluser) ){
						Map usermap=new HashMap();
						usermap.put("loginname", portaluser );
						usermap.put("firstname", dbmanager.getValue(i,"first_name","") );
						usermap.put("lastname", dbmanager.getValue(i,"last_name","") );
						usermap.put("email", dbmanager.getValue(i,"email","") );
						//usermap.put("theme", "india_zilla" );
						usermap.put("theme", defaultthemes[position] );
						
						userlist.add(usermap);
						
			}	
		}//end if ""
		
		if(position<length)position++;
				
	}//end for
		
	
	

%>





			



<%



int totaluser=userlist.size();
//out.println(totaluser);
if(totaluser>0){
for(int i=0;i<totaluser;i++){
Map hm =(Map)userlist.get(i);
out.println(hm+"<br />");


			try {
				String serverport=(80==request.getServerPort())?"":(":"+request.getServerPort()) ;
				String serverurl="http://localhost"+serverport;
				String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
				
				String fullname=(GenUtil.getHMvalue(hm,"firstname","").trim()+" "+ GenUtil.getHMvalue(hm,"lastname","").trim() ).trim();
				HashMap parammap=new HashMap();
				CoreConnector cc1=new CoreConnector(serverurl+rollercontext+"/user.do");
				
				cc1.setQuery("method=registerUser");
				cc1.setTimeout(20000);
				cc1.MGet();
				parammap=new HashMap();
				cc1=new CoreConnector(serverurl+rollercontext+"/user.do");
				parammap.put("method","add");
				parammap.put("id","");
				parammap.put("adminCreated","false");
				
				parammap.put("fullName",fullname);
				parammap.put("userName",(String)hm.get("loginname") );
				parammap.put("passwordText", "06f2ea14bb6b113d44611ff33bf337b06a837cb0");
				parammap.put("passwordConfirm","06f2ea14bb6b113d44611ff33bf337b06a837cb0" );
				
				String email=(String)hm.get("email");
				email=("".equals(email) )?"dummy@hh.com":email;
				parammap.put("emailAddress", email );
				
				parammap.put("locale","en_US");
				parammap.put("timezone","PDT");
				
				// set a theme for user
				parammap.put("theme", (String)hm.get("theme") );
				cc1.setArguments(parammap);
				System.out.println(cc1.MPost() );
				
				}catch (Exception ex){
					System.out.println("EXP:"+ex);
				}
				
				
				
				

}//end for list
out.println("porting success");
}else{
out.println("username existing in roller");

}

}else{
out.println("no such username in portal:="+usernameofportal);
}

}else{
out.println("parameter username is missing");
}

%>
