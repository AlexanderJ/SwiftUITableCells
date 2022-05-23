//
//  ViewController.swift
//  SwiftUITableCells
//
//  Created by Alexander Jährling on 12.05.22.
//

import UIKit
import SwiftUI

//let UseMyHostingCell = true

struct Item {
    var title: String
    var subtitle: String
}

#if UseMyHostingCell
class HostingCell: UITableViewCell, ObservableObject {
    static var count = 1

    @Published var text: String = ""
    @Published var subtitle: String = ""
    @Published var label: String = "instance #\(HostingCell.count)"
//    var size = CGSize()

    lazy var hostingController = UIHostingController(rootView: TableCellView(hostingCell: self))

    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        HostingCell.count += 1
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        //_text.projectedValue.sink { _ in self.invalidateIntrinsicContentSize() }
//        print("1", hostingController.preferredContentSize)
//        print("2", hostingController.sizeThatFits(in: CGSize(width: 375, height: 0)))
//        size = hostingController.sizeThatFits(in: CGSize(width: 375, height: 0))
        let view = hostingController.view!
//        let view = UILabel()      // this works fine
//        view.text = label
        view.backgroundColor = UIColor.green
        //self.control
        
//        print("preferredContentSize", hostingController.preferredContentSize, size)

        view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            view.topAnchor.constraint(equalTo: contentView.topAnchor),
//            view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            view.rightAnchor.constraint(equalTo: contentView.rightAnchor)
//        ])
//        NSLayoutConstraint.activate([
//            view.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
//            view.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
//            view.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
//            view.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor)
//            //view.heightAnchor.constraint(equalToConstant: 100)
//        ])
//        NSLayoutConstraint.activate([
//            view.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            view.heightAnchor.constraint(equalTo: contentView.heightAnchor)])
//        view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            view.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            view.heightAnchor.constraint(equalTo: contentView.heightAnchor),
//            view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
    }

    required init?(coder: NSCoder) {
        fatalError("unexpected")
    }
    
//    deinit {}
//
//    override var frame: CGRect {
//        get {
//            print("get", super.frame, size)
//            return CGRect(origin: super.frame.origin, size: size)
//        }
//        set {
//            print("set", newValue)
//            super.frame = newValue
//        }
//    }
//
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return hostingController.sizeThatFits(in: size)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        hostingController.view.frame.size = self.sizeThatFits(bounds.size)
//    }
//
//    override var intrinsicContentSize: CGSize {
//        print("intrinsicContentSize", super.intrinsicContentSize)
//        return super.intrinsicContentSize
//    }
//
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//        //super.control
//        print("didMoveToSuperview", superview, frame)
//    }
    
    func setParentController(parent: UIViewController) {
        let view = hostingController.view!
        if parent != hostingController.parent {
            parent.addChild(hostingController)
            view.invalidateIntrinsicContentSize()

            contentView.addSubview(view)
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
//                view.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
//                view.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
//                view.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
//                view.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor)
                //view.heightAnchor.constraint(equalToConstant: 100)
            ])

            hostingController.didMove(toParent: parent)
        }
        else {
            view.invalidateIntrinsicContentSize()
        }
    }
}
#else
// this version is based on
// https://noahgilmore.com/blog/swiftui-self-sizing-cells/
final class HostingCell<Content: View>: UITableViewCell {
    private let hostingController = UIHostingController<Content?>(rootView: nil)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hostingController.view.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(rootView: Content, parentController: UIViewController) {
        self.hostingController.rootView = rootView
        self.hostingController.view.invalidateIntrinsicContentSize()

        let requiresControllerMove = hostingController.parent != parentController
        if requiresControllerMove {
            parentController.addChild(hostingController)
        }

        if !self.contentView.subviews.contains(hostingController.view) {
            self.contentView.addSubview(hostingController.view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
        }

        if requiresControllerMove {
            hostingController.didMove(toParent: parentController)
        }
    }
}
#endif

class ViewController: UITableViewController {
    var data = (1...60).map { Item(title: "Title \($0) \(String(repeating: "bla ", count: $0))", subtitle: "Subtitle \($0)") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if UseMyHostingCell
        tableView.register(HostingCell.self, forCellReuseIdentifier: "host")
        #else
        tableView.register(HostingCell<TableCellView>.self, forCellReuseIdentifier: "host")
        #endif
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        #if UseMyHostingCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "host", for: indexPath) as! HostingCell
        //cell.frame.size = CGSize(width: 375.0, height: 95)
        cell.text = data[indexPath.row].title
        cell.subtitle = data[indexPath.row].subtitle
        cell.setParentController(parent: self)
        //cell.label = data[indexPath.row].title + ":-----:" + data[indexPath.row].subtitle
        #else
        let cell = tableView.dequeueReusableCell(withIdentifier: "host", for: indexPath) as! HostingCell<TableCellView>
        let cellData = CellData()
        cellData.text = data[indexPath.row].title
        cellData.subtitle = data[indexPath.row].subtitle
        cell.set(rootView: TableCellView(hostingCell: cellData), parentController: self)
        #endif
        return cell
    }
}

