<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:json="http://www.json.org/">
	
	<!-- Parses a JSON node. -->
	<xsl:function name="json:parsenode">
		<xsl:param name="currentnode" as="node()" />
		
		<xsl:for-each select="$currentnode">
			
			<xsl:variable name="previousName" select="name(preceding-sibling::*[1])" />
			<xsl:variable name="nextName" select="name(following-sibling::*[1])" />
			
			<xsl:variable name="isArray" select="$previousName = name(.) or $nextName = name(.) " />
			<xsl:variable name="isStartArray" select="$previousName != name(.) and $nextName = name(.)" />
			<xsl:variable name="isEndArray" select="$previousName = name(.) and $nextName != name(.)" />

			
			<xsl:choose>
				<xsl:when test="$isArray">
					<xsl:choose>
						<xsl:when test="$isStartArray=true()">
							"<xsl:value-of select="name(.)" />": [
							{
							<xsl:for-each select="*">
								<xsl:value-of select="json:parsenode(current())" />
							</xsl:for-each>
							},
						</xsl:when>
						<xsl:when test="$isEndArray=true()">
							{
							<xsl:for-each select="*">
								<xsl:value-of select="json:parsenode(current())" />
							</xsl:for-each>
							}
							]
						</xsl:when>
						<xsl:otherwise>
							{
							<xsl:for-each select="*">
								<xsl:value-of select="json:parsenode(current())" />
							</xsl:for-each>
							},
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$isArray=false() and count(*) &gt; 0">
					<!-- Has children, parse each child node. -->
					"<xsl:value-of select="name(.)" />": {
					<xsl:for-each select="*">
						<xsl:value-of select="json:parsenode(current())" />
					</xsl:for-each>
					}				
					<xsl:if test="$nextName != ''">
						,
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<!-- Has no children, print the value. -->
					"<xsl:value-of select="name(.)" />": "<xsl:value-of select="current()" />"
					<xsl:if test="$nextName != ''">
						,
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			
			
		</xsl:for-each>
		
	</xsl:function>
	
	
	<xsl:template match="/">
		
		{
		
		<xsl:for-each select="*">
			<xsl:value-of select="json:parsenode(current())" />
		</xsl:for-each>	
		
		}
		
	</xsl:template>
	
	
</xsl:stylesheet>