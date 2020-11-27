**Author: MJ COUNOTTE**
# A very simple citation/reference parser

* Move references from EndNote to R
	* Export EndNote references to XML (File -> Export...; Save as type: XMl; output style: Endnote Export)
	* Run the script [endnoteDF.R](endnoteDF.R)
	* Example data: [example.xml](example.xml) (6 references, 3 from EMBASE, 3 from PubMed); [example.enlx](example.enlx)
	* Exports to [example_csv.csv](example_csv.csv)	
* Move references form R to RIS or BibTex (and thus back to EndNote)
	* Load example data [example_csv.csv](example_csv.csv)
	* WriteRIS function
	* Write to BibTex using ``bib2df`` package
