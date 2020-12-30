//
//  UIImage + SystemImageExtension.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 27.12.2020.
//

import UIKit

extension UIImage {
    
    static var megaphone: UIImage {
        let symbol = UIImage(systemName: "megaphone")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var megaphoneFill: UIImage {
        let symbol = UIImage(systemName: "megaphone.fill")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var micCircle: UIImage {
        let symbol = UIImage(systemName: "mic.circle")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var mic: UIImage {
        let symbol = UIImage(systemName: "mic")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var micFill: UIImage {
        let symbol = UIImage(systemName: "mic.fill")//?.withTintColor(.red, renderingMode: .alwaysOriginal)
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var micSlash: UIImage {
        let symbol = UIImage(systemName: "mic.slash")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var nextRow: UIImage {
        let symbol = UIImage(systemName: "arrow.right.circle")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var backRow: UIImage {
        
        let symbol = UIImage(systemName: "arrow.uturn.backward.circle")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var trash: UIImage {
        
        let symbol = UIImage(systemName: "trash.circle")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var plus: UIImage {
        
        let symbol = UIImage(systemName: "plus.circle")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var edit: UIImage {
        let symbol = UIImage(systemName: "pip.remove")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var save: UIImage {
        let symbol = UIImage(systemName: "square.and.arrow.down")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    static var stop: UIImage {
        let symbol = UIImage(systemName: "stop.circle")
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    
    
    
}
