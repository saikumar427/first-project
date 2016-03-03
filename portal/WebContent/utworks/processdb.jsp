<%@ page import="java.util.*,java.sql.*,com.eventbee.general.*" %>

<%!
	public class DBRecords{
	
		Vector records;
		boolean flag;
		String message;
		
			public DBRecords getRecords(String query,int rcount,String selectedDB){
				java.sql.Connection con=null; 
				java.sql.PreparedStatement pstmt=null;
				java.sql.ResultSet rs=null;        
			        
			        DBRecords dbrec=new DBRecords();
				Vector records=new Vector();
				try{
					con=EventbeeConnection.getConnection(selectedDB);
					pstmt=con.prepareStatement(query);
					rs=pstmt.executeQuery();
					ResultSetMetaData rsmd=rs.getMetaData();
					int count=0;
					int colcount=rsmd.getColumnCount();
					String colnames[]=new String[colcount];
					
			
					while(rs.next()){	
						dbrec.flag=true;
						if(count==0){
							HashMap record=new HashMap();
							for(int i=1;i<=colcount;i++){					
								record.put(rsmd.getColumnName(i),rsmd.getColumnName(i));
								colnames[i-1]=rsmd.getColumnName(i);
								
							}
							records.add(record);				
						}
						count++;
						
						if(rcount==0){
							HashMap record=new HashMap();

							for(int i=0;i<colcount;i++){				
								
								record.put(colnames[i],rs.getString(colnames[i]));
							}
							records.add(record);
						}
					}
					if(!dbrec.flag){
						dbrec.message="NO RECORDS";	
					}
					rs.close();
					pstmt.close();
					pstmt=null;
					con.close();
				}catch(Exception e){
					dbrec.flag=false;
					dbrec.message=e.getMessage();
					System.out.println("EXCEPTION occured at processdb.jsp(get records): "+e.getMessage()+"\nquery: "+query);
				}finally{
					try{
						if(pstmt!=null)
							pstmt.close();
						if(con!=null)
							con.close();
					}catch(Exception ex){
						System.out.println("Exception occured while closing the connection");
					}
				}			
			dbrec.records=records;
			return dbrec;
		}		
	}	
	
	
	
	public class UpdateRecords{			
		boolean flag;
		String message;	
		int count=0;
	
		public UpdateRecords updateRecords(String query,String selectedDB){
			java.sql.Connection con=null; 
			java.sql.PreparedStatement pstmt=null;
			int rs=0;

			UpdateRecords uprec=new UpdateRecords();			
			try{
				con=EventbeeConnection.getConnection(selectedDB);
				pstmt=con.prepareStatement(query);
				try{
				con.setAutoCommit(false);
				rs=pstmt.executeUpdate();
				con.commit();	
				}
				catch(Exception qe){
				System.out.println(qe.getMessage()+" \n query: "+query);
				if(qe.getMessage().contains("current transaction is aborted")){
				con.rollback();
				}
				}
				pstmt.close();
				//pstmt=null;
				con.close();
				uprec.count=rs;
				uprec.flag=true;
			}catch(Exception e){
				uprec.flag=false;
				uprec.message=e.getMessage();
				System.out.println("EXCEPTION occured at processdb.jsp(update records): "+e.getMessage()+"\nquery: "+query);
			}finally{
				try{
					if(pstmt!=null)
						pstmt.close();
					if(con!=null)
						con.close();
				}catch(Exception ex){}
			}	

			return uprec;
		} 
	}
%>


<html>
<%	
	String query=request.getParameter("dbquery");
	String req=request.getParameter("req");	
	String cnt=request.getParameter("cnt");
	if("all".equals(req)){
		query="SELECT tablename FROM pg_tables WHERE tablename  !~ '^pg_' AND tablename  !~ '^pga_' AND tablename  !~ '^sql_' ORDER BY tablename;";
	}else if("sing".equals(req)){
		String tablename=request.getParameter("tname");		
		query="select a.attname,c.typname from pg_attribute a,pg_class b,pg_type c where a.attrelid=b.relfilenode and a.attnum>0 and b.relname='"+tablename+"' and a.atttypid=c.oid;";
	}else if("singdata".equals(req)){
		String tablename=request.getParameter("tname");
		query="SELECT * from "+tablename+";";
	}else if("singcount".equals(req)){
		String tablename=request.getParameter("tname");
		query="SELECT count(*) from "+tablename+";";
	}
%>
	
<%	if(query!=null&&!"".equals(query)){

	long time1=0;
	long time2=0;
	 //query=query.toLowerCase();	
	if((query.toLowerCase()).startsWith("select")){	
	      DBRecords dbrecords=null;
	        if("sing".equals(req)){
		    time1 =new java.util.Date().getTime();
		    dbrecords=(new DBRecords()).getRecords(query,0,selectedDB);
		    time2 =new java.util.Date().getTime();
		    query="COLUMNS OF TABLE "+request.getParameter("tname");
		}else{
		    time1 =new java.util.Date().getTime();
		    dbrecords=(new DBRecords()).getRecords(query,0,selectedDB);
		    time2 =new java.util.Date().getTime();
		}
		 Vector v=dbrecords.records;
		 boolean flag=dbrecords.flag;		 
		//Vector v=getRecords(query);	
%>
<table border="0" width="100%">
<tr>
	<td align='left' width='25%'>Begin at: <B><%=time1%></B></td>
	<td width='25%' align='left'>End at: <b><%=time2%></b></td>
	<td align='left'>Diff: <B><%=(time2-time1)%></B> Milli Seconds</td>
</tr>
</table>
	<table border="1" width="100%">
		<tr><td width="100%"><font face="verdana">Query: <%=query%></font></td></tr>	
	</table>	
	
<%
	if(flag){
		int vsize=v.size();
%>
		<table border="1" width="100%">
			<tr><td width="100%"><font face="verdana">Status : <%=(vsize-1)%> records selected</font></td></tr>
		</table>	
		<table border="1" width="100%">
<%
		for (int m=0;m<vsize;m++){
%>
			
			<tr>		
<%
			HashMap record=(HashMap)v.elementAt(m);		
			Set set=record.entrySet();					
			for(Iterator i=set.iterator();i.hasNext();){			
%>
			<td><font face="verdana">
<%
				Map.Entry entry=(Map.Entry)i.next();
				String name=(String)entry.getKey();
				
				if(m==0){
					out.println("<b>");				
					out.println((String)record.get(name));
					out.println("</b>");				
				}else{					
					if("all".equals(req)){
					
						//out.println("<a href='dbquery.jsp?req=sing&tname="+(String)record.get(name)+"'>");						
						//out.println("</a>");									
						out.println("<a href='dbquery.jsp?req=sing&db_name="+selectedDB+"&tname="+(String)record.get(name)+"'>");
						out.println("Schema");
						out.println("</a>");						
						out.println((String)record.get(name));
						out.println("<a href='dbquery.jsp?req=singdata&db_name="+selectedDB+"&tname="+(String)record.get(name)+"'>");
						out.println("Data");
						out.println("</a>");out.println("&nbsp;");
						//out.println("<a href='dbquery.jsp?req=singcount&db_name="+selectedDB+"&tname="+(String)record.get(name)+"'>");
						if("yes".equals(cnt)){
						String Count = DbUtil.getVal("select count(*) from "+record.get(name) , null);
						out.println(Count);
						}
						//out.println("</a>");						

						
					}else{
						out.println((String)record.get(name));
					}
				}			
				out.println("<br/>");
%>
			</font></td>
<%
			}
%>
			</tr>
<%
			
		}
%>
		</table>
<%
	}else{	
%>
	<table border="1" width="100%">
		<tr><td width="100%"><font face="verdana"><%=(dbrecords.message)%></font></td></tr>	
	</table>
<%
	}
%>
	</table>
<%
	}else{
		 String qtype="Updated";
		 UpdateRecords uprecords=(new UpdateRecords()).updateRecords(query,selectedDB);
		 boolean flag=uprecords.flag;
		 if((query.toLowerCase()).startsWith("update")){
		 	qtype="Updated "+uprecords.count+" Records";
		 }else if((query.toLowerCase()).startsWith("delete")){
		 	qtype="Deleted "+uprecords.count+" Records";
		 }else if((query.toLowerCase()).startsWith("drop")){
		 	qtype="Table dropped successfully";
		 }else if((query.toLowerCase()).startsWith("truncate")){
		 	qtype="Table truncated successfully";
		 }else if((query.toLowerCase()).startsWith("create")){
		 	qtype="Table Created successfully";
		 }else if((query.toLowerCase()).startsWith("insert")){
		 	qtype="Inserted "+uprecords.count+" Records";
		 }else if((query.toLowerCase()).startsWith("alter")){
		 	qtype="Table Altered Successfully";
		 }
		 
%>
	<table border="1" width="100%">
		<tr><td width="100%"><font face="verdana">Query: <%=query%></font></td></tr>
	</table>	
	<table border="1" width="100%">
<%
		 if(flag){
%>
		   <tr><td width="100%"><font face="verdana"><%=qtype%></font></td></tr>
<%
		}else{	
%>
		  <tr><td width="100%"><font face="verdana">ERROR: <%=(uprecords.message)%></font></td></tr>	
<%
		}
	}
    }
%>
</html>

