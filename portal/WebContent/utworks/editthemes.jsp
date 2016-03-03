<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*"%>

<%



String module=request.getParameter("module");
System.out.println("module----"+module);

module=module.trim();
String themetobeused=request.getParameter("theme");
themetobeused=themetobeused.trim();
System.out.println("themetobeused----"+themetobeused);

DBManager dbmanager=new DBManager();
Vector listvec=new Vector();
HashMap hm=new HashMap(); 
			
StatusObj sb=dbmanager.executeSelectQuery("select cssurl,themecode,module from ebee_roller_def_themes where module=? and themecode not in('basic')",new String[]{module});
if(sb.getStatus()){  
    out.println("Themes count------"+sb.getCount());        
    out.println("<br>");
  
		for(int i=0;i<sb.getCount();i++)
		
		{
		
		
			
			
   String cssurl=dbmanager.getValue(i,"cssurl","");
   int index1=cssurl.indexOf("/home/images/themes/");
   int index2=cssurl.indexOf(".gif)");
   String themecode=dbmanager.getValue(i,"themecode","");
   String image="";

   if(index1>0&&index2>0){
   image=cssurl.substring(index1,index2+4);
   }
   
    hm.put(themecode,image);


                    }

    
              }
             
 
 String s=DbUtil.getVal("select cssurl from ebee_roller_def_themes where themecode=? and module=?",new String[]{themetobeused,module});
 int count=0;
 String s1=null;
 StatusObj sb2=null;           
   Set ss=hm.keySet();
   Iterator im=ss.iterator();
 while(im.hasNext()){
 s1=new String(s);
 String str=(String)im.next();
 
 String s2=s1.replaceAll("##image.gif##",(String)hm.get(str));
 
  sb2=DbUtil.executeUpdateQuery("update ebee_roller_def_themes set cssurl=? where themecode=? and module=?",new String[]{s2,str,module});
 if(sb2.getStatus())
 count++;
 out.println(str+"---------------"+sb2.getStatus());
 
 out.println("<br>");
 
 
 }
  out.println("Themes modified--------------"+count);

 
 
 
    
            
            

%>