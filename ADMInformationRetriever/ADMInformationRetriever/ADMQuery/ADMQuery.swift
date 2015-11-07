//
//  ADMQuery.swift
//  ADMInformationRetriever
//
//  Created by Florian Panzer on 07.11.15.
//  Copyright © 2015 sovanta AG. All rights reserved.
//

import UIKit

class ADMQuery: NSObject{
    var query: String
    var results: Array<ADMDocument> = [ADMDocument]()
    var totalResults: Int = 0
    var resultsPerPage: Int = 0
    
    init(query: String) {
        self.query = query
    }
    
    func send(index: Int, length: Int, urlString: String) -> Bool {
        let url: NSURL = NSURL.init(fileURLWithPath: urlString)
        let request: NSMutableURLRequest = NSMutableURLRequest.init(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
        request.HTTPMethod = "GET"
        //var response: NSURLResponse
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        do{
            let responseData: NSData =
                //try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
                "{\"results\":[{\"journal\":\"Int J Ophthalmol. 2012;5(2):158-63. Epub 2012 Apr 18.\",\"id\":\"1\",\"authors\":[\"Saichanma S\",\"Bunyaratvej A\",\"Sila-Asna M\"],\"title\":\"In vitro transdifferentiation of corneal epithelial-like cells from human\nskin-derived precursor cells.\",\"institutions\":\"Department of Pathology, Faculty of Medicine, Ramathibodi Hospital, Mahidol\nUniversity, Bangkok 14140, Thailand.\",\"abstract\":\"The damage of human corneal cells encounter with the problem of availability of\ncorneal cells for replacement. Limitation of the source of corneal cells has been\nrealized. An attempt of development of corneal epithelial-like cells from the\nhuman skin-derived precursor (hSKPs) has been made in this study. Combination of \nthree essential growth factors: epidermal growth factor (EGF), keratinocyte\ngrowth factor (KGF) and hepatocyte growth factor (HGF) could demonstrate\nsuccessfully induction of hSKPs to differentiation into corneal cells.The induced\ncells expressed the appearance of markers of corneal epithelial cells as shown by\nthe presence of keratin 3 (K3) by antibody label and Western blot assay. The K3\ngene expression of induced hSKPs cells as shown by reverse\ntranscription-polymerase chain reaction (RT-PCR) technology was also\ndemonstrated. The presence of these markers at both gene and protein levels could\nlead to our conclusion that the directional transdifferentiation of hSKPs cells\ninto corneal epithelial cells was successfully done under this cell induction\nprotocol. The finding shows a newly available stem cell source can be obtained\nfrom easily available skin. Cells from autologous human skin might be used for\ncorneal disorder treatment in future clinical application.\",\"ranking\":0.42,\"pmid\":\"22762041\"},{\"journal\":\"Int J Ophthalmol. 2012;5(2):125-32. Epub 2012 Apr 18.\",\"id\":\"2\",\"authors\":[\"Xu YT\",\"Wang Y\",\"Chen P\",\"Xu HF\"],\"title\":\"Age-related maculopathy susceptibility 2 participates in the phagocytosis\nfunctions of the retinal pigment epithelium.\",\"institutions\":\"School of Medicine and Life Sciences of Shandong Academy of Medical Sciences,\nUniversity of Jinan, Jinan 250022, Shandong Province, China.\",\"abstract\":\"AIM: Age-related macular degeneration (AMD) is a multifactorial disease and a\nprevalent cause of visual impairment in developed countries. Many studies suggest\nthat age-related maculopathy susceptibility 2 (ARMS2) is a second major\nsusceptibility gene for AMD. At present, there is no functional information on\nthis gene. Therefore, the purpose of the present study was to detect the\nexpression of ARMS2 in retinal pigment epithelium (RPE) cells and to investigate \nthe effect of ARMS2 on the phagocytosis function of RPE cells.\nMETHODS: Immunofluorescence and reverse transcriptase PCR were used to\ndemonstrate the presence and location of ARMS2 in ARPE-19 (human retinal pigment \nepithelial cell line, ATCC, catalog No.CRL-2302) cells. siRNA was used to knock\ndown ARMS2 mRNA, and the effects of the knockdown on the phagocytosis function of\nthe ARPE-19 cells were evaluated via Fluorescence Activated Cell Sorting (FACS).\nRESULTS: ARMS2 was present in ARPE-19 cells, localized in the cytosol of the\nperinuclear region. The expression of ARMS2 mRNA (messenger RNA) in ARPE-19 cells\ntransfected with ARMS2-siRNA (small interfering RNA, 0.73±0.08) was decreased\ncompared with normal cells (1.00±0.00) or with cells transfected with scrambled\nsiRNA (0.95±0.13) (P<0.05). After incubation of RPE cells with a latex beads\nmedium for 12, 18, or 24 hours, the fluorescence intensities were 38.04±1.02,\n68.92±0.92, and 78.00±0.12 in the ARMS2-siRNA-transfected groups, respectively,\nand 77.98±5.43, 94.87±0.60, and 98.30±0.11 in the scrambled siRNA-transfected\ngroups, respectively. The fluorescent intensities of the same time points in the \ntwo groups were compared using Student's t-test, and the p values were all less\nthan 0.001 at the three different time points.\nCONCLUSION: There is endogenous expression of ARMS2 in ARPE-19 cells. ARMS2 plays\na role in the phagocytosis function of RPE cells, and this role may be one of the\nmechanisms that participates in the development of AMD.\",\"ranking\":1,\"pmid\":\"22762035\"}],\"totalResults\":2,\"resultsPerPage\":10,\"index\":0}".dataUsingEncoding(NSUTF8StringEncoding)
            var jsonresult: NSDictionary =
                try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        }
        catch { return false }
        return true
    }
}
