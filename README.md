[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FFlineDev%2FIntelligenceKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/FlineDev/IntelligenceKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FFlineDev%2FIntelligenceKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/FlineDev/IntelligenceKit)

# IntelligenceKit

Unified Swift package for OpenAI API integration with GPT-5 support and advanced reasoning capabilities.

## Platform Support

- **Apple Platforms**: iOS 18+, macOS 15+, tvOS 18+, visionOS 2+, watchOS 11+
- **Linux**: Full server-side Swift support for deployment on Linux servers

## Features

- **OpenAI GPT-5 family**: GPT-5, GPT-5-mini, GPT-5-nano with reasoning capabilities
- **Legacy model support**: GPT-4.1, o3, o4-mini for comparison and migration
- **Advanced reasoning**: Multiple reasoning effort levels (minimal, low, medium, high)
- **Responses API**: Modern OpenAI API with better performance and lower costs
- **Cross-platform compatibility**: Apple platforms + Linux server support
- **ErrorKit integration**: Localized error messages with typed error handling
- **Structured response parsing**: JSON Schema support for data extraction
- **Multi-turn conversations**: Automatic conversation state management
- **Pricing transparency**: Built-in cost tracking and optimization

## Usage

### Basic Usage with GPT-5
```swift
import IntelligenceKit

let openAI = OpenAI(apiKey: "your-key")

// Simple text generation with GPT-5-mini
let response = try await openAI.ask(
    model: .gpt5Mini,
    input: "Write a haiku about coding"
)
print(response.outputText)

// Advanced reasoning with specific effort level
let response = try await openAI.ask(
    model: .gpt5,
    instructions: "You are a helpful coding assistant",
    input: "Explain the benefits of Swift's type system",
    reasoning: .high,
    verbosity: .high
)
```

### Reasoning and Verbosity Options
```swift
// Reasoning effort levels
reasoning: .minimal  // Fastest, fewer reasoning tokens
reasoning: .low      // Balanced speed and reasoning
reasoning: .medium   // Default, good balance
reasoning: .high     // Most thorough reasoning

// Text verbosity levels  
verbosity: .low      // Concise responses
verbosity: .medium   // Default length
verbosity: .high     // Detailed explanations
```

### Multi-turn Conversations
```swift
// First message
let response1 = try await openAI.ask(
    model: .gpt5Mini,
    input: "What is Swift?"
)

// Continue conversation (automatic context)
let response2 = try await openAI.ask(
    model: .gpt5Mini,
    input: "How does it compare to Objective-C?",
    previousResponseID: response1.id
)
```

## Dependencies

- [HandySwift](https://github.com/FlineDev/HandySwift) - REST client and utilities
- [ErrorKit](https://github.com/FlineDev/ErrorKit) - Typed error handling

## Error Handling

All errors conform to ErrorKit's `Throwable` protocol with localized user-friendly messages:

```swift
do {
    let response = try await openAI.chatCompletion(...)
} catch let error as OpenAI.Error {
    print(error.userFriendlyMessage) // Localized error message
}
```

## Cross-Platform Notes

- **Linux Deployment**: Fully supported for server-side Swift applications
- **API Compatibility**: Identical API surface across all platforms

## Showcase

I extracted this library from my following Indie apps (rate them with 5 stars to thank me!):

<table>
  <tr>
    <th>App Icon</th>
    <th>App Name & Description</th>
    <th>Supported Platforms</th>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6476773066?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/TranslateKit.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6476773066?pt=549314&ct=github.com&mt=8">
        <strong>TranslateKit: App Localizer</strong>
      </a>
      <br />
      Simple drag & drop translation of String Catalog files with support for multiple translation services & smart correctness checks.
    </td>
    <td>Mac</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6587583340?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/PleydiaOrganizer.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6587583340?pt=549314&ct=github.com&mt=8">
        <strong>Pleydia Organizer: Movie & Series Renamer</strong>
      </a>
      <br />
      Simple, fast, and smart media management for your Movie, TV Show and Anime collection.
    </td>
    <td>Mac</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6502914189?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/FreemiumKit.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6502914189?pt=549314&ct=github.com&mt=8">
        <strong>FreemiumKit: In-App Purchases</strong>
      </a>
      <br />
      Simple In-App Purchases and Subscriptions for Apple Platforms: Automation, Paywalls, A/B Testing, Live Notifications, PPP, and more.
    </td>
    <td>iPhone, iPad, Mac, Vision</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6480134993?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/FreelanceKit.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6480134993?pt=549314&ct=github.com&mt=8">
        <strong>FreelanceKit: Time Tracking</strong>
      </a>
      <br />
      Simple & affordable time tracking with a native experience for all  devices. iCloud sync & CSV export included.
    </td>
    <td>iPhone, iPad, Mac, Vision</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6472669260?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/CrossCraft.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6472669260?pt=549314&ct=github.com&mt=8">
        <strong>CrossCraft: Custom Crosswords</strong>
      </a>
      <br />
      Create themed & personalized crosswords. Solve them yourself or share them to challenge others.
    </td>
    <td>iPhone, iPad, Mac, Vision</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6477829138?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/FocusBeats.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6477829138?pt=549314&ct=github.com&mt=8">
        <strong>FocusBeats: Pomodoro + Music</strong>
      </a>
      <br />
      Deep Focus with proven Pomodoro method & select Apple Music playlists & themes. Automatically pauses music during breaks.
    </td>
    <td>iPhone, iPad, Mac, Vision</td>
  </tr>
  <tr>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6478062053?pt=549314&ct=github.com&mt=8">
        <img src="https://raw.githubusercontent.com/FlineDev/HandySwift/main/Images/Apps/Posters.webp" width="64" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/app/apple-store/id6478062053?pt=549314&ct=github.com&mt=8">
        <strong>Posters: Discover Movies at Home</strong>
      </a>
      <br />
      Auto-updating & interactive posters for your home with trailers, showtimes, and links to streaming services.
    </td>
    <td>Vision</td>
  </tr>
</table>