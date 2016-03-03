<%@ page import="com.eventbee.general.DbUtil" %>

<%
	String foto=request.getParameter("photo");
	String photourl="";
	if(foto==null) 
		foto="";
	else{
		foto=foto.trim();
	 	photourl=DbUtil.getVal("select uploadurl from member_photos where encrypt_photoid=?", new String[]{foto});
	 }
	if(photourl==null) 
		photourl="";
	String album=	request.getParameter("album");
	if(album==null) 
		album="";
%>
 
  <body  text="brown" bgcolor="skyblue"><h2><marquee direction='right' bgcolor='pink'>Images Page</marquee></h2>
  	
        <i><b><center> <align="center">welcome to view Images </align></center></b></i> <br>
  <center>
   <form action="photoblogscript.jsp" method="post" onsubmit="verify" >
  <b> Photo URL </b> <br>
Album-ID <input type="text" name="album" value="<%=album%>"><br>
Photo-ID <input type="text" name="photo" value="<%=foto%>"><br>
         <input type="submit" value="GetURLs" name="submit">
         <input type="reset"  value="Clear" name="reset"></form> </center>
<br>
<%
if(photourl.equals("")){
}else{
%>
<table cellspacing="2" cellpadding="2" >
<tr><td>
   
   
   
   <b>Big Photo </b></td><td>	<input type="text" size="85" name="img" value="http://images.desihub.com/pics/profile/big/<%=photourl%>">
 </td></tr>
    

<tr><td>
   <b>Photo Page </b>	</td><td><align="left" width="400"><input type="text" size="85" name="img" value="http://www.eventbee.com/portal/photogallery/photodisplay.jsp?UNITID=13579&photo_id=<%=foto%>">
</td></tr>
 

<tr><td>
     <b>SmallThumbnail</b>  </td><td><input type="text" size="85" name="smallimg" value="http://images.desihub.com/pics/profile/smallthumbnail/<%=photourl%>"><br></td></tr>
</tr></td>

<tr><td>
    <b>Thumbnail </b></td><td><input type="text" size="85" name="img" value="http://images.desihub.com/pics/profile/thumbnail/<%=photourl%>">
</td></tr>

 <tr><td>
<b>Album Page</b></td><td><input type="text" size="85" name="img" value="http://www.desihub.com/view/telugumovies/photos?albumid=<%=request.getParameter("album")%>">
  </td></tr>
  
<tr><td valign="top">
<b>  Blog Script </b> </td><td>

<textarea cols="64" rows="10">
<a href="http://www.desihub.com/view/telugumovies/photos?albumid=<%=album%>">
<img src="http://images.desihub.com/pics/profile/smallthumbnail/<%=photourl%>"></a>
</textarea>
</td></tr>
</table>
<%
}
 %>
  


  </body>
</html>

