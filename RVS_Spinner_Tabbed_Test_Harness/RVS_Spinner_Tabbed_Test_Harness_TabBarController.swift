/**
 © Copyright 2019, The Great Rift Valley Software Company
 
 LICENSE:
 
 MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 
 The Great Rift Valley Software Company: https://riftvalleysoftware.com
 */

import UIKit
import RVS_Spinner

/* ###################################################################################################################################### */
// MARK: - The Directory List Container Struct
/* ###################################################################################################################################### */
/**
 This is a custom struct that holds a list of image/text objects (spinner value elements).
 */
struct RVS_Spinner_Tabbed_Test_Harness_DirElement: Comparable, Equatable {
    static func < (lhs: RVS_Spinner_Tabbed_Test_Harness_DirElement, rhs: RVS_Spinner_Tabbed_Test_Harness_DirElement) -> Bool {
        return lhs.path < rhs.path
    }
    
    static func == (lhs: RVS_Spinner_Tabbed_Test_Harness_DirElement, rhs: RVS_Spinner_Tabbed_Test_Harness_DirElement) -> Bool {
        return lhs.path == rhs.path
    }
    
    var name: String = ""
    var path: String = ""
    var items: [RVS_SpinnerDataItem] = []
}

/* ###################################################################################################################################### */
// MARK: - The Main Tab Bar Controller Class
/* ###################################################################################################################################### */
/**
 */
class RVS_Spinner_Tabbed_Test_Harness_TabBarController: UITabBarController {
    /* ################################################################## */
    // This holds the names of the directories (used for the list)
    var directories: [RVS_Spinner_Tabbed_Test_Harness_DirElement] = []
    
    /* ################################################################## */
    /**
     Read all the images from the bundle, segrgated by directory.
     */
    func readImages() {
        if let resourcePath = Bundle.main.resourcePath {
            let rootPath =  "\(resourcePath)/DisplayImages"
            
            // What we do here, is load in the image directories, and assign each one to a switch segment.
            do {
                let dirPaths = try FileManager.default.contentsOfDirectory(atPath: rootPath).sorted()
                
                dirPaths.forEach {
                    let path = rootPath + "/" + $0
                    let name = String($0[$0.index($0.startIndex, offsetBy: 3)...])  // Strip off the number in front (used to sort).
                    directories.append(RVS_Spinner_Tabbed_Test_Harness_DirElement(name: name, path: path, items: []))
                }
                
                directories = directories.sorted()
                
                for i in directories.enumerated() {
                    let imagePaths = try FileManager.default.contentsOfDirectory(atPath: i.element.path).sorted()
                    
                    imagePaths.forEach {
                        if let imageFile = FileManager.default.contents(atPath: "\(i.element.path)/\($0)"), let image = UIImage(data: imageFile) {
                            // The name is the filename, minus the file extension, and minus the numbers in front.
                            let imageName = String($0.prefix($0.count - 4)[$0.index($0.startIndex, offsetBy: 3)...])    // Strip off the sorting number (front), and the file extension.
                            let item = RVS_SpinnerDataItem(title: imageName, icon: image)
                            directories[i.offset].items.append(item)
                        }
                    }
                }
                // At this point, our directories property is populated with our special directory type; each, containing an array of image objects.
            } catch let error {
                print(error)
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        readImages()
    }
}
