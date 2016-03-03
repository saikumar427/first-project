<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
>
    <!-- generate PDF page structure -->
    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<fo:layout-master-set>
	    <!--fo:simple-page-master master-name="main" 
	      margin-top="36pt" margin-bottom="36pt" 
	      page-width="8.5in" page-height="11in" 
	      margin-left="72pt" margin-right="72pt">
	      <fo:region-body margin-bottom="50pt" margin-top="50pt"/>
	    </fo:simple-page-master-->  
    		<fo:simple-page-master margin="25mm 25mm 5mm 25mm" master-name="PageMaster" page-height="182mm" page-width="257mm">
    			<fo:region-body margin="0mm 00mm 20mm 00mm"/>
    			<fo:region-after extent="10mm" display-align="after"/>
    			<!--fo:region-after extent="10mm" display-align="before"/-->
		</fo:simple-page-master>	    
	  </fo:layout-master-set>
  	<!--fo:page-sequence master-reference="main"-->
	<fo:page-sequence master-reference="PageMaster" force-page-count="no-force" initial-page-number="1" format="1">
		<fo:static-content flow-name="xsl-region-after">
			<!--<fo:block text-align="center" font-size="9pt">
				Copyright @ Beeport inc. 2003
			</fo:block>
			-->
			<fo:block text-align="right" font-size="9pt">
			     <fo:page-number/> 
			</fo:block>
		</fo:static-content>			
	
    	
  	  <fo:flow flow-name="xsl-region-body" 
  	    font-size="12pt" line-height="15pt">                                
                    <fo:block>
                        <!--fo:block 
		    		break-before="page" 
		    		break-after="page">
		    	<fo:block  
		    		  space-after="4in" 
		    		  space-before="3in" 
		    		  space-before.conditionality="retain" 
		    		  font="24pt Times bold" 
		    		  text-align="center">
		              Document Title, using single or multiple lines.
		    	</fo:block>
		          </fo:block-->     	

                    <xsl:apply-templates/></fo:block>
            </fo:flow>
         </fo:page-sequence>  	    
        </fo:root>           
    </xsl:template>

	<xsl:template match="page">        			
		<fo:block text-align="center" font-size="10pt" color="red" font-weight="bold">	
       			   <xsl:apply-templates select="@title"/>        			
       		</fo:block>
	        <fo:block space-after="1em" font-size="10pt" text-align="right" font-weight="bold" border-after-style="solid" border-after-width="1pt">
       			   <xsl:apply-templates select="@sub-title"/>
       		</fo:block>	  
		<xsl:apply-templates/>
	</xsl:template>  

        <xsl:template match="page1">        			
		<fo:block text-align="center" font-size="10pt" color="red" font-weight="bold">	
       			   <xsl:apply-templates select="@title"/>        			
       		</fo:block>
	        <fo:block space-after="1em" font-size="10pt" text-align="right" font-weight="bold" border-after-style="solid" border-after-width="1pt">
       			   <xsl:apply-templates select="@sub-title"/>
       		</fo:block>	      
		<xsl:apply-templates/> 		
	</xsl:template>  

    <!-- process paragraphs -->
    <xsl:template match="p">
        <fo:block><xsl:apply-templates/></fo:block>
    </xsl:template>

    <!-- convert sections to XSL-FO headings -->
    <xsl:template match="s1">
        <fo:block space-after="1em" font-size="10pt" color="red" font-weight="bold" text-align="left">
            <xsl:apply-templates select="@title"/>
        </fo:block>
        <xsl:apply-templates/>
    </xsl:template>  	
    
   <xsl:template match="IMG">
          <fo:block>
            <fo:external-graphic src="{@src}">
                <xsl:attribute name="content-width">
                    <xsl:value-of select="@width"/>
                </xsl:attribute>
                <xsl:attribute name="content-height">
                    <xsl:value-of select="@height"/>
                </xsl:attribute>
            </fo:external-graphic>
          </fo:block>
	
   </xsl:template>  
    
 <xsl:template match="table">
   <!--fo:table-and-caption>
	<fo:table-caption text-align="center">
	  <fo:block font-weight="bold">Table Caption.</fo:block>
	</fo:table-caption--> 
       <fo:table table-layout="fixed" space-after="20pt"   padding-start="75pt">
        <!--fo:table-column column-width="168pt"/>
        <fo:table-column column-width="150pt"/>
        <fo:table-column column-width="150pt"/-->
        <!--dynamically setting column width -->
	<fo:table-column column-number="1" number-columns-repeated="{@cols}"/>
             <xsl:apply-templates/>
        </fo:table>
   <!--/fo:table-and-caption-->    
  </xsl:template>
 <xsl:template match="tbody">
   <fo:table-body>
     <xsl:apply-templates/>
   </fo:table-body>
 </xsl:template>

 <xsl:template match="tr[@class='colheader']">
    <fo:table-row font-size="12pt" font-weight="bold">
    	
      <xsl:apply-templates/>
    </fo:table-row>
  </xsl:template>

  <xsl:template match="tr">
    <fo:table-row font-size="10pt" >
    	
      <xsl:apply-templates/>
    </fo:table-row>
  </xsl:template>


 <xsl:template match="td">
 <!-- without  border -->
 <!--fo:table-cell border-color="black" border-width="1pt"
               padding-before="3pt" padding-after="3pt" 
              padding-start="3pt" padding-end="3pt"-->
 
    <!-- with border -->
    <fo:table-cell border-style="solid" 
              border-color="black" border-width="1pt"
              padding-before="3pt" padding-after="3pt" 
              padding-start="3pt" padding-end="3pt">
      <fo:block ><xsl:apply-templates/></fo:block>
    </fo:table-cell>
  </xsl:template>
    

</xsl:stylesheet>

