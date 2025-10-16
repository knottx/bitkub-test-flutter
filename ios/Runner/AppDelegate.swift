import Flutter
import UIKit
import CryptoKit
import LocalAuthentication

@main
@objc class AppDelegate: FlutterAppDelegate {
  let channel = "com.example.bitkub_test.crypto.device"
  let keyService = "com.example.bitkub_test.crypto.device.sym.v1".data(using: .utf8)!

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: channel, binaryMessenger: controller.binaryMessenger)

    methodChannel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      do {
        switch call.method {
        case "encrypt":
          guard let args = call.arguments as? [String: Any],
                let data = (args["data"] as? FlutterStandardTypedData)?.data else {
            result(FlutterError(code: "ARG", message: "bad args", details: nil)); return
          }
          let aad = (args["aad"] as? FlutterStandardTypedData)?.data
          let out = try self.encrypt(data: data, aad: aad)
          result(FlutterStandardTypedData(bytes: out))

        case "decrypt":
          guard let args = call.arguments as? [String: Any],
                let combined = (args["data"] as? FlutterStandardTypedData)?.data else {
            result(FlutterError(code: "ARG", message: "bad args", details: nil)); return
          }
          let aad = (args["aad"] as? FlutterStandardTypedData)?.data
          let out = try self.decrypt(combined: combined, aad: aad)
          result(FlutterStandardTypedData(bytes: out))

        default:
          result(FlutterMethodNotImplemented)
        }
      } catch {
        result(FlutterError(code: "CRYPTO_ERR", message: error.localizedDescription, details: nil))
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func makeAccessControl() throws -> SecAccessControl {
    if let ac = SecAccessControlCreateWithFlags(
      nil,
      kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
      [.biometryCurrentSet, .userPresence],
      nil
    ) {
      return ac
    }

    if let ac = SecAccessControlCreateWithFlags(
      nil,
      kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
      [.userPresence],
      nil
    ) {
      return ac
    }

    if let ac = SecAccessControlCreateWithFlags(
      nil,
      kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
      [],
      nil
    ) {
      return ac
    }

    throw NSError(domain: "AC", code: -1)
  }

  private func loadOrCreateKey() throws -> Data { 
    var q: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: keyService,
      kSecReturnData as String: true,
      kSecUseAuthenticationUI as String: kSecUseAuthenticationUIAllow
    ]
    let ctx = LAContext()
    q[kSecUseAuthenticationContext as String] = ctx
    q[kSecUseOperationPrompt as String] = "Use device key"

    var item: CFTypeRef?
    let status = SecItemCopyMatching(q as CFDictionary, &item)
    if status == errSecSuccess, let data = item as? Data { return data }

    var key = Data(count: 32)
    _ = key.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!) }

    let ac = try makeAccessControl()
    let add: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: keyService,
      kSecValueData as String: key,
      kSecAttrAccessControl as String: ac,
      kSecUseAuthenticationUI as String: kSecUseAuthenticationUIAllow,
      kSecAttrSynchronizable as String: kCFBooleanFalse as Any 
    ]
    let addStatus = SecItemAdd(add as CFDictionary, nil)
    guard addStatus == errSecSuccess else { throw NSError(domain: "KC_ADD", code: Int(addStatus)) }
    return key
  }

  private func encrypt(data: Data, aad: Data?) throws -> Data {
    let keyBytes = try loadOrCreateKey()
    let sym = SymmetricKey(data: keyBytes)
    let sealed = try AES.GCM.seal(data, using: sym, authenticating: aad ?? Data())
    let nonce = Data(sealed.nonce) 
    var out = Data()
    out.append(nonce)
    out.append(sealed.ciphertext)
    out.append(sealed.tag) 
    return out
  }

  private func decrypt(combined: Data, aad: Data?) throws -> Data {
    let keyBytes = try loadOrCreateKey()
    let sym = SymmetricKey(data: keyBytes)
    let nonce = try AES.GCM.Nonce(data: combined.prefix(12))
    let tag = combined.suffix(16)
    let ct = combined.dropFirst(12).dropLast(16)
    let box = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ct, tag: tag)
    return try AES.GCM.open(box, using: sym, authenticating: aad ?? Data())
  }
}
