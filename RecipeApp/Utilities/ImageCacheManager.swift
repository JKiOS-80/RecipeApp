//
//  ImageCacheManager.swift
//  RecipeApp
//
//
//


import UIKit
import CryptoKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}

    private let cacheDirectory: URL = {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }()

    func loadImage(from url: URL) async throws -> UIImage {
        let fileURL = cachedFileURL(for: url)

        // Diskte varsa onu döndür
        if FileManager.default.fileExists(atPath: fileURL.path) {
            let data = try Data(contentsOf: fileURL)
            if let image = UIImage(data: data) {
                return image
            }
        }

        // Yoksa indir ve kaydet
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw AppError.badResponse
        }

        try data.write(to: fileURL)
        guard let image = UIImage(data: data) else {
            throw AppError.unknown
        }

        return image
    }

    private func cachedFileURL(for url: URL) -> URL {
        let hashedFileName = sha256(url.absoluteString)
        return cacheDirectory.appendingPathComponent(hashedFileName)
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }
}
