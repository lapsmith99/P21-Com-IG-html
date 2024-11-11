<?xml version="1.0" encoding="UTF-8"?>
<!--
  Copyright © 2008-2016 Pinnacle 21 LLC

  This file is part of Pinnacle 21 Community.

  Pinnacle 21 Community is free software licensed under the OpenCDISC Open Source Software License
  located at [http://www.opencdisc.org/license] (the "License").

  Pinnacle 21 Community is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY,
  and is distributed "AS IS," "WITH ALL FAULTS," and without the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the License for more details.

  @author Inna Lernerman
-->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
   xmlns:odm="http://www.cdisc.org/ns/odm/v1.3"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xsi="http://www.w3c.org/2001/XMLSchema-instance"
   xmlns:def="http://www.cdisc.org/ns/def/v2.0"
   xmlns:val="http://www.opencdisc.org/schema/validator">
    <xsl:strip-space elements="*"/>
    <xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
    <xsl:variable name="itemDefs" select="/odm:ODM/odm:Study/odm:MetaDataVersion/odm:ItemDef"/>
    <xsl:variable name="validationRules" select="/odm:ODM/odm:Study/odm:MetaDataVersion/val:ValidationRules/*"/>
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <title>Pinnacle 21 Validator Configuration</title>
                <!-- Style Sheets -->
                <link rel="stylesheet" type="text/css" href="resources/css/reset.css"/>
                <link rel="stylesheet" type="text/css" href="resources/css/base.css"/>
            </head>
            <body>
                <header id="top" class="header">
                    <img class="logo" src="resources/images/P21_Certara.svg" alt="Pinnacle 21 by Certara" height="50px" width="268px"/>
                </header>
                <div class="validator two-column">
                    <nav id="navigation" class="nav card col">
                        <h2 class="title h2">Table of Contents</h2>
                        <ul class="nav-bar">
                            <xsl:for-each select="odm:ODM/odm:Study/odm:MetaDataVersion/odm:ItemGroupDef">
                                <li class="nav-item">
                                    <a class="nav-link">
                                        <xsl:attribute name="href">#<xsl:value-of select="@OID"/></xsl:attribute>
                                        <xsl:value-of select="odm:Description/odm:TranslatedText"/> (<xsl:value-of select="@Name"/>)
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </nav>
                    <main class="content col">
                        <header class="content-header">
                            <h1 class="h1">Validator Configuration</h1>
                        </header>
                        <xsl:apply-templates/>
                    </main>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="odm:ODM">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="odm:Study">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="odm:GlobalVariables"/>
    <xsl:template match="odm:MetaDataVersion">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="odm:ItemGroupDef">
        <section class="card">
            <h2 class="title">
                <a>
                    <xsl:attribute name="name"><xsl:value-of select="@OID"/></xsl:attribute>
                    <xsl:value-of select="odm:Description/odm:TranslatedText"/>
                </a>
            </h2>
            <table>
                <caption>Dataset Structure</caption>
                <thead>
                    <tr>
                        <th>Variable</th>
                        <th>Description</th>
                        <th class="text-center">Required</th>
                        <th>Data Type</th>
                        <th>Length</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:apply-templates select="odm:ItemRef"/>
                </tbody>
            </table>
            <p>&#160;</p>
            <table class="rules">
                <caption>Validation Rules</caption>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Description</th>
                        <th>Validator</th>
                        <th>Message</th>
                        <th>Severity</th>
                        <th class="text-center">Active</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:apply-templates select="val:ValidationRuleRef"/>
                </tbody>
            </table>
        </section>
        <div class="card-footer">
            <a href="#top" class="link"><img class="icon-inline" src="resources/images/arrow-up-to-line-regular.svg" alt="yes" height="14px" width="auto"/>Back to top</a>
        </div>
    </xsl:template>
    <xsl:template match="odm:ItemRef">
        <xsl:variable name="itemDefOid" select="@ItemOID"/>
        <xsl:variable name="itemDef" select="$itemDefs[@OID=$itemDefOid]"/>
        <xsl:variable name="row">
            <xsl:number/>
        </xsl:variable>
        <tr>
            <xsl:attribute name="class"><xsl:choose><xsl:when test="number($row) mod 2 = 1">odd</xsl:when><xsl:otherwise>even</xsl:otherwise></xsl:choose></xsl:attribute>
            <td>
                <xsl:value-of select="$itemDef/@Name"/>
            </td>
            <td>
                <xsl:value-of select="$itemDef/odm:Description/odm:TranslatedText"/>
            </td>
            <td>
                <xsl:if test="@Mandatory = 'Yes'">
                    <img class="icon-status" src="resources/images/check-regular.svg" alt="yes" height="24px" width="21px"/>
                </xsl:if>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="$itemDef/@DataType">
                        <xsl:value-of select="$itemDef/@DataType"/>
                    </xsl:when>
                    <xsl:otherwise>text</xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="$itemDef/@Length">
                        <xsl:value-of select="$itemDef/@Length"/>
                    </xsl:when>
                    <xsl:otherwise>200</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="val:ValidationRuleRef">
        <xsl:variable name="ruleId" select="@RuleID"/>
        <xsl:variable name="validationRule" select="$validationRules[@ID=$ruleId]"/>
        <xsl:variable name="row">
            <xsl:number/>
        </xsl:variable>
        <xsl:apply-templates select="$validationRule">
            <xsl:with-param name="active">
                <xsl:value-of select="@Active"/>
            </xsl:with-param>
            <xsl:with-param name="row">
                <xsl:value-of select="$row"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="val:Unique|val:Condition|val:Match|val:Regex|val:Required|val:Lookup|val:Metadata|val:Find|val:Varorder|val:Varlength|val:Property">
        <xsl:param name="active"/>
        <xsl:param name="row"/>
        <tr>
            <xsl:attribute name="class"><xsl:choose><xsl:when test="number($row) mod 2 = 1">odd</xsl:when><xsl:otherwise>even</xsl:otherwise></xsl:choose></xsl:attribute>
            <td>
                <xsl:value-of select="@ID"/>
            </td>
            <td>
                <xsl:value-of select="@Description"/>
            </td>
            <td>
                <xsl:value-of select="local-name()"/>
            </td>
            <td>
                <xsl:value-of select="@Message"/>
            </td>
            <td>
                <xsl:attribute name="class"><xsl:choose><xsl:when test="@Type = 'Error'">message-type error</xsl:when><xsl:when test="@Type = 'Warning'">message-type warning</xsl:when><xsl:otherwise>message-type information</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:value-of select="@Type"/>
            </td>
            <td>
                <xsl:if test="$active = 'Yes'">
                    <img class="icon-status" src="resources/images/check-regular.svg" alt="yes" height="24px" width="21px"/>
                </xsl:if>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="val:ValidationRules"/>
    <xsl:template match="odm:CodeList"/>
    <xsl:template match="odm:Description"/>
</xsl:stylesheet>
