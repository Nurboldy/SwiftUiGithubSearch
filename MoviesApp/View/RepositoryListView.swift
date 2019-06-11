//
//  RepositoryListView.swift
//  GitHubSearch
//
//  Created by Nurboldy on 6/11/19.
//  Copyright © 2019 Nurboldy. All rights reserved.
//

import SwiftUI

struct RepositoryListView : View {
    
    @ObjectBinding
    private(set) var viewModel: RepositoryListViewModel
    
    var body: some View {
        
        NavigationView {
            
            TextField($viewModel.text,
                      placeholder: Text("Search reposipories..."),
                      onCommit: { self.viewModel.search() })
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .border(Color.gray, cornerRadius: 8)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            
            List {
                
                viewModel.errorMessage.map(Text.init)?
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                
                ForEach(viewModel.repositories.identified(by: \.id)) { repository in
                    
                    NavigationButton(destination:
                        WebView(url: repository.htmlUrl)
                            .navigationBarTitle(Text(repository.fullName))
                    ) {
                        
                        RepositoryView(repository: repository)
                    }
                }
                }
                .navigationBarTitle(Text("Search🔍"))
        }
    }
}
