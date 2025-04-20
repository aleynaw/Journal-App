// GlobusUploader.swift – Anonymous upload version

import Foundation

struct GlobusUploader {
    static func upload(
        fileURL: URL,
        accessToken: String,
        baseURL: String,
        collectionPath: String = ""
    ) {
        let fileName = fileURL.lastPathComponent
        
        // 1) Trim or add slashes so we end up with:
        //    baseURL: "...collection…org"
        //    collectionPath: "/~/MobileUploads/"
        //    fileName: "MyFile.txt"
        let trimmedBase: String = baseURL.hasSuffix("/")
            ? String(baseURL.dropLast())
            : baseURL
        
        let normalizedPath: String = {
            var p = collectionPath
            if !p.hasPrefix("/") { p = "/" + p }
            if !p.hasSuffix("/") { p += "/" }
            return p
        }()
        
        let fullURLString = trimmedBase + normalizedPath + fileName
        print("➡️ Uploading to URL:", fullURLString)
        
        guard let uploadURL = URL(string: fullURLString) else {
            print("❌ Invalid upload URL: \(fullURLString)")
            return
        }
        
        guard let fileData = try? Data(contentsOf: fileURL) else {
            print("❌ Failed to read file at: \(fileURL.path)")
            return
        }
        
        var req = URLRequest(url: uploadURL)
        req.httpMethod = "PUT"
        req.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        req.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        req.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        // Using uploadTask ensures the body gets sent reliably
        URLSession.shared.uploadTask(with: req, from: fileData) { data, resp, err in
            if let err = err {
                print("❌ Upload error:", err.localizedDescription)
                return
            }
            guard let http = resp as? HTTPURLResponse else {
                print("❌ No HTTP response")
                return
            }
            print("✅ HTTP \(http.statusCode)")
            if let d = data, let body = String(data: d, encoding: .utf8) {
                print("📦 Response body:", body)
            }
        }.resume()
    }
}
