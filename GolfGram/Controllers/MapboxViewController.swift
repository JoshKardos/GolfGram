//
//  MapboxViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 1/15/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Mapbox

class MapboxViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let mapView = MGLMapView(frame: view.bounds)
		mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		// Set the map’s center coordinate and zoom level.
		mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
		view.addSubview(mapView)
	}
}
