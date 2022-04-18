//
//  OrganizerView+Profiles.swift
//  Passepartout
//
//  Created by Davide De Rosa on 4/2/22.
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

import SwiftUI
import PassepartoutCore

extension OrganizerView {
    struct ProfilesSection: View {
        @ObservedObject private var appManager: AppManager

        @ObservedObject private var profileManager: ProfileManager

        @ObservedObject private var providerManager: ProviderManager

        // just to observe changes in profiles eligibility
        @ObservedObject private var productManager: ProductManager

        private let addProfileMenuBindings: AddProfileMenu.Bindings

        @State private var isFirstLaunch = true
        
        @State private var selectedProfileId: UUID?
        
        init(addProfileMenuBindings: AddProfileMenu.Bindings) {
            appManager = .shared
            profileManager = .shared
            providerManager = .shared
            productManager = .shared
            self.addProfileMenuBindings = addProfileMenuBindings
        }

        var body: some View {
            debugChanges()
            return Section {
                ReloadingContent(
                    observing: profileManager.headers,
                    equality: {
                        Set($0) == Set($1)
                    }
                ) {
                    if !$0.isEmpty {
                        ForEach($0.sorted(), content: navigationLink(forHeader:))
                            .onAppear(perform: selectActiveProfile)
                    } else {
                        AddProfileMenu(
                            withImportedURLs: false,
                            bindings: addProfileMenuBindings
                        )
                    }
                }
            }.onAppear(perform: performMigrationsIfNeeded)

            // detect deletion
            .onChange(of: profileManager.headers, perform: dismissSelectionIfDeleted)

            // from AddProfileView
            .onReceive(profileManager.didCreateProfile) {
                selectedProfileId = $0.id
            }
        }

        private func navigationLink(forHeader header: Profile.Header) -> some View {
            NavigationLink(tag: header.id, selection: $selectedProfileId) {
                ProfileView(header: header)
            } label: {
                if profileManager.isActiveProfile(header.id) {
                    ActiveProfileHeaderRow(header: header)
                } else {
                    ProfileHeaderRow(header: header)
                }
            }
        }
    }
}

extension OrganizerView.ProfilesSection {
    struct ActiveProfileHeaderRow: View {
        @ObservedObject private var currentVPNState: VPNManager.ObservableState

        private let header: Profile.Header
        
        init(header: Profile.Header) {
            currentVPNState = .shared
            self.header = header
        }
        
        var body: some View {
            debugChanges()
            return ProfileHeaderRow(header: header)
                .withTrailingText(statusDescription)
        }

        private var statusDescription: String {
            return currentVPNState.localizedStatusDescription(
                withErrors: false,
                withDataCount: false
            )
        }
    }
}

extension OrganizerView.ProfilesSection {
    private func selectActiveProfile() {
        guard isFirstLaunch else {
            return
        }
        isFirstLaunch = false

        // do not push profile if:
        //
        // - an alert is active, as it would break navigation
        // - on iPad, as it's already shown
        //
        if addProfileMenuBindings.alertType == nil,
           themeIdiom != .pad,
           let activeProfileId = profileManager.activeHeader?.id {

            selectedProfileId = activeProfileId
        }
    }

    private func performMigrationsIfNeeded() {
        Task {
            await appManager.doMigrations(profileManager)
        }
    }

    private func dismissSelectionIfDeleted(headers: [Profile.Header]) {
        if let selectedProfileId = selectedProfileId,
           !profileManager.isExistingProfile(withId: selectedProfileId) {

            self.selectedProfileId = nil
        }
    }
}
