//
//  FormatUtilities.swift
//  Crucibe
//

import Foundation

/// 一个提供静态方法的工具类集合，用于格式化各种数据类型为人类可读的字符串。
public enum FormatUtilities {

  /// 格式化数字，当数字过大时，会转换为带有“万”或“亿”单位的字符串。
  ///
  /// - Parameter number: 需要格式化的整数。
  /// - Returns: 格式化后的字符串。例如 12345 会返回 "1.2万"。
  public static func formatNumber(_ number: Int) -> String {
    if number >= 100_000_000 {
      return String(format: "%.1f亿", Double(number) / 100_000_000.0)
    } else if number >= 10_000 {
      return String(format: "%.1f万", Double(number) / 10_000.0)
    }
    return "\(number)"
  }

  /// 格式化以秒为单位的总时长。
  ///
  /// - Parameter seconds: 需要格式化的总秒数。
  /// - Returns: "HH:MM:SS" 或 "MM:SS" 格式的字符串。
  public static func formatDuration(_ seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let secs = seconds % 60

    if hours > 0 {
      return String(format: "%d:%02d:%02d", hours, minutes, secs)
    } else {
      return String(format: "%d:%02d", minutes, secs)
    }
  }

  /// 格式化 Unix 时间戳为本地化的日期时间字符串。
  ///
  /// - Parameter timestamp: 自1970年1月1日以来的秒数。
  /// - Returns: 符合中文地区习惯的日期时间字符串 (例如 "2023年10月27日 下午3:30")。
  public static func formatDate(_ timestamp: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.locale = Locale(identifier: "zh_CN")
    return formatter.string(from: date)
  }

  /// 将原始 Data 对象（应为JSON格式）解析并格式化为带有缩进和排序的美化JSON字符串。
  ///
  /// - Parameter data: 包含 JSON 数据的 Data 对象。
  /// - Returns: 格式化后的 JSON 字符串，如果解析失败则返回 nil。
  public static func formatJSONOutput(from data: Data) -> String? {
    do {
      let object = try JSONSerialization.jsonObject(with: data, options: [])
      let formattedData = try JSONSerialization.data(
        withJSONObject: object,
        options: [.prettyPrinted, .sortedKeys]
      )
      return String(data: formattedData, encoding: .utf8)
    } catch {
      return nil
    }
  }

  /// 将任何遵守 Encodable 协议的 Swift 对象编码为美化的 JSON 字符串。
  ///
  /// 这是处理 Swift 数据模型到 JSON 字符串的首选方法。
  ///
  /// - Parameter value: 需要编码的 `Encodable` 对象。
  /// - Returns: 美化（带缩进和排序）后的 JSON 字符串。如果编码失败，则返回对象的字符串描述。
  public static func prettyJSON<T: Encodable>(from value: T) -> String {
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

  /// 截断过长的字符串，并在末尾附加提示信息。
  ///
  /// 这可以防止在控制台或 UI 上因输出过多内容而导致卡顿或信息淹没。
  ///
  /// - Parameters:
  ///   - text: 原始字符串。
  ///   - limit: 字符数限制，默认为 10000。
  /// - Returns: 如果原始字符串长度超过限制，则返回截断后的字符串，否则返回原字符串。
  public static func trimmedOutput(
    from text: String,
    limit: Int = 10000
  ) -> String {
    guard text.count > limit else { return text }
    let endIndex = text.index(text.startIndex, offsetBy: limit)
    return String(text[..<endIndex]) + "\n...\n(输出过长，已截断)"
  }
}
