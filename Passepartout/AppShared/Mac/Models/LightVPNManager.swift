//
//  LightVPNManager.swift
//  Passepartout
//
//  Created by Davide De Rosa on 7/3/22.
//  Copyright (c) 2022 Davide De Rosa. All rights reserved.
//
//  https://github.com/passepartoutvpn
//
//  This file is part of Passepartout.
//
//  Passepartout is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Passepartout is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Passepartout.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

@objc(LightVPNStatus)
public enum LightVPNStatus: Int {
    case connecting
    
    case connected
    
    case disconnecting
    
    case disconnected
}

@objc
public protocol LightVPNManager {
    var isEnabled: Bool { get }

    var vpnStatus: LightVPNStatus { get }
    
    func connect(with profileId: UUID)
    
    func connect(with profileId: UUID, to serverId: String)
    
    func toggle()
    
    func reconnect()
    
    var delegate: LightVPNManagerDelegate? { get set }
}

@objc
public protocol LightVPNManagerDelegate {
    func didUpdateState(isEnabled: Bool, vpnStatus: LightVPNStatus)
}
