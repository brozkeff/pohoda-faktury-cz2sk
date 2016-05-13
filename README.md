# pohoda-faktury-cz2sk
## XSLT transformation of a XML with selected single issued invoice in Czech Pohoda to be imported to received invoice in Slovak Pohoda

Czech accounting software Pohoda offers you to export/import invoices and other documents to XML format. There exists a Czech edition of Pohoda and a similar Slovak edition of Pohoda. If your company is based in Czechia and your subsidiary in Slovakia, and you regularly issue invoices from Czech to Slovak company branch, while both branches use their own versions of Pohoda, you may have asked how to make converting an issued invoice to a received invoice at least partly automatic. CZ and SK versions of Pohoda appear to have no simple tool to achieve that: while exchanging invoices between multiple users of Czech Pohoda is possible via ISDOC format, this format is not available in Slovak edition.

For our internal purpose I created an ugly XSLT transformation stylesheet that converts a XML of issued invoice in EUR currency from Czech branch to a XML of received invoice for Slovak branch, so that whole invoice can be imported into the Slovak Pohoda, including the links to the store articles if the catalogue numbers match. If multiple stores have the same art.numbers it is necessary before importing the XML to select just the one store (Sklady->Sklady) to not enter the goods into the wrong store.

Please review the code thoroughly, change the IDs (IČO) of your companies in CZ and SK before attempting to use the XSLT!

### Steps how it works:
 * In Czech Pohoda go to Issued invoices, and filter the grid so that only a SINGLE invoice directed to your Slovak branch is left
 * right-click to export XML, either use the custom XML format and directly apply the XSLT stylesheet, or use the "XML for re-import to Pohoda", and convert the XML later in SLovak Pohoda during import, or by an external tool (for debugging I used the Atom editor with AtomXsltTransform plugin accessible through Ctrl-Shift-P)
 * Go to Slovak Pohoda, first select only the store you want the items be imported to
 * Import XML, if already transformed no transformation needed anymore, if not transformed yet apply the XSL file for the input XML

**Warning: The code is really UGLY, DIRTY, HACK done by a person with NO experience with good programming or XML/XSLT, it is my first attempt to do anything useful with XML. I did not review at all the search&replace or delete patterns for any redundant statements, the XSLT is not ready for any anomalies in the export XML etc. etc. It does not work for XML with multiple invoices etc. Use AT YOUR OWN RISK! Improvement of the code (refactoring to make the code work in a much more elegant way) is HIGHLY WELCOME!**

## Brief explanation in Czech language - Stručné vysvětlení česky

Podrobnější info viz anglická verze výše.

tl;dr: Zbastlená XSLT transformační šablona pro přenos XML s vydanou fakturou z české Pohody do přijaté faktury ve slovenské Pohodě. Využití: Firma má na slovensku dceřinnou firmu, využívající slovenskou Pohodu, a česká "matka" pravidelně fakturuje zboží slovenské dceři. Sklad zboží v české i slovenské pohodě používá stejná katalogová čísla (IDs). Jakmile je vydaná faktura vytvořená, je exportována do XML, tranformována XSLT šablonou (složitější variace na téma Najít a nahradit různé části kódu, nějaké smazat atd.) a výstupem je nové XML, které už by měla slovenská Pohoda být schopna akceptovat jako přijatou fakturu včetně navázání skladových zásob na sklad a zanesení stejných EUR cen, jako byly v původní vydané faktuře.
