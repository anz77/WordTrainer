//
//  XMLDictManager.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.10.2020.
//

import Foundation

class XMLDictManager {
    
    let xmlPrefixString = """
        <?xml version="1.0" encoding="UTF-8" ?>
        <!DOCTYPE xdxf SYSTEM "http://xdxf.sourceforge.net/xdxf_lousy.dtd">
        <xdxf lang_from="ENG" lang_to="RUS" format="visual">
        <full_name>Новый Большой англо-русский словарь</full_name>
        <description></description>
        """
    
    let resourcePath: String? = Bundle.main.path(forResource: "new_dict", ofType: "txt")
    let destinationPath: String? = Bundle.main.path(forResource: "new_dict", ofType: "txt")
    
    func makeURLFromPath(_ path: String?) -> URL? {
        guard let path = path else {
            debugPrint("no such path")
            return nil
        }
        return URL(fileURLWithPath: path)
    }
    
}


// MARK: - CREATING LIBRARY FROM XML
extension XMLDictManager {
    
    public func makeWordsFromXML(_ completion: @escaping (Result<[Word], Error>)->()) {
        guard let url = self.makeURLFromPath(self.resourcePath) else {
            completion(.failure(StorageError.pathError))
            return
        }
        DispatchQueue.global().async {
            self.parseXMLWithURL(url) { result in
                do {
                    let words = try result.get().map({ rawWord -> Word in
                        var array = self.parseStringToArrayOfSentences(rawWord.values)
                        let word = Word(key: rawWord.key, id: UUID(), word: array.removeFirst(), /*transcription: "", */values: array)
                        return word
                    })
                    completion(.success(words))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func parseXMLWithURL(_ url: URL, completion: @escaping (Result<[RawDictWord], Error>)->()) {
        guard let data = try? Data(contentsOf: url) else {
            completion(.failure(StorageError.dataError))
            return
        }
        let parcer = XMLDictParcer()
        let rawWords = parcer.parsedItemsFromData(data)
        completion(.success(rawWords))
        debugPrint(#function)
    }
        
    private func parseStringToArrayOfSentences(_ string: String) -> [String] {
        var currentIndex: Int = 1
        var stringsArray: [String] = []
        let scanner = Scanner(string: string)
        var currentString: String?
        //let littleSet = CharacterSet(charactersIn: ":;")
        while !scanner.isAtEnd {
            currentString = scanner.scanUpToString("\(currentIndex)>")
            if scanner.scanString("\(currentIndex)>") != nil {
                if let string = currentString {
                    stringsArray.append(string.replacingOccurrences(of: "\n     ", with: "")/*.components(separatedBy: "_Id:").first?*/.trimmingCharacters(in: .whitespacesAndNewlines))
                    currentString = nil
                    currentIndex += 1
                }
            }
        }
        if let string = currentString {
            stringsArray.append(string.replacingOccurrences(of: "\n     ", with: "")/*.components(separatedBy: "_Id:").first?*/.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        //stringsArray.removeFirst()
        return stringsArray
    }
   
}

// MARK: - CREATING XML FROM LIBRARY
extension XMLDictManager {
    
    func makeXMLStringFromWord(_ word: Word) -> String {
        var string: String = "<ar>"
        string.append("<k>\(word.key)</k>")
        string.append("\n\(word.values[0])")
        for i in 1..<word.values.count {
            string.append("\n      \(i)&gt; \(word.values[i])")
        }
        string.append("</ar>\n")
        return string
    }
    
    func makeXMLStringFromWordsArray(_ array: [Word]) -> String {
        var string = xmlPrefixString
        for card in array {
            string.append(makeXMLStringFromWord(card))
        }
        return string
    }
    
    func storeString(_ string: String, url: URL) throws {

        guard let data = string.data(using: .utf8) else {
            debugPrint("no data")
            throw StorageError.dataError
        }
        do {
            try data.write(to: url)
            debugPrint("tried to write")
        } catch {
            debugPrint("writing error")
            throw error
        }
    }
    
    func makeNewXMLDictionaryFromWords(_ words: [Word]?) throws {
        
        guard let url = makeURLFromPath(self.resourcePath) else {
            throw StorageError.pathError
        }
        
        debugPrint(url)
        
        guard let array = words else {
            debugPrint("no such array")
            throw StorageError.emptyArrayError
        }
        
        let string = makeXMLStringFromWordsArray(array)
        
        do {
            try storeString(string, url: url)
            debugPrint("tried to store")
        } catch let error {
            debugPrint(error)
            throw error
        }
    }
}


