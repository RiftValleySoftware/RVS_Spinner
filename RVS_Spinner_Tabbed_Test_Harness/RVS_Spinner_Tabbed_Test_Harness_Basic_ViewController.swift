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

/* ################################################################################################################################## */
/// This is a simple tuple that we use to hold an iterated value.
typealias ShapeValueTuple = (name: String, image: UIImage)

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
// MARK: - The Main View Controller Class
/* ###################################################################################################################################### */
/**
 This is actually an Abstract Base Class for the tab handlers.
 */
class RVS_Spinner_Tabbed_Test_Harness_Basic_ViewController: UIViewController, RVS_SpinnerDelegate {
    /* ################################################################################################################################## */
    /// This is the actual spinner instance for this tab.
    @IBOutlet weak var spinnerObject: RVS_Spinner!
    
    /* ################################################################################################################################## */
    /// This is a segmented switch, displayed along the bottom, that allows the user to choose an image set.
    var _imageSelectorChoices: [String: [RVS_SpinnerDataItem]] = [:]
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    @objc func segmentedImageSelectorHit(_ inSegmentedSwitch: UISegmentedControl) {
        if let title = inSegmentedSwitch.titleForSegment(at: inSegmentedSwitch.selectedSegmentIndex) {
            if let images = _imageSelectorChoices[title] {
                spinnerObject?.values = images
                spinnerObject.selectedIndex = images.count / 2
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    @objc func modeSwitchHit(_ inSwitch: UISwitch) {
        spinnerObject?.spinnerMode = inSwitch.isOn ? 1 : -1
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    func setUpImageSelectorSwitch() {
        // Yeah, all these functions are clunky, but this is a damn test harness. Not worth tweaking them to be suer-optimal. Copy-Pasta FTW.
        /* ################################################################## */
        /**
         */
        func addSegmentedView(_ inSubView: UIView, to inToView: UIView) {
            inToView.addSubview(inSubView)
            
            let guide = self.view.safeAreaLayoutGuide
            inSubView.translatesAutoresizingMaskIntoConstraints = false
            inSubView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            inSubView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8).isActive = true
            inSubView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8).isActive = true
            inSubView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -4).isActive = true
        }
        
        /* ################################################################## */
        /**
         */
        func addSwitch(_ inSubView: UIView, to inToView: UIView, previous inPrevious: UIView) {
            inToView.addSubview(inSubView)
            
            let guide = self.view.safeAreaLayoutGuide
            inSubView.translatesAutoresizingMaskIntoConstraints = false
            inSubView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            inSubView.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
            inSubView.bottomAnchor.constraint(equalTo: inPrevious.topAnchor, constant: -4).isActive = true
        }
        
        /* ################################################################## */
        /**
         */
        func addSpinnerLabel(_ inSubView: UIView, to inToView: UIView, previous inPrevious: UIView) {
            inToView.addSubview(inSubView)
            
            let guide = self.view.safeAreaLayoutGuide
            inSubView.translatesAutoresizingMaskIntoConstraints = false
            inSubView.heightAnchor.constraint(equalTo: inPrevious.heightAnchor).isActive = true
            inSubView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8).isActive = true
            inSubView.trailingAnchor.constraint(equalTo: inPrevious.leadingAnchor, constant: -2).isActive = true
            inSubView.centerYAnchor.constraint(equalTo: inPrevious.centerYAnchor).isActive = true
        }
        
        /* ################################################################## */
        /**
         */
        func addPickerLabel(_ inSubView: UIView, to inToView: UIView, previous inPrevious: UIView) {
            inToView.addSubview(inSubView)
            
            let guide = self.view.safeAreaLayoutGuide
            inSubView.translatesAutoresizingMaskIntoConstraints = false
            inSubView.heightAnchor.constraint(equalTo: inPrevious.heightAnchor).isActive = true
            inSubView.leadingAnchor.constraint(equalTo: inPrevious.trailingAnchor, constant: 4).isActive = true
            inSubView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            inSubView.centerYAnchor.constraint(equalTo: inPrevious.centerYAnchor).isActive = true
        }

        if let resourcePath = Bundle.main.resourcePath {
            var directories: [RVS_Spinner_Tabbed_Test_Harness_DirElement] = []
            
            let rootPath =  "\(resourcePath)/DisplayImages"
            
            do {
                let dirPaths = try FileManager.default.contentsOfDirectory(atPath: rootPath).sorted()

                dirPaths.forEach {
                    let path = rootPath + "/" + $0
                    let name = String($0[$0.index($0.startIndex, offsetBy: 3)...])
                    directories.append(RVS_Spinner_Tabbed_Test_Harness_DirElement(name: name, path: path, items: []))
                }
                
                directories = directories.sorted()
                
                for i in directories.enumerated() {
                    let imagePaths = try FileManager.default.contentsOfDirectory(atPath: i.element.path).sorted()
                    
                    imagePaths.forEach {
                        if let imageFile = FileManager.default.contents(atPath: "\(i.element.path)/\($0)"), let image = UIImage(data: imageFile) {
                            // The name is the filename, minus the file extension.
                            let imageName = String($0.prefix($0.count - 4))
                            let item = RVS_SpinnerDataItem(title: imageName, icon: image)
                            directories[i.offset].items.append(item)
                        }
                    }
                }
                
                directories.forEach {
                    _imageSelectorChoices[$0.name] = $0.items
                }
            } catch let error {
                print(error)
            }
            
            spinnerObject.delegate = self
            
            let segmentNames = directories.compactMap { $0.name }
            let imageSetSelectorSegmentedSwitch = UISegmentedControl(items: segmentNames)
            imageSetSelectorSegmentedSwitch.tintColor = UIColor.white
            imageSetSelectorSegmentedSwitch.backgroundColor = UIColor.clear
            imageSetSelectorSegmentedSwitch.selectedSegmentIndex = segmentNames.count / 2
            segmentedImageSelectorHit(imageSetSelectorSegmentedSwitch)
            imageSetSelectorSegmentedSwitch.addTarget(self, action: #selector(segmentedImageSelectorHit), for: .valueChanged)
            addSegmentedView(imageSetSelectorSegmentedSwitch, to: self.view)
            
            let modeSwitch = UISwitch()
            modeSwitch.isOn = false
            modeSwitch.tintColor = UIColor.white
            modeSwitch.addTarget(self, action: #selector(modeSwitchHit), for: .touchUpInside)
            addSwitch(modeSwitch, to: self.view, previous: imageSetSelectorSegmentedSwitch)
            
            let spinnerLabel = UILabel()
            spinnerLabel.text = "Spinner"
            spinnerLabel.textColor = UIColor.white
            spinnerLabel.textAlignment = .right
            addSpinnerLabel(spinnerLabel, to: self.view, previous: modeSwitch)
            
            let pickerLabel = UILabel()
            pickerLabel.text = "Picker"
            pickerLabel.textColor = UIColor.white
            pickerLabel.textAlignment = .left
            addPickerLabel(pickerLabel, to: self.view, previous: modeSwitch)
        }
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerObject?.delegate = self
        setUpImageSelectorSwitch()
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?) {
        #if DEBUG
        print("spinner(:, singleValueSelected:) called in default.")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
        print("spinner(:, hasSelectedTheValue:) called in default.")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func spinner(_: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
        print("spinner(:, hasOpenedWithTheValue:) called in default.")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func spinner(_: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
        print("spinner(:, hasClosedWithTheValue:) called in default.")
        #endif
    }
}
