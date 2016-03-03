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
	
	
	 
	
	
	
%>





<%









String usernameofportal=request.getParameter("username");
if(usernameofportal ==null)usernameofportal="";

if(!"".equals(usernameofportal) ){



			try {
			
				
				Map usermap=new HashMap();
				usermap.put("loginname", usernameofportal );
				usermap.put("firstname", "f"+usernameofportal );
				usermap.put("lastname", "l"+usernameofportal );
				usermap.put("email", "dummy@"+usernameofportal+".com" );
				usermap.put("theme", "wuhan" );

					Map hm=	usermap;
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
				out.println(cc1.MPost() );
				
				}catch (Exception ex){
					System.out.println("EXP:"+ex);
				}
				
				
				
				
}else{
out.println("parameter username is missing");
}


%>
