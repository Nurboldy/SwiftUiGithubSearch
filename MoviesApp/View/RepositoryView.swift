//
//  RepositoryView.swift
//  GitHubSearch
//
//  Created by Nurboldy on 6/11/19.
//  Copyright © 2019 Nurboldy. All rights reserved.
//

import SwiftUI

struct RepositoryView : View {
    
    let repository: Repository
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Image(systemName: "doc.text")
                Text(repository.fullName)
                    .bold()
            }
            
            // Show text if description exists
            repository.description
                .map(Text.init)?
                .lineLimit(nil)
            
            HStack {
                Image(systemName: "star")
                Text("\(repository.stargazersCount)")
            }
        }
    }
}
