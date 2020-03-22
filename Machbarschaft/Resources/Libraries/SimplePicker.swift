//
//  SimplePicker.swift
//  EZYGradientView
//
//  Created by Linus Geffarth on 10.03.20.
//

import UIKit

struct SimplePicker {
    enum PickerType {
        case strings, date
    }
    
    var type: PickerType = .strings
    
    var options = Options()
    var data: [String] = []
    var data2D: [[String]] = []
    var presenter: UIViewController
    
    let storyboard = UIStoryboard(name: "Other", bundle: nil)
    
    func show(anchor: UIView, _ done: @escaping ((_ index: Int, _ value: String) -> Void) = { _, _ in }) {
        if type == .strings && data.isEmpty {
            print("WARNING: picker data for type ”strings” is empty – SimplePicker.show(), SimplePicker.swift")
        }
        guard let picker = storyboard.instantiateViewController(withIdentifier: "SimplePicker") as? SimplePickerViewController else {
            print("ERROR: cannot present picker: no view controller with identified ”SimplePicker” found in Modals.storybard – SimplePicker.show(), SimplePicker.swift")
            return
        }
        picker.modalPresentationStyle = .overCurrentContext
        picker.modalTransitionStyle = .coverVertical

        picker.configuration = self
        picker.done = done
        
        presenter.present(picker, animated: true)
    }
    
    func show2D(anchor: UIView, _ done2D: @escaping ((_ indices: [Int], _ values: [String]) -> Void) = { _, _ in }) {
        if type == .strings && data2D.isEmpty {
            print("WARNING: picker data for type ”strings” is empty – SimplePicker.show(), SimplePicker.swift")
        }
        guard let picker = storyboard.instantiateViewController(withIdentifier: "SimplePicker") as? SimplePickerViewController else {
            print("ERROR: cannot present picker: no view controller with identified ”SimplePicker” found in Modals.storybard – SimplePicker.show(), SimplePicker.swift")
            return
        }
        picker.modalPresentationStyle = .popover
        picker.popoverPresentationController?.sourceView = anchor
        
        picker.configuration = self
        picker.done2D = done2D
        
        presenter.present(picker, animated: true)
    }
    
    struct Options {
        var initialItem: String?
        var initialRow: Int = 0
        var initialItems: [String]?
        var initialRows: [Int]?
        var initialDate: Date = Date()
        var pickerMode: UIDatePicker.Mode = .date
        var minDate: Date? = nil
        var maxDate: Date? = nil
        var minuteInterval: Int = 1
        var dateReturnFormat: String = "dd.MM.yyyy"
    }
}

class SimplePickerViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var configuration: SimplePicker!
    
    lazy var selectedItem: String = {
        configuration.options.initialItem ?? configuration.data[safe: configuration.options.initialRow] ?? configuration.data.first ?? ""
    }()
    lazy var selectedItems: [String] = {
        let initialItems = configuration.options.initialItems
        let fromInitialRows = configuration.data2D.enumerated().map { (i, array) in
            array[configuration.options.initialRows?[i] ?? 0]
        }.nonEmpty
        return initialItems ?? fromInitialRows ?? []
    }()
    
    var done: ((_ index: Int, _ value: String) -> Void) = { _, _ in }
    var done2D: ((_ indices: [Int], _ values: [String]) -> Void) = { _, _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.roundCorners([.topLeft, .topRight], radius: 5)
        
        view.mask(withRect: contentView.frame)
        
        picker.isShown = configuration.type == .strings
        datePicker.isShown = configuration.type == .date
        
        datePicker.date = configuration.options.initialDate
        datePicker.datePickerMode = configuration.options.pickerMode
        datePicker.minimumDate = configuration.options.minDate
        datePicker.maximumDate = configuration.options.maxDate
        datePicker.minuteInterval = configuration.options.minuteInterval
        
        guard configuration.type == .strings else { return }
        if configuration.data2D.isEmpty {
            picker.selectRow(configuration.data.firstIndex(of: configuration.options.initialItem ?? selectedItem) ?? 0, inComponent: 0, animated: false)
        } else {
            (configuration.options.initialItems ?? []).enumerated().forEach { (i, value) in
                guard let index = configuration.data2D[i].firstIndex(of: value) else { return }
                picker.selectRow(index, inComponent: i, animated: false)
            }
        }
    }
    
    @IBAction func cancelAction() {
        dismiss(animated: true)
    }
    
    @IBAction func doneAction() {
        if configuration.data2D.isEmpty {
            let value = configuration.type == .strings ? selectedItem : datePicker.date.string(withFormat: configuration.options.dateReturnFormat)
            done(configuration.data.firstIndex(of: selectedItem) ?? 0, value)
        } else {
            let indices = selectedItems.enumerated().map { (i, element) in configuration.data2D[i].firstIndex(of: element) ?? 0 }
            done2D(indices, selectedItems)
        }
        dismiss(animated: true)
    }
}

extension SimplePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        configuration.data2D.isEmpty ? 1 : configuration.data2D.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        configuration.data2D.isEmpty ? configuration.data.count : configuration.data2D[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if configuration.data2D.isEmpty {
            selectedItem = configuration.data[row]
        } else {
            selectedItems[component] = configuration.data2D[component][row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        configuration.data2D.isEmpty ? configuration.data[row] : configuration.data2D[component][row]
    }
}
