//
// Copyright (c) 2026 Related Code - https://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SwiftUI

// MARK: - Configuration
public extension ProgressHUD {

	static var mediaSize: CGFloat {
		get { shared.mediaSize }
		set { shared.mediaSize = newValue }
	}

	static var marginSize: CGFloat {
		get { shared.marginSize }
		set { shared.marginSize = newValue }
	}

	static var animationType: AnimationType {
		get { shared.animationType }
		set { shared.animationType = newValue }
	}

	static var animationSymbol: String {
		get { shared.animationSymbol }
		set { shared.animationSymbol = newValue }
	}

	static var colorBackground: Color {
		get { shared.colorBackground }
		set { shared.colorBackground = newValue }
	}

	static var colorHUD: Color {
		get { shared.colorHUD }
		set { shared.colorHUD = newValue }
	}

	static var colorStatus: Color {
		get { shared.colorStatus }
		set { shared.colorStatus = newValue }
	}

	static var colorProgress: Color {
		get { shared.colorProgress }
		set { shared.colorProgress = newValue }
	}

	static var colorAnimation: Color {
		get { shared.colorAnimation }
		set { shared.colorAnimation = newValue }
	}

	static var fontStatus: Font {
		get { shared.fontStatus }
		set { shared.fontStatus = newValue }
	}

	static var imageSuccess: Image {
		get { shared.imageSuccess }
		set { shared.imageSuccess = newValue }
	}

	static var imageError: Image {
		get { shared.imageError }
		set { shared.imageError = newValue }
	}

	static var colorSuccess: Color {
		get { shared.colorSuccess }
		set { shared.colorSuccess = newValue }
	}

	static var colorError: Color {
		get { shared.colorError }
		set { shared.colorError = newValue }
	}
}

// MARK: - Banner Configuration
public extension ProgressHUD {

	static var colorBanner: Color {
		get { shared.colorBanner }
		set { shared.colorBanner = newValue }
	}

	static var colorBannerTitle: Color {
		get { shared.colorBannerTitle }
		set { shared.colorBannerTitle = newValue }
	}

	static var colorBannerMessage: Color {
		get { shared.colorBannerMessage }
		set { shared.colorBannerMessage = newValue }
	}

	static var fontBannerTitle: Font {
		get { shared.fontBannerTitle }
		set { shared.fontBannerTitle = newValue }
	}

	static var fontBannerMessage: Font {
		get { shared.fontBannerMessage }
		set { shared.fontBannerMessage = newValue }
	}
}

// MARK: - Dismiss Methods
public extension ProgressHUD {

	@MainActor
	static func dismiss() {
		shared.dismissAnimTask?.cancel()
		shared.dismissAnimTask = Task {
			withAnimation(.easeIn(duration: 0.15)) {
				shared.isVisible = false
			}
			try? await Task.sleep(for: .milliseconds(150))
			if !Task.isCancelled {
				shared.text = nil
				shared.staticImage = nil
			}
		}
	}

	@MainActor
	static func remove() {
		shared.isVisible = false
		shared.text = nil
		shared.staticImage = nil
	}
}

// MARK: - Animate Methods
public extension ProgressHUD {

	@MainActor
	static func animate(_ text: String? = nil, interaction: Bool = true) {
		present {
			shared.displayMode = .animation
			shared.text = text
			shared.interaction = interaction
		}
	}

	@MainActor
	static func animate(_ text: String? = nil, _ type: AnimationType, interaction: Bool = true) {
		present {
			shared.animationType = type
			shared.displayMode = .animation
			shared.text = text
			shared.interaction = interaction
		}
	}

	@MainActor
	static func animate(_ text: String? = nil, symbol: String, interaction: Bool = true) {
		present {
			shared.animationType = .sfSymbolBounce
			shared.animationSymbol = symbol
			shared.displayMode = .animation
			shared.text = text
			shared.interaction = interaction
		}
	}
}

// MARK: - Progress Methods
public extension ProgressHUD {

	@MainActor
	static func progress(_ value: CGFloat, interaction: Bool = false) {
		present {
			shared.displayMode = .progress
			shared.progressValue = max(0, min(1, value))
			shared.text = nil
			shared.interaction = interaction
		}
	}

	@MainActor
	static func progress(_ text: String?, _ value: CGFloat, interaction: Bool = false) {
		present {
			shared.displayMode = .progress
			shared.progressValue = max(0, min(1, value))
			shared.text = text
			shared.interaction = interaction
		}
	}
}

// MARK: - Live Icon Methods
public extension ProgressHUD {

	@MainActor
	static func liveIcon(_ text: String? = nil, icon: LiveIcon, interaction: Bool = true, delay: TimeInterval? = nil) {
		present {
			shared.liveIconID = UUID()
			shared.displayMode = .liveIcon(icon)
			shared.text = text
			shared.interaction = interaction
		}
		scheduleAutoDismiss(text: text, delay: delay)
	}

	@MainActor
	static func succeed(_ text: String? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
		liveIcon(text, icon: .succeed, interaction: interaction, delay: delay)
	}

	@MainActor
	static func failed(_ text: String? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
		liveIcon(text, icon: .failed, interaction: interaction, delay: delay)
	}

	@MainActor
	static func failed(_ error: Error?, interaction: Bool = true, delay: TimeInterval? = nil) {
		liveIcon(error?.localizedDescription, icon: .failed, interaction: interaction, delay: delay)
	}

	@MainActor
	static func added(_ text: String? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
		liveIcon(text, icon: .added, interaction: interaction, delay: delay)
	}
}

// MARK: - Static Image Methods
public extension ProgressHUD {

	@MainActor
	static func image(_ text: String? = nil, image: Image?, interaction: Bool = true, delay: TimeInterval? = nil) {
		presentImage(text, image: image, color: nil, interaction: interaction, delay: delay)
	}

	@MainActor
	static func symbol(_ text: String? = nil, name: String, interaction: Bool = true, delay: TimeInterval? = nil) {
		let image = Image(systemName: name)
		presentImage(text, image: image, color: nil, interaction: interaction, delay: delay)
	}

	@MainActor
	static func success(_ text: String? = nil, image: Image? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
		presentImage(text, image: image ?? shared.imageSuccess, color: shared.colorSuccess, interaction: interaction, delay: delay)
	}

	@MainActor
	static func error(_ text: String? = nil, image: Image? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
		presentImage(text, image: image ?? shared.imageError, color: shared.colorError, interaction: interaction, delay: delay)
	}

	@MainActor
	static func error(_ error: Error?, image: Image? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
		presentImage(error?.localizedDescription, image: image ?? shared.imageError, color: shared.colorError, interaction: interaction, delay: delay)
	}
}

// MARK: - Banner Methods
public extension ProgressHUD {

	@MainActor
	static func banner(_ title: String?, _ message: String?, delay: TimeInterval = 3.0) {
		shared.bannerTask?.cancel()
		shared.bannerCleanupTask?.cancel()
		shared.bannerTitle = title
		shared.bannerMessage = message
		withAnimation(.easeOut(duration: 0.25)) {
			shared.bannerVisible = true
		}
		shared.bannerTask = Task {
			try? await Task.sleep(for: .seconds(delay))
			if !Task.isCancelled {
				bannerHide()
			}
		}
	}

	@MainActor
	static func bannerHide() {
		shared.bannerTask?.cancel()
		shared.bannerCleanupTask?.cancel()
		withAnimation(.easeIn(duration: 0.25)) {
			shared.bannerVisible = false
		}
		shared.bannerCleanupTask = Task {
			try? await Task.sleep(for: .milliseconds(250))
			if !Task.isCancelled {
				shared.bannerTitle = nil
				shared.bannerMessage = nil
			}
		}
	}
}

// MARK: - Private Methods
private extension ProgressHUD {

	@MainActor
	static func present(_ configure: () -> Void) {
		shared.dismissTask?.cancel()
		shared.dismissAnimTask?.cancel()
		configure()
		withAnimation(.easeOut(duration: 0.15)) {
			shared.isVisible = true
		}
	}

	@MainActor
	static func presentImage(_ text: String?, image: Image?, color: Color?, interaction: Bool, delay: TimeInterval?) {
		present {
			shared.displayMode = .staticImage
			shared.staticImage = image
			shared.staticImageColor = color
			shared.text = text
			shared.interaction = interaction
		}
		scheduleAutoDismiss(text: text, delay: delay)
	}

	static func scheduleAutoDismiss(text: String?, delay: TimeInterval?) {
		let count = text?.count ?? 0
		let actualDelay = delay ?? Double(count) * 0.03 + 1.25

		shared.dismissTask = Task { @MainActor in
			try? await Task.sleep(for: .seconds(actualDelay))
			if !Task.isCancelled {
				dismiss()
			}
		}
	}
}
