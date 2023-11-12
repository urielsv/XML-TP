<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:text># Season </xsl:text> <xsl:value-of select="//season/name"/>
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>### Competition </xsl:text> <xsl:value-of select="//season/name"/>
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>Gender: </xsl:text> <xsl:value-of select="//gender"/>
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>#### Year: </xsl:text> <xsl:value-of select="//date/year"/> 
        <xsl:text>. From </xsl:text> <xsl:value-of select="//season/date/start"/> <xsl:text> to </xsl:text> 
        <xsl:value-of select="//season/date/end"/>
        <xsl:text>&#xa;</xsl:text>

        <xsl:for-each select="//stages/stage">
            <xsl:text>---&#xa;</xsl:text>
            <xsl:text>#### </xsl:text> <xsl:value-of select="./@phase"/>
            <xsl:text>. From </xsl:text> <xsl:value-of select="./@start_date"/>
            <xsl:text> to </xsl:text> <xsl:value-of select="./@end_date"/> 
            <xsl:text>&#xa;</xsl:text>

            <xsl:for-each select="./groups/group">
                <xsl:text>---&#xa;#### Competitors:&#xa;</xsl:text>
                <xsl:for-each select="./competitor">
                    <xsl:text>* </xsl:text> 
                    <xsl:value-of select="concat(./name, ' (',./abbreviation, ')')"/>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>

        <xsl:text>#### Teams:&#xa;</xsl:text>
        <xsl:for-each select="//competitors/competitor">
            <xsl:text>#### </xsl:text> <xsl:value-of select="./name"/>
            <xsl:text>&#xa;</xsl:text>

            <xsl:text>##### Players:&#xa;Name|Type|Date of Birth|Nationality|Events Played</xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>|---|---|---|---|---|</xsl:text>
            <xsl:for-each select="./players/player">
                <xsl:sort select="./events_played" order='descending' data-type="number"/>
                <xsl:text>&#xa;</xsl:text>
                <xsl:value-of select="concat('|',./name,'|',./type,'|',./date_of_birth,'|',./nationality,'|',./events_played)"/>
            </xsl:for-each>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        


    </xsl:template>
</xsl:stylesheet>