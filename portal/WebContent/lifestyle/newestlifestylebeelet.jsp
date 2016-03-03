<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,java.sql.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.useraccount.*,com.eventbee.profiles.*,java.net.*" %>

<%!

static final String GET_NEWEST_MEMBERS="select first_name,last_name,city, "
 +" to_char(a.created_at,'MM/DD') as joindate,interests,a.user_id,a.login_name from authentication a,"
 +" user_profile b,user_role c where c.role_code='MEM' and a.user_id=b.user_id  and a.acct_status='1' and "
 +" a.role_id=c.role_id and a.unit_id=? order by a.created_at desc limit 10";



	final String CLASS_NAME="newestlifestylebeelet.jsp";
	String encode(String str){
	    if (str==null) return "";
	     return str;
	}
	
	
	
	public  Vector getBeeIDMember(String unitid){
	      int count=0;
	      Connection con=null;		
	      java.sql.PreparedStatement pstmt=null;
	      java.sql.ResultSet rs=null;
              HashMap hm=null; 
              Vector v=new Vector();
	      try{
  	           con=EventbeeConnection.getReadConnection();
		   pstmt=con.prepareStatement(GET_NEWEST_MEMBERS);
		   pstmt.setString(1,unitid);
		   rs=pstmt.executeQuery();
		   while(rs.next()&& count<10){
                        hm=new HashMap();
			hm.put("firstname",rs.getString("first_name"));
       			hm.put("lastname",rs.getString("last_name"));
                	hm.put("city",rs.getString("city"));
                        hm.put("joindate",rs.getString("joindate"));
                	hm.put("interests",rs.getString("interests"));
                        hm.put("userid",rs.getString("user_id"));
			 hm.put("loginname",rs.getString("login_name"));
			 
                        v.addElement(hm);
                        count++;
		   }
		   rs.close();
		   pstmt.close();
		   pstmt=null;
		   con.close();
		   con=null;
	}catch(Exception e){
	       EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "getBeeIDMember()", e.getMessage(), e) ;
	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return v;
      }

	
	
	

%>

<%
		String userid="",unitid="",lastlogin="";
		int intsize=0;
                Vector v=null;
		Authenticate authData=AuthUtil.getAuthData(pageContext); //(Authenticate)session.getAttribute("authData");

		if(authData!=null){
			unitid=authData.getUnitID();
		}//end of authdata null
		else{
			//unitid="13579";
		}

			//v=ProfileDB.getBeeIDMember(unitid);
			v=getBeeIDMember("13579");
		  
                  if ((v!=null) && (v.size()>0)){

%>

<%
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent("Newest Lifestyles",request.getParameter("border"),request.getParameter("width"),true) );
%>


	
	 <table  align="center" width="100%" cellspacing="0" cellpadding="0">
		<% 
		
			int k=0;
			String base="evenbase";
		int size1=5;
			if(v.size()<5) size1=v.size();
			for (int i=0;i<size1;i++){
			HashMap hm=(HashMap)v.elementAt(i);
			base=(k%2==0)?"evenbase":"oddbase";
			k++;
				if (hm!=null){
		%>
		
		<tr class='<%=base %>'>
			<td class='<%=base %>'>
				<!--<a href='<%="/portal/editprofiles/networkuserprofile.jsp?userid="+(String)hm.get("userid")+"&entryunitid="+(String)session.getAttribute("entryunitid")%>' >-->
				<a href='<%="/member/"+(String)hm.get("loginname")%>' >
				<%=encode((String)hm.get("firstname"))+" " + encode((String)hm.get("lastname")) %>
				</a>
			</td>
			<td><%=encode( (hm.get("city")==null)?"":(String)hm.get("city") ) %></td>
			<!-- <td>
			<%--= (hm.get("joindate")==null)?"":(String)hm.get("joindate") --%>
			</td>--> 
		</tr>
		
		<tr class='<%=base %>'>
		
		<td colspan='3' class='<%=base %>'><%=" Interests: "+encode( (hm.get("interests")==null)?"":(String)hm.get("interests") ) %></td>
		</tr>
		<%
				}//hm!=null
			}//end for
		
		%>
	 </table>

<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent()); 
%>

<%
}
%>
