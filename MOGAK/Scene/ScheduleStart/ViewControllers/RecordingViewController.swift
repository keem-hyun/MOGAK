//
//  RecodingViewController.swift
//  MOGAK
//
//  Created by 안세훈 on 2023/08/15.
//

import UIKit
import SnapKit
import Then
import BSImagePicker

protocol RecordingVCdelegate {
    func moveRecordingVC()
}

class RecordingViewController : UIViewController, UIScrollViewDelegate{
    
    //MARK: - Properties
    private lazy var popButton : UIButton = {
        let popButton = UIButton()
        popButton.backgroundColor = .clear //백그라운드색
        popButton.setImage(UIImage(named: "backButton_black"), for: .normal)
        popButton.addTarget(self, action: #selector(backhome), for: .touchUpInside)
        return popButton
    }()
    
    private lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "조각 내용 기록"
        titleLabel.textColor = UIColor(hex: "24252E")
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        return titleLabel
    }()
    
    //MARK: - ScrollView
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    //MARK: - contentView
    private lazy var contentView : UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    //MARK: - start
    
    private lazy var startView : UIView = {
        let startView = UIView()
        startView.layer.cornerRadius = 10
        startView.layer.shadowColor = UIColor(red: 0.749, green: 0.765, blue: 0.831, alpha: 0.5).cgColor
        startView.layer.shadowOffset = CGSize(width: 0, height: 2)
        startView.layer.shadowOpacity = 1
        startView.layer.shadowRadius = 10
        startView.backgroundColor = .white
        return startView
    }()
    
    private lazy var startLabel : UILabel = {
        let startLabel = UILabel()
        startLabel.text = "시작"
        startLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        startLabel.textColor = UIColor(red: 0.431, green: 0.441, blue: 0.483, alpha: 1)
        return startLabel
    }()
    
    private lazy var startTimeLabel : UILabel = {
        let startTimeLabel = UILabel()
        startTimeLabel.text = "12:02"
        startTimeLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        startTimeLabel.textColor = UIColor(red: 0.142, green: 0.147, blue: 0.179, alpha: 1)
        return startTimeLabel
    }()
    
    //MARK: - end
    
    private lazy var endView : UIView = {
        let endView = UIView()
        endView.layer.cornerRadius = 10
        endView.layer.shadowColor = UIColor(red: 0.749, green: 0.765, blue: 0.831, alpha: 0.5).cgColor
        endView.layer.shadowOffset = CGSize(width: 0, height: 2)
        endView.layer.shadowOpacity = 1
        endView.layer.shadowRadius = 10
        endView.backgroundColor = .white
        return endView
    }()
    
    private lazy var endLabel : UILabel = {
        let endLabel = UILabel()
        endLabel.text = "종료"
        endLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        endLabel.textColor = UIColor(red: 0.431, green: 0.441, blue: 0.483, alpha: 1)
        return endLabel
    }()
    
    private lazy var endTimeLabel : UILabel = {
        let endTimeLabel = UILabel()
        endTimeLabel.text = "12:02"
        endTimeLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        endTimeLabel.textColor = UIColor(red: 0.142, green: 0.147, blue: 0.179, alpha: 1)
        return endTimeLabel
    }()
    
    
    
    //MARK: - cellView
    private lazy var cellView : UIView = {
        let cellView = UIView()
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowColor = UIColor(red: 0.749, green: 0.765, blue: 0.831, alpha: 0.5).cgColor
        cellView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cellView.layer.shadowOpacity = 1
        cellView.layer.shadowRadius = 10
        cellView.backgroundColor = .white
        return cellView
    }()
    
    let cellViewImage : UIImageView = {
        let cellViewImage = UIImageView()
        cellViewImage.backgroundColor = .clear
        cellViewImage.image = UIImage(named: "ScheduleVariant")
        return cellViewImage
    }()
    
    var cellLabel : UILabel = {
        let cellLabel = UILabel()
        cellLabel.text = "기획 아티클 읽기"
        cellLabel.textColor = UIColor(red: 0.142, green: 0.147, blue: 0.179, alpha: 1)
        cellLabel.font = UIFont(name: "PretendardVariable-Medium", size: 16)
        return cellLabel
    }()
    
    var celltimeLabel : UILabel = {
        let celltimeLabel = UILabel()
        celltimeLabel.text = "1시간 20분"
        celltimeLabel.textColor = UIColor(red: 0.278, green: 0.373, blue: 0.992, alpha: 1)
        celltimeLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        return celltimeLabel
    }()
    
    private let textViewLabel : UILabel = {
        let textViewLabel = UILabel()
        textViewLabel.text = "글을 작성해주세요"
        textViewLabel.font = UIFont(name: "PretendardVariable-Medium", size: 16)
        textViewLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return textViewLabel
    }()
    
    private lazy var textbackgroundView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(red: 0.947, green: 0.953, blue: 0.979, alpha: 1)
        return view
    }()
    
    private lazy var textView : UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    //MARK: - scrollview
    private var scrollview : UIScrollView = {
        let scrollview = UIScrollView()
        return scrollview
    }()
    
    //MARK: - galleryCollectioview
    private lazy var galleryCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .init(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: flowLayout)
        view.isScrollEnabled = true
        view.delegate = self
        view.dataSource = self
        view.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryTableViewCell")
        view.backgroundColor = .red
        return view
    }()
    
//    let layout = UICollectionViewFlowLayout()
//    let sectionSpacing : CGFloat = 20
//    let itemSpacing : CGFloat = 8
//    let width: CGFloat = UIScreen.main.bounds.width - (itemSpacing * (rowCount-1)) - (sectionSpacing * 2)
//    let itemWidth: CGFloat = width / rowCount
//    layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
//
//    // 스크롤 방향 설정
//    layout.scrollDirection = .vertical
//
//    // Section간 간격 설정
//    layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
//
//    // item간 간격 설정
//    layout.minimumLineSpacing = itemSpacing        // 최소 줄간 간격 (수직 간격)
//    layout.minimumInteritemSpacing = itemSpacing   // 최소 행간 간격 (수평 간격)
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        self.scrollView.delegate = self
        self.galleryCollectionView.delegate = self
        //textView.delegate = self
        setUI()
    }
    
    func setUI(){
        [popButton,titleLabel].forEach{view.addSubview($0)}
        
        contentView.addSubviews(startView,startLabel,startTimeLabel,endView,endTimeLabel,endLabel,textView,textbackgroundView,cellView,cellLabel,cellViewImage,cellLabel,textViewLabel,celltimeLabel,galleryCollectionView)
        
        popButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(popButton)
        }
        
        scrollView.snp.makeConstraints{
            $0.top.equalTo(self.titleLabel.snp.bottom)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            
        }
        
        contentView.snp.makeConstraints{
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.greaterThanOrEqualTo(scrollView.snp.height).priority(.low)
            $0.width.equalTo(scrollView.snp.width)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(915)
            
        }
        
        startView.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).offset(40)
            $0.height.equalTo(56)
            $0.leading.equalTo(contentView).inset(20)
            $0.trailing.equalTo(contentView).inset(200)
        }
        
        startLabel.snp.makeConstraints{
            $0.centerX.centerY.equalTo(startView)
            $0.leading.equalTo(startView.snp.leading).offset(16)
        }
        
        startTimeLabel.snp.makeConstraints{
            $0.centerY.equalTo(startView)
            $0.trailing.equalTo(startView.snp.trailing).offset(-16)
        }
        
        endView.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).offset(40)
            $0.height.equalTo(56)
            $0.trailing.equalTo(contentView).inset(20)
            $0.leading.equalTo(contentView).inset(200)
        }
        
        endLabel.snp.makeConstraints{
            $0.centerX.centerY.equalTo(endView)
            $0.leading.equalTo(endView.snp.leading).offset(16)
        }
        
        endTimeLabel.snp.makeConstraints{
            $0.centerY.equalTo(endLabel)
            $0.trailing.equalTo(endView.snp.trailing).offset(-16)
        }
        
        cellView.snp.makeConstraints{
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.top.equalTo(startView.snp.bottom).offset(12)
            $0.height.equalTo(70)
        }
        
        cellViewImage.snp.makeConstraints{
            $0.centerY.equalTo(cellView)
            $0.leading.equalTo(cellView.snp.leading).offset(16)
        }
        
        textViewLabel.snp.makeConstraints{
            $0.top.equalTo(cellView.snp.bottom).offset(32)
            $0.leading.equalTo(contentView).inset(25)
        }
        
        textbackgroundView.snp.makeConstraints{
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.top.equalTo(textViewLabel.snp.bottom).offset(12)
            $0.bottom.equalTo(textView.snp.bottom).offset(16)
            $0.height.equalTo(411)
            
        }
        
        cellLabel.snp.makeConstraints{
            $0.top.equalTo(cellView.snp.top).offset(13)
            $0.leading.equalTo(cellViewImage.snp.trailing).offset(12)
        }
        
        celltimeLabel.snp.makeConstraints{
            $0.leading.equalTo(cellLabel)
            $0.bottom.equalTo(cellView.snp.bottom).offset(-13)
        }
        
        textView.snp.makeConstraints{
            $0.top.equalTo(textbackgroundView.snp.top).offset(16)
            $0.leading.trailing.equalTo(textbackgroundView).inset(16)
        }
        
        galleryCollectionView.snp.makeConstraints{
            $0.top.equalTo(textbackgroundView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)

            $0.width.equalToSuperview()
        }
        
    }
    
    //MARK: - @objc func
    @objc func backhome(){
        self.dismiss(animated: true)
        print("back home")
    }
}
    //MARK: - exteinson CollectioView
extension RecordingViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 4
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as? GalleryCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // 셀의 크기를 여기에서 설정하세요.
            return CGSize(width: 50, height: collectionView.frame.height)
        }
        
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("\(indexPath.section), \(indexPath.row)")
        }
    
}

//extension RecordingViewController : UITextViewDelegate{
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        guard textView.textColor == UIColor(red: 0.5, green: 0.518, blue: 0.592, alpha: 1) else {return}
//        textView.text = nil
//        textView.textColor = .label
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "오늘 당신의 조각은 어떠셨나요?\n느낀 점이나 기억에 남는 것을 공유해보세요"
//            textView.textColor = UIColor(red: 0.5, green: 0.518, blue: 0.592, alpha: 1)
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if textView.isFirstResponder && !textView.text.isEmpty {
//            textView.resignFirstResponder()
//        }
//    }
//
//    // 리턴 키 입력 시 키보드 내림
//    func textViewShouldReturn(_ textView: UITextView) -> Bool {
//        textView.resignFirstResponder()
//        return true
//    }
//}









//Preview code
#if DEBUG
import SwiftUI
struct RecordingViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        RecordingViewController()
    }
}
@available(iOS 13.0, *)
struct RecordingViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                RecordingViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif



