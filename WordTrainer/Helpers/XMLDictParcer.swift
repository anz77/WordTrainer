//
//  XMLDictParcer.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 23.10.2020.
//

import Foundation

class XMLDictParcer: NSObject, XMLParserDelegate {
    
    var words: [RawDictWord] = []
    
    var currentWord: RawDictWord?
    var currentKey: String = ""
    var currentValue: String = ""
    //var currentTranscription = ""
    
    private var currentElement = ""

    //private var parserCompletionHandler: (([Word]) -> Void)?
    
    func parsedItemsFromData(_ data: Data?) ->  [RawDictWord] {
        guard let data = data else { return [] }
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return words
    }
    
// MARK: - XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "ar" {
            self.currentWord = RawDictWord()
            self.currentKey = ""
            self.currentValue = ""
            //self.currentTranscription = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let string = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        switch currentElement {
        case "ar": currentValue += string
        case "k": currentKey += string
        //case "tr": currentTranscription += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        switch elementName {
        case "k":
            currentWord?.k = currentKey
            currentElement = "ar"
            //if currentElement != "tr" { currentElement = "ar" }
//        case "tr":
//            currentWord?.tr = currentTranscription
//            currentElement = "ar"
        case "ar":
            currentWord?.value = currentValue
            if let currentWord = currentWord {
                words.append(currentWord)
            }
        default: break
        }
    }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        //debugPrint(parseError.localizedDescription)
    }
    
    //    func parserDidEndDocument(_ parser: XMLParser) {
    //        parserCompletionHandler?(rssItems)
    //    }
    
}

