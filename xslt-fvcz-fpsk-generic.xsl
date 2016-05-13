<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dat="http://www.stormware.cz/schema/version_2/data.xsd"
  xmlns:inv="http://www.stormware.cz/schema/version_2/invoice.xsd"
  xmlns:typ="http://www.stormware.cz/schema/version_2/type.xsd"
  version="1.0">

<!-- Xslt sablona pro predelani XML vydane faktury z CZ Pohody
     do prijate faktury SK pohody. Vyutizi pro prefakturovavani zbozi z ceske
     do slovenske pobocky firmy.
     Nutno pouzivat pro XML s JEDNOU fakturou, ne vice soucasne.
     Pred pouzitim je nutne na dvou mistech nize zmenit ICO slovenske firmy (ted 12345678)
     changelog:
     verze 2016-05-13b prvni verze pro github
     License: GNU GENERAL PUBLIC LICENSE Version 3 (GNU GPL v3)
     Autor: Martin Malec, brozkeff@gmail.com
-->

  <xsl:output method="xml" />

<!-- na zacatek zkopirujeme vse -->
  <xsl:template match="node()|@*">
          <xsl:copy>
              <xsl:apply-templates select="node()|@*"/>
          </xsl:copy>
      </xsl:template>

<!-- magicka zmena XML z vydane faktury na prijatou fakturu :)) -->
  <xsl:template match="inv:invoiceType/text()[.='issuedInvoice']">receivedInvoice</xsl:template>

<!-- ZDE ZMENIT ICO z 12345678 na ICO slovenske firmy -->
<xsl:template match="dat:dataPack/@ico">
          <xsl:attribute name="ico">
              <xsl:value-of select="12345678"/>
          </xsl:attribute>
      </xsl:template>

<!-- ZDE ZMENIT ICO z 12345678 na ICO slovenske firmy -->
  <xsl:template match="dat:dataPack/@note">
              <xsl:attribute name="note">
                  <xsl:value-of select="12345678"/>
              </xsl:attribute>
          </xsl:template>

<!-- Predpokladame platce DPH -->
<xsl:template match="inv:classificationVAT"/>

<!-- smazeme nejake zbytecnosti -->
<xsl:template match="inv:account"/>

<xsl:template match="inv:accounting"/>

<!-- spojeni retezce ulice a cisla, ehm -->
  <xsl:template match="inv:myIdentity/typ:address/typ:street">
    <xsl:element name="typ:street">
      <xsl:value-of select="concat(../typ:street, ' ', ../typ:number)"/>
    </xsl:element>
  </xsl:template>

<!-- katalogove cislo ve vydane fakture je ids, v prijate code ... ehm -->
  <xsl:template match="inv:invoiceItem">
    <xsl:copy>
    <xsl:copy-of select="@*" />
    <inv:stockItem>
    <typ:stockItem>
      <xsl:element name="typ:ids">
      <xsl:value-of select="inv:code"/>
    </xsl:element>
  </typ:stockItem>
  </inv:stockItem>
  <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="typ:number"/>

<!-- prohozeni dodavatele/odberatele  a vice versa -->

<xsl:template match="inv:partnerIdentity">
  <xsl:element name="inv:myIdentity">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="inv:myIdentity">
  <xsl:element name="inv:partnerIdentity">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- dodaci adresa je irelevantni -->
<xsl:template match="typ:shipToAddress"/>

<!-- korunove castky jsou na slovensku irelevantni -->
<xsl:template match="typ:amountHome"/>

<!-- cizi mena EUR v CZ je domaci mena v SK -->
<xsl:template match="typ:amountForeign">
  <xsl:element name="typ:amountHome">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- homeCurrency v ceske Pohode je Kc, to je na slovenske Pohode irelevantni, doklad je stejne v cizi mene EUR -->
<xsl:template match="inv:homeCurrency"/>

<!-- pro ceskou Pohodu cizi mena, pro slovenskou Pohodu samozrejme domaci mena -->
<xsl:template match="inv:foreignCurrency">
  <xsl:element name="inv:homeCurrency">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- smazeme par nadbytecnych veci -->
<xsl:template match="typ:currency"/>

<xsl:template match="typ:country"/>

<xsl:template match="typ:rate"/>

<xsl:template match="typ:establishment"/>

<xsl:template match="typ:www"/>

<!-- OVERIT neni tohle duplicitne? Proc to tu vubec znovu strasi? -->
<xsl:template match="inv:myIdentity">
  <xsl:element name="inv:partnerIdentity">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!--patrne redundantni jelikoz dalsi radek maze celou sekci, overit -->
<xsl:template match="typ:amount"/>

<!-- ve shrnuti jsou udaje o mene a celkove castce zbytecne a neplatne, SK Pohoda si polozky secte sama -->
<xsl:template match="inv:invoiceSummary/inv:foreignCurrency"/>

</xsl:stylesheet>
