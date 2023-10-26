//
//  Model.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 06.10.2023.
//
// ---------------------------------------------------
//
//  JMDictModel.swift
//  JDictionary
//
//  Created by Kovs on 24.02.2023.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let jMDictionary = try? JSONDecoder().decode(JMDictionary.self, from: jsonData)

import Foundation

// MARK: - JMDictionary
struct JMDictionary: Codable {
//    let id: Int
    let version: String
    let languages: [String]
    let commonOnly: Bool
    let dictDate: String
    let dictRevisions: [String]
    let tags: [String: String]
    let words: [JMDictWord]
}

// MARK: - Word
struct JMDictWord: Codable, Identifiable {
    let id: String
    let kanji: [JMdictKanji]?
    let kana: [JMdictKana]?
    let sense: [JMdictSense]?
}

extension JMDictWord: Hashable {
    static func == (lhs: JMDictWord, rhs: JMDictWord) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Kanji
struct JMdictKanji: Codable {
    let common: Bool
    let text: String
    let tags: [Related]?
}

// MARK: - Kana
struct JMdictKana: Codable {
    let common: Bool
    let text: String
    let tags: [Related]?
    let appliesToKanji: [String]?
}

// MARK: - Sense
struct JMdictSense: Codable { // TODO: Work on it
    let partOfSpeech: [String]?
    let appliesToKanji, appliesToKana: [String]?
    let related: [[Related]]?
    let antonym: [[Related]]?
    let field, dialect: [Related]?
    let misc: [Related]?
    let info: [String]?
    let languageSource: [JMdictLanguageSource]
    let gloss: [JMdictGloss]
}

// MARK: - Gloss
struct JMdictGloss: Codable {
    let lang: String
    let gender: Gender?
    let type: JMdictGlossType?
    let text: String?
}

// MARK: - LanguageSource
struct JMdictLanguageSource: Codable {
    let lang: String
    let full: Bool
    let wasei: Bool
    let text: String?
}

enum Gender: String, Codable {
    case masculine = "masculine"
    case feminine = "feminine"
    case neuter = "neuter"
}

enum JMdictGlossType: String, Codable {
    case literal = "literal"
    case figurative = "figurative"
    case explanation = "explanation"
    case trademark = "trademark"
}

enum Related: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Related.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Related"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
