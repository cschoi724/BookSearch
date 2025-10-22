//
//  MockData.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

enum MockData {
    static let searchOK: Data = {
        let json = """
        {
          "error":"0",
          "total":"20",
          "page":"1",
          "books":[
            {"title":"SwiftUI in Action","subtitle":"Build UIs","isbn13":"111","price":"$10","image":"img1","url":"u1"},
            {"title":"Combine Essentials","subtitle":"FRP","isbn13":"222","price":"$12","image":"img2","url":"u2"}
          ]
        }
        """
        return Data(json.utf8)
    }()

    static let searchError: Data = {
        let json = """
        {
          "error":"1",
          "total":"0",
          "page":"1",
          "books":[]
        }
        """
        return Data(json.utf8)
    }()
    
    static let detailOK: Data = {
        let json = """
        {
          "error": "0",
          "title": "Securing DevOps",
          "subtitle": "Security in the Cloud",
          "authors": "Julien Vehent",
          "publisher": "Manning",
          "language": "en",
          "isbn10": "1617294136",
          "isbn13": "9781617294136",
          "pages": "384",
          "year": "2018",
          "rating": "5",
          "desc": "desc",
          "price": "$26.98",
          "image": "https://itbook.store/img/books/9781617294136.png",
          "url": "https://itbook.store/books/9781617294136",
          "pdf": {
            "Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf"
          }
        }
        """
        return Data(json.utf8)
    }()

    static let detailError: Data = {
        let json = """
        {
          "error": "2",
          "title": "",
          "subtitle": "",
          "authors": "",
          "publisher": "",
          "isbn13": "9781617294136",
          "price": "$0",
          "image": "",
          "url": ""
        }
        """
        return Data(json.utf8)
    }()

    static let errorBody: Data = {
        let json = #"{"error":"3","message":"invalid request"}"#
        return Data(json.utf8)
    }()
}
