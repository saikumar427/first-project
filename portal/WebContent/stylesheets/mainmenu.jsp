<%!
String [] eventtabs={"Events","Classes"};
String [] eventtablinks={"/portal/eventdetails/events.jsp?evttype=event",
			"/portal/eventdetails/events.jsp?evttype=class",
			};
%>
					<%
					String tabtype=(String)request.getAttribute("truesubtabtype");
					int len=eventtabs.length;
					String tabclass="desitabcont mytab2";
					if(tabtype==null||"null".equals(tabtype))
					tabtype=eventtabs[0];
					for(int i=0;i<eventtabs.length;i++){
					    if(tabtype.equals(eventtabs[i]))
						tabclass="desitabcont mytab1";
					    else
						tabclass="desitabcont mytab2";
					%>
					<span class="<%=tabclass %>" ><a href="<%=eventtablinks[i]%>"><%=eventtabs[i] %></a></span>
					<%
					}//end for
					%>



			
