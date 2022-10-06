/*
 ПРИ НАЖАТИИ НА ЛЮБУЮ ЦИФРУ ТЕКСТ НА КНОПКЕ СБРОСА БУДЕТ С, ПРИ СБРОСЕ  -> будет АС.
 НЕ ПОЛУЧИЛОСЬ СДЕЛАТЬ У НИХ НОРМАЛЬНЙ РАЗМЕР ТЕКСТА.
 НЕ УСПЕЛ СДЕЛАТЬ ВЫЧИСЛЕНИЕ РАЗЛИЧНЫХ ДЕЙСТВИЙ ОДНОВРЕМЕННО ( НАПРИМЕР  2+2-2)
 ЕСЛИ РЕЗУЛЬТАТ БОЛЬШЕ 9 ЦИФР  -->  Ошибка , В АЙФОНЕ РЕЗУЛЬТАТ БУДЕТ  3.5e39 ( не знаю как сделать также, поэтому выдаю ошибку)                  ИЗ-ЗА ЭТОГО БЫВАЮТ БАГИ */
import UIKit
class ViewController: UIViewController {
    
    // MARK: - Private properties
    private var action : ActionType = .nothing
    private var intChecker : Int = 0
    private var result : Double = 0
    private var currentNumber : Double = 0
    private var currentNumberStr : String = "0"
    private var firstNumber : Double = 0
    
    private var isFirstDone = true
    private var isDot = false
    
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
        currentNumberStr.remove(at: currentNumberStr.index(before: currentNumberStr.endIndex))
        if currentNumberStr == "" {currentNumberStr = "0"}
        mainLabel.text = currentNumberStr
    }
    
    private func currentToFirst(){
        guard let str = Double(currentNumberStr) else {return}
        firstNumber = str
        setCurrNumToZero()
    }
    
    private func intResultToLabel(){
        var checkerString = String(intChecker)
        if checkerString.count > 9{
            if checkerString.count>14{
                checkerString = "Too many digits"
            } else{
                mainLabel.font = mainLabel.font.withSize(50)
            }
        }
        mainLabel.text = checkerString
    }
    private func doubleResultToLabel(){
        var checkerString = String(result)
        checkerString = checkerString.replacingOccurrences(of: ".", with: ",")
        if checkerString.count > 9{
            if checkerString.count>14{
                checkerString = "Too many digits"
            } else{
                mainLabel.font = mainLabel.font.withSize(50)
            }
        }
        mainLabel.text = checkerString
        
    }
    
    private func tapNumber(char :Int){
        currentNumberStr += String(char)
        mainLabel.text = currentNumberStr
    }
    
    private func intOrDouble(){
        intChecker = Int(result)
        if Double(intChecker) == result {
            intResultToLabel()
        } else {doubleResultToLabel()}
    }
    
    private func setCurrNumToZero(){
        currentNumber = 0
        currentNumberStr = ""
    }
    
    private func intOrDoubleForFirstNum(){
        intChecker = Int(firstNumber)
        if Double(intChecker) == firstNumber {
            intResultToLabel()
        } else { doubleFirstNumToLabel() }
    }
    
    private func doubleFirstNumToLabel() {
        var checkerString = String(firstNumber)
        checkerString = checkerString.replacingOccurrences(of: ".", with: ",")
        mainLabel.text = checkerString
    }
    
    private func clearEverything(){
        result = 0
        currentNumber = 0
        currentNumberStr = "0"
        isFirstDone = true
        isDot = false
        mainLabel.font = mainLabel.font.withSize(73)
    }
    
    // MARK: - IBActions
    @IBAction func digitButtons(_ sender: UIButton){
        if currentNumberStr == "0" { currentNumberStr = ""}
        if currentNumberStr.count == 9{ return }
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
            } else {
                if let str = Int(currentNumberStr) {
                    currentNumberStr = String(-str)
                    currentNumber = Double(str) * -1
                } else
                if let str = Double(currentNumberStr) {
                    currentNumberStr = String(-str)
                    currentNumber = str * -1
                }
                let replaced = currentNumberStr.replacingOccurrences(of: ".", with: ",")
                mainLabel.text = replaced
            }
        case 3:
            guard let str = Double(currentNumberStr) else {return}
            currentNumber = round((str/100) * 100000000)/100000000
            currentNumberStr = String(currentNumber)
            let replaced = currentNumberStr.replacingOccurrences(of: ".", with: ",")
            mainLabel.text = replaced
        default: return
        }
    }
    
    @IBAction func actionButtons(_ sender: UIButton) {
        currentNumberStr = currentNumberStr.replacingOccurrences(of: ",", with: ".")
        switch sender.tag % 20 {
        case 1:
            action = .divide
            guard let str = Double(currentNumberStr) else {return}
            if isFirstDone == true{ firstNumber = str
                isFirstDone = false
            } else {
                firstNumber /= str
            }
            setCurrNumToZero()
            intOrDoubleForFirstNum()
        case 2:
            action = .multiply
            guard let str = Double(currentNumberStr) else {return}
            if isFirstDone == true{ firstNumber = str
                isFirstDone = false
            } else
            {
                firstNumber *= str
            }
            setCurrNumToZero()
            intOrDoubleForFirstNum()
        case 3:
            action = .minus
            guard let str = Double(currentNumberStr) else {return}
            if isFirstDone == true{ firstNumber = str
                isFirstDone = false
            } else {
                firstNumber -= str
            }
            setCurrNumToZero()
            intOrDoubleForFirstNum()
        case 4:
            action = .plus
            guard let str = Double(currentNumberStr) else {return}
            if isFirstDone == true{ firstNumber = str
                isFirstDone = false
            } else {
                firstNumber += str
                setCurrNumToZero()
            }
            setCurrNumToZero()
            intOrDoubleForFirstNum()
        case 5:
            guard let oneHundredPercentIsDouble = Double(currentNumberStr) else {return}
            switch action {
            case .plus:
                result = firstNumber + oneHundredPercentIsDouble
                intOrDouble()
                
            case .minus:
                result =  firstNumber - oneHundredPercentIsDouble
                firstNumber = result
                intOrDouble()
                
            case .multiply:
                result = firstNumber *  oneHundredPercentIsDouble
                firstNumber = result
                intOrDouble()
                
            case .divide:
                if oneHundredPercentIsDouble == 0 {
                    mainLabel.text = "Ошибка"
                    return
                }
                result = firstNumber /  oneHundredPercentIsDouble
                result = round(result * 10000000000) / 10000000000
                firstNumber = result
                intOrDouble()
                
            case .nothing:
                return
            }
            firstNumber = 0
            currentNumberStr = String(result)
            currentNumber = 0
            action = .nothing
            isFirstDone = true
        default:
            return
        }
    }
    
}

