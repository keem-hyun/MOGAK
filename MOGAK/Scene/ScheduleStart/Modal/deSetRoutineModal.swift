//
//  deSetRoutineModal.swift
//  MOGAK
//
//  Created by 안세훈 on 12/10/23.
//


import SnapKit
import Then

class deSetRoutineModal : UIViewController,UISheetPresentationControllerDelegate{
    
    var pushClosure : (() -> ())?
    
     lazy var jogaktitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(hex: "24252E")
        return label
    }()
    
     let subtitleLabel : UILabel = {
        let label = UILabel()
         label.text = "이 조각은 루틴으로 지정되지 않았어요\n오늘 추가한 조각을 꾸준히 해볼까요?"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: "Pretendard", size: 14)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return label
    }()
    
    private lazy var stopButton : UIButton = {
        let stopButton = UIButton()
        stopButton.setTitle("루틴 지정하기",for : .normal) //타이틀
        stopButton.setTitleColor(.white, for : .normal) //글자 색
        stopButton.backgroundColor = UIColor(hex: "475FFD") //백그라운드색
        stopButton.layer.cornerRadius = 10 //둥글기
        stopButton.addTarget(self, action: #selector(ScheduleStop), for: .touchUpInside)
        return stopButton
    }()
    
    private lazy var keepGoButton : UIButton = {
        let keepGoButton = UIButton()
        keepGoButton.setTitle("삭제하기",for : .normal) //타이틀
        keepGoButton.setTitleColor(UIColor(hex: "475FFD"), for: .normal) //글자 색
        keepGoButton.backgroundColor = UIColor(hex: "#E8EBFE") //백그라운드색
        keepGoButton.layer.cornerRadius = 10 //둥글기
        keepGoButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        return keepGoButton
    }()
    
    let CellVC = ScheduleTableViewCell()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        
    }
    
    //MARK: - setUI
    func setUI(){
        [jogaktitleLabel,subtitleLabel,stopButton,keepGoButton].forEach{view.addSubview($0)}
        jogaktitleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(39)
        }
        
        subtitleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(jogaktitleLabel.snp.bottom).offset(12)
        }
        
        stopButton.snp.makeConstraints{ //루틴 지정하기
            $0.width.equalTo(170)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.equalTo(keepGoButton.snp.trailing).offset(10)
        }
        
        keepGoButton.snp.makeConstraints{ //삭제하기
            $0.width.equalTo(170)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().multipliedBy(0.5).offset(-5)
        }
    }
    //MARK: - @objc func
    @objc func ScheduleStop(){
        self.dismiss(animated: true){ [weak self] in
            guard let self = self else { return }
            let jogakEditViewController = JogakEditViewController()
            if let navigationController = self.navigationController {
                navigationController.pushViewController(jogakEditViewController, animated: true)
            } else {
                // 만약 navigationController가 없는 경우에 대한 처리
                // 예를 들어, self가 UINavigationController의 자식 뷰컨트롤러인 경우
                // 또는 self가 navigationController에 포함되어 있지 않은 경우
                // 그냥 present로 표시하거나 다른 처리를 해야 함
                if let window = UIApplication.shared.windows.first {
                                window.rootViewController?.present(jogakEditViewController, animated: true, completion: nil)
                            }
                print("else")
            }
        }
        
    }
    
    @objc func dismissModal(){
        self.dismiss(animated: true){
            
            
        }
        
    }
    
    
}











//Preview code
#if DEBUG
import SwiftUI
struct deSetRoutineModalVCRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        deSetRoutineModal()
    }
}
@available(iOS 13.0, *)
struct deSetRoutineModalRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                deSetRoutineModalVCRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 15pro"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
