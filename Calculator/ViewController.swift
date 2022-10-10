/// Программа еще далеко не идеальная, но пофикшено много багов, добавлена экспоненциальная форма и возможность вычисления действий практически любой сложности. Код не успел привести в нормальный вид, может даже есть лишние переменные
import UIKit
class ViewController: UIViewController {
    
    // MARK: - Private properties
    private var action : ActionType = .nothing
    private var intChecker : Int = 0
    private var result : Double = 0
    private var currentNumber : Double = 0
    private var currentNumberStr : String = "0"
    private var firstNumber : Double = 0
    private var secondNumber : Double = 0
    private var thirdNumber : Double = 0
    private var resultToLabel = ""
    
    private var firstAction = ActionType.nothing
    private var secondAction = ActionType.nothing
    private var thirdAction = ActionType.nothing
    
    private var isFirstNumExists = false
    private var isSecondNumExists = false
    private var isThirdNumExists = false
    private var isFinalAction = false
    private var isTapNubmerAfterCompute = false
    private var isDot = false
    private var isLastComputed = false
    private var isActionTapped = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var labelVIew: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet var allButtons: [UIButton]!
    @IBOutlet weak var clearButton: UIButton!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipe(to: labelVIew, with: .left)
        addSwipe(to: labelVIew, with: .right)
        
    }
    override func viewWillLayoutSubviews() {
        view.layoutIfNeeded()
        allButtons.forEach{
            $0.layer.cornerRadius = $0.frame.height / 2
        }
        
    }
    // MARK: - Private methods
    private func addSwipe(to view: UIView, with direction: UISwipeGestureRecognizer.Direction){
        let swipeGesture = UISwipeGestureRecognizer(target:self, action: #selector(deleteDigit))
        swipeGesture.direction = direction
        view.addGestureRecognizer(swipeGesture)
        
    }
    @objc private func deleteDigit(){
        if Int(resultToLabel) != 0{
            resultToLabel.remove(at: resultToLabel.index(before: resultToLabel.endIndex))
            currentNumberStr = resultToLabel
            if resultToLabel == "" {
                resultToLabel = "0"
                currentNumber = 0
                currentNumberStr = "0"
            }
        } else{
            currentNumberStr.remove(at: currentNumberStr.index(before: currentNumberStr.endIndex))
            if currentNumberStr == "" {
                currentNumber = 0
                currentNumberStr = "0"
            }
            currentNumberStr = currentNumberStr.replacingOccurrences(of: ".", with: ",")
            resultToLabel = currentNumberStr
        }
        mainLabel.text = resultToLabel
    }
    
    private func intResultToLabel(){
        var checkerString = String(intChecker)
        if checkerString.count > 9{
            checkerString = intChecker.scientificFormatted
        }
        resultToLabel = checkerString
        setSpacesToLabel()
        
        mainLabel.text = resultToLabel
    }
    
    private func doubleResultToLabel(){
        var checkerString = String(firstNumber)
        if checkerString.count > 9{
            checkerString = firstNumber.scientificFormatted
        }
        checkerString = checkerString.replacingOccurrences(of: ".", with: ",")
        resultToLabel =  checkerString
        mainLabel.text = resultToLabel
        
    }
    
    private func tapNumber(char :Int){
        currentNumberStr += String(char)
        currentNumberStr = currentNumberStr.replacingOccurrences(of: ",", with: ".")
        guard let str = Double(currentNumberStr) else {return}
        currentNumber = str
        currentNumberStr = currentNumberStr.replacingOccurrences(of: ".", with: ",")
        resultToLabel = currentNumberStr
        if  Int(resultToLabel) ==  Int(currentNumber) { setSpacesToLabel() }
        mainLabel.text = resultToLabel
        isActionTapped = false
    }
    
    private func setSpacesToLabel() {
        if (resultToLabel.count > 6) {
            resultToLabel.insert(" ", at: resultToLabel.index(resultToLabel.endIndex, offsetBy: -6))
        }
        if (resultToLabel.count > 3) {
            resultToLabel.insert(" ", at: resultToLabel.index(resultToLabel.endIndex, offsetBy: -3))
        }
    }
    
    private func clearAfterComputing(){
        secondNumber = 0
        thirdNumber = 0
        isThirdNumExists = false
        isFirstNumExists = false
        isSecondNumExists = false
        thirdAction = ActionType.nothing
        secondAction = ActionType.nothing
        isTapNubmerAfterCompute = true
        isActionTapped = false
    }
    private func intOrDouble(){
        intChecker = Int(firstNumber)
        if Double(intChecker) == firstNumber {
            intResultToLabel()
        } else {doubleResultToLabel()}
    }
    
    private func setCurrNumToZero(){
        currentNumber = 0
        currentNumberStr = ""
    }
    
    private func clearEverything(){
        intChecker = 0
        result = 0
        currentNumber = 0
        currentNumberStr = "0"
        firstNumber = 0
        secondNumber = 0
        thirdNumber = 0
        isDot = false
        isFirstNumExists = false
        isSecondNumExists = false
        isThirdNumExists = false
        isLastComputed = false
        isFinalAction = false
    }
    
    func toNewNumber (actionType: ActionType = .nothing) {
        if isActionTapped == true{
            return
        }
        isActionTapped = true
        if (!isFirstNumExists) {
            isFirstNumExists = true
            guard let str = Double(currentNumberStr) else{ return }
            firstNumber = str
            if (actionType != .nothing) {
                firstAction = actionType
            }
            setCurrNumToZero()
            isLastComputed = false
        } else {
            if(!isSecondNumExists) {
                isSecondNumExists = true
                guard let str = Double(currentNumberStr) else{ return }
                secondNumber = str
                if (actionType != .nothing) {
                    secondAction = actionType
                }
                setCurrNumToZero()
                isLastComputed = false
            } else {
                if(!isThirdNumExists) {
                    isThirdNumExists = true
                    guard let str = Double(currentNumberStr) else{ return }
                    thirdNumber = str
                    if (actionType != .nothing) {
                        thirdAction = actionType
                    }
                    setCurrNumToZero()
                    isLastComputed = false
                    
                } else {
                    compute()
                    isThirdNumExists = true
                    thirdNumber = currentNumber
                    if (actionType != .nothing) {
                        thirdAction = actionType
                        
                    }
                    setCurrNumToZero()
                    isLastComputed = false
                }
            }
        }
    }
    
    func compute() {
        let firstActionLP: Bool = (firstAction == .plus || firstAction == .minus)
        let secondActionHP: Bool = (secondAction == .multiply || secondAction == .divide)
        if firstActionLP && secondActionHP {
            computeSecondAction()
            secondAction = thirdAction
            thirdNumber = 0
            thirdAction = .nothing
            isThirdNumExists = false
        } else {
            computeFirstAction()
            secondNumber = thirdNumber
            firstAction = secondAction
            thirdNumber = 0
            secondAction = thirdAction
            isThirdNumExists = false
        }
    }
    
    func computeFirstAction() {
        if (isFirstNumExists && isSecondNumExists) {
            switch firstAction {
            case .plus: do {
                self.firstNumber += secondNumber
            }
            case .minus: do {
                self.firstNumber -= secondNumber
            }
            case .multiply: do {
                self.firstNumber *= secondNumber
            }
            case .divide: do {
                if (self.secondNumber == 0) {
                    mainLabel.text = "Ошибка"
                    return
                }
                self.firstNumber /= secondNumber
            }
            case .nothing: return
            }
        }
        intOrDouble()
    }
    func computeSecondAction() {
        if (isSecondNumExists && isThirdNumExists) {
            switch secondAction {
            case .plus: do {
                self.secondNumber += thirdNumber
            }
            case .minus: do {
                self.secondNumber -= thirdNumber
            }
            case .multiply: do {
                self.secondNumber *= thirdNumber
            }
            case .divide: do {
                if (self.thirdNumber == 0) {
                    mainLabel.text = "Ошибка"
                    return
                }
                self.secondNumber /= thirdNumber
            }
            case .nothing: return
            }
        }
    }
    // MARK: - IBActions
    @IBAction func digitButtons(_ sender: UIButton){
        if currentNumberStr.count >= 9 { return }
        if isTapNubmerAfterCompute == true{
            currentNumberStr = ""
            currentNumber = 0
            isTapNubmerAfterCompute = false
        }
        if currentNumberStr == "0" { currentNumberStr = ""}
        if sender.tag != 10{ tapNumber(char: sender.tag)}
        else{
            currentNumberStr.forEach{
                if $0 == "," { isDot = true}
            }
            if isDot == true {return}
            if currentNumberStr == ""   { currentNumberStr = "0,"}
            else {  currentNumberStr += ","}
            mainLabel.text = currentNumberStr
        }
        clearButton.setTitle("C", for: .normal)
    }
    
    @IBAction func additionalButtons(_ sender: UIButton) {
        currentNumberStr = currentNumberStr.replacingOccurrences(of: ",", with: ".")
        switch sender.tag % 10  {
        case 1:
            setCurrNumToZero()
            clearEverything()
            mainLabel.text = currentNumberStr
            sender.setTitle("AC", for: .normal)
        case 2:
            if currentNumberStr == "0"{
                currentNumberStr = "-0"
                mainLabel.text = currentNumberStr
                return
            }
            intChecker = Int(currentNumber)
            if Double(intChecker) == currentNumber {
                currentNumberStr = String(-intChecker)
                currentNumber = Double(intChecker) * -1
            } else {
                currentNumberStr = String(-currentNumber)
                currentNumber = currentNumber * -1
                currentNumberStr = currentNumberStr.replacingOccurrences(of: ".", with: ",")
            }
            mainLabel.text = currentNumberStr
            
        case 3:
            currentNumber = currentNumber/100
            var checkerString = String(currentNumber)
            if checkerString.count > 9{
                checkerString = currentNumber.scientificFormatted
            }
            checkerString = checkerString.replacingOccurrences(of: ".", with: ",")
            
            mainLabel.text = checkerString
        default: return
        }
    }
    
    @IBAction func actionButtons(_ sender: UIButton) {
        currentNumberStr = currentNumberStr.replacingOccurrences(of: ",", with: ".")
        switch sender.tag % 20 {
        case 1:
            toNewNumber(actionType: .divide)
        case 2:
            toNewNumber(actionType: .multiply)
        case 3:
            toNewNumber(actionType: .minus)
        case 4:
            toNewNumber(actionType: .plus)
        case 5:
            if (mainLabel.text == "Ошибка") { return }
            toNewNumber()
            if (isThirdNumExists) {
                compute()
                isFinalAction = true
            }
            computeFirstAction()
            currentNumber = firstNumber
            currentNumberStr = String(firstNumber)
            clearAfterComputing()
        default:
            return
        }
    }

}
