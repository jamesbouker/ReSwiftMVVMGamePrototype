//
//  Codable+Extensions.swift
//  StateArch
//
//  Created by james bouker on 10/23/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//

import Foundation

public class Storage {

    fileprivate init() {}

    enum Directory {
        case documents
        case caches
    }

    /// Returns URL constructed from specified directory
    fileprivate static func getURL(for directory: Directory) -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory

        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }

        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }

    static func save<T: Encodable>(_ object: T, filename: String) {
        store(object, to: .documents, as: filename)
    }

    static func cache<T: Encodable>(_ object: T, filename: String) {
        store(object, to: .caches, as: filename)
    }

    static func saved<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        return retrieve(filename, from: .documents, as: type)
    }

    static func cached<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        return retrieve(filename, from: .caches, as: type)
    }

    static func data<T: Encodable>(_ object: T) -> Data {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(object) else {
            fatalError("Could not encode \(object)")
        }
        return data
    }

    /// Store an encodable struct to the specified directory on disk
    ///
    /// - Parameters:
    ///   - object: the encodable struct to store
    ///   - directory: where to store the struct
    ///   - fileName: what to name the file where the struct data will be stored
    static func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        do {
            let data = self.data(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    /// Retrieve and convert a struct from a file on disk
    ///
    /// - Parameters:
    ///   - fileName: name of the file where struct data is stored
    ///   - directory: directory where struct data is stored
    ///   - type: struct type (i.e. Message.self)
    /// - Returns: decoded struct model(s) of data
    static func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T? {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)

        if !FileManager.default.fileExists(atPath: url.path) {
            return nil
        }

        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }

    /// Remove all files at specified directory
    static func clear(_ directory: Directory) {
        let manager = FileManager.default
        let url = getURL(for: directory)
        do {
            let contents = try manager.contentsOfDirectory(at: url,
                                                           includingPropertiesForKeys: nil,
                                                           options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    /// Remove specified file from specified directory
    static func remove(_ fileName: String, from directory: Directory) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    /// Returns BOOL indicating whether file exists at specified directory with specified file name
    static func fileExists(_ fileName: String, in directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
}
