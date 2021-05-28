//
//  ResultTVCell.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 17/05/21.
//

import UIKit

class ResultTVCell: UITableViewCell {

    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgThumbnil: UIImageView!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblWatch: UILabel!
    @IBOutlet weak var lblTime: RCustomLabel!
    @IBOutlet weak var viewTime: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCellData(Dict:NSMutableDictionary){
        print(Dict)
        viewTime.isHidden = true
        if let ID = Dict["question_id"] as? Int{
            lblId.text = String(ID)
        }
        if let watch = Dict["views"] as? Int{
            lblWatch.text = String(watch) + " asked"
        }
        if let ocrtext = Dict["ocr_text"] as? String{
            
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: ocrtext, options: [], range: NSRange(location: 0, length: ocrtext.utf16.count))

            for match in matches {
                guard let range = Range(match.range, in: ocrtext) else { continue }
                let url = ocrtext[range]
                print(url)
                if url == "" {
                    imgThumbnil.isHidden = true
                }else{
                    imgThumbnil.isHidden = false
                    imgThumbnil?.sd_setImage(with: URL.init(string: String(url)), completed: nil)

                }
            }
            if matches.count == 0 {
                imgThumbnil.isHidden = true
            }
            
        }
        
        
                if let ocrText = Dict["ocr_text"] as? String{
                    
                    lblText.text = ocrText.html2String
                }
    }
}

