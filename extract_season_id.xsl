<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="@*">
    <xsl:attibute name="{name()}">
        <xsl:value-of select="."/>
    </xsl:attibute>
</xsl:template>

<xsl:template match="*">
    <xsl:element name="{name()}">
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/>
    </xsl:element>
<xsl:template>

</xsl:transform>