//
//  ObserverRTSViewController.swift
//  Graviton
//
//  Created by Sihao Lu on 7/13/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import UIKit
import Orbits
import MathUtil
import XLPagerTabStrip

class ObserverRTSViewController: UITableViewController {

    private var rtsSubscriptionIdentifier: SubscriptionUUID!
    lazy var observerInfo = ObserverInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(handleRefresh(target:)), for: .valueChanged)
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to reload RTS info")
            return refreshControl
        }()
        self.clearsSelectionOnViewWillAppear = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "informationCell")
        rtsSubscriptionIdentifier = RiseTransitSetManager.default.subscribe(didLoad: updateRiseTransitSetInfo)
        refreshControl?.addTarget(self, action: #selector(handleRefresh(target:)), for: .valueChanged)
        refreshControl?.beginRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl?.beginRefreshing()
        handleRefresh(target: self.refreshControl!)
    }

    deinit {
        RiseTransitSetManager.default.unsubscribe(rtsSubscriptionIdentifier)
    }

    @objc func handleRefresh(target: UIRefreshControl) {
        RiseTransitSetManager.default.fetch()
    }

    func updateRiseTransitSetInfo(_ rtsInfo: [Naif: RiseTransitSetElevation]) {
        observerInfo.updateRtsInfo(rtsInfo)
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ObserverInfo.sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ObserverInfo.section(atIndex: section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observerInfo.riseTransitSetElevationInfo(forSection: section)?.tableRows.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rows = observerInfo.riseTransitSetElevationInfo(forSection: indexPath.section)!.tableRows
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath)
        cell.textLabel?.text = rows[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
}

// MARK: - Info provider

extension ObserverRTSViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Rise-Transit-Set"
    }
}