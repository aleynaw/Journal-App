// GlobusUploader.swift – Anonymous upload version

import Foundation


struct GlobusUploader {
    static func upload(fileURL: URL, accessToken: String, baseURL: String, collectionPath: String = "/~/MobileUploads/") {
        let fileName = fileURL.lastPathComponent
        guard let uploadURL = URL(string: baseURL + collectionPath + fileName) else {
            print("Invalid upload URL")
            return
        }

        guard let fileData = try? Data(contentsOf: fileURL) else {
            print("Failed to load file data at: \(fileURL)")
            return
        }

        var request = URLRequest(url: uploadURL)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.httpBody = fileData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Upload error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Upload response: \(httpResponse.statusCode)")
                if let data = data {
                    print("Response body: \(String(data: data, encoding: .utf8) ?? "")")
                }
            }
        }.resume()
    }
}

//struct GlobusUploader {
//    static func upload(fileURL: URL, baseURL: String, collectionPath: String = "/~/MobileUploads/") {
//        let fileName = fileURL.lastPathComponent
//        guard let uploadURL = URL(string: baseURL + collectionPath + fileName) else {
//            print("Invalid upload URL")
//            return
//        }
//
//        guard let fileData = try? Data(contentsOf: fileURL) else {
//            print("Failed to load file data at: \(fileURL)")
//            return
//        }
//
//        var request = URLRequest(url: uploadURL)
//        request.httpMethod = "PUT"
//        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
//        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
//        request.httpBody = fileData
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Upload error: \(error.localizedDescription)")
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Upload response: \(httpResponse.statusCode)")
//                if let data = data {
//                    print("Response body: \(String(data: data, encoding: .utf8) ?? "")")
//                }
//            }
//        }.resume()
//    }
//}
