<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>


<%
/*

for details:
http://jakarta.apache.org/velocity/user-guide.html#Hello%20Velocity%20World!






 If / ElseIf / Else
	#if( $foo < 10 )
	    <strong>Go North</strong>
	#elseif( $foo == 10 )
	    <strong>Go East</strong>
	#elseif( $bar == 6 )
	    <strong>Go South</strong>
	#else
	    <strong>Go West</strong>
	#end

 Relational and Logical Operators  
		#set ($foo = "deoxyribonucleic acid")
		#set ($bar = "ribonucleic acid")
		
		#if ($foo == $bar)
		  In this case it's clear they aren't equivalent. So...
		#else
		  They are not equivalent and this will be the output.
		#end

		
logical operators		
## used for commenting
## logical AND

#if( $foo && $bar )
   <strong> This AND that</strong>
#end



## logical OR

#if( $foo || $bar )
    <strong>This OR That</strong>
#end


##logical NOT

#if( !$foo )
  <strong>NOT that</strong>
#end




loops



hash map;
<ul>
#foreach( $key in $myevtmap.keySet() )
    <li>Key: $key -> Value: $myevtmap.get($key)</li>
#end
</ul>

list 


<table>
#foreach( $customer in $customerList )
    <tr><td>$velocityCount</td><td>$customer.Name</td></tr>
#end
</table>




*/
	Map myevtmap=new HashMap();
	Map myevtmap1=new HashMap();
	Map myevtmap2=null;
	
	myevtmap.put("a","value is a");
	myevtmap.put("b","value is b");
	
	
	
	List testlist=new ArrayList();
	testlist.add("list entry 1");
	testlist.add("list entry 2");
	
	
	

		VelocityContext context = new VelocityContext();
            context.put ("lastname","reddynr");
            context.put ("total", "5.0");
            context.put ("customer", "narayan" );
	    context.put ("myevtmap", myevtmap );
	    context.put ("myevtmap1", myevtmap1 );
	    
	        context.put ("testlist", testlist );
	    
	    
	    
	    
	    try{
	  String testcont=
			"#macro( tablerows $color $somelist )"
			+"#foreach( $something in $somelist )"
			    +"<tr><td bgcolor=$color>$something</td></tr>"
			+"#end"
			+"#end"
	  		+"<html>"
			+"<body>"
			+"#set( $foo = \"Velocity\" )"
			+"Hello $foo World! <br/>"
			+"$lastname<br />**"
				+"#if( $lastname1  )"
				+"<strong>lastname exists</strong>"
				+" #else "
				+"lastname1 doesnot exists in the context"
				+"#end"
			+"#set( $greatlakes = [\"Superior\",\"Michigan\",\"Huron\",\"Erie\",\"Ontario\"] )"
			+"#set( $color = \"blue\" )"
			+"<table>"
			+"#tablerows( $color $greatlakes )"
			+"</table><br />"
			
			+"map contains values<ul>"
			+" #foreach( $key in $myevtmap.keySet() ) "
			+" <li>Key: $key -> Value: $myevtmap.get($key)</li>"
			+" #end "
			+" </ul> "
			+"map is empty<ul>"
			+" #foreach( $key in $myevtmap1.keySet() ) "
			+" <li>Key: $key -> Value: $myevtmap1.get($key)</li>"
			+" #end "
			+" </ul> "
			
			+"map is null<ul>"
			+" #foreach( $key in $myevtmap2.keySet() ) "
			+" <li>Key: $key -> Value: $myevtmap2.get($key)</li>"
			+" #end "
			+" </ul> "
			+"List contains values<ul>"
			+" #foreach( $listentry in $testlist ) "
			+" <li>listentry: $listentry</li>"
			+" #end "
			+" </ul> "
			
			+"List null<ul>"
			+" #foreach( $listentry in $testlist1 ) "
			+" <li>listentry: $listentry</li>"
			+" #end "
			+" </ul> "
			
			
			+"</body>"
			+"<html>";



	    
	    /*
	    evaluate(Context context, java.io.Writer out, java.lang.String logTag, java.lang.String instring)
          renders the input string using the context into the output writer.
	  */
	  
	  
	  	VelocityEngine ve= new VelocityEngine(); ve.init();boolean abletopares=ve.evaluate(context,out,"ebeetemplate", testcont );
		
		
	  
	  
	    }catch(Exception exp){
	    out.println(exp.getMessage());
	    
	    }
	    
	    

%>


