<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:text># Season </xsl:text> <xsl:value-of select="//season/name/@name"/>
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>### Competition </xsl:text> <xsl:value-of select="//season/competition/name/@name"/>
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>Gender: </xsl:text> <xsl:value-of select="//@gender"/>
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>#### Year </xsl:text> <xsl:value-of select="//@year"/> 
        <xsl:text> From </xsl:text> <xsl:value-of select="//season//@start_date"/> <xsl:text> to </xsl:text> 
        <xsl:value-of select="//season//@end_date"/>

        <xsl:for-each select="//stages/stage">
            <xsl:text>---&#xa;</xsl:text>
            <xsl:text>#### </xsl:text> <xsl:value-of select="./@phase"/>
            <xsl:text>From </xsl:text> <xsl:value-of select="./@start_date"/>
            <xsl:text>to </xsl:text> <xsl:value-of select="./@end_date"/> 
            <xsl:text>&#xa;</xsl:text>

            <xsl:for-each select="./group">
                <xsl:text>---&#xa;#### Competitors&#xa;</xsl:text>
                <xsl:for-each select="//competitor">
                    <xsl:text>* </xsl:text> 
                    <xsl:value-of select="concat('./name/@name)',' (', './/@abbreviation')"/>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>

        <xsl:text>#### Teams:&#xa;</xsl:text>
        


    </xsl:template>
</xsl:stylesheet>