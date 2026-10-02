/**
 © Copyright 2021-2026, The Great Rift Valley Software Company

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
 A bundled image collection with a display name, absolute directory path, and ordered items.

 Ordering and equality use only the path; neither compares image contents.
 */
struct RVS_Spinner_Tabbed_Test_Harness_DirElement: Comparable, Equatable {

    /* ################################################################## */
    /**
     Orders collections lexicographically by directory path.

     - returns: True when the left collection's path sorts before the right collection's path.
     */
    static func < (lhs: RVS_Spinner_Tabbed_Test_Harness_DirElement, rhs: RVS_Spinner_Tabbed_Test_Harness_DirElement) -> Bool {
        return lhs.path < rhs.path
    }

    /* ################################################################## */
    /**
     Compares collection paths, ignoring display names and items.

     - returns: True when the two paths match.
     */
    static func == (lhs: RVS_Spinner_Tabbed_Test_Harness_DirElement, rhs: RVS_Spinner_Tabbed_Test_Harness_DirElement) -> Bool {
        return lhs.path == rhs.path
    }

    /* ################################################################## */
    /**
     The collection's display name with its three-character sorting prefix removed.
     */
    var name: String = ""

    /* ################################################################## */
    /**
     The absolute path of the collection inside the app bundle.
     */
    var path: String = ""

    /* ################################################################## */
    /**
     Successfully decoded images in filename order, with filename-derived titles.
     */
    var items: [RVS_SpinnerDataItem] = []
}

/* ###################################################################################################################################### */
// MARK: - The Main Tab Bar Controller Class
/* ###################################################################################################################################### */
/**
 Loads the bundled image collections shared by the tab controllers.

 Numbered directory and file prefixes establish deterministic ordering. The Quadrants
 tab relies on the six collections shipped with this harness.
 */
class RVS_Spinner_Tabbed_Test_Harness_TabBarController: UITabBarController {

    /* ################################################################## */
    // This holds the names of the directories (used for the list)

    /* ################################################################## */
    /**
     Loaded image collections used by the selectors and quadrant fixture.
     */
    var directories: [RVS_Spinner_Tabbed_Test_Harness_DirElement] = []

    /* ################################################################## */
    /**
     Appends collections from DisplayImages and decodes their files in sorted order.

     Three-character numeric prefixes and file extensions are removed from display
     titles. Images retain their original rendering mode. Undecodable files are skipped;
     file-system errors are printed and can leave partially loaded collections.
     This setup method is intended to be called once for the bundled fixture.
     */
    func readImages() {
        if let resourcePath = Bundle.main.resourcePath {
            let rootPath =  "\(resourcePath)/DisplayImages"

            // What we do here, is load in the image directories, and assign each one to a switch segment.
            do {
                let dirPaths = try FileManager.default.contentsOfDirectory(atPath: rootPath).sorted()

                dirPaths.forEach {
                    let path = rootPath + "/" + $0
                    let name = String($0.dropFirst(3))  // Strip off the number in front (used to sort).
                    directories.append(RVS_Spinner_Tabbed_Test_Harness_DirElement(name: name, path: path, items: []))
                }

                directories = directories.sorted()

                for i in directories.enumerated() {
                    let imagePaths = try FileManager.default.contentsOfDirectory(atPath: i.element.path).sorted()

                    imagePaths.forEach {
                        if let imageFile = FileManager.default.contents(atPath: "\(i.element.path)/\($0)"), let image = UIImage(data: imageFile) {
                            // The name is the filename, minus the file extension, and minus the numbers in front.
                            let imageName = String(($0 as NSString).deletingPathExtension.dropFirst(3))    // Strip off the sorting number (front), and the file extension.
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
     Loads the shared image collections before the tab controllers configure their spinners.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        readImages()
    }
}
