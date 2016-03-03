						</td>
							 </tr>
						</table>
						</td>
						<td valign='top' >
						<% if(request.getAttribute("rightcontent") !=null){ %>
						<jsp:include page="<%=(String)request.getAttribute("rightcontent") %>" />
						<%}%>
						</td>
					</tr>
					<tr>
						<td colspan='3' align="left" width="100%">
						<% if(request.getAttribute("bottomcontent") !=null){ %>
						<jsp:include page="<%=(String)request.getAttribute("bottomcontent") %>" />
						<%}%>
						</td>
					</tr>
					</table>
				</td>
			</tr>
		</table>
		
		
				<%
				if(request.getAttribute("dispalysubmenu") !=null  ){
				%>
								</table>
								</td></tr>
				<%
				}else{
				%>
				<%--</td></tr>
				<!-- end of desi border full -->
				--%>
				
				<%
				if(request.getAttribute("displaydesiborderfull") !=null && 
					request.getAttribute("dispalysubmenu") ==null){
					
					
					
				%>
				
				<%
					}
				%>
				</td></tr>
				<!-- end of desi border full -->
				<%
				}
				%>
		
		
		
	</td></tr>
	
	
				<%
				if(request.getAttribute("dispalysubmenu") !=null  ){
				%>
					<tr><td height='10'></td></tr>			

				<%
				}
				%>
	
	
	
	
	<tr>
		<td align="center" >
			<%@ include file="ebeefooter.jsp" %>
		</td>
	</tr>
</table>
</body>
</html>
