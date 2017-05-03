//
//  CombatViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 12/20/16.
//
//

import UIKit
import SwiftyJSON

class CombatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    // HP
    @IBOutlet weak var hpView: UIView!
    @IBOutlet weak var hpTitle: UILabel!
    @IBOutlet weak var hpValue: UILabel!
    @IBOutlet weak var hpButton: UIButton!
    
    // Resource
    @IBOutlet weak var resourceView: UIView!
    @IBOutlet weak var resourceTitle: UILabel!
    @IBOutlet weak var resourceValue: UILabel!
    @IBOutlet weak var resourceButton: UIButton!
    
    // Proficiency
    @IBOutlet weak var profView: UIView!
    @IBOutlet weak var profTitle: UILabel!
    @IBOutlet weak var profValue: UILabel!
    @IBOutlet weak var profButton: UIButton!
    
    // Armor Class
    @IBOutlet weak var acView: UIView!
    @IBOutlet weak var acTitle: UILabel!
    @IBOutlet weak var acValue: UILabel!
    @IBOutlet weak var acButton: UIButton!
    
    // Speed
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var speedTitle: UILabel!
    @IBOutlet weak var speedValue: UILabel!
    @IBOutlet weak var speedButton: UIButton!
    
    // Initiative
    @IBOutlet weak var initView: UIView!
    @IBOutlet weak var initTitle: UILabel!
    @IBOutlet weak var initValue: UILabel!
    @IBOutlet weak var initButton: UIButton!
    
    // Weapon TableView
    @IBOutlet weak var weaponsTable: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var hpEffectValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        weaponsTable.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
        self.setMiscDisplayData()
    }
    
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setMiscDisplayData() {
        // HP
        hpValue.text = String(Character.Selected.current_hp)+"/"+String(Character.Selected.max_hp)
        
        if((Character.Selected.resources?.allObjects.count ?? 0)! > 0) {
            for resource: Resource in Character.Selected.resources?.allObjects as! [Resource] {
                if resource.spellcasting == false {
                    resourceTitle.text = resource.name ?? "Resource"
                    
                    let currentResourceValue: Int32 = resource.current_value
                    let maxResourceValue: Int32 = resource.max_value
                    let dieType: Int32 = resource.die_type
                    
                    var resourceDisplay = ""
                    if dieType == 0 {
                        if maxResourceValue == 0 {
                            resourceDisplay = String(currentResourceValue)
                        }
                        else {
                            resourceDisplay = String(currentResourceValue)+"/"+String(maxResourceValue)
                        }
                    }
                    else {
                        if maxResourceValue == 0 {
                            resourceDisplay = String(currentResourceValue)+"d"+String(dieType)
                        }
                        else {
                            resourceDisplay = String(currentResourceValue)+"d"+String(dieType)+"/"+String(maxResourceValue)+"d"+String(dieType)
                        }
                    }
                    
                    resourceValue.text = resourceDisplay
                }
            }
        }
        
        // Proficiency
        profValue.text = "+"+String(Character.Selected.proficiency_bonus)
        
        // Armor Class
        acValue.text = String(Character.Selected.ac)
        
        // Speed
        switch Character.Selected.speed_type {
        case 0:
            // Walk
            speedTitle.text = "Walk"
            speedValue.text = String(Character.Selected.speed_walk)
            break
        case 1:
            speedTitle.text = "Burrow"
            speedValue.text = String(Character.Selected.speed_burrow)
            break
        case 2:
            speedTitle.text = "Climb"
            speedValue.text = String(Character.Selected.speed_climb)
            break
        case 3:
            speedTitle.text = "Fly"
            speedValue.text = String(Character.Selected.speed_fly)
            break
        case 4:
            speedTitle.text = "Swim"
            speedValue.text = String(Character.Selected.speed_swim)
            break
        default: break
        }
        
        // Initiative
        if Character.Selected.initiative < 0 {
            initValue.text = String(Character.Selected.initiative)
        }
        else {
            initValue.text = "+"+String(Character.Selected.initiative)
        }
        
        hpView.layer.borderWidth = 1.0
        hpView.layer.borderColor = UIColor.black.cgColor
        
        resourceView.layer.borderWidth = 1.0
        resourceView.layer.borderColor = UIColor.black.cgColor
        
        profView.layer.borderWidth = 1.0
        profView.layer.borderColor = UIColor.black.cgColor
        
        acView.layer.borderWidth = 1.0
        acView.layer.borderColor = UIColor.black.cgColor
        
        speedView.layer.borderWidth = 1.0
        speedView.layer.borderColor = UIColor.black.cgColor
        
        initView.layer.borderWidth = 1.0
        initView.layer.borderColor = UIColor.black.cgColor
        
        weaponsTable.layer.borderWidth = 1.0
        weaponsTable.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBasicView() -> UIView {
        let tempView = UIView.init(frame: CGRect.init(x:20, y:10+64, width:view.frame.size.width-40, height:view.frame.size.height/2-20-32))
        tempView.layer.borderWidth = 1.0
        tempView.layer.borderColor = UIColor.black.cgColor
        tempView.backgroundColor = UIColor.white
        
        let applyBtn = UIButton.init(type: UIButtonType.custom)
        applyBtn.frame = CGRect.init(x:10, y:tempView.frame.size.height-45, width:tempView.frame.size.width/2-10, height:30)
        applyBtn.setTitle("Apply", for:UIControlState.normal)
        applyBtn.addTarget(self, action: #selector(self.applyAction), for: UIControlEvents.touchUpInside)
        applyBtn.layer.borderWidth = 1.0
        applyBtn.layer.borderColor = UIColor.black.cgColor
        applyBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
        tempView.addSubview(applyBtn)
        
        let cancelBtn = UIButton.init(type: UIButtonType.custom)
        cancelBtn.frame = CGRect.init(x:tempView.frame.size.width/2+10, y:tempView.frame.size.height-45, width:tempView.frame.size.width/2-20, height:30)
        cancelBtn.setTitle("Cancel", for:UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(self.cancelAction), for: UIControlEvents.touchUpInside)
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
        tempView.addSubview(cancelBtn)
        
        return tempView
    }
    
    func applyAction(button: UIButton) {
        let parentView:UIView = button.superview!
        
        switch parentView.tag {
        case 100:
            // HP
            for case let view in parentView.subviews {
                if view.tag == 105 {
                    let segControl = view as! UISegmentedControl
                    if segControl.selectedSegmentIndex == 0 {
                        // Damage
                        Character.Selected.current_hp -= hpEffectValue
                    }
                    else if segControl.selectedSegmentIndex == 1 {
                        // Heal
                        Character.Selected.current_hp += hpEffectValue
                        if Character.Selected.current_hp > Character.Selected.max_hp {
                            Character.Selected.current_hp = Character.Selected.max_hp
                        }
                    }
                    else {
                        // Temp HP
                        Character.Selected.current_hp += hpEffectValue
                    }
                }
            }
            hpEffectValue = 0
            hpValue.text = String(Character.Selected.current_hp)+"/"+String(Character.Selected.max_hp)
            
            if Character.Selected.current_hp == 0 {
                // Death Saves
            }
            break
            
        case 200:
            // Resource
            for resource: Resource in Character.Selected.resources?.allObjects as! [Resource] {
                if resource.spellcasting == false {
                    resourceTitle.text = resource.name
                    let currentResourceValue: Int32 = resource.current_value
                    let maxResourceValue: Int32 = resource.max_value
                    let dieType: Int32 = resource.die_type
                    
                    var resourceDisplay = ""
                    if dieType == 0 {
                        if maxResourceValue == 0 {
                            resourceDisplay = String(currentResourceValue)
                        }
                        else {
                            resourceDisplay = String(currentResourceValue)+"/"+String(maxResourceValue)
                        }
                    }
                    else {
                        if maxResourceValue == 0 {
                            resourceDisplay = String(currentResourceValue)+"d"+String(dieType)
                        }
                        else {
                            resourceDisplay = String(currentResourceValue)+"d"+String(dieType)+"/"+String(maxResourceValue)+"d"+String(dieType)
                        }
                    }
                    
                    resourceValue.text = resourceDisplay
                }
            }
            break
            
        case 300:
            // Proficiency Bonus
            profValue.text = "+"+String(Character.Selected.proficiency_bonus)
            break
            
        case 400:
            // Armor Class
            acValue.text = String(Character.Selected.ac)
            break
            
        case 500:
            // Speed
            switch Character.Selected.speed_type {
            case 0:
                // Walk
                speedTitle.text = "Walk"
                speedValue.text = String(Character.Selected.speed_walk)
                break
            case 1:
                speedTitle.text = "Burrow"
                speedValue.text = String(Character.Selected.speed_burrow)
                break
            case 2:
                speedTitle.text = "Climb"
                speedValue.text = String(Character.Selected.speed_climb)
                break
            case 3:
                speedTitle.text = "Fly"
                speedValue.text = String(Character.Selected.speed_fly)
                break
            case 4:
                speedTitle.text = "Swim"
                speedValue.text = String(Character.Selected.speed_swim)
                break
            default: break
            }
            break
            
        case 600:
            // Initiative
            if Character.Selected.initiative < 0 {
                initValue.text = String(Character.Selected.initiative)
            }
            else {
                initValue.text = "+"+String(Character.Selected.initiative)
            }
            break
            
        default:
            break
            
        }
        
        parentView.removeFromSuperview()
    }
    
    func cancelAction(button: UIButton) {
        let parentView = button.superview
        parentView?.removeFromSuperview()
    }
    
    func segmentChanged(segControl: UISegmentedControl) {
        
    }
    
    func stepperChanged(stepper: UIStepper) {
        if stepper.tag == 107 {
            // HP
            hpEffectValue = Int(stepper.value)
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 106 {
                    let textField = view as! UITextField
                    textField.text = String(hpEffectValue)
                }
            }
        }
        else if stepper.tag == 209 {
            // HD
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 202 {
                    let textField = view as! UITextField
                    textField.text = String(Int(stepper.value))
                }
            }
        }
    }
    
    // Edit HP
    @IBAction func hpAction(button: UIButton) {
        // Create hit point adjusting view
        let tempView = createBasicView()
        tempView.tag = 100
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "HP"
        title.textAlignment = NSTextAlignment.center
        title.tag = 101
        tempView.addSubview(title)
        
        let currentHP = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
        currentHP.text = String(Character.Selected.current_hp)
        currentHP.textAlignment = NSTextAlignment.center
        currentHP.layer.borderWidth = 1.0
        currentHP.layer.borderColor = UIColor.black.cgColor
        currentHP.tag = 102
        tempView.addSubview(currentHP)
        
        let slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
        slash.text = "/"
        slash.textAlignment = NSTextAlignment.center
        slash.tag = 103
        tempView.addSubview(slash)
        
        let maxHP = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
        maxHP.text = String(Character.Selected.max_hp)
        maxHP.textAlignment = NSTextAlignment.center
        maxHP.layer.borderWidth = 1.0
        maxHP.layer.borderColor = UIColor.black.cgColor
        maxHP.tag = 104
        tempView.addSubview(maxHP)
        
        let effectType = UISegmentedControl.init(frame: CGRect.init(x:10, y:75, width:tempView.frame.size.width-20, height:30))
        effectType.insertSegment(withTitle:"Damage", at:0, animated:false)
        effectType.insertSegment(withTitle:"Heal", at:1, animated:false)
        effectType.insertSegment(withTitle:"Temp", at:2, animated:false)
        effectType.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        effectType.selectedSegmentIndex = 0
        effectType.tag = 105
        tempView.addSubview(effectType)
        
        let effectValue = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:110, width:40, height:30))
        effectValue.text = String(hpEffectValue)
        effectValue.textAlignment = NSTextAlignment.center
        effectValue.layer.borderWidth = 1.0
        effectValue.layer.borderColor = UIColor.black.cgColor
        effectValue.tag = 106
        tempView.addSubview(effectValue)
        
        let stepper = UIStepper.init(frame: CGRect.init(x:tempView.frame.size.width/2-47, y:145, width:94, height:29))
        stepper.value = 0
        stepper.minimumValue = 0
        stepper.maximumValue = 1000
        stepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        stepper.tag = 107
        tempView.addSubview(stepper)
        
        view.addSubview(tempView)
    }
    
    // Edit Resource
    @IBAction func resourceAction(button: UIButton) {
        // Create resource adjusting view
        let tempView = createBasicView()
        tempView.tag = 200
        for resource: Resource in Character.Selected.resources?.allObjects as! [Resource] {
            if resource.spellcasting == false {
                let currentResourceValue: Int32 = resource.current_value
                let maxResourceValue: Int32 = resource.max_value
                let dieType: Int32 = resource.die_type
                
                let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
                title.text = resource.name
                title.textAlignment = NSTextAlignment.center
                title.tag = 201
                tempView.addSubview(title)
                
                if dieType == 0 {
                    if maxResourceValue == 0 {
                        // current
                        let currentResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:35, width:40, height:30))
                        currentResource.text = String(currentResourceValue)
                        currentResource.textAlignment = NSTextAlignment.center
                        currentResource.layer.borderWidth = 1.0
                        currentResource.layer.borderColor = UIColor.black.cgColor
                        currentResource.tag = 202
                        tempView.addSubview(currentResource)
                    }
                    else {
                        // current / max
                        let currentResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
                        currentResource.text = String(currentResourceValue)
                        currentResource.textAlignment = NSTextAlignment.center
                        currentResource.layer.borderWidth = 1.0
                        currentResource.layer.borderColor = UIColor.black.cgColor
                        currentResource.tag = 202
                        tempView.addSubview(currentResource)
                        
                        let slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
                        slash.text = "/"
                        slash.textAlignment = NSTextAlignment.center
                        slash.tag = 205
                        tempView.addSubview(slash)
                        
                        let maxResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
                        maxResource.text = String(maxResourceValue)
                        maxResource.textAlignment = NSTextAlignment.center
                        maxResource.layer.borderWidth = 1.0
                        maxResource.layer.borderColor = UIColor.black.cgColor
                        maxResource.tag = 206
                        tempView.addSubview(maxResource)
                    }
                }
                else {
                    if maxResourceValue == 0 {
                        // current d die
                        let currentResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
                        currentResource.text = String(currentResourceValue)
                        currentResource.textAlignment = NSTextAlignment.center
                        currentResource.layer.borderWidth = 1.0
                        currentResource.layer.borderColor = UIColor.black.cgColor
                        currentResource.tag = 202
                        tempView.addSubview(currentResource)
                        
                        let d1 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
                        d1.text = "d"
                        d1.textAlignment = NSTextAlignment.center
                        d1.tag = 203
                        tempView.addSubview(d1)
                        
                        let rd1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
                        rd1.text = String(dieType)
                        rd1.textAlignment = NSTextAlignment.center
                        rd1.textColor = UIColor.darkGray
                        rd1.layer.borderWidth = 1.0
                        rd1.layer.borderColor = UIColor.darkGray.cgColor
                        rd1.tag = 204
                        tempView.addSubview(rd1)
                    }
                    else {
                        // current d die / max d die
                        let currentResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:35, width:40, height:30))
                        currentResource.text = String(currentResourceValue)
                        currentResource.textAlignment = NSTextAlignment.center
                        currentResource.layer.borderWidth = 1.0
                        currentResource.layer.borderColor = UIColor.black.cgColor
                        currentResource.tag = 202
                        tempView.addSubview(currentResource)
                        
                        let d1 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:35, width:30, height:30))
                        d1.text = "d"
                        d1.textAlignment = NSTextAlignment.center
                        d1.tag = 203
                        tempView.addSubview(d1)
                        
                        let rd1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
                        rd1.text = String(dieType)
                        rd1.textAlignment = NSTextAlignment.center
                        rd1.isUserInteractionEnabled = false
                        rd1.textColor = UIColor.darkGray
                        rd1.layer.borderWidth = 1.0
                        rd1.layer.borderColor = UIColor.darkGray.cgColor
                        rd1.tag = 204
                        tempView.addSubview(rd1)
                        
                        let slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
                        slash.text = "/"
                        slash.textAlignment = NSTextAlignment.center
                        slash.tag = 205
                        tempView.addSubview(slash)
                        
                        let maxResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
                        maxResource.text = String(maxResourceValue)
                        maxResource.textAlignment = NSTextAlignment.center
                        maxResource.layer.borderWidth = 1.0
                        maxResource.layer.borderColor = UIColor.black.cgColor
                        maxResource.tag = 206
                        tempView.addSubview(maxResource)
                        
                        let d2 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+50, y:35, width:30, height:30))
                        d2.text = "d"
                        d2.textAlignment = NSTextAlignment.center
                        d2.tag = 207
                        tempView.addSubview(d2)
                        
                        let rd2 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:35, width:40, height:30))
                        rd2.text = String(dieType)
                        rd2.textAlignment = NSTextAlignment.center
                        rd2.layer.borderWidth = 1.0
                        rd2.layer.borderColor = UIColor.black.cgColor
                        rd2.tag = 208
                        tempView.addSubview(rd2)
                    }
                }
                
                let stepper = UIStepper.init(frame: CGRect.init(x:tempView.frame.size.width/2-47, y:90, width:94, height:29))
                stepper.value = Double(currentResourceValue)
                stepper.minimumValue = 0
                stepper.maximumValue = Double(maxResourceValue)
                stepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
                stepper.tag = 209
                tempView.addSubview(stepper)
        
            }
        }
        
        view.addSubview(tempView)
    }
    
    // Edit Proficiency
    @IBAction func profAction(button: UIButton) {
        // Create proficiency bonus adjusting view
        let tempView = createBasicView()
        tempView.tag = 300
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Proficiency Bonus"
        title.textAlignment = NSTextAlignment.center
        title.tag = 301
        tempView.addSubview(title)
        
        let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        profField.text = String(Character.Selected.proficiency_bonus)
        profField.textAlignment = NSTextAlignment.center
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.black.cgColor
        profField.tag = 302
        tempView.addSubview(profField)
        
        view.addSubview(tempView)
    }
    
    // Edit Armor Class
    @IBAction func acAction(button: UIButton) {
        // Create armor class adjusting view
        let tempView = createBasicView()
        tempView.tag = 400
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
        tempView.addSubview(scrollView)
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Armor Class"
        title.textAlignment = NSTextAlignment.center
        title.tag = 401
        scrollView.addSubview(title)
        
        // Armor value
        let armorValueLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-120, y: 30, width: 40, height: 30))
        armorValueLabel.text = "Armor\nValue"
        armorValueLabel.font = UIFont.systemFont(ofSize: 10)
        armorValueLabel.textAlignment = NSTextAlignment.center
        armorValueLabel.numberOfLines = 2
        armorValueLabel.tag = 402
        scrollView.addSubview(armorValueLabel)
        
        let armorValueField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:55, width:40, height:30))
        armorValueField.text = String(10)
        armorValueField.textAlignment = NSTextAlignment.center
        armorValueField.layer.borderWidth = 1.0
        armorValueField.layer.borderColor = UIColor.darkGray.cgColor
        armorValueField.textColor = UIColor.darkGray
        armorValueField.isEnabled = false
        armorValueField.tag = 403
        scrollView.addSubview(armorValueField)
        
        // Dex bonus
        let dexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-70, y: 30, width: 40, height: 30))
        dexLabel.text = "Dex\nBonus"
        dexLabel.font = UIFont.systemFont(ofSize: 10)
        dexLabel.textAlignment = NSTextAlignment.center
        dexLabel.numberOfLines = 2
        dexLabel.tag = 404
        scrollView.addSubview(dexLabel)
        
        let dexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-70, y:55, width:40, height:30))
        dexField.text = String(Character.Selected.dexBonus)
        dexField.textAlignment = NSTextAlignment.center
        dexField.layer.borderWidth = 1.0
        dexField.layer.borderColor = UIColor.darkGray.cgColor
        dexField.textColor = UIColor.darkGray
        dexField.isEnabled = false
        dexField.tag = 405
        scrollView.addSubview(dexField)
        
        // Shield Value
        let shieldLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-20, y: 30, width: 40, height: 30))
        shieldLabel.text = "Shield\nValue"
        shieldLabel.font = UIFont.systemFont(ofSize: 10)
        shieldLabel.textAlignment = NSTextAlignment.center
        shieldLabel.numberOfLines = 2
        shieldLabel.tag = 406
        scrollView.addSubview(shieldLabel)
        
        let shieldField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:55, width:40, height:30))
        shieldField.text = String(0)
        shieldField.textAlignment = NSTextAlignment.center
        shieldField.layer.borderWidth = 1.0
        shieldField.layer.borderColor = UIColor.darkGray.cgColor
        shieldField.textColor = UIColor.darkGray
        shieldField.isEnabled = false
        shieldField.tag = 407
        scrollView.addSubview(shieldField)
        
        // Max Dex
        let maxDexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+30, y: 30, width: 40, height: 30))
        maxDexLabel.text = "Max\nDex"
        maxDexLabel.font = UIFont.systemFont(ofSize: 10)
        maxDexLabel.textAlignment = NSTextAlignment.center
        maxDexLabel.numberOfLines = 2
        maxDexLabel.tag = 408
        scrollView.addSubview(maxDexLabel)
        
        let maxDexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+30, y:55, width:40, height:30))
        maxDexField.text = "-"
        maxDexField.textAlignment = NSTextAlignment.center
        maxDexField.layer.borderWidth = 1.0
        shieldField.layer.borderColor = UIColor.darkGray.cgColor
        shieldField.textColor = UIColor.darkGray
        shieldField.isEnabled = false
        maxDexField.tag = 409
        scrollView.addSubview(maxDexField)
        
        // Misc Mod
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+80, y: 30, width: 40, height: 30))
        miscLabel.text = "Misc\nValue"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 410
        scrollView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:55, width:40, height:30))
        miscField.text = String(Character.Selected.ac_misc)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 411
        scrollView.addSubview(miscField)
        
        //Additional Ability Mod (Monk/Barb)
        let addAbilityLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-120, y: 90, width: 90, height: 30))
        addAbilityLabel.text = "Additional Mod"
        addAbilityLabel.font = UIFont.systemFont(ofSize: 10)
        addAbilityLabel.tag = 412
        scrollView.addSubview(addAbilityLabel)
        
        let addAbilityField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:90, width:40, height:30))
        addAbilityField.text = String(0)
        addAbilityField.textAlignment = NSTextAlignment.center
        addAbilityField.layer.borderWidth = 1.0
        addAbilityField.layer.borderColor = UIColor.darkGray.cgColor
        addAbilityField.textColor = UIColor.darkGray
        addAbilityField.isEnabled = false
        addAbilityField.tag = 413
        scrollView.addSubview(addAbilityField)
        
        let addAbilitySeg = UISegmentedControl.init(frame: CGRect.init(x:10, y:130, width:tempView.frame.size.width-20, height:30))
        addAbilitySeg.insertSegment(withTitle:"N/A", at:0, animated:false)
        addAbilitySeg.insertSegment(withTitle:"STR", at:1, animated:false)
        addAbilitySeg.insertSegment(withTitle:"DEX", at:2, animated:false)
        addAbilitySeg.insertSegment(withTitle:"CON", at:3, animated:false)
        addAbilitySeg.insertSegment(withTitle:"INT", at:4, animated:false)
        addAbilitySeg.insertSegment(withTitle:"WIS", at:5, animated:false)
        addAbilitySeg.insertSegment(withTitle:"CHA", at:6, animated:false)
        addAbilitySeg.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        addAbilitySeg.selectedSegmentIndex = 0
        addAbilitySeg.tag = 414
        scrollView.addSubview(addAbilitySeg)
        
        let armorTable = UITableView.init(frame: CGRect.init(x:10, y:170, width:tempView.frame.size.width-20, height:80))
        armorTable.tag = 415
        armorTable.delegate = self
        armorTable.dataSource = self
        scrollView.addSubview(armorTable)
        
        scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 260)
        
        
        let allArmor: [Armor] = Character.Selected.equipment!.armor?.allObjects as! [Armor]
        
        for armor: Armor in allArmor {
            if armor.equipped == true {
                if armor.shield == true {
                    let shieldValue = armor.value + armor.magic_bonus + armor.misc_bonus
                    shieldField.text = String(shieldValue)
                }
                else {
                    let armorValue = armor.value + armor.magic_bonus + armor.misc_bonus
                    armorValueField.text = String(armorValue)
                    let maxDex = armor.max_dex
                    if maxDex == 0 {
                        maxDexField.text = "-"
                    }
                    else {
                        maxDexField.text = String(maxDex)
                    }
                }
            }
        }
        
        switch Character.Selected.additional_ac_mod! {
        case "STR":
            addAbilitySeg.selectedSegmentIndex = 1
            addAbilityField.text = String(Character.Selected.strBonus)
            break
        case "DEX":
            addAbilitySeg.selectedSegmentIndex = 2
            addAbilityField.text = String(Character.Selected.dexBonus)
            break
        case "CON":
            addAbilitySeg.selectedSegmentIndex = 3
            addAbilityField.text = String(Character.Selected.conBonus)
            break
        case "INT":
            addAbilitySeg.selectedSegmentIndex = 4
            addAbilityField.text = String(Character.Selected.intBonus)
            break
        case "WIS":
            addAbilitySeg.selectedSegmentIndex = 5
            addAbilityField.text = String(Character.Selected.wisBonus)
            break
        case "CHA":
            addAbilitySeg.selectedSegmentIndex = 6
            addAbilityField.text = String(Character.Selected.chaBonus)
            break
        default:
            addAbilitySeg.selectedSegmentIndex = 0
            addAbilityField.text = "-"
            break
        }
        
        view.addSubview(tempView)
    }
    
    // Edit Speed
    @IBAction func speedAction(button: UIButton) {
        // Create speed adjusting view
        let tempView = createBasicView()
        tempView.tag = 500
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Speed"
        title.textAlignment = NSTextAlignment.center
        title.tag = 501
        tempView.addSubview(title)
        
        let baseLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-85, y: 35, width: 90, height: 30))
        baseLabel.text = "Base\nValue"
        baseLabel.font = UIFont.systemFont(ofSize: 10)
        baseLabel.textAlignment = NSTextAlignment.center
        baseLabel.numberOfLines = 2
        baseLabel.tag = 502
        tempView.addSubview(baseLabel)
        
        let baseField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-60, y:65, width:40, height:30))
        baseField.textAlignment = NSTextAlignment.center
        baseField.layer.borderWidth = 1.0
        baseField.layer.borderColor = UIColor.black.cgColor
        baseField.tag = 503
        tempView.addSubview(baseField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-5, y: 35, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 504
        tempView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+20, y:65, width:40, height:30))
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 505
        tempView.addSubview(miscField)
        
        switch Character.Selected.speed_type {
        case 0:
            // Walk
            baseField.text = String(Character.Selected.speed_walk)
            miscField.text = String(Character.Selected.speed_walk_misc)
            break
        case 1:
            // Burrow
            baseField.text = String(Character.Selected.speed_burrow)
            miscField.text = String(Character.Selected.speed_burrow_misc)
            break
        case 2:
            // Climb
            baseField.text = String(Character.Selected.speed_climb)
            miscField.text = String(Character.Selected.speed_climb_misc)
            break
        case 3:
            // Fly
            baseField.text = String(Character.Selected.speed_fly)
            miscField.text = String(Character.Selected.speed_fly_misc)
            break
        case 4:
            // Swim
            baseField.text = String(Character.Selected.speed_swim)
            miscField.text = String(Character.Selected.speed_swim_misc)
            break
        default: break
        }
        
        let movementLabel = UILabel.init(frame: CGRect.init(x:10, y:100, width:tempView.frame.size.width-20, height:30))
        movementLabel.text = "Movement Type"
        movementLabel.textAlignment = NSTextAlignment.center
        movementLabel.tag = 506
        tempView.addSubview(movementLabel)
        
        let movementType = UISegmentedControl.init(frame: CGRect.init(x:10, y:135, width:tempView.frame.size.width-20, height:30))
        movementType.insertSegment(withTitle:"Walk", at:0, animated:false)
        movementType.insertSegment(withTitle:"Burrow", at:1, animated:false)
        movementType.insertSegment(withTitle:"Climb", at:2, animated:false)
        movementType.insertSegment(withTitle:"Fly", at:3, animated:false)
        movementType.insertSegment(withTitle:"Swim", at:4, animated:false)
        movementType.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        movementType.selectedSegmentIndex = 0
        movementType.tag = 507
        tempView.addSubview(movementType)
        
        view.addSubview(tempView)
    }
    
    // Edit Initiative
    @IBAction func initAction(button: UIButton) {
        // Create initiative adjusting view
        let tempView = createBasicView()
        tempView.tag = 600
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
        title.text = "Initiative"
        title.textAlignment = NSTextAlignment.center
        title.tag = 601
        tempView.addSubview(title)
        
        let profLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-105, y: 25, width: 90, height: 30))
        profLabel.text = "Proficiency\nBonus"
        profLabel.font = UIFont.systemFont(ofSize: 10)
        profLabel.textAlignment = NSTextAlignment.center
        profLabel.numberOfLines = 2
        profLabel.tag = 602
        tempView.addSubview(profLabel)
        
        let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:50, width:40, height:30))
        profField.text = String(Character.Selected.proficiency_bonus)
        profField.textAlignment = NSTextAlignment.center
        profField.isEnabled = false
        profField.textColor = UIColor.darkGray
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.darkGray.cgColor
        profField.tag = 603
        tempView.addSubview(profField)
        
        let dexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-45, y: 25, width: 90, height: 30))
        dexLabel.text = "Dexterity\nBonus"
        dexLabel.font = UIFont.systemFont(ofSize: 10)
        dexLabel.textAlignment = NSTextAlignment.center
        dexLabel.numberOfLines = 2
        dexLabel.tag = 604
        tempView.addSubview(dexLabel)
        
        let dexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        dexField.text = String(Character.Selected.dexBonus)
        dexField.textAlignment = NSTextAlignment.center
        dexField.layer.borderWidth = 1.0
        dexField.layer.borderColor = UIColor.black.cgColor
        dexField.tag = 605
        tempView.addSubview(dexField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+15, y: 25, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 606
        tempView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:50, width:40, height:30))
        miscField.text = String(0)//String(Character.Selected.miscInitBonus)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 607
        tempView.addSubview(miscField)
        
        let alertLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-90, y:85, width:120, height:30))
        alertLabel.text = "Alert Feat"
        alertLabel.textAlignment = NSTextAlignment.right
        alertLabel.tag = 608
        tempView.addSubview(alertLabel)
        
        let alertSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:85, width:51, height:31))
        alertSwitch.isOn = false
        alertSwitch.tag = 609
        tempView.addSubview(alertSwitch)
        
        let halfProfLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:120, width:150, height:30))
        halfProfLabel.text = "Half Proficiency"
        halfProfLabel.textAlignment = NSTextAlignment.right
        halfProfLabel.tag = 610
        tempView.addSubview(halfProfLabel)
        
        let halfProfSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:120, width:51, height:31))
        halfProfSwitch.isOn = false
        halfProfSwitch.tag = 611
        tempView.addSubview(halfProfSwitch)
        
        let roundUpLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:155, width:150, height:30))
        roundUpLabel.text = "Round Up"
        roundUpLabel.textAlignment = NSTextAlignment.right
        roundUpLabel.tag = 612
        tempView.addSubview(roundUpLabel)
        
        let roundUpSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:155, width:51, height:31))
        roundUpSwitch.isOn = false
        roundUpSwitch.tag = 613
        tempView.addSubview(roundUpSwitch)
        
        if halfProfSwitch.isOn {
            roundUpLabel.isHidden = false
            roundUpSwitch.isHidden = false
        }
        else {
            roundUpLabel.isHidden = true
            roundUpSwitch.isHidden = true
        }
        
        view.addSubview(tempView)
    }
    
    // UITableView Delegate & Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == weaponsTable{
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 415 {
            return (Character.Selected.equipment?.armor?.allObjects.count) ?? 0
        }
        else {
            if section == 0 {
                return (Character.Selected.equipment?.weapons?.allObjects.count) ?? 0
            }
            else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 415 {
            return 30
        }
        else {
            if indexPath.section == 0 {
                // Existing weapon
                return 70
            }
            else {
                // New weapon
                return 30
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 415 {
            let cell = weaponsTable.dequeueReusableCell(withIdentifier: "ArmorTableViewCell") as! ArmorTableViewCell
            
            let armor = Character.Selected.equipment?.armor?.allObjects[indexPath.row] as! Armor            
            var armorValue = armor.value
            armorValue = armorValue + armor.magic_bonus
            armorValue = armorValue + armor.misc_bonus
            
            if armor.equipped == true {
                cell.armorName.textColor = UIColor.green
                cell.armorValue.textColor = UIColor.green
            }
            
            if Int(armor.str_requirement) > Character.Selected.strScore {
                cell.armorName.textColor = UIColor.red
                cell.armorValue.textColor = UIColor.red
            }
            
            cell.armorName.text = armor.name
            if armor.shield == true {
                cell.armorValue.text = " + " + String(armorValue)
            }
            else {
                if armor.ability_mod?.name == "" {
                    cell.armorValue.text = String(armorValue)
                }
                else {
                    cell.armorValue.text = String(armorValue) + " + " + (armor.ability_mod?.name)!
                }
            }
            
            return cell
        }
        else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponTableViewCell") as! WeaponTableViewCell
                let weapon = Character.Selected.equipment?.weapons?.allObjects[indexPath.row] as! Weapon
                let damage = weapon.damage! as Damage
                
                var attackBonus = 0
                var damageBonus = 0
                let modDamage = damage.mod_damage
                let abilityType: String = (weapon.ability?.name)!
                switch abilityType {
                case "STR":
                    attackBonus += Character.Selected.strBonus //Add STR bonus
                    if modDamage {
                        damageBonus += Character.Selected.strBonus
                    }
                case "DEX":
                    attackBonus += Character.Selected.dexBonus //Add DEX bonus
                    if modDamage {
                        damageBonus += Character.Selected.dexBonus
                    }
                case "CON":
                    attackBonus += Character.Selected.conBonus //Add CON bonus
                    if modDamage {
                        damageBonus += Character.Selected.conBonus
                    }
                case "INT":
                    attackBonus += Character.Selected.intBonus //Add INT bonus
                    if modDamage {
                        damageBonus += Character.Selected.intBonus
                    }
                case "WIS":
                    attackBonus += Character.Selected.wisBonus //Add WIS bonus
                    if modDamage {
                        damageBonus += Character.Selected.wisBonus
                    }
                case "CHA":
                    attackBonus += Character.Selected.chaBonus //Add CHA bonus
                    if modDamage {
                        damageBonus += Character.Selected.chaBonus
                    }
                default: break
                }
                
                attackBonus = attackBonus +
                    Int(weapon.magic_bonus + weapon.misc_bonus)
                damageBonus = damageBonus + Int(damage.magic_bonus + damage.misc_bonus)
                
                var damageDieNumber = damage.die_number
                var damageDie = damage.die_type
                let extraDie = damage.extra_die
                if (extraDie) {
                    damageDieNumber = damageDieNumber + damage.extra_die_number
                    damageDie = damageDie + damage.extra_die_type
                }
                
                let damageType = damage.damage_type
                
                cell.weaponName.text = weapon.name
                cell.weaponReach.text = "Range: " + weapon.range!
                cell.weaponModifier.text = "+" + String(attackBonus)
                let dieDamage = String(damageDieNumber)+"d"+String(damageDie)
                cell.weaponDamage.text = dieDamage+"+"+String(damageBonus)+" "+damageType!
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell") as! NewTableViewCell
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Edit selected skill value
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.tag == 415 {
            // Select a new armor to equip
            let allArmor = Character.Selected.equipment?.armor?.allObjects
            let armor: Armor = allArmor?[indexPath.row] as! Armor
            
            armor.equipped = !armor.equipped
            
            let parentView:UIView = tableView.superview!
            for case let view in parentView.subviews {
                if armor.shield == true {
                    if view.tag == 307 {
                        // Shield Value
                        let textField = view as! UITextField
                        if armor.equipped == true {
                            textField.text = String(armor.value)
                        }
                        else {
                            textField.text = "-"
                        }
                    }
                }
                else {
                    if view.tag == 303 {
                        // Armor Value
                        let textField = view as! UITextField
                        if armor.equipped == true {
                            textField.text = String(armor.value)
                        }
                        else {
                            textField.text = String(10)
                        }
                    }
                    else if view.tag == 309 {
                        // Max Dex
                        let textField = view as! UITextField
                        if armor.equipped == true {
                            textField.text = String(armor.max_dex)
                        }
                        else {
                            textField.text = "-"
                        }
                    }
                }
            }
            
            tableView.reloadData()
        }
        else {
            if indexPath.section == 0 {
                let tempView = createBasicView()
                tempView.tag = 700 + (indexPath.row * 100)
                
                let weapon = Character.Selected.equipment?.weapons?.allObjects[indexPath.row] as! Weapon
                let damage = weapon.damage! as Damage
                
                var attackBonus = 0
                var damageBonus = 0
                let modDamage = damage.mod_damage
                let abilityType: String = (weapon.ability?.name)!
                switch abilityType {
                case "STR":
                    attackBonus += Character.Selected.strBonus //Add STR bonus
                    if modDamage {
                        damageBonus += Character.Selected.strBonus
                    }
                case "DEX":
                    attackBonus += Character.Selected.dexBonus //Add DEX bonus
                    if modDamage {
                        damageBonus += Character.Selected.dexBonus
                    }
                case "CON":
                    attackBonus += Character.Selected.conBonus //Add CON bonus
                    if modDamage {
                        damageBonus += Character.Selected.conBonus
                    }
                case "INT":
                    attackBonus += Character.Selected.intBonus //Add INT bonus
                    if modDamage {
                        damageBonus += Character.Selected.intBonus
                    }
                case "WIS":
                    attackBonus += Character.Selected.wisBonus //Add WIS bonus
                    if modDamage {
                        damageBonus += Character.Selected.wisBonus
                    }
                case "CHA":
                    attackBonus += Character.Selected.chaBonus //Add CHA bonus
                    if modDamage {
                        damageBonus += Character.Selected.chaBonus
                    }
                default: break
                }
                
                attackBonus = attackBonus + Int(weapon.magic_bonus + weapon.misc_bonus)
                damageBonus = damageBonus + Int(damage.magic_bonus + damage.misc_bonus)
                
                var damageDieNumber = damage.die_number
                var damageDie = damage.die_type
                let extraDie = damage.extra_die
                if (extraDie) {
                    damageDieNumber = damageDieNumber + damage.extra_die_number
                    damageDie = damageDie + damage.extra_die_type
                }
                
                let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
                tempView.addSubview(scrollView)
                
                let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
                title.text = weapon.name?.capitalized
                title.textAlignment = NSTextAlignment.center
                title.tag = 700 + (indexPath.row * 100) + 1
                title.layer.borderWidth = 1.0
                title.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(title)
                
                let reachLabel = UILabel.init(frame: CGRect.init(x: 10, y: 30, width: tempView.frame.size.width/2-15, height: 30))
                reachLabel.text = "Range"
                reachLabel.textAlignment = NSTextAlignment.center
                reachLabel.tag = 700 + (indexPath.row * 100) + 2
                scrollView.addSubview(reachLabel)
                
                let reachField = UITextField.init(frame: CGRect.init(x: 10, y: 55, width: tempView.frame.size.width/2-15, height: 40))
                reachField.text = weapon.range
                reachField.textAlignment = NSTextAlignment.center
                reachField.layer.borderWidth = 1.0
                reachField.layer.borderColor = UIColor.black.cgColor
                reachField.tag = 700 + (indexPath.row * 100) + 3
                scrollView.addSubview(reachField)
                
                let damageTypeLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+5, y: 30, width: tempView.frame.size.width/2-15, height: 30))
                damageTypeLabel.text = "Damage Type"
                damageTypeLabel.textAlignment = NSTextAlignment.center
                damageTypeLabel.tag = 700 + (indexPath.row * 100) + 4
                scrollView.addSubview(damageTypeLabel)
                
                let damageTypePickerView = UIPickerView.init(frame: CGRect.init(x: tempView.frame.size.width/2+5, y: 55, width: tempView.frame.size.width/2-15, height: 40))
                damageTypePickerView.dataSource = self
                damageTypePickerView.delegate = self
                damageTypePickerView.layer.borderWidth = 1.0
                damageTypePickerView.layer.borderColor = UIColor.black.cgColor
                damageTypePickerView.tag = 700 + (indexPath.row * 100) + 5
                scrollView.addSubview(damageTypePickerView)
                
                let attackLabel = UILabel.init(frame: CGRect.init(x: 10, y: 90, width: tempView.frame.size.width-20, height: 30))
                attackLabel.text = "Attack Ability"
                attackLabel.textAlignment = NSTextAlignment.center
                attackLabel.tag = 700 + (indexPath.row * 100) + 6
                scrollView.addSubview(attackLabel)
                
                var aaIndex = 0
                var abilityName = ""
                var abilityMod = 0
                switch abilityType {
                case "STR":
                    aaIndex = 0
                    abilityName = "Strength"
                    abilityMod = Character.Selected.strBonus
                case "DEX":
                    aaIndex = 1
                    abilityName = "Dexterity"
                    abilityMod = Character.Selected.dexBonus
                case "CON":
                    aaIndex = 2
                    abilityName = "Constitution"
                    abilityMod = Character.Selected.conBonus
                case "INT":
                    aaIndex = 3
                    abilityName = "Intelligence"
                    abilityMod = Character.Selected.intBonus
                case "WIS":
                    aaIndex = 4
                    abilityName = "Wisdom"
                    abilityMod = Character.Selected.wisBonus
                case "CHA":
                    aaIndex = 5
                    abilityName = "Charisma"
                    abilityMod = Character.Selected.chaBonus
                default: break
                }
                
                let aa = UISegmentedControl.init(frame: CGRect.init(x:10, y:115, width:tempView.frame.size.width-20, height:30))
                aa.insertSegment(withTitle:"STR", at:0, animated:false)
                aa.insertSegment(withTitle:"DEX", at:1, animated:false)
                aa.insertSegment(withTitle:"CON", at:2, animated:false)
                aa.insertSegment(withTitle:"INT", at:3, animated:false)
                aa.insertSegment(withTitle:"WIS", at:4, animated:false)
                aa.insertSegment(withTitle:"CHA", at:5, animated:false)
                aa.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
                aa.selectedSegmentIndex = aaIndex
                aa.tag = 700 + (indexPath.row * 100) + 7
                scrollView.addSubview(aa)
                
                let profLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 145, width: 90, height: 30))
                profLabel.text = "Proficiency\nBonus"
                profLabel.font = UIFont.systemFont(ofSize: 10)
                profLabel.textAlignment = NSTextAlignment.center
                profLabel.numberOfLines = 2
                profLabel.tag = 700 + (indexPath.row * 100) + 8
                scrollView.addSubview(profLabel)
                
                let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-110, y:170, width:40, height:30))
                profField.text = String(Character.Selected.proficiency_bonus)
                profField.textAlignment = NSTextAlignment.center
                profField.isEnabled = false
                profField.textColor = UIColor.darkGray
                profField.layer.borderWidth = 1.0
                profField.layer.borderColor = UIColor.darkGray.cgColor
                profField.tag = 700 + (indexPath.row * 100) + 9
                scrollView.addSubview(profField)
                
                let abilityLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 145, width: 90, height: 30))
                abilityLabel.text = abilityName+"\nBonus"
                abilityLabel.font = UIFont.systemFont(ofSize: 10)
                abilityLabel.textAlignment = NSTextAlignment.center
                abilityLabel.numberOfLines = 2
                abilityLabel.tag = 700 + (indexPath.row * 100) + 10
                scrollView.addSubview(abilityLabel)
                
                let abilityField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:170, width:40, height:30))
                abilityField.text = String(abilityMod)
                abilityField.textAlignment = NSTextAlignment.center
                abilityField.isEnabled = false
                abilityField.textColor = UIColor.darkGray
                abilityField.layer.borderWidth = 1.0
                abilityField.layer.borderColor = UIColor.black.cgColor
                abilityField.tag = 700 + (indexPath.row * 100) + 11
                scrollView.addSubview(abilityField)
                
                let magicLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 145, width: 90, height: 30))
                magicLabel.text = "Magic Item\nAttack Bonus"
                magicLabel.font = UIFont.systemFont(ofSize: 10)
                magicLabel.textAlignment = NSTextAlignment.center
                magicLabel.numberOfLines = 2
                magicLabel.tag = 700 + (indexPath.row * 100) + 12
                scrollView.addSubview(magicLabel)
                
                let magicField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:170, width:40, height:30))
                magicField.text = String(weapon.magic_bonus)
                magicField.textAlignment = NSTextAlignment.center
                magicField.layer.borderWidth = 1.0
                magicField.layer.borderColor = UIColor.black.cgColor
                magicField.tag = 700 + (indexPath.row * 100) + 13
                scrollView.addSubview(magicField)
                
                let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 145, width: 90, height: 30))
                miscLabel.text = "Misc\nAttack Bonus"
                miscLabel.font = UIFont.systemFont(ofSize: 10)
                miscLabel.textAlignment = NSTextAlignment.center
                miscLabel.numberOfLines = 2
                miscLabel.tag = 700 + (indexPath.row * 100) + 14
                scrollView.addSubview(miscLabel)
                
                let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:170, width:40, height:30))
                miscField.text = String(weapon.misc_bonus)
                miscField.textAlignment = NSTextAlignment.center
                miscField.layer.borderWidth = 1.0
                miscField.layer.borderColor = UIColor.black.cgColor
                miscField.tag = 700 + (indexPath.row * 100) + 15
                scrollView.addSubview(miscField)
                
                let profWithLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 205, width: 90, height: 40))
                profWithLabel.text = "Proficient\nWith\nWeapon"
                profWithLabel.font = UIFont.systemFont(ofSize: 10)
                profWithLabel.textAlignment = NSTextAlignment.center
                profWithLabel.numberOfLines = 3
                profWithLabel.tag = 700 + (indexPath.row * 100) + 16
                scrollView.addSubview(profWithLabel)
                
                let profWithSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-115, y: 245, width:51, height:31))
                if (Character.Selected.weapon_proficiencies?.lowercased().contains(weapon.category!))! {
                    profWithSwitch.isOn = true
                }
                else {
                    profWithSwitch.isOn = false
                }
                profWithSwitch.tag = 700 + (indexPath.row * 100) + 17
                scrollView.addSubview(profWithSwitch)
                
                let abilityDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 205, width: 90, height: 40))
                abilityDmgLabel.text = "Ability\nMod to\nDamage"
                abilityDmgLabel.font = UIFont.systemFont(ofSize: 10)
                abilityDmgLabel.textAlignment = NSTextAlignment.center
                abilityDmgLabel.numberOfLines = 3
                abilityDmgLabel.tag = 700 + (indexPath.row * 100) + 18
                scrollView.addSubview(abilityDmgLabel)
                
                let abilityDmgSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-50, y: 245, width:51, height:31))
                abilityDmgSwitch.isOn = damage.mod_damage
                
                abilityDmgSwitch.tag = 1109
                scrollView.addSubview(abilityDmgSwitch)
                
                let magicDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 205, width: 90, height: 40))
                magicDmgLabel.text = "Magic Item\nDamage\nBonus"
                magicDmgLabel.font = UIFont.systemFont(ofSize: 10)
                magicDmgLabel.textAlignment = NSTextAlignment.center
                magicDmgLabel.numberOfLines = 3
                magicDmgLabel.tag = 700 + (indexPath.row * 100) + 19
                scrollView.addSubview(magicDmgLabel)
                
                let magicDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:245, width:40, height:30))
                magicDmgField.text = String(damage.magic_bonus)
                magicDmgField.textAlignment = NSTextAlignment.center
                magicDmgField.layer.borderWidth = 1.0
                magicDmgField.layer.borderColor = UIColor.black.cgColor
                magicDmgField.tag = 700 + (indexPath.row * 100) + 20
                scrollView.addSubview(magicDmgField)
                
                let miscDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 205, width: 90, height: 40))
                miscDmgLabel.text = "Misc\nDamage\nBonus"
                miscDmgLabel.font = UIFont.systemFont(ofSize: 10)
                miscDmgLabel.textAlignment = NSTextAlignment.center
                miscDmgLabel.numberOfLines = 3
                miscDmgLabel.tag = 700 + (indexPath.row * 100) + 21
                scrollView.addSubview(miscDmgLabel)
                
                let miscDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:245, width:40, height:30))
                miscDmgField.text = String(damage.misc_bonus)
                miscDmgField.textAlignment = NSTextAlignment.center
                miscDmgField.layer.borderWidth = 1.0
                miscDmgField.layer.borderColor = UIColor.black.cgColor
                miscDmgField.tag = 700 + (indexPath.row * 100) + 22
                scrollView.addSubview(miscDmgField)
                
                let weaponDmgLabel = UILabel.init(frame: CGRect.init(x: 10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
                weaponDmgLabel.text = "Weapon Damage Die"
                weaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
                weaponDmgLabel.textAlignment = NSTextAlignment.center
                weaponDmgLabel.tag = 700 + (indexPath.row * 100) + 23
                scrollView.addSubview(weaponDmgLabel)
                
                let extraWeaponDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
                extraWeaponDmgLabel.text = "Extra Damage Die"
                extraWeaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
                extraWeaponDmgLabel.textAlignment = NSTextAlignment.center
                extraWeaponDmgLabel.tag = 700 + (indexPath.row * 100) + 24
                scrollView.addSubview(extraWeaponDmgLabel)
                
                let weaponDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:320, width:40, height:30))
                weaponDieAmount.text = String(damage.die_number)
                weaponDieAmount.textAlignment = NSTextAlignment.center
                weaponDieAmount.layer.borderWidth = 1.0
                weaponDieAmount.layer.borderColor = UIColor.black.cgColor
                weaponDieAmount.tag = 700 + (indexPath.row * 100) + 25
                scrollView.addSubview(weaponDieAmount)
                
                let weaponD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:320, width:20, height:30))
                weaponD.text = "d"
                weaponD.textAlignment = NSTextAlignment.center
                weaponD.tag = 700 + (indexPath.row * 100) + 26
                scrollView.addSubview(weaponD)
                
                let weaponDie = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-60, y:320, width:40, height:30))
                weaponDie.text = String(damage.die_type)
                weaponDie.textAlignment = NSTextAlignment.center
                weaponDie.layer.borderWidth = 1.0
                weaponDie.layer.borderColor = UIColor.black.cgColor
                weaponDie.tag = 700 + (indexPath.row * 100) + 27
                scrollView.addSubview(weaponDie)
                
                let extraDieSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2+40, y: 305, width:51, height:31))
                extraDieSwitch.isOn = damage.extra_die
                extraDieSwitch.tag = 700 + (indexPath.row * 100) + 28
                scrollView.addSubview(extraDieSwitch)
                
                let extraDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+20, y:340, width:40, height:30))
                extraDieAmount.text = String(damage.extra_die_number)
                extraDieAmount.textAlignment = NSTextAlignment.center
                extraDieAmount.layer.borderWidth = 1.0
                extraDieAmount.layer.borderColor = UIColor.black.cgColor
                extraDieAmount.tag = 700 + (indexPath.row * 100) + 29
                scrollView.addSubview(extraDieAmount)
                
                let extraD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+60, y:340, width:20, height:30))
                extraD.text = "d"
                extraD.textAlignment = NSTextAlignment.center
                extraD.tag = 700 + (indexPath.row * 100) + 30
                scrollView.addSubview(extraD)
                
                let extraDieField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:340, width:40, height:30))
                extraDieField.text = String(damage.extra_die_type)
                extraDieField.textAlignment = NSTextAlignment.center
                extraDieField.layer.borderWidth = 1.0
                extraDieField.layer.borderColor = UIColor.black.cgColor
                extraDieField.tag = 700 + (indexPath.row * 100) + 31
                scrollView.addSubview(extraDieField)
                
                scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 380)
                
                view.addSubview(tempView)
            }
            else {
                
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Types.DamageStrings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //appDelegate.character. = damageTypes[row] as? String
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont.systemFont(ofSize: 17)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = Types.DamageStrings[row]
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width-20
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 21.0
    }
    
    @IBAction func typePickerViewSelected(sender: AnyObject) {
        
    }
}

