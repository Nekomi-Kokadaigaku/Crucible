//
//  FormatUtilities.swift
//  BilibiliKitTestDemo
//

import Foundation

/// 格式化工具类
enum FormatUtilities {

  /// 格式化数字（万、亿）
  static func formatNumber(_ number: Int) -> String {
    if number >= 100_000_000 {
      return String(format: "%.1f亿", Double(number) / 100_000_000.0)
    } else if number >= 10_000 {
      return String(format: "%.1f万", Double(number) / 10_000.0)
    }
    return "\(number)"
  }

  /// 格式化时长（HH:MM:SS 或 MM:SS）
  static func formatDuration(_ seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let secs = seconds % 60

    if hours > 0 {
      return String(format: "%d:%02d:%02d", hours, minutes, secs)
    } else {
      return String(format: "%d:%02d", minutes, secs)
    }
  }

  /// 格式化日期时间戳
  static func formatDate(_ timestamp: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.locale = Locale(identifier: "zh_CN")
    return formatter.string(from: date)
  }

  /// 格式化JSON输出
  static func formatJSONOutput(from data: Data) -> String? {
    do {
      let object = try JSONSerialization.jsonObject(with: data, options: [])
      let formatted = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys])
      return String(data: formatted, encoding: .utf8)
    } catch {
      return nil
    }
  }

  /// 将对象编码为格式化的JSON字符串
  static func prettyJSON<T: Encodable>(from value: T) -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    encoder.dateEncodingStrategy = .secondsSince1970

    do {
      let data = try encoder.encode(value)
      return String(data: data, encoding: .utf8) ?? String(describing: value)
    } catch {
      return String(describing: value)
    }
  }

  /// 截断过长的输出
  static func trimmedOutput(from text: String, limit: Int = LayoutConstants.maxOutputLength) -> String {
    guard text.count > limit else { return text }
    let endIndex = text.index(text.startIndex, offsetBy: limit)
    return String(text[..<endIndex]) + "\n...\n(输出过长，已截断)"
  }
}
