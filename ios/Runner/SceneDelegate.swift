import Flutter
import UIKit

/// Best-effort iOS privacy protection. iOS does not offer an equivalent to
/// Android FLAG_SECURE, so CyVault obscures the app switcher and active capture.
class SceneDelegate: FlutterSceneDelegate {
  private var privacyOverlay: UIView?

  override func sceneWillResignActive(_ scene: UIScene) {
    super.sceneWillResignActive(scene)
    installPrivacyOverlay()
  }

  override func sceneDidBecomeActive(_ scene: UIScene) {
    super.sceneDidBecomeActive(scene)
    if UIScreen.main.isCaptured {
      installPrivacyOverlay()
    } else {
      removePrivacyOverlay()
    }
  }

  override func sceneDidDisconnect(_ scene: UIScene) {
    removePrivacyOverlay()
    super.sceneDidDisconnect(scene)
  }

  private func installPrivacyOverlay() {
    guard privacyOverlay == nil, let window = window else { return }
    let overlay = UIView(frame: window.bounds)
    overlay.backgroundColor = UIColor(red: 0.027, green: 0.106, blue: 0.2, alpha: 1)
    overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    let icon = UIImageView(image: UIImage(systemName: "lock.shield.fill"))
    icon.tintColor = .white
    icon.contentMode = .scaleAspectFit
    icon.frame = CGRect(x: 0, y: 0, width: 88, height: 88)
    icon.center = overlay.center
    icon.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
    overlay.addSubview(icon)
    window.addSubview(overlay)
    privacyOverlay = overlay
  }

  private func removePrivacyOverlay() {
    privacyOverlay?.removeFromSuperview()
    privacyOverlay = nil
  }
}
