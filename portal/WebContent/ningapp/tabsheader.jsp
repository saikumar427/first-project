

<%

String [] tabs={"Network Ticket Selling","Network Event listing","My Earnings"}; 

String [] tablinks={"/ningapp/networkticketselling.jsp","/ningapp/networkeventlisting.jsp",""}; 
for(int i=0;i<tabs.length;i++){
					
%>
<span class="tab2" ><a href="<%=tablinks[i]%>"><%=tabs[i] %></a></span>
					
			
			
<%}			
%>		




