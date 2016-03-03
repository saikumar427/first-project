<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"
              doctype-system="svg-19991203.dtd"
              version="1.0"
              encoding="ISO-8859-1" />
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:apply-templates select="Data"/>
  </xsl:template>

<xsl:template match="Data">
<xsl:variable name="basex" select="(floor(MaxCount div 10)+1)" />

<xsl:variable name="final-y">
   	<xsl:value-of select="(10 + count(info) * 22) "/>
 </xsl:variable>
<xsl:variable name="width-svg">
   	<xsl:value-of select="(250 + MaxSize * 6) "/>
 </xsl:variable>

<svg  width="{$width-svg}" height="{$final-y}">
<text style="font-size:18; text-anchor:middle" x="120" y="5">
        <xsl:value-of select="caption/heading"/>
</text>
<text style="font-size:12; text-anchor:middle" y="18" x="120">
	<xsl:value-of select="caption/subheading"/>
 </text>

<xsl:for-each select="info">
  <xsl:variable name="pos">
       	<xsl:value-of select="position()"/>
    </xsl:variable>

           <xsl:apply-templates select=".">             
                           
             <xsl:with-param name="basex">
	                    <xsl:value-of select="$basex "/>
             </xsl:with-param>
 
             <xsl:with-param name="y-offset">
               <xsl:value-of select="5 + ($pos * 20)"/>
             </xsl:with-param>
		<xsl:with-param name="y-legend-offset">
		   <xsl:value-of select=" ($final-y) + ($pos * 20)"/>
             </xsl:with-param>
            
   </xsl:apply-templates>
</xsl:for-each>
</svg>
</xsl:template>

<xsl:template match="info">
<xsl:param name="x-offset" select="'15'"/>
    <xsl:param name="y-offset" select="'220'"/>
    <xsl:param name="basex" select="'0'"/>
    <xsl:param name="color" select="(Color)"/>
    <xsl:param name="y-legend-offset" select="'40'"/>    
    <xsl:variable name="count">
			<xsl:value-of select="Count"/>
    </xsl:variable>    
   
    <xsl:variable name="x">
          <xsl:value-of select="$x-offset + ($count * (20 div ($basex)))"/>
    </xsl:variable>

 
 <path>
      <xsl:attribute name="style">
        <xsl:text>stroke-width:1; stroke:</xsl:text>
	<xsl:value-of select="$color"/>
	<xsl:text>; fill:</xsl:text>
        <xsl:value-of select="$color"/>
      </xsl:attribute>
	
       <xsl:attribute name="d">
       <xsl:text>M </xsl:text>
        <xsl:value-of select="$x-offset"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$y-offset - 7"/>

        <xsl:text> L </xsl:text>
        <xsl:value-of select="$x"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$y-offset - 7"/>

        <xsl:text> L </xsl:text>
        <xsl:value-of select="$x"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$y-offset + 7"/>

        <xsl:text> L </xsl:text>
        <xsl:value-of select="$x-offset"/>
        <xsl:text> </xsl:text> 
        <xsl:value-of select="$y-offset + 7"/>

         <xsl:text> Z</xsl:text>
      </xsl:attribute>
    </path>
    
   <text style="font-size:10; text-anchor:middle">
      <xsl:attribute name="y">
        <xsl:value-of select="$y-offset"/>
      </xsl:attribute>
      <xsl:attribute name="x">
        <xsl:value-of select="$x + 10"/>
      </xsl:attribute>
      <xsl:value-of select="$count"/>
      </text>

   <path>
      <xsl:attribute name="style">
        <xsl:text>stroke:black; stroke-width:1; fill:</xsl:text> 
        <xsl:value-of select="$color"/>
      </xsl:attribute> 
      <xsl:attribute name="d">
        <xsl:text>M </xsl:text>
        <xsl:value-of select="$x-offset+210"/>
        <xsl:text> </xsl:text>
	<xsl:value-of select="$y-offset - 7"/>	
        <xsl:text> </xsl:text>
	
	<xsl:text> L </xsl:text> 
        <xsl:value-of select="$x-offset+210+10"/>
        <xsl:text> </xsl:text>
	<xsl:value-of select="$y-offset - 7"/>	
	<xsl:text> </xsl:text>
	
	<xsl:text> L </xsl:text> 
        <xsl:value-of select="$x-offset+210+10"/>
        <xsl:text> </xsl:text>
	<xsl:value-of select="$y-offset + 7"/>	
	<xsl:text> </xsl:text>	

	<xsl:text> L </xsl:text> 
        <xsl:value-of select="$x-offset+210"/>
        <xsl:text> </xsl:text>
	<xsl:value-of select="$y-offset + 7"/>	
	<xsl:text> </xsl:text>	
	
		
        <xsl:text> Z</xsl:text> 
      </xsl:attribute>
</path>
<text style="font-size:12; text-anchor:start">
      <xsl:attribute name="x">
       <xsl:value-of select="$x-offset+210+20"/>
      </xsl:attribute>
      <xsl:attribute name="y">
        <xsl:value-of select="$y-offset+5"/>
      </xsl:attribute>
      <xsl:value-of select="Name"/>
</text>   

   ======  FOR LEGEND BELOW GRAPH ========  -->
<!--       <path>  
	 <xsl:attribute name="style">
        <xsl:text>stroke:black; stroke-width:1; fill:</xsl:text> 
        <xsl:value-of select="$color"/>
        </xsl:attribute>  
      <xsl:attribute name="d">
      <xsl:text>M 50 </xsl:text> 
      <xsl:value-of select="$y-legend-offset - 10"/>
      <xsl:text> L 50 </xsl:text> 
      <xsl:value-of select="$y-legend-offset"/>
      <xsl:text> L 60 </xsl:text> 
      <xsl:value-of select="$y-legend-offset"/>
      <xsl:text> L 60 </xsl:text> 
      <xsl:value-of select="$y-legend-offset - 10"/>
      <xsl:text> Z</xsl:text> 
      </xsl:attribute></path>
      
<text style="font-size:14; text-anchor:start" x="70">
      <xsl:attribute name="y">
        <xsl:value-of select="$y-legend-offset"/>
      </xsl:attribute>
      <xsl:value-of select="Name"/>
     </text>  -->

	

</xsl:template>
</xsl:stylesheet>
