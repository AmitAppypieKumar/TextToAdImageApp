📱 TextToAdImageApp
   An iOS app that uses AI to generate ad-style images from text and lets users save them to the photo library with a simple UI.
   Built with Swift (UIKit), this app integrates with an image generation API and handles image saving, photo permissions, and toast messages.

🧩 Features
  🔤 Text-to-Image API integration (e.g. Stability AI or similar)
  🖼️ Preview generated images
  📥 Save to photo library with permission handling
  ✅ Action Sheet: Save / Cancel
  🔔 Toasts for success & error messages
  📱 Designed for iOS 15+

🚀 Getting Started
  1. Clone the Repository
     git clone https://github.com/AmitAppypieKumar/TextToAdImageApp.git
     cd TextToAdImageApp
     open TextToAdImageApp.xcodeproj
  2. Add API Key (Optional)
     request.setValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")

📸 Photo Library Permissions
   Add these to Info.plist:
   <key>NSPhotoLibraryUsageDescription</key>
   <string>This app saves generated images to your photo gallery.</string>
   <key>NSPhotoLibraryAddUsageDescription</key>
   <string>We need access to save images to your library.</string>

🧪 Usage
   App generates a placeholder or API-based image
   You see the image preview
   Action Sheet appears:
   Save to Gallery – saves with permission handling
   Cancel – dismisses
   Toast displays success/failure

🛠 Requirements
   Xcode 14+
   iOS 15 or newer
   Swift 5

📦 Dependencies
   None — 100% UIKit, Foundation, and system frameworks like Photos.

📄 License
   MIT License.
   Use it, remix it, credit appreciated but not required ✌️

